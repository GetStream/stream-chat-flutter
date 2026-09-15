# 05 — HTTP client & interceptor pipeline

**Goal:** replace `StreamHttpClient` with core's `StreamCoreHttpClient` and assemble the
interceptor pipeline once, in the order feeds already runs in production.

**Size:** ~600 chat LOC deleted (288 client + ~310 interceptors) against ~150 core LOC. Breaking
on two public types.

## Scope

| Delete | Adopt |
| --- | --- |
| `lib/src/core/http/stream_http_client.dart` (288) | `stream_core` `api/stream_core_http_client.dart` (26) |
| `lib/src/core/http/interceptor/additional_headers_interceptor.dart` (22) | `stream_core` `api/interceptors/headers_interceptor.dart` (21) |
| `lib/src/core/http/interceptor/connection_id_interceptor.dart` (19) | `stream_core` `api/interceptors/connection_id_interceptor.dart` (26) |
| `lib/src/core/http/interceptor/logging_interceptor.dart` (344) | `stream_core` `api/interceptors/logging_interceptor.dart` (388) |
| — | `stream_core` `api/interceptors/api_key_interceptor.dart` (new to chat) |

Core's `StreamCoreHttpClient` is an `extension type const ... implements Dio`, so it **is** a Dio
— no wrapper, no verb methods, no error parsing. That is the whole difference: ours is a facade
with eight verb wrappers that catch `DioException` and throw; core's hands you the Dio and lets
`ApiErrorInterceptor` + `runApiSafely` do the classification.

### The `@internal` verb facade — the load-bearing decision

Everything in phases 04–09 assumes the 13 hand-written `*_api.dart` files are untouched. Keeping a
thin `@internal` facade over the Dio — same signatures, now throwing `StreamException` after phase
[03](03-errors.md) — is what makes that true, and it is what keeps this plan independent of
`openapi-migration` progress. Without it, every phase after 03 acquires a dependency on an
out-of-scope plan.

**Verified before writing this file, and the risk is small:**

```
115 call sites across 13 files in lib/src/core/api/
  54  client.post        19  client.delete       6  client.patch
  23  client.get          8  client.postFile     5  client.put
   0  client.fetch        0  client.request
```

So the facade needs exactly **six** methods, not eight. `fetch` has one caller in the whole
package — `auth_interceptor.dart:64`, which phase [04](04-token-and-auth.md) deletes — and
`request` has none.

`postFile` is the only non-trivial one: it wraps its `MultipartFile` in
`FormData.fromMap({'file': file})` and delegates to `post`, carrying `onSendProgress` /
`onReceiveProgress` / `cancelToken`. Preserve it as-is; phase [09](09-uploads.md) decides its
future.

The facade is deleted when `openapi-migration` finishes. It also settles that plan's open question
about where `DefaultApi` is constructed — built once in `StreamChatApi` and injected, which
sidesteps the `invalid_use_of_visible_for_testing_member` problem it describes.

### Pipeline assembly

Assemble once, in `StreamChatApi`, in feeds' verified order — the order is load-bearing:

```dart
StreamCoreHttpClient(
  options: BaseOptions(
    baseUrl: ...,                 // chat's default stays chat's default
    connectTimeout: ...,
    receiveTimeout: ...,
    headers: customHeaders,       // as Dio *defaults*, so SDK interceptors always win
  ),
)..interceptors.addAll([
  ApiKeyInterceptor(apiKey),
  HeadersInterceptor(systemEnvironmentManager),
  AuthInterceptor(client, tokenManager, tag: 'SCh:HttpAuth'),
  ConnectionIdInterceptor(connectionIdGetter),
  const ApiErrorInterceptor(),
  LoggingInterceptor(requestHeader: true, tag: 'SCh:Http'),
]);
```

Passing user headers as `BaseOptions.headers` rather than through an interceptor is deliberate in
feeds: Dio's header map is case-insensitive, so a user-supplied `authorization` in the wrong case
would otherwise clobber ours. As defaults, the interceptors always win.

`ConnectionIdInterceptor` takes a `ConnectionIdGetter` (`String? Function()`). Feed it from our
`ConnectionIdManager`, which stays — see the README's "What stays ours": connection-id is threaded
into request *semantics* at `client.dart:774`, `:907` and `:1071`, not just into headers.

