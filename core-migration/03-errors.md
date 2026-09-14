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
- **It gives the old name somewhere to land.** `StreamChatError` was our root; aliasing the new
  root under a recognisably chat-shaped name is the smallest possible conceptual move for a
  consumer, and `@Deprecated('Use StreamChatException') typedef StreamChatError = StreamException;`
  is a legitimate one-line soft landing for the rename (unlike `StreamChatNetworkError`, which was
  a *kind* and maps to `StreamApiException`, not to the root).

Export it from `lib/stream_chat.dart` alongside the allowlist below. Prefer it in chat's own
dartdoc so the public docs read in chat's vocabulary; the four kinds keep their core names, since
those are what a `switch` matches on and renaming them would break the shared-handler property.

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

## Decisions to make

- The `Success` collision: rename `UploadState.success`'s class, or don't export core's `Success`.
- Whether `StreamChatNetworkError` is **deprecated** or **deleted** in v11. It must survive this
  phase because every unmigrated endpoint still throws it, and it becomes dead code only when
  `openapi-migration` group 12 lands. Deprecating it now and deleting it there is the honest
  sequencing.
- Whether `ChatErrorCode` ships as a deprecated forwarder onto `StreamErrorCode` (possible for the
  ~22 codes whose values match) or is deleted outright. The three bad codes cannot forward.

## Risks

- **This is the break with the widest blast radius.** `StreamChatNetworkError` is caught by type
  in `retry_queue.dart`, `app_settings_manager.dart`, `websocket.dart:392` and across
  `channel.dart` / `channel_client_state.dart`'s optimistic-update rollbacks. Every one of those
  sites changes.
- Consumers catch `StreamChatNetworkError` in app code. This is the single most-visible v11 change
  and the migration guide's Error Handling section has to be exactly right.

## Upstream `stream_core` work

None.

## Definition of done

- [ ] `core/error/` deleted except whatever `StreamWebSocketError` needs to survive until 07.
- [ ] `core/http/stream_chat_dio_error.dart` deleted — its payload becomes a `StreamException`
      here, so core's `StreamDioException` carries it from this phase on. Deferred from
      [01](01-utilities.md).
- [ ] `ApiErrorInterceptor` installed last in the pipeline.
- [ ] A test asserts a failed call yields a `Failure` carrying a `StreamApiException` with a
      parsed `.apiError`, and that a malformed response body yields a `StreamClientException`
      rather than a bare `TypeError`.
- [ ] `Result` and the core error types are exported via the `show` allowlist; the `Success`
      collision is resolved.
- [ ] `isRetriable` re-expressed chat-side; `RetryQueue` and `RetryPolicy` behave identically —
      a test pins that a 5xx retries and a 4xx does not.
- [ ] The 23 → 48 `requestTimeout` correction has its own CHANGELOG line.
- [ ] `melos bootstrap && melos run analyze && melos run test:dart && melos run test:flutter`.
      Note `analysis_options.yaml` excludes `**/*.g.dart` and `**/*.freezed.dart` repo-wide, so
      `default_api.g.dart` and ~490 generated `.freezed.dart` files are never analyzed —
      exercising them in a test is what compiles them.
- [ ] `migrations/v11-migration.md` Error Handling section matches what shipped, including the two
      lossy conversions.
- [ ] `refactor(llc)!:` title, `🛑️ Breaking` CHANGELOG entries.
- [ ] Decisions recorded here, status box ticked in `README.md`.
