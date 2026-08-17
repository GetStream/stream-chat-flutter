---
name: flutter-version-bump
description: >
  Adopt a new Flutter stable release on the v9 branch — diagnose and fix the analyze, format, golden, and build
  failures a new toolchain introduces, while keeping the published minimum at v9's frozen Flutter 3.27.4 / Dart
  3.6 floor. Use when CI suddenly goes red after a Flutter release, when `dart analyze --fatal-infos` reports
  diagnostics that did not exist before, when goldens drift after upgrading, or when asked to "support Flutter X"
  on v9.
allowed-tools:
  - Bash
  - Read
  - Edit
  - Write
  - Grep
  - Glob
---

# flutter-version-bump (v9)

Two different jobs share the phrase "bump Flutter". Decide which one you are doing **before** touching a file —
they produce different diffs, different review burdens, and only one of them is breaking for consumers.

| Track | Goal | Scope | Consumer impact | Reference PR |
|---|---|---|---|---|
| **A — Compat** (the normal case) | Make CI green on the new stable | Source fixes, lint config, goldens, CI/Android/iOS floors | None | [#2895](https://github.com/GetStream/stream-chat-flutter/pull/2895) |
| **B — Floor raise** (exceptional on v9) | Move the minimum Flutter/Dart | 12 pubspecs + `.fvmrc` + `legacy_version_analyze.yml` + 5 CHANGELOGs + newly-activated lints + (if crossing Dart 3.7) a repo-wide reformat | Apps below the floor stop resolving | [#2108](https://github.com/GetStream/stream-chat-flutter/pull/2108) (last one) |

**v9's floor is frozen, not policy-driven.** The v9 floor has sat at Flutter `>=3.27.4` / Dart `^3.6.2` since
#2108 — v9 is the maintenance line and its value is precisely that it keeps supporting older Flutters. So on v9,
"bump Flutter" almost always means **Track A only**. A v9 floor raise is a maintainer decision — never infer it
from a new stable shipping. If one is decided, see Step 6 for what it drags in (on v9 it is bigger than it looks:
crossing Dart 3.7 flips `dart format` to the tall style and reformats the entire repo).

When Track B does happen, the repo does **not** treat it as a breaking change: no `!` in the commit/PR title, and
the CHANGELOG bullet goes under `🔄 Changed`, not `🛑️ Breaking`. Existing code keeps compiling; older SDKs simply
stop resolving the new version. Follow that precedent (#2108, #2068) rather than inventing a `!`.

## Why CI breaks the day a Flutter stable ships

`stream_flutter_workflow.yml` sets, at the top:

```yaml
env:
  flutter_version: "3.x"
```

and every job in it — `analyze`, `format`, `test`, `build` — installs Flutter via `subosito/flutter-action@v2`
with that version, so they all **auto-adopt the new stable within hours of release**. Two more places pin `"3.x"`
independently and adopt it too: `update_goldens.yml` and `.github/actions/pana/action.yml` (used by `pana.yml`).
`.fvmrc` (local dev) and `legacy_version_analyze.yml` (both pinned to the 3.27.4 floor) do *not* follow. So the
first symptom is always "CI went red and nobody changed anything", while every local machine still passes.

`melos run analyze` runs `dart analyze --fatal-infos` per package. New SDKs ship new diagnostics as **infos and
warnings**, which `--fatal-infos` turns into hard failures. That is why an SDK bump hurts here more than in a
typical repo.

### Check the canary first — it usually already told you

`beta_version_analyze.yml` runs `package_analysis` against the **beta** channel every Monday and Slacks on
failure. Beta becomes stable roughly a quarter later, so this workflow reports the next release's failures
*months* early. Before investigating anything, read its history:

```bash
gh run list --workflow=beta_version_analyze.yml --limit 10
gh run view <id> --log-failed | grep -E "warning -|info -|error"
```

A run of consecutive failures is the diagnosis handed to you for free — the failing lines are the same ones the
new stable is about to produce, and the first red date tells you when the regression entered beta.

Traps when reading it:

- **Scheduled runs execute on the repo's default branch, not v9.** The canary analyzes that branch's code, so
  its failing lines apply to v9 only where the source is shared — check them against v9's files before assuming
  they reproduce here, and expect v9-only code to have no canary coverage at all.

- **It fails fast.** `package_analysis` runs one step per package, and a failed step skips all later ones — so
  the first failing package masks every later one. A canary reporting one issue in `stream_chat` does *not* mean
  the rest are clean.
- **Per package it analyzes `lib/` only, then runs `flutter test --exclude-tags golden`.** So it does catch
  test-visible regressions (new runtime assertions), but never golden drift, never `test/`-only analyzer issues,
  and never `sample_app` (it covers the five `packages/*` only).

If the canary has been red and unactioned for weeks, that is the most valuable finding in the exercise — report
it separately from the code fixes. Either the Slack alert is not reaching anyone or it is being ignored, and
fixing that is worth more than any single lint fix.

## Step 1 — Branch off v9

Never branch a toolchain bump off a feature branch. Bootstrap rewrites lockfiles repo-wide.

```bash
git fetch origin
git checkout -b chore/flutter-<version>-v9 origin/v9
```

The PR's base is `v9`, not `master`.

## Step 2 — Install the new SDK side by side

Keep the old one. Every claim below is an A/B comparison, and you cannot make one with a single toolchain.

```bash
fvm install <new>                       # e.g. 3.47.0
fvm list                                # confirm old + new are both cached
NEW=~/fvm/versions/<new>
OLD=~/fvm/versions/$(python3 -c "import json;print(json.load(open('.fvmrc'))['flutter'])")
```

Do **not** edit `.fvmrc`. On v9 it stays at the floor permanently — local dev builds against the minimum so
newer APIs get caught. `$OLD` is both the "before" side of the comparison *and* the floor the fixes must keep
supporting.

## Step 3 — Measure before you fix

The single most important habit: **never attribute a failure to the new SDK without seeing the old SDK pass it.**
Repos accumulate drift; a feature branch may already be dirty; a local `build/` directory may inject hundreds of
phantom issues. Run each check under both toolchains and diff.

### Format — check the language version BEFORE running any formatter

v9 formats at dart_style's default 80 columns with **no** `formatter:` section, and its language version is
**3.6 — below the 3.7 tall-style cutover**. `dart format` reads the language version from each package's
`.dart_tool/package_config.json` (written by `pub get`), **not** from `pubspec.yaml`. A stale `.dart_tool` left
over from a branch that resolves at ≥3.7 makes the formatter apply the **tall style** and rewrite the whole repo
with sticky trailing commas. Verify first, and bootstrap if wrong:

```bash
python3 -c "import json;d=json.load(open('packages/stream_chat/.dart_tool/package_config.json'));\
print([p.get('languageVersion') for p in d['packages'] if p['name']=='stream_chat'])"
# expect ['3.6'] — anything ≥3.7 means: melos bootstrap before formatting anything
```

If a tall-style pass already polluted files, **re-formatting after bootstrap will not undo it** — the tall
formatter's trailing commas are sticky under the short formatter. `git restore` the polluted files.

CI runs bare `dart format --set-exit-if-changed .` at the root (`melos run format`), then
`validate-formatting.sh`, which fails on `git ls-files --modified` — **tracked files only**. So the `build/` and
`.symlinks/` trees the formatter walks are noise that can never fail CI. Scope to tracked files and compare:

```bash
git ls-files '*.dart' > /tmp/dartfiles.txt
for V in $OLD $NEW; do
  echo "== $V"
  $V/bin/cache/dart-sdk/bin/dart format --output=none --set-exit-if-changed $(cat /tmp/dartfiles.txt) 2>&1 | tail -3
done
```

Interpretation:

- **Both 0 changed** → the formatter did not change. Do not touch formatting in this PR. This is the expected
  result on v9: at language version 3.6, both old and new SDKs use the short style, so formatter churn should be
  rare until a floor raise crosses 3.7.
- **New > 0, old = 0** → `dart_style` changed behaviour *at 3.6*. Apply it as an **isolated commit** touching
  nothing else, so the real fixes stay reviewable.
- **New > 0 in the thousands** → you are almost certainly seeing the tall style via a stale package config, not
  a real formatter change. Re-check the language version before believing it.
- **Old > 0, new = 0** → pre-existing drift, harmless. Not yours to fix here — but mention it.

### Analyze

> **Run `melos bootstrap` first, and re-run it after every pubspec edit.** Same `package_config.json` mechanism
> as above: `dart analyze` reads the language version from `.dart_tool`, so a stale one reports a confidently
> clean result CI will not reproduce, and editing an SDK constraint without re-bootstrapping changes nothing.

Mirror `melos run analyze` (`--fatal-infos`; melos ignores `*example*`, and there is no `docs/` package on v9)
and **filter local build artifacts**, which are not in CI and will otherwise bury the real signal:

```bash
set -o pipefail   # otherwise a matching grep masks an analyzer that crashed
for V in $OLD $NEW; do
  echo "##### $V"
  for p in packages/stream_chat packages/stream_chat_flutter_core packages/stream_chat_flutter \
           packages/stream_chat_persistence packages/stream_chat_localizations sample_app; do
    echo "### $p"
    # `|| true` so a package with no diagnostics is not reported as a failure
    (cd "$p" && $V/bin/cache/dart-sdk/bin/dart analyze --fatal-infos . 2>&1 \
      | { grep -E "^\s+(info|warning|error)" | grep -v " build/" || true; })
  done
done
```

Everything present under `$NEW` and absent under `$OLD` is your work list. Everything in both is pre-existing —
leave it alone and say so.

### Tests and goldens — `CI=true` is mandatory

`packages/stream_chat_flutter/test/flutter_test_config.dart` disables alchemist's platform goldens when `CI` or
`GITHUB_ACTIONS` is set:

```dart
platformGoldensConfig: PlatformGoldensConfig(enabled: !isRunningInCi),
```

**Only `goldens/ci/` is committed** (~140 files, all under `packages/stream_chat_flutter/test/`). A bare
`flutter test` on your machine runs the *platform* variant, whose goldens do not exist in the repo, and fails a
pile of tests that have nothing to do with the new SDK. Always:

```bash
(cd packages/stream_chat_flutter && CI=true $OLD/bin/flutter test --reporter=compact > /tmp/t-old.log 2>&1)
# CI bootstraps FRESH under the new stable, and package pubspec.locks are untracked bootstrap
# products (only the workspace root lock is committed). Carrying the floor's lockfile into the
# new-SDK run pins floor-era dependency versions that may not even compile there — alchemist
# 0.11.0 fails to build against 3.47's dart:ui, which kills every test file at load and looks
# like 100+ regressions. Re-resolve like CI before the new-side run:
(cd packages/stream_chat_flutter && rm -f pubspec.lock example/pubspec.lock && $NEW/bin/flutter pub get)
(cd packages/stream_chat_flutter && CI=true $NEW/bin/flutter test --reporter=compact > /tmp/t-new.log 2>&1)
# compare the failure sets, not the counts — `\r` matters, the compact reporter uses it; and
# normalize on `/test/`, not `/test/src/` — this package has suites outside src/ whose reporter
# timing prefixes otherwise make every line unique and break the comparison
for S in old new; do
  tr '\r' '\n' < /tmp/t-$S.log | grep -E '\[E\]$' \
    | sed -E 's/^[0-9]+:[0-9]+ \+[0-9]+( ~[0-9]+)?( -[0-9]+)?: //; s|^.*/test/|test/|; s/ \[E\]$//' \
    | sort -u > /tmp/fail-$S.txt
done
comm -13 /tmp/fail-old.txt /tmp/fail-new.txt   # caused by the new SDK
comm -12 /tmp/fail-old.txt /tmp/fail-new.txt   # pre-existing, out of scope
```

When you are done with the new-side runs, `melos bootstrap` (under the floor SDK) restores local resolution.

Repeat for the other packages with tests (`stream_chat`, `stream_chat_flutter_core`, `stream_chat_persistence`,
`stream_chat_localizations`).

Some CI goldens fail on macOS even on the old SDK — they are rendered on Linux runners. That baseline noise is
exactly what `comm` separates out. **Only the lines the new SDK adds are yours.**

Two macOS-specific distortions to keep in mind when reading the `comm` output:

- **New-SDK-only lines are suspects, not convictions.** macOS can add new-SDK failures CI never sees: in the
  3.47 adoption, ~20 plain behavioral tests (tap a button, expect a callback) failed under the new SDK on macOS
  while CI's Linux runners stayed green. Golden entries in the new-only list are real drift — CI regenerates
  them anyway — but confirm a *behavioral* entry actually fails in CI before spending time on it.
- **Some real golden drift hides in the pre-existing bucket.** A golden that already fails on macOS under the
  old SDK (Linux-rendered baseline) cannot show up as "new" locally even if the new SDK also moved it on Linux.
  Harmless for the same reason: the regeneration workflow rewrites the whole suite, not just the files you
  spotted locally.

> **Never run `git checkout -- .` between runs.** Alchemist only writes untracked `failures/*.png` directories,
> so there is nothing to revert — and a blanket checkout silently destroys the source fixes you just made. Clean
> up with `git clean -fd -- '*/failures'` instead, and keep `git status --short` in view.

## Step 4 — Fix, by failure class

Work the diff from Step 3. Known classes and this repo's chosen remedy:

### New analyzer diagnostics (the usual bulk)

New SDKs add diagnostics that `--fatal-infos` promotes to failures. Treat each as a real finding first — most of
them point at a genuine latent bug — and only suppress when the diagnostic is wrong about this code.

| Remedy | When |
|---|---|
| Fix the code | Default. The diagnostic is usually right. |
| `// ignore: <name>` with a one-line reason above it | The diagnostic is correct in general but wrong here, or the fix belongs to an upstream package. Never a bare ignore. |
| Delete the rule from `analysis_options.yaml` | The lint was **removed or renamed** by the SDK. An unrecognized rule name is itself a warning. |

To find removed/renamed/deprecated lints mechanically rather than by guessing, analyse the options file itself —
`melos run analyze` never does, because the root `analysis_options.yaml` sits **outside** every melos package:

```bash
for V in $OLD $NEW; do
  echo "== $V"; $V/bin/cache/dart-sdk/bin/dart analyze --fatal-infos analysis_options.yaml
done
```

`undefined_lint` means the rule was removed or renamed — delete it, it is a hard failure. `deprecated_lint` means
it still parses but is on its way out — safe to delete now, and cheaper than discovering it as `undefined_lint`
two releases later. Run it under both toolchains: a `deprecated_lint` that also fires on the old SDK is
pre-existing debt, not something this release introduced.

### New *lint rules* are a separate PR — never this one

Distinguish two things a new SDK brings, and do not let them share a branch:

- **New diagnostics that fire on their own.** These break CI whether you like it or not. Fix them here.
- **New lint rules you could opt into.** `analysis_options.yaml` is a hand-curated allowlist, so these stay off
  until someone enables them. They are a code-style decision, not a toolchain fix — **always their own PR**, with
  their own before/after numbers and their own review.

Two findings that generalise if you do enumerate candidates:

- **A rule with zero violations may just be dormant.** Lints stay silent while their fix is not expressible at
  the current language version — and v9's language version is pinned at 3.6, far below the current SDK, so
  dormancy is the *common case* here, not the exception. Enabling a dormant rule schedules a surprise repo-wide
  diff for whichever release finally raises the floor.
- Rules the floor's analyzer (3.27.4 / Dart 3.6) does not recognise are **silently ignored** there, not errors —
  `undefined_lint` only surfaces when you analyse the options file directly. So adopting a new-SDK-only rule will
  not break `legacy_version_analyze`; it just is not enforced on the floor.

### Framework deprecations

New `deprecated_member_use` infos are fatal here. Prefer migrating to the replacement API — **but the replacement
must exist on Flutter 3.27.4**, and with v9's floor this far behind the current stable, it frequently does not.
When it does not, you cannot use it: suppress with a scoped ignore naming the reason, and leave the migration to
a release that raises the floor. Expect scoped ignores to be the common outcome here; that is the cost of the
frozen floor, not sloppiness.

### New runtime assertions

Flutter adds asserts that only fire in tests, so they surface as widget-test failures, not analyzer output. Read
the assertion and fix the widget tree; do not silence the test. Example of the class: Flutter 3.44 added an
assertion in `ListTile._findIntermediateWidget` that fired whenever a `ColoredBox`/`DecoratedBox` sat between a
tappable `ListTile` and its nearest `Material` — fixed by replacing the `DecoratedBox` with a `Material` carrying
the same colour and radius. These fixes must also still pass on the floor, since the legacy job runs the
non-golden test suite at 3.27.4.

### Golden pixel drift

Small diffs (well under 1%) across unrelated widgets mean the engine's rasterisation changed — legitimate, and
the goldens must be regenerated (#2895 regenerated seven for exactly this). Larger diffs confined to one widget
family usually mean a real layout change; investigate before regenerating.

**Goldens are always regenerated by the CI workflow — never locally. No exceptions.**

`melos run update:goldens` writes the *platform* variant on your machine; the committed `goldens/ci/*.png` are
Linux-rendered. Regenerating locally therefore commits macOS-rendered pixels that CI immediately rejects, or
platform goldens the repo does not even track. Locally you may **compare** (`CI=true flutter test`) to see which
goldens moved — never write them.

`update_goldens.yml` commits back to whatever branch you dispatch against, so **push the branch first**.

> **Confirm with the user before running this.** It pushes a branch and dispatches a workflow that writes a
> commit to the remote using `secrets.BOT_SSH_PRIVATE_KEY`. It is the one outward-facing action in this skill —
> never dispatch it unprompted, and expect the branch to stay red on goldens until it has run.

```bash
git push -u origin chore/flutter-<version>-v9
gh workflow run update_goldens.yml --ref chore/flutter-<version>-v9
gh run watch $(gh run list --workflow=update_goldens.yml --limit 1 --json databaseId --jq '.[0].databaseId')
git pull    # pick up the bot's "chore: Update Goldens" commit
```

The workflow takes **no inputs** — there is a single Linux job covering every alchemist-using package (in
practice `stream_chat_flutter` only). It installs Flutter via `flutter-version: "3.x"`, so it regenerates
against the **new** stable automatically.

Two consequences to state plainly when you report:

- **The branch is not verifiable-green on macOS.** Even after regeneration, a local `CI=true` run still shows the
  pre-existing Linux-vs-macOS baseline diffs from Step 3. Give the reviewer that number so a non-zero local
  failure count is not read as "the fix did not work".
- `legacy_version_analyze.yml` excludes golden tests (`--exclude-tags golden`), so regenerating against the new
  stable cannot break the floor job.

### Files the toolchain rewrites underneath you

`melos bootstrap` and `flutter pub get` both edit tracked files. Sort them into "commit" and "never commit" —
getting this wrong either breaks CI or leaves everyone with a permanently dirty tree.

| What | Where | Verdict |
|---|---|---|
| `analyzer.exclude` block (`build/**`, `android/**`, `ios/**`, `web/**`, `windows/**`, `macos/**`, `linux/**`) injected into an app-type `analysis_options.yaml` | `sample_app/`, `packages/stream_chat_flutter_core/example/` | **Already committed on v9** (#2895). Keep all seven entries verbatim — see below. |
| `test_api: any` / `flutter_test: any` appended to `dev_dependencies` | `sample_app/pubspec.yaml` | **Never commit.** Melos injects these around bootstrap and normally strips them again; they get left behind when a run does not complete cleanly. `flutter_test` has no pub.dev version, so committing it makes the next `melos bootstrap` fail version solving outright. |
| `version.dart` and the `sample_app` version line, rewritten by the `version:update` bootstrap post-hook | `packages/stream_chat/lib/version.dart`, `sample_app/pubspec.yaml` | Commit only if the version actually changed. |

Anything bootstrap rewrites and you do not commit will fail the **format** job — `validate-formatting.sh` fails
on any `git ls-files --modified` *after* bootstrap, and reports it under the misleading heading "These files are
not formatted correctly."

#### The injected `analyzer.exclude` block — decided on v9, do not relitigate

Flutter ≥3.47's `pub get` writes that seven-entry exclude block into every *app-type* package (has a `flutter:`
SDK dep and platform directories). It is needed: `ios/.symlinks` and `macos/.symlinks` are symlinks into
`~/.pub-cache` (hundreds of third-party `.dart` files that the analyzer follows — `find` without `-L` misses
them), and without the exclusion `--fatal-infos` judges all of it against this repo's rule set.

v9 committed the block in #2895, and that is also the **only stable state**: `pub get` merges its full list into
any existing `exclude:`, so trimming it just means every future `melos bootstrap` dirties the file and the format
job fails. Keep all seven entries verbatim. If a later Flutter extends the list, commit the merge result — after
verifying with a throwaway worktree that it really is `pub get` doing the writing:

```bash
# Probe in a throwaway worktree — never `git checkout` over your working copy, which
# is exactly how you lose the change this PR is making.
probe=$(mktemp -d)/probe
git worktree add --detach "$probe" origin/v9
(cd "$probe/sample_app" && flutter pub get) \
  && git -C "$probe" diff --stat -- sample_app/analysis_options.yaml
git worktree remove --force "$probe"
```

### Shared dependency floors live in `melos.yaml` too

v9's `melos.yaml` carries a repo-wide dependency catalog under `command.bootstrap.dependencies` /
`dev_dependencies`. When a new Flutter forces a third-party package floor up (a plugin embedding fix, an API the
new engine removed), the bump goes in **both** the affected package pubspecs *and* that catalog — otherwise
bootstrap re-pins the old floor. Precedent: #2895 raised `rate_limiter` to `^1.1.1` in `melos.yaml` alongside the
pubspec edits. Any such floor must still resolve on Flutter 3.27.4 / Dart 3.6 — check the dependency's own SDK
constraints before raising it.

### Android / iOS build floors

The `build` matrix job compiles `sample_app` for both platforms via fastlane (`build_apk` on ubuntu,
`build_ipa no_codesign:true` on `macos-15` with Xcode pinned at `26.3`). Every Flutter release raises its
Gradle / AGP / Kotlin floors, and the check is **fail-fast** — it reports only the first violated floor, so
fixing one commonly just reveals the next. Read all of them out of the SDK up front instead of iterating through
CI:

```bash
grep -n "Version(" $NEW/packages/flutter_tools/gradle/src/main/kotlin/DependencyVersionChecker.kt | head
```

Each tool has an `error…Version` (hard floor, fails the build) and a `warn…Version` (deprecation only). v9's
precedent is **minimal churn**: raise only the tools that violate an *error* floor, and raise them to the floor —
not to the newest combination the release notes advertise. The 3.47 adoption (#2895):

| Tool | pre-bump | 3.47 error floor | #2895 action | Set in |
|---|---|---|---|---|
| Gradle | 8.13 | 8.14.0 | → 8.14.3 | `sample_app/android/gradle/wrapper/gradle-wrapper.properties` |
| Kotlin (KGP) | 2.1.20 | 2.2.20 | → 2.2.20 | `sample_app/android/settings.gradle` |
| AGP | 8.12.2 | 8.11.1 | untouched — already above the floor | `sample_app/android/settings.gradle` |

The release notes also publish an **"Android dependency matrix"** — the combination Flutter actually tested,
typically far ahead of the floors (3.47's matrix: Gradle 9.3.1 / AGP 9.1.0 / KGP 2.4.0). Jumping to it buys
headroom against the next release's floors, but it is a bigger, riskier diff than the maintenance branch needs.
If you do adopt it, its versions are mutually constrained — move all of them together or not at all.

Also prefer the SDK's API-level variables (`flutter.compileSdkVersion`, `targetSdkVersion`, `minSdkVersion`) over
hardcoded numbers, so future releases carry the project forward automatically, and check
`sample_app/android/{app/build.gradle,build.gradle,gradle.properties}` for SDK floors.

**Validate Android locally — you probably can.** `flutter doctor` showing a working Android toolchain means
`(cd sample_app && flutter build apk --release)` reproduces the CI `build (android)` job in one shot, instead of
5-minute CI round trips per attempt. Only fall back to "unverifiable locally" if the toolchain is genuinely
missing.

> The five `packages/*/example/android` projects are still on Gradle 7.6 and are **not** built by CI, so they
> never gate a PR. They are broken for anyone building an example locally on a modern Flutter. Out of scope for a
> compat bump — but say so rather than letting it look verified.

If a Flutter release raises its Xcode floor above the pinned `26.3`, the pin must move — it appears in
`stream_flutter_workflow.yml` *and three more times* in `distribute_internal.yml` / `distribute_external.yml`.
A release that raises the **macOS** floor can also strand the `macos-15` runner those same jobs pin.

The iOS build is the one job you realistically cannot verify locally — a full fastlane IPA build is slow and
needs toolchains most machines lack. That is fine, but **say so**: report it as unverified and let the PR's own
CI run be the check, rather than implying the branch is fully green.

## Step 5 — Verify like CI does

```bash
melos bootstrap
melos run analyze
melos run format && ./.github/workflows/scripts/validate-formatting.sh
CI=true melos run test:all
git status --short          # expect only your intended edits
git clean -fdn -- '*/failures'   # review, then drop -n to remove alchemist's diff images
```

Two things will still look wrong locally and are not:

- `melos run analyze` surfaces `build/` noise if you have ever built the sample app. Compare against Step 3's
  baseline instead of expecting a clean zero.
- `CI=true melos run test:all` still fails the pre-existing Linux-vs-macOS goldens. Compare failure **sets**, not
  counts.

Then re-check the floor, because `legacy_version_analyze.yml` gates the PR — per package it analyzes `lib/`
**and runs the non-golden test suite** on 3.27.4:

```bash
for p in packages/*/; do
  (cd "$p/lib" && $OLD/bin/cache/dart-sdk/bin/dart analyze --fatal-infos .) \
    && (cd "$p" && [ -d test ] && CI=true $OLD/bin/flutter test --exclude-tags golden)
done
```

A fix that relies on syntax or API newer than the floor passes on `$NEW` and fails that job. On v9 this is the
check most likely to bite, because the gap between floor and stable is years wide.

## Step 6 — Track B: raising the floor (exceptional — maintainer decision only)

Do not start this because a new stable shipped; v9's floor is deliberately frozen. If maintainers decide to move
it anyway, keep it out of the Track A commit and know what it drags in.

Version-carrying files, all of which must move together:

- `.fvmrc` — `flutter`
- `melos.yaml` — `command.bootstrap.environment.{sdk,flutter}` (the source of truth; `melos bs` propagates)
- `pubspec.yaml` (workspace root) — `environment.sdk`
- `packages/*/pubspec.yaml` × 5 — `sdk`, and `flutter` on the four Flutter packages (`stream_chat` is pure Dart
  and carries **no** `flutter` constraint — do not add one)
- `packages/*/example/pubspec.yaml` × 5
- `sample_app/pubspec.yaml`
- `.github/workflows/legacy_version_analyze.yml` — `env.flutter_version`. Set it to the **new floor** (never the
  new stable): this job exists to prove the floor still analyses and tests clean.

Pair the Flutter minor with its Dart SDK (`fvm releases` lists both).

### Crossing Dart 3.7 reformats the entire repository

v9 sits at language version 3.6, the last short-style version of `dart_format`. Any floor raise to Dart ≥3.7
flips every package to the **tall style** — a repo-wide mechanical diff on the order of hundreds of files that
must be its own isolated commit, and that permanently changes how this branch formats. It also
invalidates this skill's Step 3 assumption that format A/B diffs are near-zero. Do not fold it into anything
else, and make sure the maintainer deciding the raise knows this diff is part of the price.

### The floor raise activates dormant lints — budget for it

Raising the Dart constraint raises each package's **language version**, and lints stay silent while their
suggested fix is not yet expressible. Raise the floor and they all fire at once, in code nobody touched — for
example, `prefer_initializing_formals` cannot fire until Dart 3.12 legalises `this._privateField` as a named
parameter. With v9 jumping several language versions in one step, expect *multiple releases' worth* of
activations at once.

So: **`melos bootstrap` and re-analyse immediately after editing the constraints**, before you write the
CHANGELOG. Then let the tooling do the mechanical work:

```bash
for p in packages/*/ sample_app; do (cd $p && dart fix --dry-run); done
# then, per lint, once you have decided the fix is right:
(cd <pkg> && dart fix --apply --code=<lint_name>)
```

Two things to check by hand afterwards — `dart fix` is mechanical, not thoughtful:

- **Doc comments get mangled *and silently deleted*.** It rewrites `[logger]` to `[_logger]` in the doc above the
  constructor — leaking a private name into public API docs, when callers still pass the *public* name
  (`logger:`, underscore stripped). It also drops any `///` comment attached to the parameter it rewrites. Review
  every comment line the refactor touched, in both directions:

  ```bash
  git diff -- '*.dart' | grep -E "^[-+]\s*(///|//)"
  ```

  Checking only added lines misses the deletions — that is how a lost doc comment survives review.
- **Confirm no public parameter was renamed.** For every `this._foo` it introduced, the parameter it replaced
  must have been named exactly `foo`. It always should be, but a mismatch is a silent breaking change for
  callers.

If a package uses codegen (`@JsonSerializable`, `freezed`, `drift`), re-run `melos run generate:all` afterwards
and confirm the generated call sites are unchanged — the generators read constructor parameters, and a renamed
parameter would silently change `.g.dart`. Then `dart format` the regenerated files before concluding codegen
"changed" anything — pure-reflow diffs are the formatter's, not the generator's.

Then one short bullet under `🔄 Changed` in each of the five package CHANGELOGs:

```md
- Raised minimum Flutter to `>=X.Y.Z` and Dart SDK to `^A.B.C`.
```

`stream_chat` is Dart-only — its bullet mentions the Dart SDK only.

Finish with `melos bootstrap` and commit whatever tracked files it legitimately rewrote (Step 4's table says
which).

## Step 7 — Changelog and PR

Track A changes that are user-visible (a widget swapped, a deprecation migrated, a dependency floor raised) get a
CHANGELOG bullet in the affected package — one sentence stating the observable behavior, under the matching emoji
heading (`✅ Added` / `🔄 Changed` / `🐞 Fixed`). Pure CI/tooling/golden churn does not.

PR title follows Conventional Commits, base branch `v9`:

- Track A → `chore(repo): support Flutter <version>` (precedent: #2895)
- Track B → `chore(repo): bump min flutter version to <version>` (precedent: #2108)

## Report back with attribution

When summarising, always separate the three buckets — it is the difference between a reviewable PR and a mystery:

1. **Caused by the new SDK** (present on new, absent on old) — what this PR fixes.
2. **Pre-existing** (present on both) — explicitly out of scope, named so nobody re-investigates.
3. **Local-only noise** (`build/` artifacts, platform goldens without `CI=true`) — never appears in CI, never
   fix.
