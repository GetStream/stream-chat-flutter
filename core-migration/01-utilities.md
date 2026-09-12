# 01 — Utilities

**Goal:** prove the pattern on files that touch no behaviour and almost no public surface.

**Size:** 317 chat LOC deleted. Two methods added to `stream_core` — `sortedMerge` and `sortedUpsertAt`.

## Scope

| Delete | Adopt | Status |
| --- | --- | --- |
| `lib/src/core/util/in_flight_cache.dart` (47) | `stream_core` `utils/in_flight_cache.dart` (32) | **done** |
| `lib/src/core/util/list_extensions.dart` (270) | `stream_core` `utils/list_extensions.dart` | **done** — every helper moved to core, measured at parity first |
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

### `list_extensions` — moved to core, after a performance comparison

**Why this was held back rather than swapped.** Core's `merge` is a keyed-map-merge-then-sort
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

Both belonged to `list_extensions`, and both are answered:

- ~~**Adopt core's `merge`, or upstream ours?**~~ **Neither, in the end.** Ours wins 1.76-1.86x
  on the shape the hot path has, so adopting `merge` was not an option — but rather than keeping
  it chat-side it went up as `sortedMerge`, a second method beside `merge` with the narrower
  contract. See [UPSTREAM.md](UPSTREAM.md).
- ~~**Deprecated forwarders, or a clean break?**~~ **A clean break.** A Dart `extension` cannot be
  aliased by a `typedef`, so forwarders would mean keeping all three extension names alive for a
  release. Not worth it for list helpers almost nobody calls directly, so this shipped as a
  `refactor(llc)!:` with a CHANGELOG entry and Symbol Map rows, and the phase is breaking rather
  than silent.

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

## Outcome

Chat's file is deleted rather than kept. The plan allowed for keeping the two-pointer `merge`
chat-side if it beat core's, and it did — so it moved to core as `sortedMerge` instead, alongside
`sortedUpsertAt`. `updateIf` became core's `updateWhere`, and `mergeFrom` is expressed as `merge`
over a projected list, so nothing needed a home chat-side.

Each helper was measured against the one it replaced before that one was deleted: 0.97-1.01x on
merges whose keys overlap, 0.92-0.95x where they do not, and identical output over 40k randomized
merges. `sortedMerge` keeps the O(n + m) walk that made chat's version worth keeping; `merge`
would have cost 1.76-1.86x on the same shapes.

Two things came out of the benchmarking rather than the migration, and are written up in
[message-ordering.md](message-ordering.md): what actually caused the duplicate-key crash in
[#2660](https://github.com/GetStream/stream-chat-flutter/pull/2660), and why a tiebreak on
`Message.id` is the wrong fix for tied timestamps.

## Definition of done

- [x] `in_flight_cache.dart` deleted; `client.dart` imports core's with a `show` clause.
- [x] Our `in_flight_cache_test.dart` deleted, with core's confirmed to cover the same six cases.
- [x] `dart analyze --fatal-infos` clean on `stream_chat`; `dart format` clean.
- [x] `stream_chat` tests green (1687 passing); `stream_chat_persistence` tests green (302
      passing) and analyze clean.
- [x] `merge` benchmarked on realistic shapes, with numbers recorded here.
- [x] `list_extensions.dart` resolved — every helper moved to core, the file deleted, and
      `SortedListExtensions` re-exported from the barrel in its place.
- [x] `stream_chat_dio_error.dart` handled in [03](03-errors.md) (tracked there, not here).
- [x] `melos run analyze && melos run test:all` before the phase closes.
- [x] The extension renames shipped as a break: `refactor(llc)!:` title, `🛑️ Breaking` CHANGELOG
      entry, `migrations/v11-migration.md` Symbol Map rows.
- [x] Decisions recorded here, status box updated in `README.md`.
