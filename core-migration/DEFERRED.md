# Deferred work

Everything the migration has consciously postponed, in one place. Each phase file explains its
rows in context; this is the index, so nothing survives only as a sentence buried in a phase doc.

A row leaves this file when it lands, not when it is decided.

## Blocked on something outside the repo

| | What | Blocked on | Phase |
| --- | --- | --- | --- |
| ☐ | **Restore hosted `stream_core` / `stream_core_flutter` constraints** in `melos.yaml` | A `stream_core` release carrying `Filter.raw`, `normalizeStringForSort`, `debugCurrentPlatformOverride` and `sortedWith`. Until then `melos bootstrap` writes a `git:` block into `stream_chat`, `stream_chat_flutter_core` and `stream_chat_flutter`, which makes all three unpublishable. This is the row every other "blocked on a core release" note now folds into. | [08](08-query-dsl.md) |
| ☐ | A test proving a malformed response body surfaces as `StreamClientException` rather than a bare `TypeError` | A call through the generated client — nothing in this package exercises `runApiSafely` yet. Arrives with `openapi-migration` group 02. | [03](03-errors.md) |

## Needs a live check, not more code

| | What | Why source cannot settle it | Phase |
| --- | --- | --- | --- |
| ☐ | One anonymous connect against a real app key | Anonymous requests now send `user_id=!anon` instead of a random id. Three backend paths say it is safe, but the enforcement in `auth.go:179` only runs for a raw anon JWT, which chat never sends — so what the server does with the *query parameter* is inference. | [04](04-token-and-auth.md) |
| ☐ | `sample_app` by hand: cold login, mid-session token expiry, logout → login as a different user | Core's interceptor refuses to refresh across a user switch. Correct, but it is a behaviour change on the path where failure means "cannot log in". | [04](04-token-and-auth.md) |
| ☐ | Probe `queryUsers` with a range operator on `name`, and a non-`$eq`/`$in` operator on a custom field | `UserFilterField.name` and `.custom` document a narrower operator set than both the published spec and `mq/user/user.go:25,43`, on the strength of observed 400s that were never written down. Source now contradicts the docs, so the next person to reconcile the two will widen them back. | [08](08-query-dsl.md) |
| ☐ | One real request against a live app key | `api_key` stays a query parameter rather than moving to core's header-setting `ApiKeyInterceptor`; mocks cannot tell us the server agrees. | [05](05-http-client.md) |
| ☑ | ~~Find what produces duplicate-keyed entries in a merged list~~ **Answered.** The merge manufactured them itself. `merge`'s non-overlapping concat fast path (`compare(last, other.first) < 0 → [...this, ...other]`) skipped dedup, and Drift stored `DateTime` as unix **seconds**, so the same message id carried a microsecond-precision `createdAt` in memory and a second-truncated one from the cache — violating the "same key ⇒ same compare value" precondition on every round trip. Merge #1 concatenated silently; merge #2 tripped `_hasUniqueKeys`, which is the [#2660](https://github.com/GetStream/stream-chat-flutter/pull/2660) crash. Both causes are gone: #2660 removed the fast path, and [`7f0804d2d`](https://github.com/GetStream/stream-chat-flutter/commit/7f0804d2d) made persistence store ISO-8601 text. Reproduced end to end on a worktree at `d07f633dd^`. Persistence holds no duplicate rows. | [01](01-utilities.md) |
| ☐ | `flutter build web --wasm` on the sample app | Core's detector has no throwing stub, so this should be a formality — but the wasm fix (`#2940`) exists because chat's *did*, so confirm rather than assume. | [02](02-platform-and-environment.md) |

## Waiting on a decision or a later phase

