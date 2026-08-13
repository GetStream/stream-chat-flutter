---
name: flutter-version-bump
description: >
  Adopt a new Flutter stable release in this monorepo — diagnose and fix the analyze, format, golden, and build
  failures a new toolchain introduces, then raise the published minimum Flutter/Dart floor to the SDK's
  "latest stable − 1" policy. Use when CI suddenly goes red after a Flutter release, when
  `dart analyze --fatal-infos` reports diagnostics that did not exist before, when goldens drift after upgrading,
  or when asked to "support Flutter X" or "bump the min Flutter version".
allowed-tools:
  - Bash
  - Read
  - Edit
  - Write
  - Grep
  - Glob
---

# flutter-version-bump

Two different jobs share the phrase "bump Flutter". Decide which one you are doing **before** touching a file —
they produce different diffs, different review burdens, and only one of them is breaking for consumers.

| Track | Goal | Scope | Consumer impact | Reference PR |
|---|---|---|---|---|
| **A — Compat** (first) | Make CI green on the new stable | Source fixes, lint config, goldens, CI/Android/iOS floors | None | [#2667](https://github.com/GetStream/stream-chat-flutter/pull/2667) |
| **B — Floor raise** (policy-driven) | Move the minimum to latest − 1 | 13 pubspecs + `.fvmrc` + `legacy_version_analyze.yml` + 5 CHANGELOGs + newly-activated lints | Apps below the floor stop resolving | [#2721](https://github.com/GetStream/stream-chat-flutter/pull/2721) |

The repo does **not** treat a floor raise as a breaking change: no `!` in the commit/PR title, and the CHANGELOG
bullet goes under `🔄 Changed`, not `🛑️ Breaking`. Existing code keeps compiling; older SDKs simply stop
resolving the new version. Follow that precedent (#2721, #2108, #2068) rather than inventing a `!`.

**Do Track A first, always.** "CI broke after the new Flutter came out" is Track A, and it must land green before
Track B starts — otherwise you cannot tell a floor-raise failure from a new-stable failure.

**Then check whether Track B is due.** The SDK's policy is **minimum supported = latest stable − 1**, so a new
stable makes the floor raise *routine, not exceptional*: when 3.47 shipped, the floor moved 3.41 → **3.44**. Pair
each Flutter minor with its Dart SDK (3.44 → Dart 3.12, 3.47 → Dart 3.13); `fvm releases` lists both.

Track B belongs in a minor/major release rather than a hotfix, and must be its own commit — its diff (13 pubspecs
+ whatever lints the new language version activates) has nothing to do with the compat fixes.

Three version knobs move together on a floor raise, and they are all the *floor*, never the new stable:

| Knob | Value |
|---|---|
| `melos.yaml` `environment` | the new floor — source of truth, `melos bs` propagates |
| `.fvmrc` | the new floor — local dev builds against the minimum, so newer APIs get caught |
| `legacy_version_analyze.yml` `flutter_version` | the new floor — this job *is* the floor's regression test |

## Why CI breaks the day a Flutter stable ships

`.github/actions/setup-flutter/action.yml` pins:

```yaml
flutter-version: "3.x"
channel: stable
```

Every job that uses it — `analyze`, `format`, `test`, `build` in `stream_flutter_workflow.yml`, plus both jobs in
`update_goldens.yml` — **auto-adopts the new stable within hours of release**. `.fvmrc` (local) and
`legacy_version_analyze.yml` (the N-1 canary) do *not* follow it. So the first symptom is always "CI went red and
nobody changed anything", while every local machine still passes.

`melos run analyze` runs `dart analyze --fatal-infos`. New SDKs ship new diagnostics as **infos and warnings**,
which `--fatal-infos` turns into hard failures. That is why an SDK bump hurts here more than in a typical repo.

### Check the canary first — it usually already told you

`beta_version_analyze.yml` runs `package_analysis` against the **beta** channel every Monday and Slacks on
failure. Beta becomes stable roughly a quarter later, so this workflow reports the next release's analyzer
failures *months* early. Before investigating anything, read its history:

```bash
gh run list --workflow=beta_version_analyze.yml --limit 10
gh run view <id> --log-failed | grep -E "warning -|info -|error"
```

A run of consecutive failures is the diagnosis handed to you for free — the failing lines are the same ones the
new stable is about to produce, and the first red date tells you when the regression entered beta.

Two traps when reading it:

- **It fails fast.** `package_analysis` analyzes packages sequentially with `&&`, so the first failing package
  masks every later one. A canary reporting one issue in `stream_chat` does *not* mean the rest are clean.
- **It only analyzes `lib/`,** per package, and never runs golden tests. Test-only and golden regressions never
  appear here.

If the canary has been red and unactioned for weeks, that is the most valuable finding in the exercise — report
it separately from the code fixes. Either the Slack alert is not reaching anyone or it is being ignored, and
fixing that is worth more than any single lint fix.

## Step 1 — Branch off master

Never branch a toolchain bump off a feature branch. Bootstrap rewrites lockfiles repo-wide.

```bash
git fetch origin
git checkout -b chore/flutter-<version> origin/master
```

## Step 2 — Install the new SDK side by side

Keep the old one. Every claim below is an A/B comparison, and you cannot make one with a single toolchain.

```bash
fvm install <new>                       # e.g. 3.47.0
fvm list                                # confirm old + new are both cached
NEW=~/fvm/versions/<new>
OLD=~/fvm/versions/$(python3 -c "import json;print(json.load(open('.fvmrc'))['flutter'])")
```

Do **not** edit `.fvmrc` yet. It is the "old" side of the comparison until Step 6.

## Step 3 — Measure before you fix

The single most important habit: **never attribute a failure to the new SDK without seeing the old SDK pass it.**
Repos accumulate drift; a feature branch may already be dirty; a local `build/` directory may inject hundreds of
phantom issues. Run each check under both toolchains and diff.

### Format

CI runs bare `dart format --set-exit-if-changed .` at the root, then `validate-formatting.sh`, which fails on
`git ls-files --modified` — **tracked files only**. So the `build/` and `.symlinks/` trees the formatter walks are
noise that can never fail CI. Locally they only pollute your output, so scope to tracked files and compare:

```bash
git ls-files '*.dart' > /tmp/dartfiles.txt
for V in $OLD $NEW; do
  echo "== $V"
  $V/bin/cache/dart-sdk/bin/dart format --output=none --set-exit-if-changed $(cat /tmp/dartfiles.txt) 2>&1 | tail -3
done
```

Interpretation:

- **Both 0 changed** → the formatter did not change. Do not touch formatting in this PR.
- **New > 0, old = 0** → `dart_style` changed. Apply it as an **isolated commit** touching nothing else, so the
  real fixes stay reviewable. A tall-style-scale change (Dart 3.10 reformatted ~600 files in
  [#2495](https://github.com/GetStream/stream-chat-flutter/pull/2495)) is the whole PR on its own.
- **Old > 0, new = 0** → the repo is already formatted for a formatter newer than `.fvmrc`. Pre-existing drift,
  harmless (`legacy_version_analyze` only analyzes, it never formats). Not yours to fix here — but mention it.

### Analyze

> **Run `melos bootstrap` first, and re-run it after every pubspec edit.** `dart analyze` reads the *language
> version* from `.dart_tool/package_config.json`, which is written by `pub get` — **not** from `pubspec.yaml`. A
> stale `.dart_tool` (e.g. left over from another branch) reports a confidently clean result that CI will not
> reproduce, and editing an SDK constraint without re-bootstrapping changes nothing at all. Verify with:
>
> ```bash
> python3 -c "import json;d=json.load(open('packages/stream_chat/.dart_tool/package_config.json'));\
> print([p.get('languageVersion') for p in d['packages'] if p['name']=='stream_chat'])"
> ```

Mirror `melos run analyze` (`--fatal-infos`, examples excluded) and **filter local build artifacts**, which are
not in CI and will otherwise bury the real signal:

```bash
set -o pipefail   # otherwise a matching grep masks an analyzer that crashed
for V in $OLD $NEW; do
  echo "##### $V"
  for p in packages/stream_chat packages/stream_chat_flutter_core packages/stream_chat_flutter \
           packages/stream_chat_persistence packages/stream_chat_localizations sample_app docs/docs_screenshots; do
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

`packages/stream_chat_flutter/test/flutter_test_config.dart` switches alchemist on `CI`/`GITHUB_ACTIONS`:

```dart
ciGoldensConfig: CiGoldensConfig(enabled: isRunningInCi),
platformGoldensConfig: PlatformGoldensConfig(enabled: !isRunningInCi),
```

**Only `goldens/ci/` is committed.** A bare `flutter test` on your machine runs the *platform* variant, whose
goldens do not exist in the repo, and fails ~128 tests that have nothing to do with the new SDK. Always:

```bash
for V in $OLD $NEW; do
  (cd packages/stream_chat_flutter && CI=true $V/bin/flutter test --reporter=compact > /tmp/t-$(basename $V).log 2>&1)
done
# compare the failure sets, not the counts — `\r` matters, the compact reporter uses it
for V in $OLD $NEW; do
  tr '\r' '\n' < /tmp/t-$(basename $V).log | grep -E '\[E\]$' | sed 's|.*/test/src/|test/src/|' | sort -u \
    > /tmp/fail-$(basename $V).txt
done
comm -13 /tmp/fail-$(basename $OLD).txt /tmp/fail-$(basename $NEW).txt   # caused by the new SDK
comm -12 /tmp/fail-$(basename $OLD).txt /tmp/fail-$(basename $NEW).txt   # pre-existing, out of scope
```

Repeat for the other packages with tests (`stream_chat`, `stream_chat_flutter_core`, `stream_chat_persistence`,
`stream_chat_localizations`).

Some CI goldens fail on macOS even on the old SDK — they are rendered on Linux runners. That baseline noise is
exactly what `comm` separates out. **Only the lines the new SDK adds are yours.**

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
| `// ignore: <name>` with a one-line reason above it | The diagnostic is correct in general but wrong here, or the fix belongs to an upstream package. Never a bare ignore — see `STYLE_GUIDE.md`. |
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

Precedent: `invariant_booleans` and `prefer_equal_for_default_values` were deleted in
[#2667](https://github.com/GetStream/stream-chat-flutter/pull/2667).

### New *lint rules* are a separate PR — never this one

Distinguish two things a new SDK brings, and do not let them share a branch:

- **New diagnostics that fire on their own** (`unawaited_return_in_try_block`, `unused_element_parameter`, …).
  These break CI whether you like it or not. Fix them here.
- **New lint rules you could opt into.** `analysis_options.yaml` is a hand-curated allowlist, so these stay off
  until someone enables them. They are a code-style decision, not a toolchain fix — **always their own PR**, with
  their own before/after numbers and their own review.

Worth enumerating anyway, so the follow-up PR has real data instead of guesses. There is no local registry of rule
names, so list them from the SDK repo and diff which ones each analyzer recognises:

```bash
gh api "repos/dart-lang/sdk/contents/pkg/linter/lib/src/rules?ref=main" --jq '.[].name' | sed 's/\.dart$//' > /tmp/allrules.txt
# put every rule in a throwaway analysis_options.yaml, then analyse THAT file under each SDK:
# rules reported `undefined_lint` by $OLD but not by $NEW are new in this release.
```

Then measure each candidate's violation count before proposing it. Two findings that generalise:

- **A rule with zero violations may just be dormant.** Lints stay silent while their fix is not expressible at the
  current language version — `use_primary_constructors` reports nothing at Dart 3.12 and fires at 3.13. Enabling a
  dormant rule schedules a surprise repo-wide diff for whoever raises the floor next. Check before adopting.
- Rules the floor's analyzer does not recognise are **silently ignored** there, not errors — `undefined_lint` only
  surfaces when you analyse the options file directly, which `melos run analyze` never does. So adopting a
  new-SDK-only rule will not break `legacy_version_analyze`; it just is not enforced on the floor.

### Framework deprecations

New `deprecated_member_use` infos are fatal here. Prefer migrating to the replacement API. If the replacement
does not exist on the floor in `melos.yaml`, you cannot use it — suppress with a scoped ignore naming the reason,
and leave the migration for the release that raises the floor.

### New runtime assertions

Flutter adds asserts that only fire in tests, so they surface as widget-test failures, not analyzer output. Read
the assertion and fix the widget tree; do not silence the test. Precedent: 3.44 added an assertion in
`ListTile._findIntermediateWidget` that fired whenever a `ColoredBox`/`DecoratedBox` sat between a tappable
`ListTile` and its nearest `Material` — fixed by replacing the `DecoratedBox` with a `Material` carrying the same
colour and radius.

### Golden pixel drift

Small diffs (well under 1%) across unrelated widgets mean the engine's rasterisation changed — legitimate, and
the goldens must be regenerated. Larger diffs confined to one widget family usually mean a real layout change;
investigate before regenerating.

**Goldens are always regenerated by the CI workflow — never locally. No exceptions.**

`melos run update:goldens` writes the *platform* variant on your machine; the committed `goldens/ci/*.png` are
Linux-rendered. Regenerating locally therefore commits macOS-rendered pixels that CI immediately rejects, or
platform goldens the repo does not even track. Locally you may **compare** (`CI=true flutter test`) to see which
goldens moved — never write them.

`update_goldens.yml` commits back to whatever branch you dispatch against, so **push the branch first**.

> **Confirm with the user before running this.** It pushes a branch and dispatches a workflow that writes a commit
> to the remote using `secrets.BOT_SSH_PRIVATE_KEY`. It is the one outward-facing action in this skill — never
> dispatch it unprompted, and expect the branch to stay red on goldens until it has run.

```bash
git push -u origin chore/flutter-<version>
gh workflow run update_goldens.yml --ref chore/flutter-<version> -f target=sdk
gh run watch $(gh run list --workflow=update_goldens.yml --limit 1 --json databaseId --jq '.[0].databaseId')
git pull    # pick up the bot's "chore: Update Goldens" commit
```

Use `target=docs` for `docs/**` (macOS runner, `goldens/macos/`) and `target=both` when both moved. The workflow
installs Flutter via `flutter-version: "3.x"`, so it regenerates against the **new** stable automatically.

Two consequences to state plainly when you report:

- **The branch is not verifiable-green on macOS.** Even after regeneration, a local `CI=true` run still shows the
  pre-existing Linux-vs-macOS baseline diffs from Step 3. Give the reviewer that number so a non-zero local
  failure count is not read as "the fix did not work".
- `legacy_version_analyze.yml` never runs golden tests, so regenerating against the new stable cannot break the
  N-1 canary.

### Files the toolchain rewrites underneath you

`melos bootstrap` and `flutter pub get` both edit tracked files. Sort them into "commit" and "never commit" —
getting this wrong either breaks CI or leaves everyone with a permanently dirty tree.

| What | Where | Verdict |
|---|---|---|
| `analyzer.exclude` block (`build/**`, `android/**`, `ios/**`, `web/**`, `windows/**`, `macos/**`, `linux/**`) injected into an app-type `analysis_options.yaml` | `sample_app/`, `packages/stream_chat_flutter_core/example/` | **Unresolved — ask, do not assume.** Tool-authored, not ours. See below. |
| `test_api: any` / `flutter_test: any` appended to `dev_dependencies` | `sample_app/pubspec.yaml` | **Never commit.** Melos injects these around bootstrap and normally strips them again; they get left behind when a run does not complete cleanly. `flutter_test` has no pub.dev version, so committing it makes the next `melos bootstrap` fail version solving outright. |
| `version.dart`, `sample_app` version line | via the `version:update` post-hook | Commit only if the version actually changed. |

Anything bootstrap rewrites and you do not commit will fail the **format** job — `validate-formatting.sh` fails on
any `git ls-files --modified` *after* bootstrap, and reports it under the misleading heading "These files are not
formatted correctly."

#### Why the injected `analyzer.exclude` exists, and why it gets committed

The exclusions are not arbitrary. Those directories fill up with **other people's Dart code**:

- `ios/.symlinks/plugins/*` and `macos/.symlinks/plugins/*` are symlinks into `~/.pub-cache`, one per Flutter
  plugin, each pointing at the plugin's whole package root. In `sample_app` that is ~459 and ~434 `.dart` files.
  Created by `pod install` / an iOS or macOS build, not by `pub get`.
- `build/**` accumulates SwiftPM and CocoaPods checkouts of the same plugins — another ~68 `.dart` files.
- `android/` has none: Gradle references plugins by path instead of symlinking them.

Without the exclusion the analyzer walks all of it and judges third-party source against this repo's 135-rule
config under `--fatal-infos`. That is the ~470-diagnostic flood you see from `sample_app` on a machine that has
built for iOS or macOS.

> Beware measuring this with `find sample_app/ios -name '*.dart'` — it reports **zero**, because `find` does not
> follow symlinks without `-L`. The analyzer does follow them. Use `find -L`.

On the CI `analyze` job the directories happen to be absent (nothing runs `pod install` there), so the exclusion
changes nothing *for that job*. It matters for every developer, and for the `build` jobs' machines.

**But it is Flutter's config, not ours.** Verified: the block appears nowhere in repo history, and running
`flutter pub get` on master's version of the file leaves it unchanged under 3.44 and injects under 3.47. Whether
to carry tool-authored config in the repo is a maintainer decision — **surface it, do not decide it yourself.**

If it is committed, note that it is also the **only stable state**:

- Flutter 3.47's `pub get` writes it into every *app-type* package (has a `flutter:` SDK dep and platform
  directories). The workspace root and `docs/` are untouched because neither is one.
- You cannot pre-empt it by writing your own smaller `analyzer:` section. `pub get` **merges its full list into
  an existing `exclude:`** — trimming it to just `build/**` and re-running restores all seven entries.
- So the fixed point is carrying all seven verbatim. Anything else means every `melos bootstrap` dirties the file
  and the format job fails.

Verify all of this rather than trusting the note — the behaviour is a moving target and may change or be reverted
in a later Flutter:

```bash
# Probe in a throwaway worktree — never `git checkout` over your working copy, which
# is exactly how you lose the change this PR is making.
probe=$(mktemp -d)/probe
git worktree add --detach "$probe" origin/master
(cd "$probe/sample_app" && flutter pub get) \
  && git -C "$probe" diff --stat -- sample_app/analysis_options.yaml
git worktree remove --force "$probe"
```

If it is *not* injected: nothing to decide, move on. If it is, the trade-off is — commit it (tree stays clean,
repo carries config nobody wrote) versus leave it out (repo stays ours, but every `melos bootstrap` dirties the
tree and the **format** job fails, since `validate-formatting.sh` greps `git ls-files --modified` after
bootstrap). A `melos.yaml` bootstrap post-hook that strips it is the third option; it re-runs forever and gives
back the ~470-diagnostic local flood.

### Android / iOS build floors

The `build` matrix job compiles the sample app for both platforms. Every Flutter release raises its Gradle / AGP /
Kotlin floors, and the check is **fail-fast** — it reports only the first violated floor, so fixing one commonly
just reveals the next. Read all of them out of the SDK up front instead of iterating through CI:

```bash
grep -n "Version(" $NEW/packages/flutter_tools/gradle/src/main/kotlin/DependencyVersionChecker.kt | head
```

Each tool has an `error…Version` (hard floor, fails the build) and a `warn…Version` (deprecation only). But the
release notes also publish an **"Android dependency matrix"** — the combination Flutter actually tested. Prefer
the verified matrix over the bare floors: the floors only tell you what will not be rejected, while the matrix is
what the release was exercised against, and it is where the *next* release's floors will land.

Flutter 3.47, showing how far apart the two are:

| Tool | error floor | warn floor | **verified matrix** | Set in |
|---|---|---|---|---|
| Gradle | 8.14.0 | 9.1.0 | **9.3.1** | `sample_app/android/gradle/wrapper/gradle-wrapper.properties` |
| AGP | 8.11.1 | 9.0.1 | **9.1.0** | `sample_app/android/settings.gradle` |
| Kotlin (KGP) | 2.2.20 | 2.3.20 | **2.4.0** | `sample_app/android/settings.gradle` |
| Java | — | — | **17** minimum | `.github/actions/setup-java` + `app/build.gradle` |

The matrix is internally constrained — "AGP 9.1.0 is the newest compatible with KGP 2.4.0; Gradle 9.3.1 is the
minimum for AGP 9.1.0" — so move all three together or not at all.

Also prefer the SDK's API-level variables (`flutter.compileSdkVersion`, `targetSdkVersion`, `minSdkVersion`) over
hardcoded numbers, so future releases carry the project forward automatically.

**Validate Android locally — you probably can.** `flutter doctor` showing a working Android toolchain means
`(cd sample_app && flutter build apk --release)` reproduces the CI `build (android)` job in one shot, instead of
5-minute CI round trips per attempt. Only fall back to "unverifiable locally" if the toolchain is genuinely
missing.

Also check `sample_app/android/{app/build.gradle,build.gradle,gradle.properties}` for SDK floors. Precedent: 3.44
needed `compileSdk` floored at 36 via `Math.max(flutter.compileSdkVersion, 36)` in both the `:app` module and the
root `subprojects` block.

> The five `packages/*/example/android` projects are still on Gradle 7.6 and are **not** built by CI, so they
> never gate a PR. They are broken for anyone building an example locally on a modern Flutter. Out of scope for a
> compat bump — but say so rather than letting it look verified.

If CI pins an Xcode version (`maxim-lobanov/setup-xcode` in `stream_flutter_workflow.yml`), a Flutter release that
raises its Xcode floor needs that pin raised too. A release that raises the **macOS** floor can also strand the
`macos-*` runner pinned in the workflow.

These jobs are the one class you realistically cannot verify locally — a full fastlane Android + iOS build is slow
and needs toolchains most machines lack. That is fine, but **say so**: report the `build (android)` / `build (ios)`
jobs as unverified and let the PR's own CI run be the check, rather than implying the branch is fully green.

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

Also re-check the floor, since `legacy_version_analyze.yml` gates the PR and analyzes `lib/` only:

```bash
for p in packages/*/; do (cd "$p/lib" && $OLD/bin/cache/dart-sdk/bin/dart analyze --fatal-infos .); done
```

A fix that relies on syntax newer than the floor passes on `$NEW` and fails that job.

## Step 6 — Track B: raise the floor to latest − 1

Keep this out of the Track A commit — it is breaking for consumers and needs to be reviewable on its own.

Version-carrying files, all of which must move together:

- `.fvmrc` — `flutter`
- `melos.yaml` — `command.bootstrap.environment.{sdk,flutter}` (the source of truth; `melos bs` propagates)
- `pubspec.yaml` (root workspace) — `environment.sdk`
- `packages/*/pubspec.yaml` × 5 — `sdk`, and `flutter` on the four Flutter packages (`stream_chat` is pure Dart
  and carries **no** `flutter` constraint — do not add one)
- `packages/*/example/pubspec.yaml` × 5
- `sample_app/pubspec.yaml`
- `docs/docs_screenshots/pubspec.yaml`
- `.github/workflows/legacy_version_analyze.yml` — `env.flutter_version`. Set it to the **new floor** (never the
  new stable): this job exists to prove the floor still analyses and tests clean.

`sample_app/e2e_stubs/*/pubspec.yaml` pin `sdk: ^3.0.0` deliberately — they are throwaway stubs. Leave them.

### The floor raise activates dormant lints — budget for it

This is the step that surprises people. Raising the Dart constraint raises each package's **language version**,
and lints stay silent while their suggested fix is not yet expressible. Raise the floor and they all fire at once,
in code nobody touched.

Concretely, the 3.11 → 3.12 raise activated `prefer_initializing_formals` on **29 sites** across four packages,
because Dart 3.12 legalised `this._privateField` as a named parameter. Zero issues before, 29 after — none of it
caused by the new *stable*, all of it caused by the *floor*.

So: **`melos bootstrap` and re-analyse immediately after editing the constraints**, before you write the
CHANGELOG. Then let the tooling do the mechanical work:

```bash
for p in packages/*/ sample_app docs/docs_screenshots; do (cd $p && dart fix --dry-run); done
# then, per lint, once you have decided the fix is right:
(cd <pkg> && dart fix --apply --code=prefer_initializing_formals)
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
- **Confirm no public parameter was renamed.** For every `this._foo` it introduced, the parameter it replaced must
  have been named exactly `foo`. It always should be, but a mismatch is a silent breaking change for callers.

If a package uses codegen (`@JsonSerializable`, `freezed`), re-run `melos run generate:all` afterwards and confirm
the generated call sites are unchanged — the generators read constructor parameters, and a renamed parameter would
silently change `.g.dart`. For `this._quotedMessageId` the generator still emits `quotedMessageId:`, confirming
the public name survives.

**Always `dart format` after build_runner.** It emits at dart_style's default 80 columns, ignoring the repo's
`page_width: 120`, so a regen dirties every `.g.dart` with pure reflow. Formatting restores them byte-for-byte —
do that before concluding codegen "changed" anything.

Then, per `STYLE_GUIDE.md`, one short bullet under `🔄 Changed` in each of the five package CHANGELOGs:

```md
- Raised minimum Flutter to `>=X.Y.Z` and Dart SDK to `^A.B.C`.
```

`stream_chat` is Dart-only — its bullet mentions the Dart SDK only.

Finish with `melos bootstrap` and commit the resulting root `pubspec.lock`.

## Step 7 — Changelog and PR

Track A changes that are user-visible (a widget swapped, a deprecation migrated) get a CHANGELOG bullet in the
affected package. Pure CI/tooling/golden churn does not.

PR title follows Conventional Commits:

- Track A → `chore(repo): support Flutter <version>`
- Track B → `chore(repo): bump min Flutter to <version> and Dart SDK to <version>`

## Report back with attribution

When summarising, always separate the three buckets — it is the difference between a reviewable PR and a mystery:

1. **Caused by the new SDK** (present on new, absent on old) — what this PR fixes.
2. **Pre-existing** (present on both) — explicitly out of scope, named so nobody re-investigates.
3. **Local-only noise** (`build/` artifacts, platform goldens without `CI=true`) — never appears in CI, never fix.
