# 10 — Cleanup: dependencies, barrel, deprecation kit

**Goal:** collect the debts the earlier phases deliberately left behind — dependencies that are
now transitive, a barrel that grew narrower, and the deprecations that need a `dart fix` path.

**Size:** no new behaviour. This is the phase that makes the upgrade tolerable for consumers.

## Scope

### Dependencies

`stream_core` re-exports all of `dio` and depends on the transport packages itself, so several of
chat's direct dependencies become redundant as phases 04–07 land. Drop them from
`packages/stream_chat/pubspec.yaml` — **by editing `melos.yaml`'s `command.bootstrap.dependencies`
block and running `melos bootstrap`**, never the package manifest directly.

| Dependency | Retired by | Note |
| --- | --- | --- |
| `dio: ^5.11.0` | 05 | Core re-exports all of dio and declares `^5.8.0+1`. Watch the skew when either moves. |
| `web_socket_channel: ^3.0.3` | 07 | Core owns the engine. |
| `jose: ^0.3.5+1` | 04 | Only `Token` parsed JWTs; `UserToken` does it in core. |
| ~~`logging: ^1.3.0`~~ | 06 | **Done.** 06 removed chat's logger outright instead of bridging it, so the deprecation cycle never applied. Gone from `melos.yaml`, and no package imports it. |
| `equatable: ^2.0.8` | — | **Stays.** 28 files in `stream_chat/lib` use it directly. |
| ~~`diacritic: ^0.1.6`~~ | 08 | **Done.** Chat's `normalizeStringForSort` was a copy of core's, differing only in its doc comment, and was `@internal` so nothing public moved. The three sort fields that fold names now use core's. Still a direct dependency of `stream_chat_flutter`, which uses it in two files. |

`rate_limiter` **stays** — `RetryQueue` uses its `backOff`, and `RetryPolicy` / `RetryQueue` are
staying chat-side. `synchronized`, `collection`, `mime`, `http_parser`, `rxdart`, `meta`,
`freezed_annotation`, `json_annotation`, `retrofit`, `uuid` and `async` are unaffected.

Run `melos run lint:pub` (or a `pub deps` pass) to confirm nothing was dropped that is still
imported — a package that resolves transitively today will break the day core drops it.

### Barrel

`lib/stream_chat.dart` re-exports five packages wholesale-or-narrowed:

```dart
export 'package:async/async.dart' hide Result;        // narrowed by 03
export 'package:dio/dio.dart' show DioException, DioExceptionType, RequestOptions, CancelToken,
    Interceptor, InterceptorsWrapper, MultipartFile, Options, ProgressCallback;
export 'package:rate_limiter/rate_limiter.dart';      // wholesale
export 'package:stream_core/stream_core.dart' show /* allowlist, grown per phase */;
export 'package:uuid/uuid.dart';                      // wholesale
```

`logging` is already gone with phase 06, and `async` is down to a `hide`. Two wholesale
re-exports are left, of packages whose types are almost certainly incidental to chat's API. Removing a re-export is breaking for anyone who relied on it transitively, so this is
the right phase for it — one break, one migration entry, alongside everything else.

- `package:async` — check whether any public signature actually mentions an `async` type.
- `package:rate_limiter` — `RetryPolicy` is public, so some of this may be load-bearing. Narrow to
  a `show` list rather than dropping.
- `package:uuid` — almost certainly incidental.
- `package:dio` — already narrowed, but reconcile it with core's wholesale dio re-export so
  consumers don't get two dio surfaces with different shapes.

End state: every package re-export in the barrel is a `show` allowlist, consistent with the
decision in the README and with the `stream_core` allowlist the later phases have been growing.

### The deprecation kit

**This is the most valuable part of the phase, and it does not exist in chat today.** There is no
`packages/stream_chat/lib/fix_data.yaml` and no `test_fixes/`. `lib/stream_chat.dart` exposes
**201 public types**, and this plan renames dozens of them.

`stream_feeds` solves it with two artifacts:

- **`lib/src/generated_typedefs.dart`** — `@Deprecated` `typedef` aliases from every old name to
  its new one, so old code keeps compiling with a warning that names the replacement.
- **`lib/fix_data.yaml`** — 58 data-driven `dart fix` transforms, so `dart fix --apply` performs
  the rename mechanically in consumer code.

Build both here, covering every rename from phases 01–09. The highest-value transforms:

A transform can only be written for a rename that has already happened, so the table splits on
whether the old symbol is still in `stream_chat/lib`:

