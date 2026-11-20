#!/usr/bin/env python3
"""Audit what breaks when one model's hand-written copyWith is replaced by freezed's.

Usage: python3 .claude/skills/openapi-migration/scripts/copywith_audit.py <Model> [--packages <dir> ...]

<Model> is a class name (`Poll`) or `path/to/file.dart:Poll`. Run it inside the repo, after `melos bootstrap`.

The probe edits only the model's file and the generated `*.freezed.dart` / `*.g.dart` files of the model's package,
and restores exactly those at the end, even on failure. It refuses to start while any of them has uncommitted
changes, so nothing of yours is ever overwritten.
"""

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path


def sh(cmd, cwd=None, env=None, check=False):
    return subprocess.run(cmd, cwd=cwd or ROOT, env=env, text=True, capture_output=True, check=check)


ROOT = Path(subprocess.run(['git', 'rev-parse', '--show-toplevel'], text=True, capture_output=True).stdout.strip()
            or Path.cwd())
GENERATED = ('.freezed.dart', '.g.dart')


# --- Files the probe may touch -----------------------------------------------------------------------------------


def managed_status(model: Path, pkg: Path):
    """git status of the files the probe may touch: the model file and the package's generated files."""
    rel_pkg = os.path.relpath(pkg, ROOT)
    out = sh(['git', 'status', '--porcelain', '--untracked-files=all', '--', f'{rel_pkg}/lib']).stdout
    status = {}
    for line in out.splitlines():
        path = line[3:].split(' -> ')[-1]
        if path == str(model) or path.endswith(GENERATED):
            status[path] = line[:2]
    return status


def restore(model: Path, pkg: Path, untracked_before):
    """Puts every managed file back as git has it; removes generated files the probe created."""
    for path, code in managed_status(model, pkg).items():
        if code == '??':
            if path not in untracked_before:
                (ROOT / path).unlink(missing_ok=True)
        else:
            sh(['git', 'checkout', '--', path])


# --- Toolchain ---------------------------------------------------------------------------------------------------


def pinned_env():
    env = dict(os.environ)
    fvmrc = ROOT / '.fvmrc'
    if fvmrc.exists():
        pin = json.loads(fvmrc.read_text()).get('flutter')
        bin_dir = Path.home() / 'fvm' / 'versions' / str(pin) / 'bin'
        if bin_dir.exists():
            env['PATH'] = f'{bin_dir}{os.pathsep}{env["PATH"]}'
    return env


def package_of(path: Path) -> Path:
    for parent in (ROOT / path).resolve().parents:
        if (parent / 'pubspec.yaml').exists():
            return parent
    sys.exit(f'No pubspec.yaml above {path}')


def default_packages():
    out = sh(['git', 'ls-files', '*pubspec.yaml']).stdout.split()
    return [ROOT / Path(p).parent for p in out
            if (ROOT / Path(p).parent / '.dart_tool' / 'package_config.json').exists()]


# --- Locating and rewriting the model ----------------------------------------------------------------------------


def find_model(spec):
    if ':' in spec:
        path, name = spec.rsplit(':', 1)
        return Path(os.path.relpath(Path(path).resolve(), ROOT)), name
    hits = [Path(p) for p in sh(['git', 'grep', '-lE', rf'^(abstract |final )*class {spec}( |<|$)',
                                 '--', ':(glob)packages/*/lib/**/*.dart']).stdout.split()
            if not p.endswith(GENERATED)]
    if len(hits) != 1:
        sys.exit(f'Found {len(hits)} files declaring `class {spec}`: {hits}. Pass `path/to/file.dart:{spec}`.')
    return hits[0], spec


def match_close(src, i, open_ch, close_ch):
    """Index just past the bracket that closes the one at src[i]."""
    depth, quote = 0, None
    while i < len(src):
        c = src[i]
        if quote:
            if c == '\\':
                i += 2
                continue
            if c == quote:
                quote = None
        elif c in '\'"':
            quote = c
        elif c == open_ch:
            depth += 1
        elif c == close_ch:
            depth -= 1
            if depth == 0:
                return i + 1
        i += 1
    raise ValueError('unbalanced brackets')


