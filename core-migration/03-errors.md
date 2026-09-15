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
| `lib/src/core/error/stream_chat_error.dart` (223) — `StreamChatError`, `StreamChatNetworkError`, `StreamChatNetworkErrorType`, `StreamWebSocketError` | `stream_core` `errors/stream_exception.dart` — `sealed StreamException` → `StreamApiException`, `StreamNetworkException`, `StreamAuthenticationException`, `StreamClientException` |
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

**`StreamChatError` is *not* aliased onto it.** An earlier draft suggested
`@Deprecated typedef StreamChatError = StreamException;`. That was wrong for a reason worth
keeping: the class was a base for two unrelated things — request failures, and *returned* values
that never get thrown (`stream_chat_flutter`'s three attachment-validation errors). An alias would
have flattened that distinction instead of forcing it. Both were separated and the class deleted;
see [`stream_chat_error.dart` is gone](#stream_chat_errordart-is-gone).

Export the alias from `lib/stream_chat.dart` alongside the allowlist below.

Feeds adds **nothing else** to the hierarchy — zero classes in `stream_feeds/lib` extend or
implement a `StreamException`. Match that: the alias is the whole product-side error surface
unless a specific case proves otherwise.

### Install `ApiErrorInterceptor`

It is **not installed anywhere in chat today.** That is why a call through the generated client
currently hands back a `Failure` carrying a raw `DioException`: `DefaultApi` goes straight to
`_dio.fetch` and bypasses `StreamHttpClient._parseError`, which only its own verb wrappers call.

Install it **after every interceptor that can reject**, so it sees the rejection on the way out —
in practice that means after auth and connection-id, and *before* the logging interceptor, so what
gets logged is the mapped `StreamException` rather than a raw `DioException`. It is therefore not
literally last: user-supplied interceptors and the default logger follow it. With it in place the
guarantee holds: `runApiSafely` — already used by `default_api.dart:783` — maps a `DioException`
through `toStreamException()`, passes a `StreamException` through unchanged, and wraps everything else,
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

**The `Success` collision had to be resolved first.** Chat's `UploadState` is a `@freezed sealed`
union whose success variant was a class named `Success`, and it is exported. The options were to
rename it (breaking, and phase [09](09-uploads.md) touches `UploadState` anyway) or to withhold
core's `Success` from the allowlist and document `Result` pattern-matching through `switch` on the
sealed type. It was renamed — see [the name to avoid](#the-success-collision-and-the-name-to-avoid).

### Keep the hand-written API layer throwing

`StreamHttpClient`'s verb wrappers keep throwing — they just throw a `StreamException` now instead
of a `StreamChatNetworkError`. This is deliberate and it is what keeps this plan independent of
`openapi-migration`: each of that plan's 12 feature groups converts its own methods to
`Future<Result<T>>` when it migrates, and until then nothing above the api layer changes shape.

The break was already promised in `migrations/v11-migration.md`'s Symbol Map, so this phase mostly
delivers what that guide advertised. It did add rows, for the symbols the guide had not
anticipated being deleted outright: `StreamChatError`, `StreamWebSocketError`, `isRetriable`, and
the attachment-validation retype.

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

It lived on both `StreamChatNetworkError` and `StreamWebSocketError` (`data == null`) and drives
`RetryQueue` via `RetryPolicy.shouldRetry`. Core has nothing equivalent — its
`DisconnectionSource.isReconnectable` is transport-level policy for the socket, not for a request.
It is now a chat-side extension over the core kinds. `ERROR_LAYER.md` is explicit that
retryability is the caller's policy, so this is the intended shape, not a workaround.

### The two types with no direct analogue

- **Lossy.** `StreamChatNetworkErrorType` mirrored `DioExceptionType` with 9 values.
  `StreamNetworkException` has `isCancelled` / `isTimeout` / `closeCode`, so `sendTimeout`,
  `receiveTimeout` and `connectionTimeout` all collapse into one `isTimeout`.
- **Not lossy, just relocated.** `StreamWebSocketError` is **deleted in this phase**, not carried
  forward. It was originally scheduled for phase [07](07-websocket.md) on the assumption that only the new
  transport could replace it, but the socket path maps onto core's kinds without touching the
  transport at all: a frame carrying an `error` object becomes a `StreamApiException`, and a
  failure raised by the channel itself becomes whatever `StreamException.tryFrom` recovers, or a
  `StreamNetworkException` when the outcome of the connection is unknown. Phase 07 still replaces
  the transport; it no longer inherits an error type to clean up.

  The `error` object is the server's `APIError` verbatim, so it parses as a `StreamApiError` with
  no massaging — see below.

### The WS error frame is a full `APIError`

Worth writing down because the obvious assumption is wrong: a frame off the socket looks nothing
like an HTTP response, so `StreamApiError.statusCode` (required, non-nullable) reads like a field
the server cannot supply. It always does.

Both emitters — `monolith/engine/websocket/conn.go` `CloseWithError` and `monolith/server/ws/server.go`
— marshal `event.NewConnectionErrorEvent(*apiErr)`, whose `error` field is a full `errors.APIError`.
`CloseWithError` guarantees a non-nil one: a cause that is not an `*APIError` is replaced with
`InternalSystemError` (500). `StatusCode` carries no `omitempty`, `APIError` has no custom
marshaller, and neither the V1 nor the V2 encode option set can drop a zero field — they only
handle tag-ignored fields, null slices/maps, extra fields and time format. So `code`, `message`
and `StatusCode` are always on the wire.

This matters because it is easy to "fix" in the wrong direction. Seeding a default
(`{...errorResponse}..['StatusCode'] ??= 0`) makes an under-specified *test fixture* parse and
then reads, in the source, as a claim about the server. Core makes the same distinction
deliberately: `duration` and `moreInfo` get `@JsonKey(defaultValue: '')` because they genuinely
can be absent, while `message` and `statusCode` get no default. Build the fixture the way the
server sends it instead.

One loose end, checked and closed: `_onDataReceived` reads `jsonData['error']` as a map on *any*
frame, not just `connection.error`, and the `export.*.error` events register under
`openapi.ProductChat` with `error` typed as a **string** — which would be a `TypeError` inside the
socket callback. They cannot reach one: they are built with `NewEventWithoutUserID`, so there is no
user to route them to, and a client socket is user-scoped. Pre-existing either way, and unrelated
to how the error object is parsed.

`ErrorResponse` is now redundant and should go when something forces the issue. Its four fields
(`code`, `message`, `StatusCode`, `moreInfo`) are a strict subset of `StreamApiError`, which adds
`details`, `duration`, `exceptionFields` and `unrecoverable` — and `websocket_test.dart` builds an
`ErrorResponse` for the sole purpose of being parsed back as a `StreamApiError`. It survives only
because `responses.dart` is generated-adjacent and nothing in `lib/` reads it any more.

## Decisions taken

1. **Retry policy adopts core's table** (`ERROR_LAYER.md` §Retrying) rather than preserving v10
   behaviour. The old predicate was `isRetriable => data == null` — it retried only when the
   response carried *no* parseable Stream error payload, so a 500 or a 429 never retried a failed
   message. The new one retries network failures (unless cancelled), 5xx, 429 and 408, and never
   other 4xx, auth failures, client failures, or anything the server flagged `unrecoverable`.
   Two token cases do not follow from the status alone and are decided by name: a token that is
   *not yet valid* retries, because that is clock skew on `nbf`/`iat` healing itself and a fresh
   token from the same skewed clock would not help; an *expired* one does not, because a refresh
   already failed to fix it. **This changes runtime behaviour** and gets its own CHANGELOG line.
2. **`StreamChatNetworkError` is deleted, not deprecated** — reversed during the phase. The
   original reasoning was that it had to survive until `openapi-migration` group 12 moved the last
   endpoint off the hand-written verb facade. That confused *who throws it* with *who names it*:
   once the facade threw a `StreamException`, nothing in `lib/` raised or caught the old type, so
   there was nothing for group 12 to release. Deprecating it would have been actively worse than
   deleting it — nothing throws it, so `on StreamChatNetworkError catch` keeps compiling and
   silently matches nothing, which is a break a consumer ships without noticing. Deleting it makes
   that a compile error. The migration guide says so in those words.
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
`Result` `Success<T>`. Before this phase there were **13 `hide Success` import clauses** in this
repo working around the first two; renaming took it to 5.

Chat's four variants are now `UploadStatePreparing`, `UploadStateInProgress`,
`UploadStateSuccess`, `UploadStateFailed`.

**Do not name them `UploadPreparing` / `UploadInProgress` / `UploadSuccess` / `UploadFailed`,**
tempting as the symmetry is: those are exactly core's `AttachmentUploadState` variant names, and
phase [09](09-uploads.md) puts core's union in scope *alongside* chat's — which stays on
`Attachment` for Drift. Matching core's names now just moves the collision into phase 09.

## Downstream: the Flutter packages

The original scope note undercounted this badly. `StreamChatError` was not confined to the LLC —
it ran through `stream_chat_flutter_core`'s **public** API:

| Surface | Where | Public |
| --- | --- | --- |
| `PagedValue.error(StreamChatError)`, plus the generated `when` / `map` / `maybeWhen` signatures | `paged_value_notifier.dart` | yes — backs every list controller |
| `errorBuilder: Widget Function(BuildContext, StreamChatError)` | `paged_value_scroll_view.dart` (×2) | yes — widget API |
| `on StreamChatError catch` followed by `StreamChatError(error.toString())` | 9 list controllers, two sites each, plus one in `search_debounce_mixin.dart` | internal |

Counted before the change: **205 `lib` references and 230 `test` references across three
packages**, not one. `stream_chat_persistence` had zero and is untouched.

All of it was retyped to `StreamChatException` here. The controllers had been wrapping non-chat
errors as `StreamChatError(error.toString())`, so those sites became `on StreamChatException catch`
with the wrap rewritten as `StreamClientException(message: 'Failed to load channels', cause: error)`
— the message names the load, and the original throwable survives as `cause`, where stringifying it
into the message was losing it.

## Risks

- **The widest blast radius in the plan**, and it spans three packages. Inside the LLC,
  `StreamChatNetworkError` was caught by type in `retry_queue.dart`, `app_settings_manager.dart`,
  `websocket.dart` and across `channel.dart` / `channel_client_state.dart`'s optimistic-update
  rollbacks — every one of which had to be found by grep, not by a failing test. See
  [Found after the fact](#found-after-the-fact).
- **The silent-catch trap — avoided here, still live for consumers.** A *deprecated*
  `on StreamChatNetworkError catch` keeps compiling and quietly matches nothing, which is the one
  break a consumer can ship without noticing. Deleting the type is what turns it into a compile
  error. The same trap applies to any `catch` clause in *their* code naming a type we retyped
  rather than removed.
- **`StreamException` has no `stackTrace`, by design** — `ERROR_LAYER.md`: "a trace records the
  raise, not the failure." `StreamChatNetworkError` has one, plus
  `toString({bool printStackTrace})`. Traces now come from the carrier (`Failure.stackTrace`) or
  from the language at the throw site.
- **`RetryPolicy.shouldRetry` is public** and was typed
  `FutureOr<bool> Function(StreamChatClient, int, StreamChatError?)`. Its third parameter is now
  `StreamChatException?`, and `retry_queue.dart`'s guard reads `error is! StreamChatException`.
- `StreamApiException.code` is **nullable** (null when no Stream payload reached us, e.g. a proxy's
  bare status), where `StreamChatNetworkError.code` was a non-null `int`. Every code read needs a
  null path.
- Consumers catch these in app code. The migration guide's Error Handling section has to be exactly
  right, and it is already written — extend it, don't contradict it.

## Upstream `stream_core` work

None.

## Definition of done

- [x] `chat_error_code.dart`, `stream_chat_dio_error.dart`, `stream_chat_error.dart` and the
      `error.dart` barrel deleted. `StreamChatError`, `StreamChatNetworkError`,
      `StreamChatNetworkErrorType` and `StreamWebSocketError` are gone with them; the UI package's
      attachment-validation errors moved to their own sealed family.
- [x] `ApiErrorInterceptor` installed, before the logging interceptor so a rejection is mapped
      before it is logged. `_parseError` delegates to `DioExceptionMapping.toStreamException()`,
      so all eight verb wrappers throw a `StreamChatException`.
- [x] `Result` and the core error kinds exported via the `show` allowlist, plus the
      `StreamChatException` alias. The `Success` collision is resolved by renaming `UploadState`'s
      variants.
- [x] `isRetriable` re-expressed chat-side over the sealed kinds, per `ERROR_LAYER.md` §Retrying,
      with a test per row of that table.
- [x] The 23 → 48 `requestTimeout` correction has its own CHANGELOG line.
- [x] `melos run analyze` clean across every package; `melos run format` clean; the non-golden
      suites green in all three packages. (Goldens are not a local signal — alchemist compares
      against CI-rendered images in CI and platform ones locally.)
- [x] `migrations/v11-migration.md`: Symbol Map rows for every retyped and every deleted symbol,
      plus new sections for endpoints that still throw, why the old types were deleted rather than
      deprecated, and the retry change.
- [x] `🛑️ Breaking` CHANGELOG entries in all three packages.
- [x] Status box updated in `README.md`.

A test asserting a **malformed response body** yields a `StreamClientException` rather than a bare
`TypeError` is *not* a condition of this phase. `runApiSafely` guarantees it and lives in
`lib/open_api/api/default_api.dart`, which nothing under `lib/src` calls, so the path cannot be
exercised until `openapi-migration` group 02 lands. It is owned by
[DEFERRED.md](DEFERRED.md), which carries it against this phase.

### `stream_chat_error.dart` is gone

This was planned as a staged emptying — the file held three things with three different
lifetimes, and two of them looked like they belonged to later phases. It was deleted outright
instead, along with the `error.dart` barrel, because each of the supposed blockers dissolved on
contact:

| In the file | Planned exit | What actually happened |
| --- | --- | --- |
| `StreamChatNetworkError`, `StreamChatNetworkErrorType` | wait for `openapi-migration` group 12 | nothing in `lib/` raised or caught it once the verb facade threw `StreamException`, so there was nothing to wait for |
| `StreamWebSocketError` | wait for phase 07's new transport | the socket path maps onto core's kinds without replacing the transport (see above) |
| `StreamChatError` (the base) | 19 precondition throws + 3 attachment-validation subtypes | throws retyped to `StreamClientException`; the attachment errors became their own sealed family |

The attachment errors are the one that needed a decision rather than a mechanical edit.
`StreamAttachmentValidator`'s dartdoc had already noticed the smell — "Both return `null` on
success and a typed subtype on failure — neither ever throws." They are *returned values* that
`StreamMessageComposer` pattern-matches to choose localized copy, and they carry data
(`maxCount`, `maxSize`, `fileExtension`). So they are now a sealed `AttachmentValidationError`
family in `stream_chat_flutter`, deliberately **not** extending one of core's kinds: nothing
failed, an attachment was refused, and typing a refusal as a transport or client exception invites
callers to treat it as one.

### Found after the fact

Retyping the errors was done, but five `is` checks on the old type were not, and they were not
the kind a test catches: `channel.dart` gated four `scheduleRetry` calls and `client.dart` gated
the `sync` 400 recovery on `e is StreamChatNetworkError`. Nothing raises that type any more, so
every branch was unreachable — a failed message was never queued for retry, and an app with a
stale `last_sync_at` could not heal. `isRetriable` itself was correct and covered a row at a
time; only the callers were missed.

Five cases hid it rather than catching it, in two patterns. Four named "should add message to
retry queue on a retriable failure" throw a 403, which is not retriable, and assert message state
rather than the queue — so they passed whether or not the queue was reached. The fifth,
`should flush persistence client on 400 error`, constructed a `StreamChatNetworkError` the SDK
cannot produce, so it exercised a dead branch.

The WS error fixture gave the same lesson from the other direction (above): **a fixture that does
not parse is evidence about the fixture until the wire format says otherwise.**

The lesson generalises to every phase that retypes something: grep for `is OldType` and
`on OldType catch` across all packages, and treat a test that constructs the old type as
evidence the test is stale rather than evidence the path works.

### Carried out of this phase

- **The misuse-vs-failure split.** The 19 precondition throws were retyped to
  `StreamClientException` mechanically, which is right for most of them but not all.
  `ERROR_LAYER.md` splits the axis further: a condition a correct program can hit becomes a
  `StreamException`, while genuine misuse should raise `StateError`/`ArgumentError` and never be
  wrapped. "Connection already in progress" and "You cannot use `queryChannels` without an active
  connection" read as the second kind. Reclassifying them one by one is worth its own change;
  doing it by sed would get it wrong.
