# 04 — Token & auth

**Goal:** adopt core's token model and auth interceptor. Ours works; core's fixes three real bugs
ours has and adds expiry awareness ours cannot express.

**Size:** ~225 chat LOC deleted against ~500 core LOC. Breaking, with a clean rename map.

## Scope

| Delete | Adopt |
| --- | --- |
| `lib/src/core/http/token.dart` (81) — `Token`, `AuthType`, `GuestTokenProvider` | `stream_core` `user/user_token.dart` — `UserToken`, `AuthType`, `UserTokenLoader` |
| `lib/src/core/http/token_manager.dart` (79) — `TokenManager`, `TokenProvider` typedef | `stream_core` `user/token_manager.dart` (247) + `user/token_provider.dart` (135) |
| `lib/src/core/http/interceptor/auth_interceptor.dart` (64) | `stream_core` `api/interceptors/auth_interceptor.dart` (118) |

### Why core's is better, concretely

Ours is a `QueuedInterceptor`, so every request serialises behind every other. Core's is a plain
`Interceptor` — token *loads* are serialised inside `TokenManager` (via `InFlightCache` keyed on a
generation counter) instead of requests, which was a deliberate 0.5.0 change.

On the refresh path, ours checks `code == ChatErrorCode.tokenExpired.code`, refreshes and refetches.
Core's does that **and**:

- guards against a retry loop with an `extra['stream_core.auth_token_retried']` marker,
- refuses to refresh across a user switch (`signedFor == tokenManager.userId`),
- skips refresh entirely for a static provider, where a re-fetch would return the same token,
- re-clones `FormData` before the retry, because the first attempt consumed its streams,
- logs every non-refresh decision under its tag.

Ours has none of those. The `FormData` one is a live bug on any retried file upload.

`UserToken` also parses `exp` via `jose` and exposes `isExpired({leeway})`, which is what lets the
interceptor act before the server refuses rather than only after.

### Rename map

| Ours | Core |
| --- | --- |
| `Token` | `UserToken` |
| `Token.fromRawValue(String)` | `UserToken(String rawJwt)` |
| `Token.anonymous` | `UserToken.anonymous()` |
| `TokenProvider = Future<String> Function(String userId)` — a **typedef** | `abstract interface class TokenProvider` — `TokenProvider.static(UserToken)` / `TokenProvider.dynamic(UserTokenLoader)` |
| `TokenManager.loadToken({refresh})` | `TokenManager.getToken()` / `expireToken()` / `peekToken()` |
| `TokenManager.isStatic` | `TokenManager.usesStaticProvider` |
| `TokenManager.setTokenOrProvider` | `TokenManager.setTokenProvider(userId, tokenProvider:)` |
| `Token.development` | keep chat-side — build the dev JWT and wrap it in `TokenProvider.static` |

`TokenProvider` going from a typedef to an interface is the break consumers actually feel: a
closure no longer satisfies the parameter. `TokenProvider.dynamic(myLoader)` is the one-line fix,
and it is a good `dart fix` transform candidate for phase [10](10-cleanup.md).

### Guest auth

`GuestTokenProvider = Future<String> Function(User)` maps onto core's
`TokenManager.setTokenProvider(id, TokenProvider.static(token))` **after** the exchange, because
the server assigns the guest's real id. `TokenManager.unconfigured()` + `setTokenProvider` exists
precisely for this.

`stream_feeds`' `_connectGuestUser` / `_exchangeForGuestIdentity`
(`stream_feeds/lib/src/client/feeds_client_impl.dart`) is the worked example, including the
`InFlightCache` keyed on the requested id so overlapping callers share one exchange rather than
racing to create two guests.

Note core's `_authenticateUser` refuses to refresh a static provider and throws
`StreamAuthenticationException` instead — correct for guests, since a re-exchange yields a
*different* guest. Chat needs the same reasoning wherever it re-authenticates.

### Anonymous

Core collapses anonymous and guest into `User.anonymousUserId` + `TokenProvider.static(
UserToken.anonymous())` at construction. Chat has its own anonymous handling in `connectUser` /
`connectAnonymousUser`; reconcile the two rather than layering them, and note core's
`ConnectionIdInterceptor` is deliberately **skipped** for anonymous users.

## Decisions to make

- Whether `Token` survives as a deprecated forwarder. `UserToken`'s constructor parses the JWT and
  throws on a malformed one, where `Token.fromRawValue` did not — so a forwarder is not
  behaviour-preserving for bad input. Probably a clean break with a migration entry.
- Whether chat keeps `GuestTokenProvider` as a public convenience over
  `TokenProvider`+`setTokenProvider`, or drops it and documents the two-step.
- Whether `TokenManager` is still constructor-injected into `StreamChatClient` or built internally.
  Core's requires a `userId` at construction, which chat does not have until `connectUser` — so
  `TokenManager.unconfigured()` at construction and `setTokenProvider` on connect is the shape.

## Risks

- **Every auth path is a connect path.** `connectUser`, `connectAnonymousUser`, guest connect and
  token refresh all change together, and a mistake here presents as "cannot log in" rather than as
  a test failure. Phase [07](07-websocket.md) then rewrites `connectUser` again — sequence these
  two deliberately and do not interleave them.
- Core's interceptor refuses a refresh across a user switch. If chat currently relies on a refresh
  surviving a `disconnectUser` → `connectUser` with a different id, that stops working — which is
  the correct behaviour, but it is a behaviour change.
- `UserToken` validates that a loaded token's `userId` matches the one it loaded for and rejects a
  mismatch. Any consumer whose token endpoint returns a token for a different user will now fail
  loudly where it previously succeeded.

## Upstream `stream_core` work

None.

## Definition of done

- [ ] `token.dart`, `token_manager.dart` and our `auth_interceptor.dart` are deleted.
- [ ] `StreamChatClient` holds core's `TokenManager`, configured on connect.
- [ ] Tests cover: static token, dynamic provider, expired-token refresh (exactly one retry),
      refresh refused across a user switch, refresh skipped for a static provider, and a retried
      **multipart** request succeeding — that last one is the `FormData` re-clone.
- [ ] Guest connect adopts the server-assigned id, and two overlapping guest connects produce one
      exchange.
- [ ] Anonymous connect sends no `connection_id` and no `Authorization` refresh attempt.
- [ ] `melos bootstrap && melos run analyze && melos run test:dart && melos run test:flutter`.
- [ ] Verified by hand in `sample_app`: cold login, a token that expires mid-session, and a
      logout → login as a different user.
- [ ] `refactor(llc)!:` title, `🛑️ Breaking` CHANGELOG entries, `migrations/v11-migration.md`
      Symbol Map rows for the whole rename map plus a feature section for `TokenProvider`.
- [ ] Decisions recorded here, status box ticked in `README.md`.