Install it unconditionally rather than behind a `user.type` check. The pipeline is built once, at
construction, and the same client later moves between anonymous, guest and authenticated
identities — a construction-time check would leave an authenticated connection without a
`connection_id`. The getter answers `null` until there is a connection id to send, which is the
only gate needed.

`ApiErrorInterceptor` comes last of the interceptors that *produce* errors, not last overall:
`LoggingInterceptor` sits after it so the log line carries the converted `StreamApiException`
rather than the raw `DioException`.

### Two things to settle on the wire

- **`api_key` placement.** Core's `ApiKeyInterceptor` sets it as a **header**; chat sets it as a
  **query parameter** in `StreamHttpClient`'s constructor. Verify the server accepts the header
  form for chat endpoints before switching. If it doesn't, keep the query parameter and don't use
  core's interceptor — that is a legitimate outcome, not a failure.
- **`StreamChatClient.additionalHeaders` is a static mutable global** read by
  `AdditionalHeadersInterceptor`. Core has no such concept and shouldn't. Replace it with
  per-client headers on `BaseOptions`, and deprecate the static — two clients in one process
  currently share it, which is a bug.

### `LoggingInterceptor`

A near-verbatim fork — same class name, same `InterceptStep` enum, same `LogPrint` typedef, same
pretty-printer — and **publicly exported** (`stream_chat.dart:34`). Adopting core's is breaking in
two ways: `logPrint` becomes optional, and output routes through `StreamLogger` instead of a
`Logger`. Sequence this with phase [06](06-logger.md) so consumers see one logging change, not
two.

## Decisions to make

- Whether the facade is a class (`@internal class StreamChatHttpClient`) or a set of extension
  methods on `Dio`. An extension reads better at call sites and cannot be constructed wrongly; a
  class is easier to delete later.
- `api_key` header vs query parameter, from the check above.
- Whether `StreamHttpClient` and `StreamHttpClientOptions` are deprecated forwarders or deleted.
  `StreamHttpClient` appears in the public signature of `AttachmentFileUploaderProvider`
  (`AttachmentFileUploader Function(StreamHttpClient)`), so its removal is also a phase-09 change
   — deprecate here, delete there.

## Risks

- **`AttachmentFileUploaderProvider` is a documented public pluggability point** wired at
  `client.dart:102`. Its parameter type changes the moment `StreamHttpClient` goes. Anyone with a
  custom uploader breaks. Coordinate the retype with phase [09](09-uploads.md) rather than doing
  it twice.
- Interceptor order mistakes fail *sometimes* — a misplaced `ApiErrorInterceptor` still works
  until something rejects. Assert the order in a test rather than trusting the code reads right.
- `dio` version skew: chat declares `^5.11.0`, core `^5.8.0+1`. Compatible today; worth pinning
  attention on when either moves.

## Upstream `stream_core` work

None, unless the `api_key` check concludes chat needs a query-parameter variant of
`ApiKeyInterceptor` — in which case that is a small, obviously-correct core addition.

## Definition of done

- [ ] **Every one of the 115 call sites in the 13 `*_api.dart` files is unchanged.** That is the
      test of whether the facade held. A diff touching them means the facade is wrong.
- [ ] `stream_http_client.dart` and our three forked interceptors are deleted.
- [ ] The pipeline is assembled in exactly one place, and a test asserts the interceptor order —
      including that `ApiErrorInterceptor` precedes `LoggingInterceptor`.
- [ ] `api_key` placement verified against the live API, with the result recorded here.
- [ ] `additionalHeaders` static deprecated; a test asserts two clients can carry different
      headers.
- [ ] One real request run against a live app key, not only against mocks.
- [ ] `melos bootstrap && melos run analyze && melos run test:dart && melos run test:flutter`.
- [ ] `refactor(llc)!:` title, `🛑️ Breaking` CHANGELOG entries, `migrations/v11-migration.md`
      rows for `StreamHttpClient`, `LoggingInterceptor` and `additionalHeaders`.
- [ ] Decisions recorded here, status box ticked in `README.md`.
