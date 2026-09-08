# 02 — Platform detector & system environment

**Goal:** delete two forks that collide with core by name, so later phases can import core's
`api/` and `platform/` barrels without a prefix.

**Size:** ~220 chat LOC deleted. Two upstream core additions. One public rename.

## Scope

| Delete | Adopt |
| --- | --- |
| `lib/src/core/platform_detector/` — `platform_detector.dart` (~97) + `_stub` / `_web` / `_io` | `stream_core` `platform/current_platform.dart` + `platform/detector/` |
| `lib/src/core/http/system_environment_manager.dart` (111) | `stream_core` `api/system_environment_manager.dart` (156) + `api/system_environment.dart` |

### Platform detector

Both packages define `CurrentPlatform` **and** `PlatformType`, so `stream_chat.dart` must stop
exporting ours in the same PR — there is no coexistence.

| Ours | Core |
| --- | --- |
| `enum PlatformType` — 7 values, no payload | `enum PlatformType` — same 7 values, each carrying `operatingSystem` |
| `CurrentPlatform.name` (a `switch`) | `CurrentPlatform.operatingSystem` |
| `is*` getters | same `is*` getters, plus `isMobile` / `isDesktop` |
| `@visibleForTesting static PlatformType? debugCurrentPlatformOverride` | **absent** — upstream it |
| conditional import: `_stub` / `_web` (on `dart.library.js_interop`) / `_io` | `detector/platform_detector` (web default) / `platform_detector_io` — **no explicit `js_interop` branch** |

The `js_interop` branch is not cosmetic: it is how `#2940` (wasm support) works. Core reaching web
via a non-io fallback is not the same guarantee. Take both gaps upstream before starting, or this
phase regresses wasm and loses the test seam our tests depend on.

### System environment

Near-verbatim fork: same class name, same `XStreamClientHeaderExtension` extension name, and a
byte-identical `xStreamClientHeader` body including the `_SdkIdentifier` precedence trick. The
only real difference is where the SDK identity comes from — ours hardcodes it in the constructor,
core takes `required SystemEnvironment environment` and snapshots the SDK-owned fields so
`updateEnvironment` cannot overwrite them.

Construct core's with chat's baseline:

```dart
SystemEnvironmentManager(
  environment: SystemEnvironment(
    sdkName: 'stream-chat',
    sdkIdentifier: 'dart',          // core promotes 'dart' -> 'flutter' one-way
    sdkVersion: PACKAGE_VERSION,
    osName: CurrentPlatform.operatingSystem,
  ),
)
```

**Fix the static while you are here.** `client.dart:168` is
`static final _systemEnvironmentManager = SystemEnvironmentManager();` — a static, so two
`StreamChatClient`s in one process cannot have different app names or versions, and the second
client silently inherits the first's environment. Make it an instance field. That is a bug fix,
not a break.

## Decisions to make

- Whether `CurrentPlatform.name` → `.operatingSystem` ships with a deprecated `name` getter on a
  chat-side extension for one release, or as a clean rename. It is exported, but a platform-name
  string is rarely load-bearing in app code.
- Whether `debugCurrentPlatformOverride` goes upstream as-is (an `@visibleForTesting` static with
  an assert gate) or as something core's style guide prefers — core's `STYLE_GUIDE.md` has an
  "Avoid `@visibleForTesting`" section, so expect pushback and have a second shape ready.

## Risks

- **Wasm.** If core's web detection is adopted without the `js_interop` branch, `#2940` regresses
  silently — nothing fails to compile, the platform is just wrong at runtime. Verify with the
  wasm build, not with tests.
- Chat's tests set `debugCurrentPlatformOverride`; without an equivalent they need reworking, and
  reworking them to not need it is the better outcome but is more work than this phase implies.

## Upstream `stream_core` work

- `CurrentPlatform.debugCurrentPlatformOverride` (or an equivalent test seam).
- An explicit `dart.library.js_interop` web branch in the platform detector's conditional import.

Both are small and belong in one core PR.

## Definition of done

- [ ] `lib/src/core/platform_detector/` deleted; `stream_chat.dart` no longer exports it.
- [ ] `system_environment_manager.dart` deleted; core's is constructed with the chat baseline.
- [ ] `_systemEnvironmentManager` is an instance field, and a test asserts two clients can hold
      different environments.
- [ ] Wasm build verified (`flutter build web --wasm` on the sample app), not just tests.
- [ ] Chat's platform-dependent tests pass without a chat-owned override.
- [ ] `melos bootstrap && melos run analyze && melos run test:dart && melos run test:flutter`.
- [ ] `refactor(llc)!:` title, `🛑️ Breaking` CHANGELOG entry and `migrations/v11-migration.md`
      Symbol Map rows for `CurrentPlatform.name` → `.operatingSystem`, `PlatformType` and
      `SystemEnvironmentManager`.
- [ ] Decisions recorded here, status box ticked in `README.md`.