def class_span(src, name):
    """(header_start, decl_start, body_start, body_end); the header is the doc comment and annotations."""
    m = re.compile(rf'^(?:abstract |final |sealed |base )*class {re.escape(name)}\b[^{{]*\{{', re.M).search(src)
    if not m:
        sys.exit(f'`class {name}` not found.')
    body_start = m.end() - 1
    body_end = match_close(src, body_start, '{', '}')
    lines = src[:m.start()].split('\n')[:-1]
    while lines and re.match(r'\s*(///|//|@|\)|\w+:)', lines[-1]):
        lines.pop()
    header_start = len('\n'.join(lines)) + (1 if lines else 0)
    return header_start, m.start(), body_start, body_end


def parse_params(params_src):
    """{name: (type, has_sentinel)} for a `{...}` parameter list's text."""
    out = {}
    for p in re.finditer(r'([\w<>?, ]+?)\s+(\w+)\s*(=\s*_nullConst)?\s*,', params_src + ','):
        out[p.group(2)] = (p.group(1).replace('required ', '').strip(), bool(p.group(3)))
    return out


def remove_copy_with(body):
    """Strips the hand-written copyWith from a class body; returns (body, params)."""
    m = re.search(r'^([ \t]+)[\w<>?, ]+\s+copyWith\(\{', body, re.M)
    if not m:
        return body, {}
    lines = body[:m.start()].split('\n')[:-1]
    while lines and re.match(r'\s*(///|@)', lines[-1]):
        lines.pop()
    start = len('\n'.join(lines)) + (1 if lines else 0)

    paren = body.index('(', m.start())
    params_end = match_close(body, paren, '(', ')')
    params = parse_params(body[paren + 2:params_end - 1])
    rest = body[params_end:]
    end = params_end + len(rest) - len(rest.lstrip())
    if body.startswith('=>', end):
        while body[end] != ';':
            c = body[end]
            end = match_close(body, end, c, {'(': ')', '[': ']', '{': '}'}[c]) if c in '([{' else end + 1
        end += 1
    else:
        end = match_close(body, end, '{', '}')
    if body[end:end + 1] == '\n':
        end += 1
    return body[:start] + body[end:], params


def put_on_freezed(src, name, header_start, decl_start):
    """Makes the class generate freezed's copyWith; returns (src, was_already_freezed)."""
    header, decl = src[header_start:decl_start], src[decl_start:]
    if re.search(r'@Freezed\([^)]*copyWith:\s*false', header):
        def fix(m):
            args = re.sub(r'copyWith:\s*false\s*,?\s*', '', m.group(1)).strip().rstrip(',')
            return '@freezed' if not args else f'@Freezed({args})'

        header = re.sub(r'@Freezed\(([^)]*copyWith:\s*false[^)]*)\)', fix, header)
        return src[:header_start] + header + decl, True
    if re.search(r'@(freezed|Freezed)\b', header):
        return src, True

    # Not on freezed yet: annotate the class, mix in the generated code, and add the part and import.
    header += '@freezed\n'
    head_end = decl.index('{')
    head = decl[:head_end]
    if re.search(r'\bwith\b', head):
        head = re.sub(r'\bwith\s+', f'with _${name}, ', head, count=1)
    elif ' implements ' in head:
        head = head.replace(' implements ', f' with _${name} implements ', 1)
    else:
        head = head.rstrip() + f' with _${name} '
    src = src[:header_start] + header + head + decl[head_end:]

    part = f"part '{MODEL.stem}.freezed.dart';"
    if part not in src:
        parts = list(re.finditer(r"^part '.*';\n", src, re.M))
        imports = list(re.finditer(r"^import '.*';\n", src, re.M))
        anchor = parts[-1].end() if parts else imports[-1].end() if imports else 0
        src = src[:anchor] + ('' if parts else '\n') + part + '\n' + src[anchor:]
    if 'package:freezed_annotation/freezed_annotation.dart' not in src:
        first_import = re.search(r"^import ", src, re.M)
        at = first_import.start() if first_import else 0
        src = src[:at] + "import 'package:freezed_annotation/freezed_annotation.dart' show freezed;\n" + src[at:]
    return src, False


# --- Generated code ----------------------------------------------------------------------------------------------


