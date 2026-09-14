# Deferred work

Everything the migration has consciously postponed, in one place. Each phase file explains its
rows in context; this is the index, so nothing survives only as a sentence buried in a phase doc.

A row leaves this file when it lands, not when it is decided.

## Blocked on something outside the repo

| | What | Blocked on | Phase |
| --- | --- | --- | --- |
| ☐ | **Restore hosted `stream_core` / `stream_core_flutter` constraints** in `melos.yaml` | A `stream_core` release carrying `Filter.raw`, `normalizeStringForSort`, `debugCurrentPlatformOverride` and `sortedWith`. Until then `melos bootstrap` writes a `git:` block into `stream_chat`, `stream_chat_flutter_core` and `stream_chat_flutter`, which makes all three unpublishable. This is the row every other "blocked on a core release" note now folds into. | [08](08-query-dsl.md) |
| ☐ | Adopt core's `CurrentPlatform` / `PlatformType`, renaming `.name` → `.operatingSystem` | Nothing any more — the SHA pinned in [08](08-query-dsl.md) carries `debugCurrentPlatformOverride`, which `stream_chat_flutter`'s tests set in 8 places. Rides the restore row above. | [02](02-platform-and-environment.md) |
| ☐ | A test proving a malformed response body surfaces as `StreamClientException` rather than a bare `TypeError` | A call through the generated client — nothing in this package exercises `runApiSafely` yet. Arrives with `openapi-migration` group 02. | [03](03-errors.md) |

## Needs a live check, not more code

| | What | Why source cannot settle it | Phase |
| --- | --- | --- | --- |
| ☐ | One anonymous connect against a real app key | Anonymous requests now send `user_id=!anon` instead of a random id. Three backend paths say it is safe, but the enforcement in `auth.go:179` only runs for a raw anon JWT, which chat never sends — so what the server does with the *query parameter* is inference. | [04](04-token-and-auth.md) |
| ☐ | `sample_app` by hand: cold login, mid-session token expiry, logout → login as a different user | Core's interceptor refuses to refresh across a user switch. Correct, but it is a behaviour change on the path where failure means "cannot log in". | [04](04-token-and-auth.md) |
| ☐ | One real request against a live app key | `api_key` stays a query parameter rather than moving to core's header-setting `ApiKeyInterceptor`; mocks cannot tell us the server agrees. | [05](05-http-client.md) |
| ☐ | Benchmark `merge` on realistic lists (1k+ sorted messages, a large member list, the read map) | Decides whether chat adopts core's keyed-map-merge or core adopts chat's two-pointer merge. It runs on every message, member and read update. | [01](01-utilities.md) |
| ☐ | `flutter build web --wasm` on the sample app | Core's detector has no throwing stub, so this should be a formality — but the wasm fix (`#2940`) exists because chat's *did*, so confirm rather than assume. | [02](02-platform-and-environment.md) |

## Waiting on a decision or a later phase

| | What | Waiting on | Phase |
| --- | --- | --- | --- |
| ☐ | **A `StreamChatConfig`**, mirroring `FeedsConfig` | Deliberately last, as a cleanup step once the adoption is done. It subsumes several rows below, so doing it early would mean doing them twice. See [below](#the-streamchatconfig-that-absorbs-several-of-these). | [10](10-cleanup.md) |
| ☐ | Retire `StreamChatClient.additionalHeaders` and `defaultUserAgent` | Both are public mutable statics, so two clients in one process share them. Replacing the first needs a per-client `headers` option; the second reads the static `_systemEnvironmentManager`, so they move together. | [10](10-cleanup.md) |
| ☐ | Take `StreamHttpClientOptions` directly instead of `baseURL` / `connectTimeout` / `receiveTimeout` | Folds into the config above rather than being a separate break. | [10](10-cleanup.md) |
| ☐ | Mark `StreamHttpClient` `@internal` | `AttachmentFileUploaderProvider` is the only public signature naming it, and retyping that is phase 09's call. | [09](09-uploads.md) |
| ☐ | Reclassify the SDK's own precondition throws | 23 sites still raise `StreamChatError`. `ERROR_LAYER.md` splits them further than a sweep can: a condition a correct program can hit becomes a `StreamException`, while genuine misuse should raise `StateError` / `ArgumentError` and never be wrapped. Doing it by sed would get it wrong. | [03](03-errors.md) |
| ☐ | Delete `stream_chat_error.dart` | Four things first: group 12 removes `StreamChatNetworkError`, phase 07 (parked) removes `StreamWebSocketError`, the precondition throws above are reclassified, and the UI's attachment-validation subtypes stop being errors — they are *returned values*, never thrown. | [03](03-errors.md) |
| ☐ | Move chat's WebSocket to `/api/v2/connect` | Three blockers, none of them chat-side: v2's handshake never calls `EnrichUserMutes` (`lib/chat/controller/v1/connect.go:118` only), it decodes `user_details` with `WithDecodeExtraFields(false)` so chat's root-promoted `extraData` is dropped, and core's `ConnectUserDetailsRequest` has no `privacySettings`. iOS is on core and v2 endpoints and still connects over v1. | [07](07-websocket.md) |
| ☐ | Decide whether id-like sort fields should opt out of string folding | `StreamSortField` folds **every** string value through `normalizeStringForSort`, which is what `ComparableField` did, so [08](08-query-dsl.md) kept it. It also means `UserSortField.id`, `MessageSearchSortField.id`, `MemberSortField.userId`, `MessageReminderSortField.channelCid` and `ThreadSortField.parentMessageId` compare case- and diacritic-insensitively — two ids differing only in case tie, so a composite sort's tie-breaker stops breaking ties. Pre-existing, and a `foldStrings: false` per field would fix it; changing it is a behaviour change beyond the migration. | [08](08-query-dsl.md) |
| ☐ | Decide whether core grows channel-scoped `CdnClient` operations, or chat keeps its broader uploader interface | Half of chat's uploads are channel-scoped and core's `CdnClient` has only four CDN-scoped methods. Must agree with `openapi-migration/12-uploads-cdn.md` before either starts. | [09](09-uploads.md) |

## Landed, listed so nobody re-raises it

| | What | Where |
| --- | --- | --- |
| ☑ | Remove chat's own logger and `package:logging` | Done in [06](06-logger.md): the SDK writes through `StreamLogger`, `logConfig` replaces `logLevel` + `logHandlerFunction`, and no package in the repo imports `package:logging` any more. |
| ☑ | Delete `StreamChatClient.devToken` | [04](04-token-and-auth.md) |
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
