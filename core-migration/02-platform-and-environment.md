# 02 — Platform detector & system environment

**Goal:** delete two forks that collide with core by name, so later phases can import core's
`api/` and `platform/` barrels without a prefix.

**Size:** ~330 chat LOC deleted. One public type swap, one public rename.

> **Read the resolved package, not the sibling repo.** The first pass at this phase claimed two
> upstream core additions were needed. Both were wrong, because they were derived from
> `stream-core-flutter/packages/stream_core` (unreleased `main`) rather than from
> `~/.pub-cache/hosted/pub.dev/stream_core-0.5.0`, which is what `stream_chat` actually resolves.
> Always diff against the pub-cache copy.

## Scope

| Delete | Adopt | Status |
| --- | --- | --- |
| `lib/src/system_environment.dart` (57) | `stream_core` `api/system_environment.dart` | **done** |
| `lib/src/core/http/system_environment_manager.dart` (111) | `stream_core` `api/system_environment_manager.dart` | **done** |
| `lib/src/core/platform_detector/` — `platform_detector.dart` (~97) + `_stub` / `_web` / `_io` | `stream_core` `platform/current_platform.dart` + `platform/detector/` | **ready** — the SHA pinned in [08](08-query-dsl.md) carries what this needed |

### Platform detector — unblocked by the pin in phase 08

Both packages define `CurrentPlatform` **and** `PlatformType`, so `stream_chat.dart` must stop
exporting ours in the same PR — there is no coexistence.

| Ours | Published core 0.5.0 |
| --- | --- |
| `enum PlatformType` — 7 values, no payload | same 7 values, each carrying `operatingSystem` — **identical strings** (`android`, `ios`, `web`, `macos`, `windows`, `linux`, `fuchsia`), so nothing on the wire changes |
| `CurrentPlatform.name` (a `switch`) | `CurrentPlatform.operatingSystem` |
| 7 `is*` getters + `isFlutterTest` | same, plus `isMobile` / `isDesktop` |
| `@visibleForTesting static PlatformType? debugCurrentPlatformOverride`, honoured by an assert-gated `type` | not in 0.5.0, but **present at the pinned SHA**, which is what the branch resolves |
| conditional import: `_stub` (throws) / `_web` on `dart.library.js_interop` / `_io` | `detector/platform_detector` (web) / `platform_detector_io` on `dart.library.io` |

Two corrections to the original write-up:

- **Wasm needs nothing.** Core has no throwing stub at all: its conditional import defaults to the
  *web* detector and switches to io only when `dart.library.io` is available, so a wasm build lands
  on `PlatformType.web` by construction. Chat needed the explicit `js_interop` branch (`#2940`)
  only because *its* default was a stub that threw. Core's shape is strictly safer.
- **`debugCurrentPlatformOverride` needs a release, not a PR.** Core's `main` already has it, with
  the same assert-gated `type` implementation ours uses — the published 0.5.0 does not. It is not
  optional: `stream_chat_flutter/test/src/message_widget/stream_message_text_test.dart` sets it in
  8 places, and no shim outside core can substitute (the override has to be read by
  `CurrentPlatform.type` itself).

So this half waits for the next `stream_core` release. Everything else about it is a mechanical
rename, already verified: `stream_core_flutter` does **not** re-export `stream_core`, so
`stream_chat_flutter` sees `CurrentPlatform` only through this barrel and there is no ambiguity to
resolve. Only two non-test `.name` call sites exist — chat's own manager, and
`stream_chat_flutter_core/lib/src/stream_chat_core.dart:215`.

### System environment — done

Both types were near-verbatim forks. `SystemEnvironment` was **identical**: same constructor,
same 8 fields, same nullability, no equality on either side — so swapping it is source-compatible
for anyone constructing or reading one, and only a type-identity change for anyone doing `is` or
`implements`. `SystemEnvironmentManager` shared the class name, the
`XStreamClientHeaderExtension` name and a byte-identical `xStreamClientHeader` body including the
`_SdkIdentifier` precedence trick.

Core's manager is the better one: it takes `required SystemEnvironment environment` and
*snapshots* the SDK-owned fields, rather than holding a reference — deliberately, because
`SystemEnvironment` is not `final`, so a subtype could return a different value on every getter
read and drift the values an update is meant to be locked to. It also rejects an unrecognized
`sdkIdentifier` outright, where ours only compared precedence.