def interface(freezed_src, name):
    """The match of the generated `$Res call({...});` interface of the model's copyWith."""
    head = re.search(rf'class [_$]*{re.escape(name)}CopyWith<\$Res>', freezed_src)
    if not head:
        return None
    return re.compile(r'\$Res call\(\{([^{}]*?)\}\);').search(freezed_src, head.end())


def interface_params(body):
    return {m.group(2): m.group(1) for m in re.finditer(r'^\s*(.+?)\s+(\w+),\s*$', body, re.M)}


def field_types(body):
    return {m.group(2): m.group(1) for m in re.finditer(r'^\s+final\s+([\w<>?, ]+?)\s+(\w+);', body, re.M)}


def bare(type_):
    return type_.strip().rstrip('?')


# --- Analysis ----------------------------------------------------------------------------------------------------


def analyze(packages, env):
    errors = {}
    for pkg in packages:
        out = sh(['dart', 'analyze', '--format=machine', '.'], cwd=pkg, env=env)
        for line in (out.stdout + out.stderr).splitlines():
            parts = line.split('|')
            if len(parts) >= 8 and parts[0] == 'ERROR':
                errors[(os.path.relpath(parts[3], ROOT), int(parts[4]), int(parts[5]))] = (parts[2], parts[7])
    return errors


def arg_name(path, line, col, code, msg):
    if code == 'UNDEFINED_NAMED_PARAMETER':
        m = re.search(r"named parameter '(\w+)'", msg)
        if m:
            return m.group(1)
    text = (ROOT / path).read_text().split('\n')[line - 1]
    m = re.search(r'(\w+)\s*:\s*$', text[:col - 1])
    return m.group(1) if m else '?'


def source_line(path, line):
    return (ROOT / path).read_text().split('\n')[line - 1].strip()


# --- Main --------------------------------------------------------------------------------------------------------


def main():
    global MODEL
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('model', help='class name, or path/to/file.dart:ClassName')
    ap.add_argument('--packages', nargs='*', help='package dirs to analyze (default: every bootstrapped package)')
    args = ap.parse_args()
    os.chdir(ROOT)

    MODEL, name = find_model(args.model)
    pkg = package_of(MODEL)
    before = managed_status(MODEL, pkg)
    dirty = [p for p, code in before.items() if code != '??']
    if dirty:
        sys.exit('These files have uncommitted changes and the probe would overwrite them; commit or stash first:\n'
                 + '\n'.join(f'  {p}' for p in dirty))
    untracked_before = set(before)

    env = pinned_env()
    packages = [ROOT / p for p in args.packages] if args.packages else default_packages()
    freezed = MODEL.with_name(MODEL.stem + '.freezed.dart')
    try:
        src = MODEL.read_text()
        header_start, decl_start, body_start, body_end = class_span(src, name)
        body, v10_params = remove_copy_with(src[body_start:body_end])
        if not v10_params:
            sys.exit(f'`{name}` has no hand-written copyWith; freezed\'s is new API, not a behaviour change.')
        src = src[:body_start] + body + src[body_end:]
        src, was_freezed = put_on_freezed(src, name, header_start, decl_start)
        MODEL.write_text(src)

        # build_runner caches by input digest, and an earlier run's outputs were restored behind its back, so a
        # rerun would keep them. Deleting the output forces the rebuild.
        freezed.unlink(missing_ok=True)
        rel = os.path.relpath((ROOT / MODEL).resolve(), pkg)
        r = sh(['dart', 'run', 'build_runner', 'build', f'--build-filter={rel[:-5]}.*.dart'], cwd=pkg, env=env)
        generated = freezed.read_text() if freezed.exists() else ''
        call = interface(generated, name)
        if r.returncode or not call:
            sys.exit(f'build_runner did not generate a copyWith for `{name}`:\n{r.stdout[-3000:]}{r.stderr[-3000:]}')
        # A filtered build deletes the package's other outputs; put them back before analyzing.
        restore_deleted(pkg)

        generated_params = interface_params(call.group(1))
        fields = field_types(body)
        missing = [p for p in v10_params if p not in generated_params]
        retyped = [(p, t, fields[p]) for p, t in generated_params.items()
                   if p in fields and bare(t) != bare(fields[p])]
        ctor_traps = [p for p, t in generated_params.items()
                      if t.endswith('?') and p in fields and not fields[p].endswith('?')]

        print(f'Analyzing `{name}` (pass 1: compile breaks)…', file=sys.stderr)
        compile_errors = analyze(packages, env)

        stripped = re.sub(r'^(\s*)(.+?)\?(\s+\w+,)\s*$', r'\1\2\3', call.group(1), flags=re.M)
        freezed.write_text(generated[:call.start(1)] + stripped + generated[call.end(1):])
        print(f'Analyzing `{name}` (pass 2: nullable arguments)…', file=sys.stderr)
        nullable_errors = {k: v for k, v in analyze(packages, env).items() if k not in compile_errors}

        report(name, was_freezed, compile_errors, nullable_errors, v10_params, missing, retyped, ctor_traps)
    finally:
        restore(MODEL, pkg, untracked_before)
        restore_deleted(pkg)
        print('Restored the model and its package\'s generated files.', file=sys.stderr)


