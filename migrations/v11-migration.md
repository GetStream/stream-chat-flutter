# Stream Chat Flutter SDK v11.0.0 Migration Guide

This guide covers the breaking changes in **Stream Chat Flutter SDK v11.0.0**, where the low-level client moves
onto Stream's OpenAPI-generated API client.

> **Status: in progress.** The version number is provisional until release. This guide is written *as the
> migration happens* — every PR that lands a breaking change appends its entry here, so the guide is complete on
> release day rather than reconstructed from a changelog afterwards. If you are landing such a PR, see
> [Contributing to this guide](#contributing-to-this-guide).

---

## Table of Contents

- [Who Should Read This](#who-should-read-this)
- [What Changed and Why](#what-changed-and-why)
- [Quick Reference](#quick-reference)
- [Symbol Map](#symbol-map)
- [Error Handling](#error-handling)
    - [The error type changed too](#the-error-type-changed-too)
- [Feature Areas](#feature-areas)
- [Migration Checklist](#migration-checklist)
- [For AI Agents](#for-ai-agents)
- [Contributing to this guide](#contributing-to-this-guide)

---

## Who Should Read This

| Upgrading From | Sections to Review |
| --- | --- |
| v10.x, using `StreamChatClient` / `Channel` directly | All of it — the API-facing types are what changed |
| v10.x, UI widgets only (`stream_chat_flutter`) | [Error Handling](#error-handling) and any [Feature Area](#feature-areas) whose models you read from `Message`, `Channel`, or `User` |
| v10.x, with a custom `AttachmentFileUploader` | [Feature Areas](#feature-areas) → File Upload |
| A v11 beta | [Symbol Map](#symbol-map) only — entries are additive across betas |

---

## What Changed and Why

The `stream_chat` package now talks to Stream's API through a client generated from the same OpenAPI spec that
backs our other SDKs, instead of a hand-written HTTP layer. For you this means:

- **Consistent shapes across Stream products.** A response type in Flutter now matches its counterpart in our
  other SDKs, because both come from one spec.
- **New API surface arrives faster.** Endpoints and fields land by regenerating, not by hand-writing a DTO.
- **Some types were replaced rather than kept.** Where a hand-written type existed only to mirror the wire, the
  generated type takes over. Where our type was the better public API, we kept ours — so this is not a blanket
  rename.

Types under `package:stream_chat/open_api/...` are generated. Treat them as data holders: they are regenerated
from the spec, so don't subclass them or depend on their private constructors.

---

## Quick Reference

| Feature Area | Key Changes |
| --- | --- |
| [**Error Handling**](#error-handling) | API calls return `Result<T>` instead of throwing; failures carry `stream_core`'s sealed `StreamException` family instead of `StreamChatNetworkError`; `ChatErrorCode` → `StreamErrorCode` |
| _(filled in per feature as PRs land)_ | |

---

## Symbol Map

The mechanical part of the upgrade: every renamed, removed, or retyped public symbol. Each row is a
search-and-replace you can apply directly. `Kind` is one of `renamed`, `removed`, `retyped`, `moved`.

| Old symbol | New symbol | Kind | Notes |
| --- | --- | --- | --- |
| `StreamChatNetworkError` | `StreamApiException` (`stream_core`) | `retyped` | Thrown-then-caught becomes `Failure.error`; a sealed family, so `switch` is exhaustive |
| `StreamChatNetworkError.code` / `.message` / `.statusCode` | `StreamApiException.code` / `.message` / `.statusCode` | `moved` | `code` is now a `StreamErrorCode` |
| `StreamChatNetworkError.isRequestCancelledError` | `StreamNetworkException.isCancelled` | `moved` | |
| `StreamChatNetworkError.stackTrace` | `Failure.stackTrace`, or the language at the throw site | `removed` | A `StreamException` carries `message` and `cause` and no trace: a trace records the raise, not the failure |
| `StreamChatNetworkError.type` (`StreamChatNetworkErrorType`) | `StreamNetworkException.isTimeout` / `.isCancelled` | `retyped` | Lossy: `connectionTimeout`, `sendTimeout` and `receiveTimeout` all become `isTimeout` |
| `ChatErrorCode` | `StreamErrorCode` (`stream_core`) | `removed` | Extension type over `int` with named constants. `requestTimeout` was `23`, which the API never returns; the real code is `48` |
| `RetryPolicy.shouldRetry`'s `StreamChatError?` | `StreamChatException?` | `retyped` | |
| `UploadState`'s `Preparing` / `InProgress` / `Success` / `Failed` | `UploadStatePreparing` / `UploadStateInProgress` / `UploadStateSuccess` / `UploadStateFailed` | `renamed` | Frees `Success` for `Result` |
| `PagedValue.error(StreamChatError)` (`stream_chat_flutter_core`) | `PagedValue.error(StreamChatException)` | `retyped` | |
| `errorBuilder: Function(BuildContext, StreamChatError)` (scroll views) | `Function(BuildContext, StreamChatException)` | `retyped` | |
| `Token` | `UserToken` (`stream_core`) | `renamed` | `Token.fromRawValue(x)` → `UserToken(x)`; parses `exp`, so expiry is known |
| `TokenProvider` (typedef `Future<String> Function(String)`) | `TokenProvider` (interface, `stream_core`) | `retyped` | A closure no longer satisfies it. Wrap it: `TokenProvider.dynamic(loader)`, where `typedef UserTokenLoader = Future<UserToken> Function(String userId)` — so the loader returns a `UserToken`, not a `String`, and must be async |
| — | `UserToken(rawJwt)` | `added` | **Throws on a malformed JWT**, where `Token.fromRawValue` accepted anything. It also rejects a token whose `user_id` claim does not match the id it was loaded for. Both present as "cannot log in" rather than as a compile error |
| `TokenManager.loadToken()` / `.isStatic` / `.setTokenOrProvider()` | `.getToken()` / `.usesStaticProvider` / `.setTokenProvider()` | `renamed` | `loadToken(refresh: true)` becomes `expireToken()` then `getToken()` |
| `StreamChatClient.devToken(userId)` | — | `removed` | Generate tokens on your backend |
| `StreamChatClient(logLevel:, logHandlerFunction:)` | `StreamChatClient(logConfig: StreamLogConfig(...))` | `retyped` | Default is unchanged: warnings and errors to the console |
| `StreamChatClient.logger` (a `Logger`) | `StreamChatClient.logger` (a `StreamLogger`) | `retyped` | Messages are lazy: `logger.i(() => '…')` |
| `StreamChatClient.detachedLogger` / `.defaultLogHandler` / `LogHandlerFunction` | — | `removed` | Supply a `StreamLogHandler`; `StreamLogHandler.console()` is the default |
| `export 'package:logging'` (`Logger`, `Level`, `LogRecord`) | `StreamLogger`, `StreamLogConfig`, `StreamLogHandler`, `StreamLogFilter`, `StreamLogPriority`, `StreamLogRecord` | `removed` | `package:logging` is no longer a dependency |
| `StreamChatPersistenceClient(logLevel:, logHandlerFunction:)` | — | `removed` | Logging is configured once, on the client |
| `SortOption<T>.asc(field)` / `.desc(field)` | `ChannelSort.asc(field)` / `MemberSort.desc(field)` / … | `renamed` | One `Sort` subclass per model, as in `stream_feeds`. `nullOrdering` is still a named parameter |
| `SortOption.ASC` / `.DESC` | `SortDirection.asc` / `.desc` | `retyped` | An enum carrying `value` (`1` / `-1`) rather than a bare `int` |
| `const [SortOption.desc(f)]` | `[ChannelSort.desc(f)]` | `retyped` | **Drop the `const`.** A sort list can no longer be `const`: a `SortField` holds a closure that reads the value off the model, which is not a constant expression. Every v10 example wrote `const`, so expect this on the first line you touch |
| `ChannelSortKey` / `MessageSortKey` / `UserSortKey` / … (extension types over `String`) | `ChannelSortField` / `MessageSearchSortField` / `UserSortField` / … | `retyped` | Same member names. A field is no longer a `String`: read `field.remote` for the wire name. `MessageSortKey` is named for its one endpoint: searching |
| `SortOption.desc('my_custom_field')` | `Sort.desc(ChannelSortField.custom('my_custom_field'))` | `retyped` | Only where the model has extra data to read it from |
| `SortOrder<T extends ComparableFieldProvider>` | `List<ChannelSort>`, `List<MemberSort>`, … | `removed` | The typedef is gone; signatures name the model's sort type |
| `SortOption.fromJson` | `ChannelSort.fromJson` | `moved` | `Sort` has no `fromJson`: the remote name has to resolve back to a declared field |
| `SortOption(comparator:)` | — | `removed` | Declare a field whose value projects onto something orderable, or sort the list yourself |
| `DraftSortKey`'s `extraData` fallback | — | `removed` | The server rejects a custom sort field on drafts |
| `PollVoteSortKey.answerText` | — | `removed` | The API rejects a sort on `answer_text`: it is whitelisted in `AllowedCustomSortColumns` but the resource sets no custom-field container, so the request fails |
| _(new)_ | `ChannelSortField.cid` | `added` | Both iOS and Android sort channels by `cid` |
| _(new)_ | `MessageReminderSortField.messageId` | `added` | The server allows it and breaks reminder ties on it |
| _(new)_ | `MessageSearchSortField.relevance` | `added` | Sorts search results by match quality; the server drops it when the request has no text filter |
| `defaultChannelListSort` / `defaultMemberListSort` / `defaultUserListSort` / `defaultDraftListSort` / `defaultMessageReminderListSort` / `defaultPollVoteListSort` (`stream_chat_flutter_core`) | `ChannelSort.defaultSort` / `MemberSort.defaultSort` / … (`stream_chat`) | `moved` | The default belongs to the sort, as in `stream_feeds` and on Android. Now reachable without the Flutter layer |
| `ComparableField` / `ComparableFieldProvider` | — | `removed` | Never exported. Value lookup is now `XSortField.value` |
| `getComparableField(String)` on `User`, `Message`, `Member`, `Draft`, `Thread`, `Poll`, `PollVote`, `Reaction`, `BannedUser`, `MessageReminder` and `ChannelState` | — | `removed` | The types it named were unexported, but the method was public on all eleven models. A field reads its own value now, so an override has nowhere to go |
| `NullOrdering` / `CompositeComparator` | `stream_core`'s, re-exported | `moved` | Same names and semantics |
| `client.search(sort:)` / `channel.search(sort:)` / `StreamMessageSearchListController.sort`, taking `SortOrder?` | `List<MessageSearchSort>?` | `retyped` | Was untyped, so a channel field compiled — and the server does not reject one, it reads it as a custom message field, which is null on every message, so the term silently did nothing |
| _(more added per feature as PRs land)_ | | | |

---

## Error Handling

**This is the one change that touches every call site.** API methods no longer throw on failure — they return a
`Result<T>`, matching the `stream_feeds` SDK.

**Before:**
```dart
try {
  final response = await client.getDevices();
  print(response.devices);
} on StreamChatNetworkError catch (error) {
  print(error.message);
}
```

**After:**
```dart
final result = await client.getDevices();

result.fold(
  onSuccess: (response) => print(response.devices),
  onFailure: (error, stackTrace) => print(error),
);
```

`Result<T>` is a sealed type with `Success<T>` and `Failure`, exported from `package:stream_chat/stream_chat.dart`.
Besides `fold` it offers `getOrThrow()`, `getOrNull()`, `getOrElse(...)`, `exceptionOrNull()`, `map(...)` and
`flatMap(...)`.

If you want the old behaviour at a call site while you migrate incrementally, `getOrThrow()` rethrows the
underlying error:

```dart
final response = (await client.getDevices()).getOrThrow();
```

### Endpoints that still throw

`Result` arrives feature by feature. Until a given endpoint has migrated it still **throws** — but it throws a
`StreamChatException` now, not a `StreamChatNetworkError`. So during the v11 betas both of these are live, and both
report the same four kinds:

```dart
// A migrated endpoint returns a Result.
final result = await client.getDevices();

// One that has not yet still throws — the type is what changed.
try {
  await channel.sendMessage(message);
} on StreamChatException catch (error) {
  print(error.message);
}
```

`StreamChatException` is an alias of `stream_core`'s `StreamException`, so either name catches the same failures.

**Reading `.code` or `.statusCode` means catching a subtype — and that narrows what you catch.** The
tempting one-for-one swap silently stops handling most failures:

```dart
// ✗ compiles, and no longer catches timeouts, cancellation, auth failures or
//   a response the SDK could not decode.
} on StreamApiException catch (e) {
  if (e.statusCode == 429) backOff();
}

// ✓ catch the root, then match. `StreamChatException` is sealed, so this
//   `switch` is exhaustive with no default arm.
} on StreamChatException catch (e) {
  switch (e) {
    case StreamApiException(:final statusCode) when statusCode == 429: backOff();
    case StreamNetworkException(isTimeout: true): retryLater();
    case StreamAuthenticationException(): reauthenticate();
    case StreamClientException(): rethrow;   // an SDK bug, not yours
    case StreamApiException(): showError(e.message);
    case StreamNetworkException(): showOffline();
  }
}
```

Note this differs from the `Result.fold` example further down: `Failure.error` is typed `Object`, so
a `switch` on it *does* need a default arm. Only the caught root is sealed.

> **The one break you can ship without noticing.** `StreamChatNetworkError` is deprecated rather than deleted,
> because unmigrated endpoints used to throw it. Nothing throws it any more, so
> `on StreamChatNetworkError catch (e)` still **compiles** and simply stops matching — the failure passes straight
> through. Search your code for it; the deprecation warning tells you where.

### Logging

One `logConfig` replaces the two logging parameters, and records are `stream_core`'s:

**Before:**
```dart
final client = StreamChatClient(
  apiKey,
  logLevel: Level.INFO,
  logHandlerFunction: (LogRecord record) => myTracker.log(record.message),
);
```

**After:**
```dart
class MyHandler extends StreamLogHandler {
  const MyHandler();

  @override
  void handle(StreamLogRecord record) => myTracker.log(record.message);
}

final client = StreamChatClient(
  apiKey,
  logConfig: const StreamLogConfig(
    priority: StreamLogPriority.info,
    handler: MyHandler(),
  ),
);
```

Leave `logConfig` out and nothing changes from before: warnings and errors go to the console.

Records carry a `tag` naming the subsystem — `SCh:Ws`, `SCh:Http`, `SCh:RetryQueue` — and
`StreamLogFilter.prefix` filters on it, so you can turn one subsystem up without the rest. The
handler is process-global across Stream SDKs, which is why the tags are prefixed per product.

`StreamChatPersistenceClient` no longer takes logging parameters at all; it writes through the same
logger.

### Anonymous connections identify as `!anon`

`connectAnonymousUser` previously sent a client-generated random `user_id`; it now sends `!anon`, which is the id
the backend reserves for anonymous access and what our other SDKs send. `client.state.currentUser.id` reflects it.
If you keyed anything off that random id, it is no longer random.

### Retry behaviour changed

If you rely on the SDK's automatic retry of failed messages, it now retries more: a request that never reached the
server, a 5xx, a 429 and a 408. It still never retries another 4xx, a cancelled request, broken credentials, or
anything the server marked `unrecoverable`. Previously only failures *without* a parseable error body retried, so a
500 and a 429 did not. A custom `RetryPolicy.shouldRetry` overrides this, and `error.isRetriable` gives you the
default decision.

### The error type changed too

`Failure.error` is statically typed `Object`, and at runtime it is always a `StreamException` from `stream_core` —
**not** a `StreamChatNetworkError`. Chat now uses the same error types as our other SDKs:

| Type | When | Carries |
| --- | --- | --- |
| `StreamApiException` | the API answered with an error | `statusCode`, `code`, `moreInfo`, `unrecoverable`, `retryAfter`, `apiError` |
| `StreamNetworkException` | transport failed | `isCancelled`, `isTimeout`, `closeCode` |
| `StreamAuthenticationException` | the token was refused | — |
| `StreamClientException` | an SDK bug, or a response body that would not decode | the original error as `cause` |

```dart
result.fold(
  onSuccess: (response) => print(response.devices),
  onFailure: (error, stackTrace) => switch (error) {
    StreamApiException(:final code, :final message, :final statusCode) =>
      print('$code: $message ($statusCode)'),
    StreamNetworkException(isCancelled: true) => null,          // user cancelled
    final StreamException e => print(e.message),
    _ => print('unexpected: $error'),
  },
);
```

It is a sealed family, so a `switch` over it is exhaustive. Everything you read off `StreamChatNetworkError` has a
counterpart: `code` is now a `StreamErrorCode` (an extension type over `int`, with named constants like
`rateLimited` and `inputError`), `statusCode` and `message` are unchanged in spirit, and
`isRequestCancelledError` becomes `StreamNetworkException.isCancelled`.

`StreamApiException` exposes `isTokenExpired`, `isTokenNotYetValid`, `isTokenSignatureInvalid`,
`isApiKeyInvalid` and `isRateLimited` directly, so the common checks need no code of your own.

`ChatErrorCode` is removed — use `StreamErrorCode`. One value differed from the API: `requestTimeout` was `23`, a code the backend never returns, so anything matching on it never matched. The real code is `48`.

`Result` and the `StreamException` family are exported from `package:stream_chat/stream_chat.dart`.

---

## Feature Areas

_Each migrated feature gets a section here. Sections are added by the PR that migrates the feature, using the
template in [Contributing to this guide](#contributing-to-this-guide)._

---

## Migration Checklist

Work top to bottom; each item is independently verifiable.

- [ ] Update `stream_chat` (and any of `stream_chat_flutter`, `stream_chat_flutter_core`,
      `stream_chat_persistence`, `stream_chat_localizations` you depend on) to `^11.0.0`
- [ ] Wrap or fold every API call that previously used `try`/`catch` — see [Error Handling](#error-handling)
- [ ] Replace `on StreamChatNetworkError catch` with a `switch` over the sealed `StreamException` family — see
      [The error type changed too](#the-error-type-changed-too)
- [ ] Replace `ChatErrorCode` comparisons with `StreamErrorCode` constants
- [ ] Apply every row of the [Symbol Map](#symbol-map)
- [ ] Re-check custom data access: fields that used to arrive in `extraData` may now be typed properties
- [ ] If you implement `AttachmentFileUploader`, review its section under [Feature Areas](#feature-areas)
- [ ] If you persist models yourself, re-check nullability — generated types are nullable wherever the API allows it
- [ ] Run `dart analyze` and your test suite; the analyzer finds most of the mechanical work for you

---

## For AI Agents

If you are an agent performing this upgrade in a consumer codebase, work in this order:

1. **Bump the dependency** and run `dart pub get`, then `dart analyze`. The error list is your work queue — do not
   try to find call sites by reading code first.
2. **Apply the [Symbol Map](#symbol-map) top to bottom.** Every row is a whole-symbol rename; prefer an
   identifier-aware rewrite over plain text replacement so you don't hit substrings or comments.
3. **Fix error handling per call site**, not globally. `getOrThrow()` preserves existing behaviour and is the
   correct minimal change when the caller already has a `try`/`catch`; use `fold` when the caller should handle
   both branches. Never swallow a `Failure` by defaulting to `null`.
4. **Re-run `dart analyze` after each group** and stop when it is clean. Then run the consumer's tests — type
   changes that compile can still change runtime behaviour, especially around nullability.
5. **Do not edit anything under `package:stream_chat/open_api/`.** It is generated and regenerated from the spec.
6. **Report what you could not resolve** rather than guessing: a removed symbol with no replacement in the Symbol
   Map means the capability moved or was dropped, and that needs a human decision.

---

## Contributing to this guide

If your PR lands a breaking change, add to this guide **in the same PR**. Three edits, in this order:

1. A row per changed symbol in the [Symbol Map](#symbol-map).
2. A row in [Quick Reference](#quick-reference) if the feature area is not listed yet.
3. A section under [Feature Areas](#feature-areas) using this template:

```markdown
### <Feature name>

#### Key Changes:

- <one bullet per user-visible change>

#### Migration Steps:

**Before:**
```dart
// v10 call site
```

**After:**
```dart
// v11 call site
```

> **Why:** <the reason the break was taken — long-term maintainability, or consistency with our other SDKs>
```

Keep the `Why` line. It is what tells a reader whether the change is worth arguing with, and it is the same
justification the PR needed in order to break API at all.