| From | To | Phase | Writable |
| --- | --- | --- | --- |
| `ChatErrorCode` | `StreamErrorCode` | 03 | yes — gone from chat |
| `Token` | `UserToken` | 04 | yes — gone from chat |
| `TokenProvider` (closure) | `TokenProvider.dynamic(...)` | 04 | yes |
| `tokenManager.loadToken()` | `.getToken()` | 04 | yes |
| `SortOption.asc('field')` | `Sort.asc(XSortField.field)` | 08 | forwarder only, see below |
| `Filter.equal('key', v)` | `XFilter.equal(XFilterField.key, v)` | 08 | forwarder only, see below |
| `LocationCoordinates` | `LocationCoordinate` | 08 | yes — gone from chat |
| `CurrentPlatform.name` | `.operatingSystem` | 02 | not yet — still 4 files |
| `StreamChatNetworkError` | `StreamApiException` | 03 | yes — gone from chat, along with `StreamChatError` and `StreamWebSocketError` |
| `StreamHttpClient` | (removed) | 05 | not yet — still 17 files |
| `ConnectionStatus` | `WebSocketConnectionState` | 07 | not yet, and 07 is parked |

The two `08` rows cannot be pure `dart fix` renames — a string key becomes a typed field
reference, and which registry it belongs to depends on the query being called. Those get a
migration-guide example instead; don't force a transform that can't be correct. Both are already
covered by Symbol Map rows.

**Wire `test_fixes/` and exercise it.** Feeds ships `fix_data.yaml` with **no** `test_fixes/`
directory, so its transforms are never verified — `melos run test:fixes` is gated on
`dirExists: test_fixes` and silently skips. Do not copy that gap:

1. Add `packages/stream_chat/test_fixes/` with a `.dart` file and a `.dart.expect` golden per
   transform group.
2. Add a `test:fixes` script to `melos.yaml` running `dart fix --compare-to-golden`.
3. Wire it into CI alongside `analyze`.

An unverified transform is worse than none: it runs on consumer code and gets it wrong.

## Decisions to make

- Whether `rate_limiter` and `uuid` — the two wholesale re-exports left — are dropped or
  narrowed, based on the public-signature audit.
- ~~Whether the deprecation kit lands here or before phase 08.~~ **Answered by events: it did
  not.** 08 landed without it, renaming `Filter` and `SortOption` — the two most-used types in
  consumer code — with no forwarders and no transforms. Neither is recoverable by a transform
  anyway (a string key becomes a typed field reference), so the loss is smaller than it looked,
  but the lesson stands for 05 and 07: write the transform in the phase that does the rename,
  while the old and new names are both still in hand.
- How long the deprecation cycle is. Every `@Deprecated` here has to name the release that removes
  it, and v11 is the release that *earns* the right to remove v10 deprecations — don't let the two
  sets blur.

## Risks

- **Dropping a re-export is invisible until a consumer upgrades.** Nothing in this repo fails; an
  app that used `Uuid` via `package:stream_chat` just stops compiling. The migration guide entry
  is the only mitigation.
- **A wrong `dart fix` transform edits consumer code incorrectly** — worse than no transform.
  Hence the golden tests.
- Deprecated forwarders that are never removed become permanent API. Name the removal release in
  every `@Deprecated` message.

## Upstream `stream_core` work

None.

## Definition of done

- [ ] Redundant dependencies removed via `melos.yaml`, and `melos bootstrap` reproduces a clean
      resolve. Nothing still-imported was dropped.
- [ ] Every package re-export in `lib/stream_chat.dart` is a `show` allowlist, or is gone.
- [ ] `packages/stream_chat/lib/fix_data.yaml` covers every mechanical rename from phases 01–09.
- [ ] `@Deprecated` forwarders exist for the renames that cannot be transformed, each naming its
      removal release.
- [ ] `packages/stream_chat/test_fixes/` exists with a golden per transform group, and
      `melos run test:fixes` passes and **runs in CI** — verified by making a transform wrong on
      purpose and watching CI fail.
- [ ] `dart fix --apply` run against `sample_app` pinned to the previous version, producing
      compiling code.
- [ ] `migrations/v11-migration.md` is complete: every Symbol Map row filled, every feature
      section written, the Migration Checklist accurate, and the "For AI Agents" section reflecting
      the final shape.
- [ ] The five pana jobs in `.github/workflows/pana.yml` are green. They were re-enabled when
      this directory was created — no `if: false` remains — so this is a confirm-they-pass item.
- [ ] `melos bootstrap && melos run lint:all && melos run test:all`.
- [ ] Every phase's status box ticked in `README.md`.
- [ ] Public dartdoc follows [`STYLE_GUIDE.md` § Documentation](../STYLE_GUIDE.md#documentation),
      including on symbols this phase retyped but whose docs it left alone.
- [ ] Tests follow [`TESTING.md`](../TESTING.md): no `group` organizing a file by method, each
      name states its subject and behaviour.
