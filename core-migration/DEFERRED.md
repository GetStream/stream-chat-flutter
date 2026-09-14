# Deferred work

Everything the migration has consciously postponed, in one place. Each phase file explains its
rows in context; this is the index, so nothing survives only as a sentence buried in a phase doc.

A row leaves this file when it lands, not when it is decided.

## Blocked on something outside the repo

### ⚠️ The branch does not compile against a released `stream_core`

**The single thing gating everything else, and it is easy to miss because the tree is green.**
`melos.yaml` pins both core packages to a git commit that no published version contains, so
`analyze` and the test suites pass against code a consumer cannot resolve from pub.dev. (An earlier
form of this used `dependencyOverridePaths` pointing at a sibling checkout; that only worked on a
machine that had one, which is why CI went red and the pin replaced it.)

Checked against `~/.pub-cache/hosted/pub.dev/stream_core-0.5.0`, chat already depends on five
things missing from it:

| Missing from released 0.5.0 | Used by | Where it is |
| --- | --- | --- |
| `debugCurrentPlatformOverride` | `stream_chat_flutter` tests | core #178, on `main` |
| `sortedMerge`, `sortedUpsertAt` | `channel_client_state.dart` — the SDK's hottest path | `feat/chat-migration-gaps`, pushed |
| `normalizeStringForSort` | the sort registries | [core#181](https://github.com/GetStream/stream-core-flutter/pull/181) |
| `Filter.raw` | `stream_chat_persistence`'s filter converter, `PredefinedFilter` | core#181 |
| element-wise matching for array fields | `members`, `attachments.type` and friends | core#181 |

Nothing on this branch ships until one `stream_core` release carries all five. That is one release,
not five — see [UPSTREAM.md](UPSTREAM.md) on batching. Until it exists, treat a green local run as
evidence about the sibling checkout and nothing more, and re-run against the hosted constraint
before believing the branch is releasable.

| | What | Blocked on | Phase |
| --- | --- | --- | --- |
| ☐ | Restore `melos.yaml` to a hosted `stream_core` constraint and re-verify | The release above. `STYLE_GUIDE.md` §Dependency management says the path override is temporary by design; this is the step that ends it. | [10](10-cleanup.md) |
| ☐ | A test proving a malformed response body surfaces as `StreamClientException` rather than a bare `TypeError` | A call through the generated client — nothing in this package exercises `runApiSafely` yet. Arrives with `openapi-migration` group 02. | [03](03-errors.md) |

## Needs a live check, not more code

| | What | Why source cannot settle it | Phase |
| --- | --- | --- | --- |
| ☑ | ~~One anonymous connect against a real app key~~ **Done, and it works.** Worth keeping for the method: reading the backend end to end predicted it would *fail* — `handshake` validates before it authenticates, and the `userID` tag's regex `^[@\w .-]*$` does not match `!anon`. Every link held and the conclusion was wrong, on a path the backend has no test for either. Why it passes is not established; see [04](04-token-and-auth.md). | [04](04-token-and-auth.md) |
| ☑ | ~~`sample_app` by hand: cold login, mid-session token expiry, logout → login as a different user~~ Done. | Core's interceptor refuses to refresh across a user switch. Correct, but it is a behaviour change on the path where failure means "cannot log in". | [04](04-token-and-auth.md) |
| ☐ | Probe `queryUsers` with a range operator on `name`, and a non-`$eq`/`$in` operator on a custom field | `UserFilterField.name` and `.custom` document a narrower operator set than both the published spec and `mq/user/user.go:25,43`, on the strength of observed 400s that were never written down. Source now contradicts the docs, so the next person to reconcile the two will widen them back. | [08](08-query-dsl.md) |
| ☐ | One real request against a live app key | `api_key` stays a query parameter rather than moving to core's header-setting `ApiKeyInterceptor`; mocks cannot tell us the server agrees. | [05](05-http-client.md) |
| ☑ | ~~Find what produces duplicate-keyed entries in a merged list~~ **Answered.** The merge manufactured them itself. `merge`'s non-overlapping concat fast path (`compare(last, other.first) < 0 → [...this, ...other]`) skipped dedup, and Drift stored `DateTime` as unix **seconds**, so the same message id carried a microsecond-precision `createdAt` in memory and a second-truncated one from the cache — violating the "same key ⇒ same compare value" precondition on every round trip. Merge #1 concatenated silently; merge #2 tripped `_hasUniqueKeys`, which is the [#2660](https://github.com/GetStream/stream-chat-flutter/pull/2660) crash. Both causes are gone: #2660 removed the fast path, and [`7f0804d2d`](https://github.com/GetStream/stream-chat-flutter/commit/7f0804d2d) made persistence store ISO-8601 text. Reproduced end to end on a worktree at `d07f633dd^`. Persistence holds no duplicate rows. | [01](01-utilities.md) |
| ☐ | `flutter build web --wasm` on the sample app | Core's detector has no throwing stub, so this should be a formality — but the wasm fix (`#2940`) exists because chat's *did*, so confirm rather than assume. | [02](02-platform-and-environment.md) |

## Waiting on a decision or a later phase

| | What | Waiting on | Phase |
| --- | --- | --- | --- |
| ☐ | Make `sortedMerge` tie-stable, so an edit does not move a message below a same-timestamp neighbour | The last ordering defect left. A comparator tiebreak looks like the cheaper fix and is not one: `Message.id` is a v4 uuid, and `message_dao`'s `(createdAt, id)` is keyset-pagination machinery rather than a chosen display order. Tie-stability in the merge is the honest fix, measured at 1.08-1.39x depending on list length. Findings, dead ends and numbers in [message-ordering.md](message-ordering.md). | [01](01-utilities.md) |
| ☐ | **A `StreamChatConfig`**, mirroring `FeedsConfig` | Deliberately last, as a cleanup step once the adoption is done. It subsumes several rows below, so doing it early would mean doing them twice. See [below](#the-streamchatconfig-that-absorbs-several-of-these). | [10](10-cleanup.md) |
| ☐ | Retire `StreamChatClient.additionalHeaders` and `defaultUserAgent` | Both are public mutable statics, so two clients in one process share them. Replacing the first needs a per-client `headers` option; the second reads the static `_systemEnvironmentManager`, so they move together. | [10](10-cleanup.md) |
| ☐ | Take `StreamHttpClientOptions` directly instead of `baseURL` / `connectTimeout` / `receiveTimeout` | Folds into the config above rather than being a separate break. | [10](10-cleanup.md) |
| ☐ | Mark `StreamHttpClient` `@internal` | `AttachmentFileUploaderProvider` is the only public signature naming it, and retyping that is phase 09's call. | [09](09-uploads.md) |
| ☐ | Reclassify the SDK's own precondition throws | 19 sites raise `StreamClientException`, retyped mechanically in [03](03-errors.md). `ERROR_LAYER.md` splits them further than a sweep can: a condition a correct program can hit becomes a `StreamException`, while genuine misuse should raise `StateError` / `ArgumentError` and never be wrapped. Doing it by sed would get it wrong. | [03](03-errors.md) |
| ☐ | Move chat's WebSocket to `/api/v2/connect` | Three blockers, none of them chat-side: v2's handshake never calls `EnrichUserMutes` (`lib/chat/controller/v1/connect.go:118` only), it decodes `user_details` with `WithDecodeExtraFields(false)` so chat's root-promoted `extraData` is dropped, and core's `ConnectUserDetailsRequest` has no `privacySettings`. iOS is on core and v2 endpoints and still connects over v1. | [07](07-websocket.md) |
| ☐ | Decide whether id-like sort fields should opt out of string folding | `StreamSortField` folds **every** string value through `normalizeStringForSort`, which is what `ComparableField` did, so [08](08-query-dsl.md) kept it. It also means `UserSortField.id`, `MessageSearchSortField.id`, `MemberSortField.userId`, `MessageReminderSortField.channelCid` and `ThreadSortField.parentMessageId` compare case- and diacritic-insensitively — two ids differing only in case tie, so a composite sort's tie-breaker stops breaking ties. Pre-existing, and a `foldStrings: false` per field would fix it; changing it is a behaviour change beyond the migration. | [08](08-query-dsl.md) |
| ☐ | Implement the uploader against core's task machinery | The **decision** is made — chat keeps its broader interface and implements a chat-side `CdnClient` for the CDN half ([09](09-uploads.md)). Only the work is outstanding. Must still agree with `openapi-migration/12-uploads-cdn.md` on who writes the multipart calls. | [09](09-uploads.md) |

## Landed, listed so nobody re-raises it

| | What | Where |
| --- | --- | --- |
| ☑ | Remove chat's own logger and `package:logging` | Done in [06](06-logger.md): the SDK writes through `StreamLogger`, `logConfig` replaces `logLevel` + `logHandlerFunction`, and no package in the repo imports `package:logging` any more. |
| ☑ | Delete `StreamChatClient.devToken` | [04](04-token-and-auth.md) |
| ☑ | Delete `stream_chat_error.dart` | [03](03-errors.md). It was expected to need four unblockings first; three dissolved on contact and the fourth (the UI's attachment-validation subtypes) was the only one needing a decision — they became their own sealed family, since a refused attachment is not a failed call. |
| ☑ | Adopt core's `CurrentPlatform` / `PlatformType` | [02](02-platform-and-environment.md). `.name` → `.operatingSystem`. The *code* is done; shipping it still waits on the release above. |
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
