# 03 — Errors & the `Result` surface

**Goal:** replace our error class tree with core's sealed `StreamException` family, and make
`Result` available to consumers. Everything after this phase assumes both.

**Size:** ~410 chat LOC deleted against ~900 core LOC adopted. The largest break in the plan.
**No upstream core work needed** — see [Error codes](#error-codes).

> This phase owns the error/`Result` slice that `openapi-migration/01-foundation.md` previously
> claimed. That file now points here. Nothing else about the openapi track changes.

## Scope

| Delete | Adopt |
| --- | --- |
| `lib/src/core/error/stream_chat_error.dart` (230) — `StreamChatError`, `StreamChatNetworkError`, `StreamChatNetworkErrorType`, `StreamWebSocketError` | `stream_core` `errors/stream_exception.dart` — `sealed StreamException` → `StreamApiException`, `StreamNetworkException`, `StreamAuthenticationException`, `StreamClientException` |
| `lib/src/core/error/chat_error_code.dart` (158) — `ChatErrorCode` (25 values), `_errorCodeWithDescription`, `chatErrorCodeFromCode`, `ChatErrorCodeX` | `stream_core` `errors/stream_error_code.dart` — `StreamErrorCode`, an `extension type const StreamErrorCode(int) implements int` with ~40 constants, plus `StreamErrorCodePredicates` |
| `ErrorResponse` decoding in `StreamHttpClient._parseError` | `stream_core` `errors/stream_api_error.dart` — `StreamApiError` |

All four core kinds are `base`, so chat may extend a kind if a case genuinely needs it and can
never add a fifth top-level kind. `stream-core-flutter/ERROR_LAYER.md` is normative and nothing in
this repo references it — read it first.

### Alias the root, the way feeds does — decided

```dart
/// An alias of [StreamException], so code written against either name catches
/// the same failures.
typedef StreamChatException = StreamException;
```

`stream_feeds` declares exactly this (`typedef StreamFeedsException = StreamException;`,
`stream_feeds/lib/src/feeds_client.dart:56`) and documents its public API in terms of the alias —
"`connect()` throws a `StreamFeedsException`". Chat follows the same shape:

- **Product-branded name, shared type.** `on StreamChatException` and `on StreamException` catch
  the same thing, so an integrator reading chat's docs never has to learn that the error family
  lives in another package, while someone working across two Stream SDKs writes one handler.
- **It is a `typedef`, not a subclass.** Nothing to construct, nothing to keep in step with core,
  and the sealed hierarchy stays exhaustive — a `switch` over `StreamChatException` still gets
  the four `base` kinds and nothing else.
- **It reads in chat's vocabulary.** Chat's own code and dartdoc use `StreamChatException`
  throughout — `_parseError`'s return type, `RetryPolicy.shouldRetry`'s parameter, the
  `isRetriable` extension — so nothing in the SDK's surface makes a reader go looking in another
  package. The four kinds keep their core names, since those are what a `switch` matches on and
  renaming them would break the shared-handler property.

**`StreamChatError` is *not* aliased onto it.** An earlier draft of this file suggested
`@Deprecated typedef StreamChatError = StreamException;`, which turned out to be wrong: that class
is still a live base for things unrelated to request failures —
`stream_chat_flutter`'s `AttachmentLimitReachedError`, `AttachmentTooLargeError` and
`AttachmentBlockedError` extend it, and the SDK's own precondition throws raise it. It stays as it
is; only `StreamChatNetworkError` is deprecated.

Export the alias from `lib/stream_chat.dart` alongside the allowlist below.

Feeds adds **nothing else** to the hierarchy — zero classes in `stream_feeds/lib` extend or
implement a `StreamException`. Match that: the alias is the whole product-side error surface
unless a specific case proves otherwise.

### Install `ApiErrorInterceptor`

It is **not installed anywhere in chat today.** That is why a call through the generated client
currently hands back a `Failure` carrying a raw `DioException`: `DefaultApi` goes straight to
`_dio.fetch` and bypasses `StreamHttpClient._parseError`, which only its own verb wrappers call.

Install it **last** in the pipeline (it must see every rejection on the way out) and the guarantee
holds: `runApiSafely` — already used by `default_api.dart:783` — maps a `DioException` through
`toStreamException()`, passes a `StreamException` through unchanged, and wraps everything else,
*including a `TypeError` from an undecodable response body*, in a `StreamClientException` with the
original as `cause`.

### The `Result` surface

Re-export from `lib/stream_chat.dart` with a `show` allowlist:

```dart
export 'package:stream_core/stream_core.dart'
    show
        Result, Success, Failure,
        StreamException, StreamApiException, StreamNetworkException,
        StreamAuthenticationException, StreamClientException,
        StreamApiError, StreamErrorCode;
```

Plus the `StreamChatException` alias above, from wherever it is declared.

**Resolve the `Success` collision first.** Chat's `UploadState` is a `@freezed sealed` union whose
success variant is a class named `Success`, and it is exported. Either rename it (breaking, and
phase [09](09-uploads.md) touches `UploadState` anyway) or do not export core's `Success` and
document `Result` pattern-matching through `switch` on the sealed type instead.

### Keep the hand-written API layer throwing

`StreamHttpClient`'s verb wrappers keep throwing — they just throw a `StreamException` now instead
of a `StreamChatNetworkError`. This is deliberate and it is what keeps this plan independent of
`openapi-migration`: each of that plan's 12 feature groups converts its own methods to
`Future<Result<T>>` when it migrates, and until then nothing above the api layer changes shape.

The break is already promised in `migrations/v11-migration.md`'s Symbol Map, so this phase
delivers what that guide advertises rather than adding a new row.

### Error codes

**Resolved against the backend, not left as a question.** `~/GolandProjects/chat`
`monolith/errors/errors.go:37-75` is the registry. It contains **no code 23 and no code 24**, and
`requestTimeout = 48`.

| Ours | Verdict |
| --- | --- |
| `requestTimeout` = **23** | **Wrong.** The wire code is 48, which core already has as `StreamErrorCode.requestTimeout`. Anyone matching on 23 has never matched a real response. |
| `maximumHeaderSizeExceeded` = **24** | **Not a wire code.** Drop it; no upstream ask. |
| `undefinedToken` = **1000** | Client-invented, not a wire code. Drop it. |
| everything else | Present in `StreamErrorCode` with the same value. |

So `StreamErrorCode` needs no additions and phase 03 has zero upstream dependencies. Record the 23
→ 48 correction as its own CHANGELOG line: it is a silent behaviour change for any consumer
matching the old constant.

### `isRetriable` stays ours

It exists on both `StreamChatNetworkError` and `StreamWebSocketError` (`data == null`) and drives
`RetryQueue` via `RetryPolicy.shouldRetry`. Core has nothing equivalent — its
`DisconnectionSource.isReconnectable` is transport-level policy for the socket, not for a request.
Re-express ours as a chat-side extension over the core kinds. `ERROR_LAYER.md` is explicit that
retryability is the caller's policy, so this is the intended shape, not a workaround.

### Two lossy conversions to document

- `StreamChatNetworkErrorType` mirrors `DioExceptionType` with 9 values.
  `StreamNetworkException` has `isCancelled` / `isTimeout` / `closeCode`, so `sendTimeout`,
  `receiveTimeout` and `connectionTimeout` all collapse into one `isTimeout`.
- `StreamWebSocketError` has no analogue; core surfaces socket failures through
  `DisconnectionSource.serverInitiated(error:)`. **Keep it alive through this phase** — the WS
  layer still throws it until phase [07](07-websocket.md), and `client.dart:459` catches it by
  type during `connectUser`.

  **Be explicit that this is a carry-forward, not an oversight.** `StreamWebSocketError` outlives
  this phase and stays fully live through phases 04–06: `websocket.dart` constructs it
  (`_handleStreamError`, `websocket.dart:392`), `connectUser` catches it by type to decide whether
  to retry the initial connect, and it keeps its own `isRetriable`. So for as long as 04–06 take,
  the SDK has *two* error families in flight — the sealed `StreamException` everywhere else, and
  this one type on the socket path. That is intended and bounded; it becomes dead code only when
  07 replaces the transport, and 07's definition of done is what deletes it. Do not try to
  half-migrate it here.

## Decisions taken

1. **Retry policy adopts core's table** (`ERROR_LAYER.md` §Retrying) rather than preserving v10
   behaviour. Today's predicate is `isRetriable => data == null` — it retries only when the
   response carried *no* parseable Stream error payload, so a 500 or a 429 never retries a failed
   message. The new predicate retries network failures (unless cancelled), 5xx, 429 and 408, and
   never other 4xx, auth failures, client failures, or anything flagged `unrecoverable`. **This
   changes runtime behaviour** and gets its own CHANGELOG line.
2. **`StreamChatNetworkError` is deprecated, not deleted.** It must survive: every endpoint
   `openapi-migration` has not yet moved still flows through the hand-written verb facade. It goes
   when group 12 lands. **The deprecation warning is not the whole story** — nothing throws it
   any more, so `on StreamChatNetworkError catch` still *compiles* and silently stops matching.
   The migration guide has to say that in those words.
3. **`ChatErrorCode` is deleted**, as `migrations/v11-migration.md` already promises. An `enum`
   cannot alias an extension type, so a deprecated forwarder is not available, and three of its
   entries are not real wire codes anyway (see below).
4. **The whole `PagedValue` / `errorBuilder` chain is retyped in this phase**, so the break lands
   once across all three packages rather than leaving `StreamChatError` alive as the UI currency.
   See [Downstream](#downstream-the-flutter-packages).

### The `Success` collision, and the name to avoid

Chat's `UploadState` union exports four strikingly generic names — `Preparing`, `InProgress`,
`Success`, `Failed` — and `Success` is contended three ways: chat's `UploadState.success` variant,
`stream_chat_flutter_core`'s `PagedValue.success` variant (`Success<Key, Value>`), and core's
`Result` `Success<T>`. There are already **13 `hide Success` import clauses** in this repo working
around the first two.

Rename chat's four variants to `UploadStatePreparing`, `UploadStateInProgress`,
`UploadStateSuccess`, `UploadStateFailed`.

**Do not name them `UploadPreparing` / `UploadInProgress` / `UploadSuccess` / `UploadFailed`,**
tempting as the symmetry is: those are exactly core's `AttachmentUploadState` variant names, and
phase [09](09-uploads.md) puts core's union in scope *alongside* chat's — which stays on
`Attachment` for Drift. Matching core's names now just moves the collision into phase 09.

## Downstream: the Flutter packages

The original scope note undercounted this badly. `StreamChatError` is not confined to the LLC —
it is woven through `stream_chat_flutter_core`'s **public** API:

| Surface | Where | Public |
| --- | --- | --- |
| `PagedValue.error(StreamChatError)`, plus the generated `when` / `map` / `maybeWhen` signatures | `paged_value_notifier.dart` | yes — backs every list controller |
| `errorBuilder: Widget Function(BuildContext, StreamChatError)` | `paged_value_scroll_view.dart` (×2) | yes — widget API |
| `on StreamChatError catch` followed by `StreamChatError(error.toString())` | 11 controllers, two sites each | internal |

Real totals for this phase: **205 `lib` references and 230 `test` references across three
packages**, not one. `stream_chat_persistence` has zero and is untouched.

All of it is retyped to `StreamException` here. The controllers already wrapped non-chat errors as
`StreamChatError(error.toString())`, so those sites become `on StreamChatException catch` with the
wrap rewritten as `StreamClientException(message: error.toString(), cause: error)` — the original
throwable survives as `cause`, which the old wrap discarded.

## Risks

- **The widest blast radius in the plan**, and it now spans three packages. Inside the LLC,
  `StreamChatNetworkError` is caught by type in `retry_queue.dart`, `app_settings_manager.dart`,
  `websocket.dart:392` and across `channel.dart` / `channel_client_state.dart`'s optimistic-update
  rollbacks.
- **The silent-catch trap.** Because the type stays declared, `on StreamChatNetworkError catch`
  keeps compiling and quietly matches nothing. This is the one break a consumer can ship without
  noticing, in this phase and in their own code.
- **`StreamException` has no `stackTrace`, by design** — `ERROR_LAYER.md`: "a trace records the
  raise, not the failure." `StreamChatNetworkError` has one, plus
  `toString({bool printStackTrace})`. Traces now come from the carrier (`Failure.stackTrace`) or
  from the language at the throw site.
- **`RetryPolicy.shouldRetry` is public** and typed
  `FutureOr<bool> Function(StreamChatClient, int, StreamChatError?)`. Its third parameter becomes
  `StreamException?`, and `retry_queue.dart:85`'s `is! StreamChatError` guard changes with it.
- `StreamApiException.code` is **nullable** (null when no Stream payload reached us, e.g. a proxy's
  bare status), where `StreamChatNetworkError.code` was a non-null `int`. Every code read needs a
  null path.
- Consumers catch these in app code. The migration guide's Error Handling section has to be exactly
  right, and it is already written — extend it, don't contradict it.

## Upstream `stream_core` work

None.

## Definition of done

- [x] `chat_error_code.dart` and `stream_chat_dio_error.dart` deleted; `StreamChatNetworkError`
      deprecated with its `ChatErrorCode` constructor removed; `StreamChatError` and
      `StreamWebSocketError` kept (the WS layer still raises the latter until phase 07, and the UI
      package's attachment-validation errors subclass the former).
- [x] `ApiErrorInterceptor` installed, before the logging interceptor so a rejection is mapped
      before it is logged. `_parseError` delegates to `DioExceptionMapping.toStreamException()`,
      so all seven verb wrappers throw a `StreamChatException`.
- [x] `Result` and the core error kinds exported via the `show` allowlist, plus the
      `StreamChatException` alias. The `Success` collision is resolved by renaming `UploadState`'s
      variants.
- [x] `isRetriable` re-expressed chat-side over the sealed kinds, per `ERROR_LAYER.md` §Retrying,
      with a test per row of that table.
- [x] The 23 → 48 `requestTimeout` correction has its own CHANGELOG line.
- [x] `melos run analyze` clean across every package; `melos run format` clean. `stream_chat`
      1672 tests green, `stream_chat_flutter_core` 362, `stream_chat_flutter` 1302 (the 11 macOS
      golden failures are pre-existing — verified against a clean tree).
- [x] `migrations/v11-migration.md`: Symbol Map rows for every retyped symbol, plus new sections
      for endpoints that still throw, the silent-catch trap, and the retry change.
- [x] `🛑️ Breaking` CHANGELOG entries in all three packages.
- [ ] A test asserting a **malformed response body** yields a `StreamClientException` rather than a
      bare `TypeError`. `runApiSafely` guarantees it, but nothing in this package exercises that
      path yet — it needs a call through the generated client, which arrives with
      `openapi-migration` group 02.
- [ ] Status box updated in `README.md`.

### When `stream_chat_error.dart` goes

The file holds three things with three different lifetimes, so it empties in stages rather than
being deleted here:

| In the file | Last users | Goes when |
| --- | --- | --- |
| `StreamChatNetworkError`, `StreamChatNetworkErrorType` | nothing raises them; consumers may still name them | `openapi-migration` **group 12** lands and no endpoint can reach the hand-written verb facade |
| `StreamWebSocketError` | `websocket.dart` raises it, `client.dart:459` catches it | phase [07](07-websocket.md), where `DisconnectionSource.serverInitiated(error:)` replaces it |
| `StreamChatError` (the base) | 23 SDK precondition throws; `stream_chat_flutter`'s attachment-validation subtypes | two more pieces of work, below |

So the file is deletable once **four** things are true — three of them already scheduled, and one
that is not:

1. Group 12 removes `StreamChatNetworkError`.
2. Phase 07 removes `StreamWebSocketError`.
3. The 23 precondition throws are reclassified (see below).
4. **The attachment-validation errors stop being errors.** `StreamAttachmentValidator`'s own
   dartdoc says it best: "Both return `null` on success and a typed `StreamChatError` subtype on
   failure — neither ever throws." `AttachmentLimitReachedError`, `AttachmentTooLargeError` and
   `AttachmentBlockedError` are *returned values* that `StreamMessageComposer` pattern-matches to
   choose localized copy. They carry data (`maxCount`, `maxSize`, `fileExtension`) and are never
   raised, so they belong in a sealed result type of their own in `stream_chat_flutter` — not in
   an exception hierarchy in the low-level client. That is a UI-package change and does not need
   this plan.

Until then `StreamChatError` stays, undeprecated. Deprecating it now would put a warning on every
one of those legitimate uses.

### Carried out of this phase

- **The SDK's own precondition throws are untouched.** 23 sites still raise
  `StreamChatError` — "Chat persistence client is not set", "Connection already in progress",
  "Message not found", "Failed to upload one or more attachments". These are a different axis from
  request failures, and `ERROR_LAYER.md` splits them further: a condition a correct program can hit
  becomes a `StreamException`, while genuine misuse should raise `StateError`/`ArgumentError` and
  never be wrapped. Reclassifying them one by one is worth its own change; doing it by sed would
  get it wrong.
- **`StreamWebSocketError`** goes in phase [07](07-websocket.md), where
  `DisconnectionSource.serverInitiated(error:)` replaces it.
- **`StreamChatNetworkError`** is deleted when `openapi-migration` group 12 lands and nothing can
  reach the hand-written verb facade any more.