def restore_deleted(pkg):
    rel_pkg = os.path.relpath(pkg, ROOT)
    deleted = [p for p in sh(['git', 'ls-files', '--deleted', '--', f'{rel_pkg}/lib']).stdout.split()
               if p.endswith(GENERATED)]
    if deleted:
        sh(['git', 'checkout', '--', *deleted])


# --- Report ------------------------------------------------------------------------------------------------------


def report(name, was_freezed, compile_errors, nullable_errors, v10_params, missing, retyped, ctor_traps):
    def row(key, value, tag=''):
        (file, line, col), (code, msg) = key, value
        arg = arg_name(file, line, col, code, msg)
        kind = 'test' if '/test/' in f'/{file}' else 'lib'
        return arg, f'- [{kind}] `{file}:{line}` `{arg}:`{tag}\n  `{source_line(file, line)}`\n  {msg}'

    missing_rows, compile_rows = [], []
    for key, value in sorted(compile_errors.items()):
        arg, text = row(key, value)
        (missing_rows if value[0] == 'UNDEFINED_NAMED_PARAMETER' and arg in missing else compile_rows).append(text)

    nullable_rows = []
    for key, value in sorted(nullable_errors.items()):
        arg = arg_name(*key, *value)
        sentinel = v10_params.get(arg, (None, False))[1]
        nullable_rows.append(row(key, value, ' — v10 sentinel, same result' if sentinel
                                 else ' — **v10 kept on null; check**')[1])

    def section(title, items, note=None):
        print(f'\n## {title}\n')
        if note and items:
            print(note + '\n')
        print('\n'.join(items) if items else 'None.')

    print(f'# freezed copyWith audit: `{name}` ({MODEL})')
    if not was_freezed:
        print(f'\n`{name}` is not on freezed yet; the probe added `@freezed` for this run only. It audits `copyWith`; '
              'freezed would also replace `==`, `hashCode` and `toString`, which this does not check.')
    if missing or retyped:
        print('\n**Verdict: freezed\'s `copyWith` cannot replace this one as it stands.** freezed builds `copyWith` '
              'from the constructor and keeps a parameter only when a field has the same name and type. Keep '
              '`@Freezed(copyWith: false)` with the hand-written method, or reshape the constructor first.')
    section('Parameters freezed does not generate', [f'- `{p}`' for p in missing] + missing_rows,
            'A constructor parameter backed by a getter, a private field or a differently named field gets no '
            '`copyWith` parameter. Every call below stops compiling.')
    section('Parameters whose type changes', [f'- `{p}`: `{t}` in `copyWith`, `{f}` on the field' for p, t, f in retyped],
            'freezed types the parameter from the constructor, not the field.')
    section('Compile breaks (non-nullable parameter given a nullable value, or a retyped parameter)', compile_rows)
    section('Nullable argument sites (null now clears instead of keeping)', nullable_rows)
    section('Constructor-default trap (passing null regenerates the default)', [f'- `{p}`' for p in ctor_traps])
    sentinels = [f'`{p}`' for p, (_, s) in v10_params.items() if s]
    section('v10 parameters with a `_nullConst` sentinel', [', '.join(sentinels)] if sentinels else [])


MODEL = Path()

if __name__ == '__main__':
    main()
