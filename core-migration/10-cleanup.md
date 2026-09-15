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
| `logging: ^1.3.0` | 06 | Only after the bridge's deprecation cycle expires — not in the same release. |
| `equatable: ^2.0.8` | — | Verify: our models may still use it directly. |
| `diacritic: ^0.1.6` | 08 | Only if `normalizeStringForSort` moved upstream. |

`rate_limiter` **stays** — `RetryQueue` uses its `backOff`, and `RetryPolicy` / `RetryQueue` are
staying chat-side. `synchronized`, `collection`, `mime`, `http_parser`, `rxdart`, `meta`,
`freezed_annotation`, `json_annotation`, `retrofit`, `uuid` and `async` are unaffected.

Run `melos run lint:pub` (or a `pub deps` pass) to confirm nothing was dropped that is still
imported — a package that resolves transitively today will break the day core drops it.

### Barrel

`lib/stream_chat.dart` re-exports five packages wholesale-or-narrowed:

```dart
export 'package:async/async.dart';                    // wholesale
export 'package:dio/dio.dart' show DioException, DioExceptionType, RequestOptions, CancelToken,
    Interceptor, InterceptorsWrapper, MultipartFile, Options, ProgressCallback;
export 'package:logging/logging.dart' show Logger, Level, LogRecord;
export 'package:rate_limiter/rate_limiter.dart';      // wholesale
export 'package:uuid/uuid.dart';                      // wholesale
```

Three of those are wholesale re-exports of packages whose types are almost certainly incidental to
chat's API. Removing a re-export is breaking for anyone who relied on it transitively, so this is
the right phase for it — one break, one migration entry, alongside everything else.

- `package:async` — check whether any public signature actually mentions an `async` type.
- `package:rate_limiter` — `RetryPolicy` is public, so some of this may be load-bearing. Narrow to
  a `show` list rather than dropping.
- `package:uuid` — almost certainly incidental.
- `package:dio` — already narrowed, but reconcile it with core's wholesale dio re-export so
  consumers don't get two dio surfaces with different shapes.
- `package:logging` — drops with phase 06's deprecation cycle.

End state: every package re-export in the barrel is a `show` allowlist, consistent with the
decision in the README and with `filter.dart show Filter, FilterOperator` already in the file.

### The deprecation kit

**This is the most valuable part of the phase, and it does not exist in chat today.** There is no
`packages/stream_chat/lib/fix_data.yaml` and no `test_fixes/`. `lib/stream_chat.dart` exposes
**202 public top-level declarations**, and this plan renames dozens of them.

`stream_feeds` solves it with two artifacts:

- **`lib/src/generated_typedefs.dart`** — `@Deprecated` `typedef` aliases from every old name to
  its new one, so old code keeps compiling with a warning that names the replacement.
- **`lib/fix_data.yaml`** — 58 data-driven `dart fix` transforms, so `dart fix --apply` performs
  the rename mechanically in consumer code.

Build both here, covering every rename from phases 01–09. The highest-value transforms:

| From | To | Phase |
| --- | --- | --- |
| `CurrentPlatform.name` | `.operatingSystem` | 02 |
| `StreamChatNetworkError` | `StreamApiException` | 03 |
| `ChatErrorCode` | `StreamErrorCode` | 03 |
| `Token` | `UserToken` | 04 |
| `TokenProvider` (closure) | `TokenProvider.dynamic(...)` | 04 |
| `tokenManager.loadToken()` | `.getToken()` | 04 |
| `StreamHttpClient` | (removed) | 05 |
| `ConnectionStatus` | `WebSocketConnectionState` | 07 |
| `SortOption.asc('field')` | `Sort.asc(XSortField.field)` | 08 |

Note the last one cannot be a pure `dart fix` rename — a string becomes a typed field reference.
Those get a `@Deprecated` forwarder and a migration-guide example instead; don't force a transform
that can't be correct.

**Wire `test_fixes/` and exercise it.** Feeds ships `fix_data.yaml` with **no** `test_fixes/`
directory, so its transforms are never verified — `melos run test:fixes` is gated on
`dirExists: test_fixes` and silently skips. Do not copy that gap:

1. Add `packages/stream_chat/test_fixes/` with a `.dart` file and a `.dart.expect` golden per
   transform group.
2. Add a `test:fixes` script to `melos.yaml` running `dart fix --compare-to-golden`.
3. Wire it into CI alongside `analyze`.

An unverified transform is worse than none: it runs on consumer code and gets it wrong.

## Decisions to make

- Which of the three wholesale package re-exports are dropped versus narrowed, based on the
  public-signature audit.
- Whether the deprecation kit lands **here** or **before phase 08**. Phase 08 renames the
  most-used types in consumer code (`Filter`, `SortOption`), so having transforms ready when it
  lands is worth more than having them collected neatly at the end. Strong argument for splitting
  the kit out early and appending to it per phase.
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
- [ ] The five pana jobs in `.github/workflows/pana.yml` are green (they were re-enabled when
      this directory was created; confirm they still pass).
- [ ] `melos bootstrap && melos run lint:all && melos run test:all`.
- [ ] Every phase's status box ticked in `README.md`.