That last difference is **not** observable, which is why the swap is not a behavioural break.
Ours resolved an update as `incoming.precedence < current.precedence ? current : incoming`; core
rejects anything with a negative precedence first. The two disagree only when the *current*
identifier is itself unrecognized — unreachable, since the baseline is always `dart` and an
update can only ever store a value that already passed the check. Every reachable transition
(unrecognized against `dart` or `flutter`, and the `dart` ⇄ `flutter` pair in both directions)
yields the same result under both rules.

Constructed with chat's baseline in `client.dart`:

```dart
SystemEnvironmentManager(
  environment: SystemEnvironment(
    sdkName: 'stream-chat',
    sdkIdentifier: 'dart',        // core promotes 'dart' -> 'flutter' one-way
    sdkVersion: PACKAGE_VERSION,
    osName: CurrentPlatform.name, // becomes `.operatingSystem` with the platform half
  ),
)
```

`SystemEnvironmentManager` was never exported, so it swapped silently. `SystemEnvironment` is
exported and is now core's, re-exported through the `show` allowlist this phase starts:

```dart
export 'package:stream_core/stream_core.dart' show SystemEnvironment;
```

`XStreamClientHeaderExtension` is deliberately **not** added to that allowlist: ours was never
public either (it lived in the unexported manager file), and exporting core's would widen the
public surface for no reason.

**The static stays, and moves to [05](05-http-client.md).** The original write-up called
`static final _systemEnvironmentManager` a free bug fix. It is not: `client.dart:201` is
`static String defaultUserAgent = _systemEnvironmentManager.userAgent;` — a **public** static
reading it, so making the manager per-instance breaks `defaultUserAgent` too. That belongs with
`additionalHeaders`, the sibling public static phase 05 already retires.

Chat's manager tests were deleted rather than ported: core covers the manager with 13 cases and
`xStreamClientHeader` with 9, a superset of ours. What chat still owns is the *baseline*, so
`test/src/client/system_environment_test.dart` pins that one thing —
`StreamChatClient.defaultUserAgent` reporting `stream-chat-dart-v<version>|os=<platform>`.

## Decisions to make

Only the platform half has open questions:

- `CurrentPlatform.name` → `.operatingSystem` has to be a clean rename. A deprecated `name` for
  one release is not on the table: `name` is a static, and an extension can only add statics
  under its own declaration name, so a chat-side shim could not answer `CurrentPlatform.name`.
  It is exported, but a platform-name string is rarely load-bearing in app code, and the returned
  values are identical.
- Whether `stream_chat_flutter`'s 8 uses of `debugCurrentPlatformOverride` are ported to core's
  override or reworked not to need one. Porting is a one-line change per site once core is
  released; reworking is better but is its own piece of work.

## Risks

- Nothing outstanding for the system-environment half — the swap is source-compatible and the
  header output is unchanged.
- For the platform half: the values are identical, so the risk is not behavioural but timing —
  it cannot land until core releases, and attempting it early leaves
  `stream_chat_flutter`'s tests uncompilable.

## Upstream `stream_core` work

**A `stream_core` release** containing `debugCurrentPlatformOverride` (already on `main`). No core
code changes needed.

## Definition of done

- [x] `lib/src/system_environment.dart` and `lib/src/core/http/system_environment_manager.dart`
      deleted; core's manager is constructed with the chat baseline.
- [x] `SystemEnvironment` re-exported from core through a `show` allowlist;
      `XStreamClientHeaderExtension` deliberately not exported.
- [x] `test/src/client/system_environment_test.dart` pins the chat baseline user agent.
- [x] `melos run analyze` clean across all packages; `stream_chat` 1673 tests green,
      `stream_chat_persistence` 302 green, `stream_chat_flutter_core` 362 green,
      `stream_chat_flutter` 1302 green (11 golden failures pre-existing on a clean tree —
      verified by stashing).
- [x] CHANGELOG entry under `🔄 Changed` for the `SystemEnvironment` type swap.
- [ ] `lib/src/core/platform_detector/` deleted; `stream_chat.dart` exports core's
      `CurrentPlatform` / `PlatformType` — **after the core release**.
- [ ] `CurrentPlatform.name` → `.operatingSystem` at both non-test call sites.
- [ ] Wasm build verified (`flutter build web --wasm` on the sample app) once the platform half
      lands — core's shape should make this a formality, but confirm rather than assume.
- [ ] `migrations/v11-migration.md` Symbol Map row for `CurrentPlatform.name`.
- [ ] Decisions recorded here, status box updated in `README.md`.
