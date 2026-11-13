# SDK size

Measures how much each SDK adds to a release app, and how large each package's
pub.dev archive is. The `sdk_size` workflow runs this on every pull request and
reports it in two comments, `## SDK Size` and `## Size Breakdown`. Pull requests
measure Android only, except `release/` pull requests, which measure both
platforms and store them as the `release` benchmark. Pushes to `master` and
`v11` measure both platforms and store the numbers as that branch's benchmark in
`GetStream/stream-internal-metrics`. A manual run of the workflow measures iOS
too, but doesn't comment on a pull request.

## How it works

Every folder under `variants/` is one app. `measure.dart` creates an empty app
with `flutter create --empty`, adds the variant's `dependencies.yaml` and
`main.dart`, and builds a release with `--analyze-size`:

- Android: an arm64 APK.
- iOS: `Runner.app`, built with `--no-codesign`.

Each variant's size is what it adds on top of `baseline`, an empty
`MaterialApp`. A variant's `main.dart` has to use the SDK the way an app would.
Otherwise tree shaking removes the Dart code, and only the native libraries are
counted.

The archive size is the `Total compressed archive size` that
`flutter pub publish --dry-run` reports for each publishable package.

## Running it locally

From the repository root:

```bash
dart run metrics/sdk_size/tool/measure.dart --platform android
```

```bash
dart run metrics/sdk_size/tool/measure.dart --platform ios --variant stream_chat_flutter
```

```bash
melos bootstrap
dart run metrics/sdk_size/tool/measure.dart --platform pub
```

Results are written to `build/sdk_size/results`. To drill down to single
functions, open a file from `build/sdk_size/results/analysis/` in the DevTools
App Size tool:

```bash
dart devtools
```

The tool's Diff tab compares two analysis files, for example a `master` build
against a `v11` build. The CI runs upload these files as the
`sdk-size-analysis-<platform>` artifacts.

To print the report without commenting or pushing, run the lane outside CI. It
needs read access to `GetStream/stream-internal-metrics`:

```bash
cd metrics/sdk_size && bundle install && BASE_BRANCH=master bundle exec fastlane sdk_size
```

## README badges

The size badges in the root `README.md` show a benchmark from
`GetStream/stream-internal-metrics`:

- `stream_chat`: what the LLC adds to an empty app.
- `stream_chat_flutter` and `stream_chat_persistence`: what each adds on top
  of `stream_chat`.
- `stream_chat_localizations`: its pub.dev archive size.

They are updated for each release, on the release branch, by the
`update_size_badges` workflow:

```bash
gh workflow run update_size_badges.yml --ref release/v<version> -f base_branch=master
```

## Adding a variant

Add a folder under `variants/` with:

- a `dependencies.yaml` that lists the packages, indented as under
  `dependencies:`. Every package in `packages/` is resolved from its path.

  ```yaml
    stream_chat: any
  ```

- a `main.dart` that uses them.
