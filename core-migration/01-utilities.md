# 01 — Utilities

**Goal:** prove the pattern on files that touch no behaviour and almost no public surface.

**Size:** 47 chat LOC deleted so far. No upstream core work.

## Scope

| Delete | Adopt | Status |
| --- | --- | --- |
| `lib/src/core/util/in_flight_cache.dart` (47) | `stream_core` `utils/in_flight_cache.dart` (32) | **done** |
| `lib/src/core/util/list_extensions.dart` (270) | `stream_core` `utils/list_extensions.dart` (656) | **deferred** — needs a performance comparison first |
| `lib/src/core/http/stream_chat_dio_error.dart` (19) | `stream_core` `StreamDioException` | **moved to [03](03-errors.md)** — blocked on the error layer |

### `in_flight_cache` — done

The two implementations were semantically identical: same `run(K, Future<V> Function())`
signature, same `Future.sync(work)`, same `whenComplete(() => _inFlight.remove(key)).ignore()`.
Core's test file is our test file — same six cases, same names — so deleting ours lost no
coverage.

`InFlightCache` was never exported from `lib/stream_chat.dart`, and its only consumer is
`client.dart`'s `_queryChannelsCache`. `client.dart` imports it with a `show` clause rather than
pulling core's barrel in wholesale, which would collide with `User`, `Filter`, `TokenManager` and
`SystemEnvironment` in that file:

```dart
import 'package:stream_core/stream_core.dart' show InFlightCache;
```

That `show`-clause pattern is the one to reuse for every subsequent phase — a bare
`import 'package:stream_core/stream_core.dart';` inside `lib/src` will not compile in most of
this package.

### `stream_chat_dio_error` — moved to phase 03, not deferred

This cannot land here, and the reason is worth recording because it looked cheap:

`StreamChatDioError.error` is typed `StreamChatNetworkError`, and core's `StreamDioException`
requires a `StreamException`. `StreamChatNetworkError` extends `StreamChatError implements
Exception` — it is **not** a `StreamException`, so there is nothing to hand core's constructor.
Wrapping it in a `StreamClientException(cause:)` would compile but would break
`stream_http_client.dart:102` (`if (exception is StreamChatDioError) return exception.error;`),
which is how the typed error reaches `_parseError` and then the caller. That would smear phase
03's break into this phase with none of phase 03's benefit.

Both its producers are phase-03/04 code anyway: `auth_interceptor.dart:30` constructs it (deleted
in [04](04-token-and-auth.md)) and `stream_http_client.dart:102` unwraps it (deleted in
[05](05-http-client.md)). It goes when the payload type does.

### `list_extensions` — deferred pending a performance comparison

**Deferred deliberately, not forgotten.** Core's `merge` is a keyed-map-merge-then-sort
(O(n log n)); ours is a two-pointer merge (O(n)) and the file's own header calls it "a runtime
optimization". `channel_client_state.dart` (2,154 LOC) calls these helpers on **every** message,
member and read update, so this is the hottest path in the SDK and "same result for sorted
inputs" is not "same cost".

**Benchmarked.** Mean per call, over `List<Item>` of `{String id, DateTime at}` sorted by date,
merged with `key: (it) => it.id` and a date comparator, warmed up then averaged over 500–20,000
reps depending on size:

| shape | chat | core | |
| --- | --- | --- | --- |
| 1k existing + 1 new | 46us | 64us | chat 1.4x |
| 5k existing + 1 new | 282us | 378us | chat 1.3x |
| 1k existing + 25 page | 47us | 77us | chat 1.6x |
| 1k existing + 25 updates | 43us | 62us | chat 1.4x |
| 1k existing + 1k refresh | 107us | 105us | tie |
| 50 existing + 1 new | 2us | 2us | tie |

Chat's wins wherever the receiver is long and the increment is small, which is the shape the hot
path actually has, and ties on a full refresh where core's re-sort is not wasted. **So chat keeps
its merge; do not adopt core's.**

Upstreaming ours is *not* a drop-in, though, and that is the second finding. The two disagree on
duplicate keys **within** the incoming list: chat's emits both, core's map resolves them to one.
Chat's behaviour is deliberate and pinned by a test (`'tolerates duplicate keys in other'`), so
porting the algorithm up would change core's contract for feeds as well. Either the ask includes
that semantic change, or the algorithm gains a dedup pass first — which costs some of the win.

The file's own header already specifies the migration:

