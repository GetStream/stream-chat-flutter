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
| `Token.development` / `StreamChatClient.devToken` | **removed** — a `devtoken`-signed JWT only works on an app with development tokens enabled, so shipping a minter in the SDK invites it into production. Tests build their own via `testUserToken` in `test/src/utils.dart`. |

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

## Decisions taken

- **`Token` is deleted, not forwarded.** `UserToken`'s constructor parses the JWT and throws on a
  malformed one where `Token.fromRawValue` did not, so a forwarder would not be
  behaviour-preserving for bad input.
- **`GuestTokenProvider` is dropped.** It was already dead: nothing outside `token.dart`
  referenced it, and its only user was the equally unused `Token.guest`.
- **The manager is built internally**, as `TokenManager.unconfigured()`, and configured by
  `setTokenProvider` on connect — core's primary constructor needs a `userId`, which chat does not
  have until `connectUser`.
- **`devToken` is removed outright** rather than retyped. See the rename map above.

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

- [x] `token.dart`, `token_manager.dart` and our `auth_interceptor.dart` are deleted;
      `StreamChatClient` holds `TokenManager.unconfigured()` and configures it on connect.
- [x] `_connectUser` takes a single `required TokenProvider`, so every entry point — regular,
      provider, anonymous, guest — configures the manager the same way.
- [x] Our token tests are deleted rather than ported: core covers `AuthInterceptor` (25 cases),
      `TokenManager` (36), `UserToken` (12) and `TokenProvider` (10) — 83 against our ~30.
- [x] `TokenManager` added to the barrel allowlist. It appears in the exported signatures of
      `StreamHttpClient` and `StreamChatApi` but was never nameable — a pre-existing wart.
- [x] `StreamChatClient.devToken` removed; the JWT builder lives in `test/src/utils.dart` as
      `testUserToken`, the way `stream_feeds_test` keeps `generateTestUserToken`.
- [x] `melos run analyze` and `melos run format` clean; `stream_chat` 1664 tests green.
- [x] `🛑️ Breaking` CHANGELOG entries and `migrations/v11-migration.md` Symbol Map rows for the
      whole rename map, plus a section on the anonymous id.
- [ ] **Verify a live anonymous connect against a real app key.** Adopting core's token layer
      changes the anonymous `user_id` from a random value to `!anon` (see below). The source
      evidence says it is safe; only a live connect proves it.
- [ ] Verified by hand in `sample_app`: cold login, a token that expires mid-session, and a
      logout → login as a different user.
- [ ] Status box updated in `README.md`.

### The anonymous id changed, deliberately

`Token.anonymous({userId})` used a caller-supplied or **random** id;
`UserToken.anonymous()` is always `User.anonymousUserId` (`!anon`), and
`StaticTokenProvider` validates that a token's id matches the one it is registered under — so the
old behaviour is not expressible on core's layer.

Adopting `!anon` is the right call rather than a compromise: `monolith/types/user.go:27` defines
`AnonUserID = "!anon"`, and `monolith/auth/auth.go:179` enforces it on anon JWT claims
*specifically so* "customers [cannot] create anon tokens that can be used to impersonate other
users or a server". Chat's random id was the outlier.

Why it still needs a live check: that enforcement only runs when a raw anon JWT is present, and
chat's anonymous token has an empty `rawValue`, so the claims path is never exercised. What the
server does with the `user_id` **query parameter** on an anonymous request is not settled from
source — `types.NewAnonymousUser(...)` suggests it builds its own user and ignores the client's,
but that is inference.