| | What | Waiting on | Phase |
| --- | --- | --- | --- |
| ☐ | Make `sortedMerge` tie-stable, so an edit does not move a message below a same-timestamp neighbour | The last ordering defect left. A comparator tiebreak looks like the cheaper fix and is not one: `Message.id` is a v4 uuid, and `message_dao`'s `(createdAt, id)` is keyset-pagination machinery rather than a chosen display order. Tie-stability in the merge is the honest fix, measured at 1.08-1.39x depending on list length. Findings, dead ends and numbers in [message-ordering.md](message-ordering.md). | [01](01-utilities.md) |
| ☐ | Adopt core's `CurrentPlatform` / `PlatformType`, renaming `.name` → `.operatingSystem` | The restore row above. No release of its own: the SHA pinned in [08](08-query-dsl.md) already carries `debugCurrentPlatformOverride`, which `stream_chat_flutter`'s tests set in 8 places, so this is doable now and only the hosted constraint is outstanding. | [02](02-platform-and-environment.md) |
| ☐ | **A `StreamChatConfig`**, mirroring `FeedsConfig` | Deliberately last, as a cleanup step once the adoption is done. It subsumes several rows below, so doing it early would mean doing them twice. See [below](#the-streamchatconfig-that-absorbs-several-of-these). | [10](10-cleanup.md) |
| ☐ | Retire `StreamChatClient.additionalHeaders` and `defaultUserAgent` | Both are public mutable statics, so two clients in one process share them. Replacing the first needs a per-client `headers` option; the second reads the static `_systemEnvironmentManager`, so they move together. | [10](10-cleanup.md) |
| ☐ | Take `StreamHttpClientOptions` directly instead of `baseURL` / `connectTimeout` / `receiveTimeout` | Folds into the config above rather than being a separate break. | [10](10-cleanup.md) |
| ☐ | Mark `StreamHttpClient` `@internal` | `AttachmentFileUploaderProvider` is the only public signature naming it, and retyping that is phase 09's call. | [09](09-uploads.md) |
| ☐ | Reclassify the SDK's own precondition throws | 23 sites still raise `StreamChatError`. `ERROR_LAYER.md` splits them further than a sweep can: a condition a correct program can hit becomes a `StreamException`, while genuine misuse should raise `StateError` / `ArgumentError` and never be wrapped. Doing it by sed would get it wrong. | [03](03-errors.md) |
| ☐ | Delete `stream_chat_error.dart` | Three things first: phase 07 (parked) removes `StreamWebSocketError`, the precondition throws above are reclassified, and the UI's attachment-validation subtypes stop being errors — they are *returned values*, never thrown. `StreamChatNetworkError` is already gone. | [03](03-errors.md) |
| ☐ | Move chat's WebSocket to `/api/v2/connect` | Three blockers, none of them chat-side: v2's handshake never calls `EnrichUserMutes` (`lib/chat/controller/v1/connect.go:118` only), it decodes `user_details` with `WithDecodeExtraFields(false)` so chat's root-promoted `extraData` is dropped, and core's `ConnectUserDetailsRequest` has no `privacySettings`. iOS is on core and v2 endpoints and still connects over v1. | [07](07-websocket.md) |
| ☐ | Narrow `PredefinedFilter._defaultSortFor` to the server's flag condition | It answers `last_message_at` whenever the filter mentions the field at all. The server flips its fallback only when *every* `last_message_at` node is reachable through `$and` alone and at least one narrows by value — `$eq` / `$ne` / `$gt` / `$gte` / `$lt` / `$lte`, or `$exists: true` (`DetectLastMessageAtFiltering`, `lib/core/mq/channel/modifiers.go`). So a preset putting `last_message_at` under `$or`, or matching it with `$in` or `$exists: false`, leaves the server on `last_updated` while the client answers `last_message_at`, and `loadMore`'s offset indexes into a differently ordered list. A test pins the loose `$or` behaviour today, so closing this inverts it. | [08](08-query-dsl.md) |
| ☐ | Decide whether id-like sort fields should opt out of string folding | `StreamSortField` folds **every** string value through `normalizeStringForSort`, which is what `ComparableField` did, so [08](08-query-dsl.md) kept it. It also means `UserSortField.id`, `MessageSearchSortField.id`, `MemberSortField.userId`, `MessageReminderSortField.channelCid` and `ThreadSortField.parentMessageId` compare case- and diacritic-insensitively — two ids differing only in case tie, so a composite sort's tie-breaker stops breaking ties. Pre-existing, and a `foldStrings: false` per field would fix it; changing it is a behaviour change beyond the migration. | [08](08-query-dsl.md) |
| ☐ | Order pinned messages by `pinnedAt`, not `createdAt` | Pre-existing, and this phase only made it visible. The API returns pinned messages `ORDER BY message.pinned_at DESC NULLS LAST`, but every write goes through `_mergePinnedMessagesIntoExisting` → `sortedUpsertAt(compare: _sortByCreatedAt)`, so a pin lands in creation order. On v10 the mis-placement was silent; core's `sortedUpsertAt` asserts its receiver is sorted, which turned it into a debug crash, and sorting the payload by `createdAt` on the way in was the minimal fix. Doing it properly means comparing by `pinnedAt` on every path, which needs a null-ordering decision — `Message.pinnedAt` is nullable where `createdAt` is not. Raised on [#2959](https://github.com/GetStream/stream-chat-flutter/pull/2959). | [01](01-utilities.md) |
| ☐ | Implement the uploader against core's task machinery | The **decision** is made — chat keeps its broader interface and implements a chat-side `CdnClient` for the CDN half ([09](09-uploads.md)). Only the work is outstanding. Must still agree with `openapi-migration/12-uploads-cdn.md` on who writes the multipart calls. | [09](09-uploads.md) |

## Landed, listed so nobody re-raises it

| | What | Where |
| --- | --- | --- |
| ☑ | Remove chat's own logger and `package:logging` | Done in [06](06-logger.md): the SDK writes through `StreamLogger`, `logConfig` replaces `logLevel` + `logHandlerFunction`, and no package in the repo imports `package:logging` any more. |
| ☑ | Delete `StreamChatClient.devToken` | [04](04-token-and-auth.md) |
| ☑ | Benchmark `merge` on realistic lists | Done, numbers in [01](01-utilities.md). The two-pointer merge wins 1.3–1.6x wherever the receiver is long and the increment is small, and ties on a full refresh, so it moved to core as `sortedMerge` rather than being dropped for `merge`. Chat's `list_extensions.dart` is deleted; parity with the version it replaced is 0.97–1.01x, and a disjoint-key fast path makes pagination ~8% faster. |
| ☑ | Adopt core's `Filter<T>` / `Sort<T>` / `ComparableField` | Done in [08](08-query-dsl.md). It was never blocked on core gaining `$nor`: no core SDK models it, and chat removed `$nor`, `$ne` and `$nin` instead — the API is withdrawing all three. |
| ☑ | Decide the fate of `Filter.custom` / `Filter.raw` / `Filter.empty` | [08](08-query-dsl.md): `custom` becomes a per-registry factory, `raw` moved to core, `empty` is replaced by nullability. |
| ☑ | Adopt core's `LocationCoordinate` | [08](08-query-dsl.md), closing that phase. |
| ☑ | Settle chat's keepalive frame | [07](07-websocket.md): no chat-side ping type. `MonitorHealth` (`client.go:607-620`) `Discard()`s every client frame, so the body is unread and core's default `pingRequestBuilder` is correct. iOS sends a raw protocol ping for the same reason. |

## The `StreamChatConfig` that absorbs several of these

Sequenced into [10](10-cleanup.md) rather than done now, because it is an API redesign and the
adoption keeps changing what belongs in it. `FeedsConfig` is the shape to follow — nullable fields,
`const`-constructible, with test seams kept as separate `@visibleForTesting` parameters rather than
config:

```dart
StreamChatClient(
  apiKey, {
  StreamChatConfig config = const StreamChatConfig(),
  // @visibleForTesting seams stay out of config, as in stream_feeds.
  StreamChatApi? chatApi,
  WebSocket? ws,
});

class StreamChatConfig {
  const StreamChatConfig({
    this.logConfig,                       // already a constructor param today
    this.httpOptions,                     // replaces baseURL / connectTimeout / receiveTimeout
    this.customHeaders,                   // retires the `additionalHeaders` static
    this.retryPolicy,
    this.attachmentFileUploaderProvider,  // the `cdnClient` analogue
    this.recoverStateOnReconnect,
    this.isLocalUnreadCountEnabled,
  });
}
```

The constructor currently carries fourteen parameters, several of them test seams sitting beside
real configuration. Grouping them is one break instead of several, and it is what kills the two
public statics.