> `TODO(perf-migration)`: once `stream_chat` adopts `stream_core`, delete this file and import
> equivalents from `package:stream_core/src/utils/list_extensions.dart`. The signatures below
> mirror `stream_core`'s so the migration is a one-line import swap. The two-pointer `merge` here
> is a runtime optimization; `stream_core` does keyed-map-merge-and-sort. Both produce the same
> result for sorted inputs.

Extension names do not match, and ours are public:

| Ours | Core |
| --- | --- |
| `SortedListX<T extends Object> on List<T>` | `SortedListExtensions` (+ `ListExtensions`) |
| `IterableMergeX<T extends Object> on Iterable<T>` | `IterableExtensions` |
| `ListX<T extends Object> on List<T>` | `ListExtensions` |

Core's split is different, not just renamed: `upsert` / `batchReplace` / `partition` sit on
`ListExtensions` while `updateWhere` / `insertUnique` / `sortedInsert` / `sortedUpsert` / `merge`
/ `removeNested` / `updateNested` sit on `SortedListExtensions`. Map each call site to the right
one; a blanket rename will not compile.

All of ours landed in core: `sortedUpsertAt` and `mergeSorted` (as `sortedMerge`) were added
there, `updateIf` became `updateWhere`, and `mergeFrom` is expressed as `merge` over a projected
list. `core/util/list_extensions.dart` is deleted; `SortedListExtensions` is re-exported from the
barrel in its place.

### `stream_chat_dio_error`

`StreamChatDioError` is thrown by `AuthInterceptor.onRequest`'s reject path only, and it exists to
carry a `StreamChatNetworkError` through dio. Its payload type belongs to phase
[03](03-errors.md), its thrower to phase [04](04-token-and-auth.md) and its only consumer,
`StreamHttpClient`, to phase [05](05-http-client.md) — so the file cannot be deleted here. This
phase leaves it alone; the switch to core's `StreamDioException` and the deletion land with the
error layer.

## Decisions to make

Both remaining decisions belong to `list_extensions`. The first is now answered:

- ~~**Adopt core's `merge`, or upstream ours?**~~ **Answered by the benchmark above: keep ours.**
  It wins 1.3–1.6x on the shape the hot path has and never loses. Sending it up is a separate
  question, tracked in [UPSTREAM.md](UPSTREAM.md), and gated on the duplicate-key contract.
- **Deprecated forwarders, or a clean break?** `list_extensions.dart` is exported at
  `stream_chat.dart:85` and the extension names differ, so the renames are visible. A Dart
  `extension` cannot be aliased by a `typedef`, so a soft landing means keeping our extension
  names as thin forwarders for one release. Decide whether that is worth it for list helpers most
  consumers never call directly — if not, this becomes a `refactor(llc)!:` with a migration entry
  and the phase is no longer non-breaking.

## Risks

- **`merge` is on the SDK's hottest path** — see the deferral note above. This is the whole reason
  the file is still here.
- Core's split is different, not just renamed, so a blanket rename will not compile: `upsert` /
  `batchReplace` / `partition` live on `ListExtensions` while `updateWhere` / `insertUnique` /
  `sortedInsert` / `sortedUpsert` / `merge` / `removeNested` / `updateNested` live on
  `SortedListExtensions`.

## Upstream `stream_core` work

Done: core gained `sortedUpsertAt` and `sortedMerge`, `merge` took a nullable `other`, and
`updateWhere` became copy-on-write. Each was benchmarked against the chat method it replaced
before the chat copy was deleted.

## Definition of done

- [x] `in_flight_cache.dart` deleted; `client.dart` imports core's with a `show` clause.
- [x] Our `in_flight_cache_test.dart` deleted, with core's confirmed to cover the same six cases.
- [x] `dart analyze --fatal-infos` clean on `stream_chat`; `dart format` clean.
- [x] `stream_chat` tests green (1687 passing); `stream_chat_persistence` tests green (302
      passing) and analyze clean.
- [ ] `merge` benchmarked on realistic shapes, with numbers recorded here.
- [ ] `list_extensions.dart` resolved — adopted, or ours upstreamed — and the export at
      `stream_chat.dart:85` updated accordingly.
- [ ] `stream_chat_dio_error.dart` handled in [03](03-errors.md) (tracked there, not here).
- [ ] `melos run analyze && melos run test:all` before the phase closes.
- [ ] If the extension renames ship as a break: `refactor(llc)!:` title, `🛑️ Breaking` CHANGELOG
      entry, `migrations/v11-migration.md` Symbol Map rows.
- [ ] Decisions recorded here, status box updated in `README.md`.
