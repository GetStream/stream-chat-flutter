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
107 call sites across 13 files in lib/src/core/api/
  54  client.post        15  client.delete       6  client.patch
  23  client.get          4  client.postFile     5  client.put
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

### The two statics

`StreamChatClient.additionalHeaders` and `defaultUserAgent` are both public mutable statics, so two
clients in one process share them. Retiring them needs a per-client `headers` parameter on
`StreamChatClient` to replace the former, and `defaultUserAgent` reads the static
`_systemEnvironmentManager`, so the two have to move together. That is an API addition rather than
an adoption, which is why they outlived this phase.

### `LoggingInterceptor`

A near-verbatim fork — same class name, same `InterceptStep` enum, same `LogPrint` typedef, same
pretty-printer — and **publicly exported** (`stream_chat.dart:34`). Adopting core's is breaking in
two ways: `logPrint` becomes optional, and output routes through `StreamLogger` instead of a
`Logger`. Sequence this with phase [06](06-logger.md) so consumers see one logging change, not
two.

## Decisions taken

- **`StreamHttpClient` stays, as the facade itself.** It was going to be replaced by a separate
  `@internal` wrapper, which turned out to be the same object under a new name: its verb wrappers
  *are* the facade, and it already owns option assembly. Core's `StreamCoreHttpClient` became the
  default `Dio` it builds instead. Making it `@internal` waits on
  `AttachmentFileUploaderProvider`, the only public signature naming it — phase
  [09](09-uploads.md).
- **`api_key` stays a query parameter**, so core's `ApiKeyInterceptor` is the one pipeline piece
  chat does not adopt. See below.
- **Six verbs are used; eight still exist.** `fetch` and `request` have no caller in `lib/` — only
  their own tests — but they were not removed. `StreamHttpClient` is still public, so dropping two
  methods is a break for no gain while the class is on its way to `@internal` anyway. They go with
  that move in [09](09-uploads.md). An earlier draft of this line claimed six had shipped; it had
  not, and the facade the api layer actually needs is the relevant number.

## Risks

- **`AttachmentFileUploaderProvider` is a documented public pluggability point** wired at
  `client.dart:102`. Its parameter type changes the moment `StreamHttpClient` goes. Anyone with a
  custom uploader breaks. Coordinate the retype with phase [09](09-uploads.md) rather than doing
  it twice.
- Interceptor order mistakes fail *sometimes* — a misplaced `ApiErrorInterceptor` still works
  until something rejects. **Pinned by a test now** (`stream_http_client_test.dart`, "interceptors
  are installed in the order the pipeline depends on"): the other interceptor tests only assert
  each type is *present*, which a reordered pipeline satisfies just as well. The order matters
  twice — anything rejecting ahead of `ApiErrorInterceptor` escapes as a raw `DioException`, and
  anything logging ahead of it logs the transport error rather than the mapped one.
- `dio` version skew: chat declares `^5.11.0`, core `^5.8.0+1`. Compatible today; worth pinning
  attention on when either moves.

## Upstream `stream_core` work

None, unless the `api_key` check concludes chat needs a query-parameter variant of
`ApiKeyInterceptor` — in which case that is a small, obviously-correct core addition.

## What landed, and what did not

**The verb facade held, which was the whole bet.** `git diff` over `lib/src/core/api/` is
**empty**: all 107 call sites across the 13 `*_api.dart` files are untouched, so phases 04–09 stay
independent of `openapi-migration`. (An earlier count said 115; that double-counted
`attachment_file_uploader.dart`.)

**Three interceptors became one.** Ours were forks of core's:

| Was | Now |
| --- | --- |
| `AdditionalHeadersInterceptor` (22) — user agent *and* the `additionalHeaders` static | core's `HeadersInterceptor` for the user agent; ours keeps only the static |
| `ConnectionIdInterceptor` (19) | core's, fed a closure over our `ConnectionIdManager` |
| `LoggingInterceptor` (**344**) | core's, re-exported from the barrel |

The pipeline is assembled with null-aware elements and `let`, so an absent dependency drops its
interceptor instead of guarding it:

```dart
const AdditionalHeadersInterceptor(),
?systemEnvironmentManager?.let(HeadersInterceptor.new),
?tokenManager?.let((it) => AuthInterceptor(httpClient, it, tag: '$streamChatLogTag:HttpAuth')),
?connectionIdManager?.let((it) => ConnectionIdInterceptor(() => it.connectionId)),
const ApiErrorInterceptor(),
```

`Standard.let` is core's. `ApiErrorInterceptor` sits before the logging interceptor so what gets
logged is the mapped failure rather than the raw transport one.

**`api_key` stays a query parameter.** Core's `ApiKeyInterceptor` sets a header, and the backend
appears to accept both — its own test harness sets a header
(`monolith/server/servercontext/dummy_auth.go:57`) while a WS test refers to the query parameter.
Changing a working wire contract for no benefit is not worth it, so core's interceptor is the one
piece of the pipeline chat does not adopt.

**Not landed: the two public statics.** `StreamChatClient.additionalHeaders` and `defaultUserAgent`
both survive. Retiring them needs a per-client `headers` parameter on `StreamChatClient` to replace
the former, and that is an API *addition* rather than an adoption — and `defaultUserAgent` reads
the static `_systemEnvironmentManager`, so it has to move at the same time.
[`UPSTREAM.md`](UPSTREAM.md) records why the interceptor that reads the static should be deleted
rather than moved to core.

## Definition of done

- [x] **Every call site in the 13 `*_api.dart` files is unchanged** — an empty diff over that
      directory, which is the test of whether the facade held.
- [x] Our `connection_id_interceptor.dart` and `logging_interceptor.dart` are deleted;
      `additional_headers_interceptor.dart` keeps only the job core has no concept of.
- [x] The pipeline is assembled in one place, with `ApiErrorInterceptor` ahead of logging.
- [x] `api_key` placement decided and recorded above.
- [x] Interceptor coverage kept: the connection-id test is retargeted at core's type through our
      closure, and a `HeadersInterceptor` group is added — core ships both interceptors with **no**
      tests of its own ([`UPSTREAM.md`](UPSTREAM.md)).
- [x] The pipeline **order** is asserted, not just each interceptor's presence. Verified to fail on
      a swap rather than only to pass as written.
- [x] `melos run analyze` and `melos run format` clean; `stream_chat` 1670 tests green.
- [x] `🛑️ Breaking` CHANGELOG entry for `LoggingInterceptor`.
- [ ] `StreamHttpClient` itself is still ours — it *is* the verb facade. It becomes `@internal`
      when `AttachmentFileUploaderProvider` is retyped in [09](09-uploads.md), which is the only
      public signature naming it.
- [ ] `additionalHeaders` / `defaultUserAgent` statics retired — needs the per-client `headers`
      parameter described above.
- [ ] One real request against a live app key, not only against mocks.
- [ ] Status box updated in `README.md`.
- [ ] Public dartdoc follows [`STYLE_GUIDE.md` § Documentation](../STYLE_GUIDE.md#documentation)
      and [`EFFECTIVE_DART_DOC.md`](../EFFECTIVE_DART_DOC.md), including on symbols this phase
      retyped but whose docs it left alone.
- [ ] Tests follow [`TESTING.md`](../TESTING.md): no `group` organizing a file by method, each
      name states its subject and behaviour.
