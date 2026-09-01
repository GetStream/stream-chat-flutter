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
| `ChatErrorCode` | `StreamErrorCode` (`stream_core`) | `removed` | Extension type over `int` with named constants |
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

`ChatErrorCode` is removed — use `StreamErrorCode`.

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
