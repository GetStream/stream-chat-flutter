# 01 — Foundation

**Goal:** land everything that every feature group depends on, so no group has to invent it. Nothing user-visible
migrates in this phase.

Feature groups can run in parallel once this is done. Until it is, they will each reinvent the same four things
differently.

## Scope

### 1. The `Result` surface

Public API methods return `Future<Result<T>>` instead of throwing, matching `stream_feeds`.

- Re-export from `lib/stream_chat.dart` with a `show` allowlist:
  `show Result, Success, Failure, StreamException, StreamApiException, StreamNetworkException,
  StreamAuthenticationException, StreamClientException, StreamApiError, StreamErrorCode`.
- **Not** a wholesale `export 'package:stream_core/stream_core.dart';` — core re-exports all of dio plus its own
  `AttachmentFile`, which collides by name with the `AttachmentFile` our barrel already exports.

### 2. Errors come from `stream_core`

`stream_core`'s error layer is a sealed `StreamException` family, so `Failure.error` is always one of four things
and never a transport type:

```text
StreamApiException            statusCode, code (StreamErrorCode), moreInfo, unrecoverable, retryAfter, apiError
StreamNetworkException        isCancelled, isTimeout, closeCode
StreamAuthenticationException
StreamClientException         our own bug, or a body that would not decode (original kept as `cause`)
```

Two pieces make that guarantee, and both are prerequisites rather than things this repo writes:

- **`runApiSafely`** (core) is what the generated client's call adapter must use. It maps a `DioException` through
  `toStreamException()`, keeps a `StreamException` as raised, and wraps everything else — including the `TypeError`
  from an undecodable response body — in a `StreamClientException`. The older `runSafely` did none of this.
- **`ApiErrorInterceptor`** on the Dio behind `DefaultApi`, as before.

There is no error-translation layer. Do not map to `StreamChatNetworkError` — that is the hand-written layer this
migration exists to delete.

**`ChatErrorCode` is superseded.** Core ships `StreamErrorCode`, an `extension type const StreamErrorCode(int)
implements int` with named constants, plus `isRetriable` and `RetryPolicy`. Drop our 25-entry enum rather than
re-expressing it; check `StreamErrorCode` before adding a constant anywhere.

This resolves what was previously an open question here (`StreamDioException` versus `HttpClientException`): both
are gone. `client_exception.dart` was deleted in core's error-layer rework, and the answer is the sealed
`StreamException` — flat, dio-free, and the direct analogue of iOS's `ClientError` and Android's
`Error.NetworkError`.

**Sequencing.** The error layer lives on core's `feat/error-layer` branch and is not on `main` yet, so our pinned
ref (`f83b5d4`) does not have it. Order: core's branch merges → core releases → we move the pin (and the pin
collapses to a hosted constraint) → the generator's `client.tpl` switches `runSafely` → `runApiSafely` → we
regenerate. Until the template changes, a regenerated client still hands back raw `DioException`s.

### 3. Where `DefaultApi` is constructed

`DefaultApi(Dio)` needs a Dio. `StreamHttpClient.httpClient` is `@visibleForTesting` and `StreamHttpClient` is
publicly exported, so `DefaultApi(client.httpClient)` fails `melos run analyze` with
`invalid_use_of_visible_for_testing_member`. Pick one and apply it everywhere:

- an `@internal` accessor on `StreamHttpClient`, or
- build `DefaultApi` once in `StreamChatApi` and inject it into each `*_api.dart`.

### 4. Freeze the `User` shape decision

`User` and `OwnUser` are embedded in nearly every response in the SDK, so the keep-vs-adopt decision cannot wait
for group 09 — a poll vote, a channel member and a message all carry a user. Decide it here, write it down, and
let group 09 merely execute it.

The same applies, in a smaller way, to the channel shape embedded in threads (group 07) versus the channels group
(group 11).

## Decisions to make

- Which of the four items above are one PR and which are separate. The `Result` surface is mechanical but touches
  every public signature; the interceptor and `DefaultApi` wiring are small and internal.
- Whether `StreamChatNetworkError` is deprecated or deleted in v11. It must survive the transition because every
  unmigrated endpoint still throws it, but it becomes dead code once the last group lands.

## Risks

- The `Result` surface is the single largest breaking change in v11 and cannot be done per-feature without leaving
  the public API in two styles at once. Sequence it deliberately.
- `stream_chat` cannot be published while `stream_core` is a git dependency, and the generated client needs
  `StreamDateTimeConverter`, which is not in the last published `stream_core`. **A `stream_core` release is a
  prerequisite for shipping any of this** — see the `openapi-codegen` skill.

## Definition of done

- [ ] `Result` and the core error types are exported from `lib/stream_chat.dart` via a `show` allowlist.
- [ ] `ApiErrorInterceptor` is installed on the Dio backing `DefaultApi`, and the call adapter uses
      `runApiSafely`; a test asserts a failed call yields a `Failure` carrying a `StreamApiException` with a
      parsed `.apiError`, and a malformed body yields a `StreamClientException`.
- [ ] `DefaultApi` construction is settled in one place, with no `invalid_use_of_visible_for_testing_member`.
- [ ] The `User` / `OwnUser` decision is written into `09-users.md`.
- [ ] `migrations/v11-migration.md` Error Handling section matches what actually shipped.
- [ ] `melos run analyze` clean, `melos run test:dart` green.
