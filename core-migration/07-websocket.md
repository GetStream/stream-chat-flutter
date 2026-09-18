# 07 — WebSocket transport

> **Parked.** A full attempt was written and reverted (`git reset` off
> `refactor/migrate-to-core`); nothing from this phase is in the tree. Everything below is kept
> because it is what the attempt established — read [Findings from the first
> attempt](#findings-from-the-first-attempt) before restarting, since most of the cost was in
> discovering those, not in the code.
>
> The phases after this one do not depend on it: `ConnectionIdManager` stays ours either way, and
> `Event` is untouched. Resume when the WS is worth a PR of its own.

**Goal:** replace our 560-line WebSocket monolith with core's decomposed engine, health monitor,
retry strategy, reconnection policies and connection state machine — **on the existing v1
protocol**, with v1 event shapes and chat's `Event` model untouched.

**Size:** ~790 chat LOC deleted against ~1,940 core LOC adopted. The most behaviourally sensitive
phase in the plan.

## Why this is possible without WS v2

Both `openapi-migration/README.md` and the `openapi-migration` skill list "move the WebSocket to
v2" as a non-goal, and both treat adopting core's WS as part of that project. The reasoning was
that the handshakes differ in kind: **chat authenticates in the connect URL** (`_buildUri` builds a
`json=` payload carrying api_key, user details and token), while **core's authenticator sends a
`WsAuthMessageRequest` frame after open** — and with v1 there is no frame to send.

That reasoning is wrong about core, which supports exactly this case:

- `web_socket_authentication_handler.dart:34` — "`authenticator` may be null, for a connection
  that needs nothing sent." The handler's `authenticate()` "does nothing when there is no
  authenticator."
- `stream_web_socket_client.dart:357-360`, in `_handleHealthCheckEvent` — "Still authenticating
  counts too: with **no authenticator** we never send anything, so this pong is the only sign we
  get that the connection works." The state machine transitions
  `Authenticating → Connected(healthCheck:)` purely off a decoded event carrying
  `healthCheckInfo`.

So: `onAuthenticate: null`, the token rides in `optionsBuilder`'s URL, and the decoded
`connection.ok` event drives the transition. `optionsBuilder` is a `WebSocketOptions Function()`
called **per attempt**, so a refreshed token is picked up on reconnect — which is exactly what
`_reconnect(refreshToken: true)` does today.

**Moving to v2 remains out of scope.** This phase adopts the machinery, not the protocol.

### Staying on v1 is the same call iOS made, and v2 is not ready for chat

`stream-chat-swift` has migrated to `StreamCore` (`StreamCore+Extensions.swift`, the shared
`WebSocketClient`) and to v2 OpenAPI endpoints for messages, reminders and message actions — and
it still connects over v1 with `?json=` (`WebSocketConnectEndpoint.swift`, `WebSocketConnectPayload`).
`stream-core-swift` absorbed chat's handshake quirks into the shared client rather than letting
chat fork it: `healthCheckBeforeConnected` is documented "Compatibility reasons for chat which has
to set it to true", alongside an optional `connectRequest` and a `requiresAuth` flag. That is the
model this phase follows — stay on v1, push chat's needs into core where they generalize.

Three things the server would have to change or core would have to grow before chat's WS could
move to `/api/v2/connect` (`lib/core/api/connect/routes.go`), all verified in
`~/GolandProjects/chat`:

- **v2's connect does not enrich user mutes.** `chatState.EnrichUserMutes` is called in
  `lib/chat/controller/v1/connect.go:118` and `longpoll.go:108`, and nowhere in
  `lib/core/api/connect/controller/connect_v2.go`. `OwnUser.mutes` would come back empty.
- **v2 drops root-level custom user fields.** Its `user_details` payload
  (`commonpayloads.ConnectUserDetailsRequest`) is decoded with `WithDecodeExtraFields(false)` and
  reads `custom` as a nested object, while v1 flattens unknown root keys into custom. Chat's
  `ConnectUserDetails.toJson` promotes `extraData` to the root, so those fields would be silently
  discarded.
- **Core's `ConnectUserDetailsRequest` has no `privacySettings`.** The v2 Go payload accepts
  `privacy_settings`; core's Dart mirror does not carry it.

## Scope

| Delete | Adopt |
| --- | --- |
| `lib/src/ws/websocket.dart` (560) — `_initWebSocketChannel`, `_subscribeToWebSocketChannel`, `_onDataReceived`, `_onConnectionError`, `_onConnectionClosed` | `StreamWebSocketEngine` + a chat `WebSocketMessageCodec<WsEvent, WsRequest>` |
| `_buildUri` | `optionsBuilder: () => WebSocketOptions(url:, queryParameters: {...})` |
| `_startHealthCheck`, `_startReconnectionMonitor`, `healthCheckInterval`, `reconnectionMonitorInterval`, `reconnectionMonitorTimeout` | `WebSocketHealthMonitor` |
| `lib/src/ws/timer_helper.dart` (39) — `TimerHelper` | (subsumed) |
| `_getReconnectInterval(attempt)`, `maxReconnectAttempts` | `RetryStrategy` / `DefaultRetryStrategy` |
| `_needsToReconnect`, `pauseReconnect`, `resumeReconnect` | `AutomaticReconnectionPolicy` family + `CompositeReconnectionPolicy` |
| `_reconnect`, `client.maybeReconnect()` | `ConnectionRecoveryHandler` |
| `lib/src/ws/connection_status.dart` (11) — `enum ConnectionStatus` | `sealed WebSocketConnectionState` + `sealed DisconnectionSource` |
| the `StreamApiException` / `StreamNetworkException` raised by `_handleStreamError` and `_onConnectionError` (phase 03) | `DisconnectionSource.serverInitiated(error:)` |

`lib/src/ws/connect_user_details.dart` maps onto core's `ConnectUserDetailsRequest`, which has
`invisible` and `language` already — those are chat's fields, in core.

## Order within the phase

### 1. `Event extends WsEvent` — do this first, on its own

`Event` is a plain `class Event {` today (`core/models/event.dart:10`), so this is purely
additive: extend `WsEvent` and override two getters.

```dart
class Event extends WsEvent {
  // error: non-null only for connection.error
  @override
  Object? get error => ...;

  // healthCheckInfo: non-null for health.check and connection.ok
  @override
  HealthCheckInfo? get healthCheckInfo => ...;
}
```

This is the prerequisite for everything else in the phase: it is what lets chat events flow
through core's `EventEmitter<WsEvent>` and what drives `Authenticating → Connected`. Land it
before touching the transport, and nothing observable changes.

`HealthCheckInfo` carries `connectionId` and `participantCount` — the latter is a video field;
ignore it.

### 2. The codec

```dart
class ChatWsCodec implements WebSocketMessageCodec<WsEvent, WsRequest> {
  // encode: json.encode(message.toJson())
  // decode: Event.fromJson(json.decode(...)) — everything is an Event
}
```

`FeedsWsCodec` (`stream_feeds/lib/src/ws/feeds_ws_event.dart`) is the template, but chat's is
simpler: feeds has to unwrap a generated union and patch in three events the spec omits, whereas
every chat frame is already an `Event`. What the codec must guarantee is that `connection.ok`,
`health.check` and `connection.error` produce events whose `healthCheckInfo` / `error` are
populated — that is step 1's job, checked here.

**A decode failure logs and drops the frame; it never disconnects.** That is core's deliberate
rule (`ERROR_LAYER.md`), and it matches what `_onDataReceived` effectively does today.

**The encode side is not a straight `json.encode(message.toJson())`.** The only `WsRequest` chat
sends is the health-check ping, and the two sides disagree on one key: core's
`HealthCheckPingEvent.toJson()` writes `{'type': 'health.check', 'client_id': …}`, while chat
serializes an `Event` and writes `connection_id`. Confirm which the chat gateway accepts before
adopting the codec, and map the key in `ChatWsCodec.encode` if it is `connection_id`. A test
asserting the exact encoded JSON is the guard — a wrong key here is silent until health checks
stop being acknowledged.

### 3. Client, health, recovery

```dart
StreamWebSocketClient(
  tag: '<chat prefix>:Ws',
  messageCodec: const ChatWsCodec(),
  onAuthenticate: null,                       // v1 sends nothing after open
  optionsBuilder: () => WebSocketOptions(
    url: ...,
    queryParameters: {'json': ..., 'api_key': ..., 'authorization': ...},
  ),
)
```

Then `ConnectionRecoveryHandler(client:, retryStrategy:, networkStateProvider:,
lifecycleStateProvider:, policies:)`.

`ConnectionRecoveryHandler` **only recovers a connection that was once `Connected`** — a first
`connect()` that fails is never retried by it. Chat's `connectUser` gates on `isRetriable` at
`client.dart:459` and retries the initial connect itself; that behaviour has to stay somewhere,
and it is not in core.

### 4. Rewrite `connectUser` around state observation

This is the real work. Today:

- `connectUser` awaits `Future<Event> _ws.connect()` and reads `OwnUser` off the returned event,
- it reaches into `_ws.connectionCompleter` directly at `client.dart:418` and `:895`,
- `_setConnectionId(event.connectionId)` at `:572` seeds the connection id,
- `ClientState` is seeded from the same event.

Core's `connect()` returns when the socket **opens** and reports the outcome only through
`connectionState`. There is no `connectionCompleter` and no returned event. Rebuild it as feeds
does (`feeds_client_impl.dart` `_connectUser`):

```dart
_ws.connect().ignore();
final state = await Future.any([
  connectionState.waitFor<Connected>(),
  connectionState.waitFor<Disconnected>(),
]);
// Disconnected(:final source) -> map through the sealed DisconnectionSource and rethrow
// with Error.throwWithStackTrace; only ServerInitiated and AuthenticationFailed carry a trace.
```

- **connection id** comes from `Connected(:final healthCheck).connectionId`.
- **`OwnUser`** comes from the decoded `connection.ok` event off the `events` emitter — subscribe
  *before* connecting, or the event is missed.
- `ConnectionIdInterceptor`'s getter reads the same place:
  `if (_ws.connectionState.value case Connected(:final healthCheck)) return healthCheck.connectionId;`

### 5. Keep `ConnectionStatus` alive as a derived view

`ConnectionStatus` is publicly exported and used in **36 places** across
`stream_chat_flutter_core` and `stream_chat_flutter`. Do not break both Flutter layers in the same
PR as the transport rewrite. Keep `wsConnectionStatus` as a deprecated getter deriving from
`WebSocketConnectionState`:

| `WebSocketConnectionState` | `ConnectionStatus` |
| --- | --- |
| `Initialized`, `Disconnected`, `Disconnecting` | `disconnected` |
| `Connecting`, `Authenticating` | `connecting` |
| `Connected` | `connected` |

Expose the sealed state alongside it, and migrate the Flutter layers in a follow-up.

### 6. Move reconnection out of the Flutter layer

`stream_chat_flutter_core/lib/src/stream_chat_core.dart` (410 LOC) hand-rolls exactly core's
policy family: `StreamChatCoreState with WidgetsBindingObserver`, a `_ChatLifecycleManager`,
`_subscribeToConnectivityChange` over `Connectivity().onConnectivityChanged`,
`didChangeAppLifecycleState`, and `onConnectivityChanged → client.maybeReconnect()`.

Core's equivalents are `InternetAvailabilityReconnectionPolicy(NetworkStateEmitter)` and
`BackgroundStateReconnectionPolicy(LifecycleStateEmitter)`, composed by
`ConnectionRecoveryHandler`. Core ships the `NetworkStateProvider` / `LifecycleStateProvider`
**interfaces only**.

Implement both in `stream_chat_flutter_core` (see the README for why not `stream_core_flutter`)
and inject them into the handler. Note `stream_chat_flutter_core.dart:3` re-exports all of
`connectivity_plus` — keep the re-export, but this is itself a public change in that package.

## Findings from the first attempt

The attempt reached a green `stream_chat` suite before being reverted. What it established, in the
order it would be rebuilt:

**1. `Event extends WsEvent`** — additive, as planned. `healthCheckInfo` reports the connection id
on `health.check`, which covers both the acknowledgement that opens a connection and the pongs that
keep it alive. `error` stays `null` by inheritance.

**2. `ChatWsCodec`** — simpler than feeds', which has to unwrap a generated union and patch in
three frames its spec omits. Chat's protocol puts every event in the same shape, so a frame decodes
straight to an `Event`; the one exception is a refusal, which becomes a `ConnectionErrorEvent`.

The refusal frame is `{"type":"connection.error","created_at":…,"connection_id":"","error":{…}}` —
it *does* carry a type (`monolith/types/event_schema_registry.go:374`,
`event_video.go:533`), so dispatch on `type == 'connection.error'` and not on the presence of an
`error` key. It needs its own event because `Event` has no field for the payload and would drop it.

That event carries `Object error` rather than a `StreamApiError`, deliberately.
`StreamApiError.fromJson` requires `code`, `message` and `StatusCode`, while chat's own
`ErrorResponse` had all three nullable — so a payload missing one would throw and we would lose the
refusal entirely, leaving only a close code that says nothing (auth, token and permission failures
all close with 1000). Instead the raw payload is carried, and `stream_core` wraps anything it does
not recognize in a `StreamClientException`; the frame still ends the connection either way.

**3. `buildChatWsOptions`** — the connect URL, as a pure function, so it can be tested against
what goes on the wire without a socket. `stream_core`'s provider does
`Uri.parse(url).replace(queryParameters: …)`, so chat resolves the scheme (`http`/`ws` → `ws`,
`https`/`wss` → `wss`), host, port and `/connect` path itself and hands over the query map.

### The constraint feeds does not have: a synchronous options builder

`WebSocketOptionsBuilder` is `WebSocketOptions Function()` — **synchronous**, called once per
attempt. Chat's `_buildUri` was `async` because it awaited `tokenManager.getToken()`.

Feeds has no such problem, and looking at why is what explains core's shape: its `optionsBuilder`
carries **no token at all** — just `api_key`, `stream-auth-type` and `X-Stream-Client`, all
synchronously available. The token goes out in `_authenticateUser`'s `WsAuthMessageRequest`, which
*is* async, so feeds refreshes on `previousError.isTokenExpired` and sends the fresh token **within
the same attempt**. Core's async authenticator exists precisely because v2 authenticates in a
frame.

Chat authenticates in the URL — the token appears three times, in `json`'s `user_token`, in
`authorization` and via `stream-auth-type` — so it has to be readable synchronously at attempt
time. Consequences, decided:

- **The token is cached, not fetched, in the builder.** `StreamChatClient` loads one before it
  calls `connect()`, so a first attempt is always fresh. `TokenManager.onTokenUpdated` keeps the
  cached copy current.
- **A refused token costs one extra attempt.** `onAuthenticate` still gets supplied — not to send
  anything, since v1 sends nothing after open, but because it is the only async hook that receives
  `previousError`. It expires and refetches there, which makes the *next* attempt's URL fresh
  rather than the current one's. Chat used to do this in two attempts via
  `_reconnect(refreshToken: true)`; core's recovery does it in three.
- **That cost is narrow.** It only applies when the server refuses a token the client believed
  valid — clock skew, or a revocation. `UserToken.isExpired` covers the ordinary case before the
  URL is ever built, which chat's old `Token` could not do.

The alternative was keeping chat's own reconnect loop so it could await a fresh token before each
attempt, preserving two attempts exactly. Rejected: it would leave `ConnectionRecoveryHandler`,
`RetryStrategy` and the reconnection policies unadopted, and with them the 410 lines of lifecycle
and connectivity wiring in `stream_chat_flutter_core` that this phase exists to delete.

### The ping frame is not a wire difference: use core's default

Chat's old ping and core's default disagree on the key — chat serialized a whole `Event`
(`{"type":"health.check","connection_id":"…","created_at":"…","is_local":true}`), core sends
`{"type":"health.check","client_id":"…"}` — and it does not matter. The server never reads the
body.

`Client.MonitorHealth` (`monolith/engine/websocket/client.go:607-620`) reads the next frame,
returns on `OpClose`, and otherwise calls `reader.Discard()`. Any frame at all is the keepalive;
the health check it replies with is built server-side from its own client id
(`coreevent.NewHealthCheckEvent(wsClientID)`). iOS relies on this directly: for
`webSocketClientType == .coordinator` it sends a raw WebSocket protocol ping
(`WebSocketClient.sendPing() → engine?.sendPing()`), no JSON at all.

So `pingRequestBuilder` is left at its default and there is no chat-side ping type. The
"backgrounding past the ping interval" case in the definition of done still applies — it exercises
the monitor's cadence, not the frame.

### Two traps in core's state emitter, both of which bit

**`isActive` is not "connecting".** It means "anything but `Disconnected`", which includes
`Initialized` — where every fresh client starts. Guarding `_connectUser` with it made *every* first
connect throw "User already getting connected". The guard has to pattern-match
`Connecting() || Authenticating()`.

**`waitFor` resolves on the *current* value.** `connectionState` is a state emitter, so it replays
what it holds to a new listener. `waitFor<Disconnected>()` therefore fired immediately on any
client that had disconnected before, and `openConnection` reported "User initiated disconnection"
for a connection it had not attempted yet. Both outcomes have to be armed **before** `connect()`,
with the starting state dropped:

```dart
final acknowledged = _ws.events.whereType<Event>().firstWhere((it) => it.type == EventType.healthCheck);
// `skip(1)` drops the state this attempt starts from.
final refused = _ws.connectionState.skip(1).firstWhere((it) => it is Disconnected);

_ws.connect().ignore();
final outcome = await Future.any<Object>([acknowledged, refused]);
```

The real client sets `Connecting` synchronously inside `connect()`, so arming after it happens to
work — which is exactly why this is worth writing down rather than relying on.

### Three test-harness facts worth not rediscovering

- **The fake has to be a real `StreamWebSocketClient`**, faked over `MutableEventEmitter<WsEvent>`
  and `MutableConnectionStateEmitter` (both exported from core). Driving those two emitters is the
  whole harness; `connect()` sets `Connecting` then emits a `health.check`.
- **One subscription to `_ws.events`, not two.** A `firstWhere` inside `openConnection` alongside
  the constructor's `listen(handleEvent)` gives no ordering guarantee between them, so
  `openConnection` can return before `handleEvent` has run and `state.currentUser` is stale. Feed
  the waiting completer *from* the single listener, after dispatching.
- **A more faithful fake surfaces a pre-existing write.** Every server health check carries a
  connection id, so `_handleHealthCheckEvent` writes `updateConnectionInfo` to persistence roughly
  every 25s — that is current behaviour (the old code passed `handler: handleEvent` to `WebSocket`
  too), but the old fake bypassed `handleEvent` entirely, so no test ever saw it. Groups that
  connect with persistence need it stubbed. Sourcing the connection id from
  `connectionState.value case Connected(:final healthCheck)` the way feeds does would remove the
  per-ping churn at the root.

### `StreamWebSocketError` did not wait for this phase

It was deferred here on the assumption that only `DisconnectionSource.serverInitiated(error:)`
could replace it. Phase [03](03-errors.md) deleted it instead: the socket path maps onto core's
kinds without touching the transport, so this phase inherits no error type to clean up. What is
still true is that `DisconnectionSource` is where the *reason* belongs once the transport moves —
`_handleStreamError` and `_onConnectionError` both become codec/state concerns rather than
exception construction.

## Decisions to make

- Where the **initial**-connect retry lives now that `ConnectionRecoveryHandler` won't do it.
  Options: keep chat's loop in `connectUser`, or drive `RetryStrategy` manually there.
- Whether `WebSocket` (the class) is deleted or kept as a deprecated shell. It is not exported
  from `stream_chat.dart`, so deletion is likely free — verify.
- Whether the sealed `WebSocketConnectionState` is exposed publicly in this phase or the next.
  Exposing it means consumers can finally ask *why* a disconnect happened, which is the main win
  for them.
- Whether `keepConnectionAliveInBackground` (a `ConnectionRecoveryHandler` flag) becomes a public
  chat option. Today backgrounding behaviour is hard-coded in the Flutter layer.

## Risks

- **The highest-risk phase in the plan, and unit tests will not catch the failures.** Reconnection
  bugs present as "messages stop arriving after the phone was in a tunnel", which no test suite
  reproduces. Budget hand-verification (below).
- **`connectUser`'s contract changes shape internally** while its public signature stays. Any
  behaviour that depended on the handshake `Event` being returned synchronously with the connect
  future has to be re-derived from the emitter, and a subscription registered too late silently
  misses `connection.ok`.
- **Ping cadence is not configurable.** `WebSocketHealthMonitor`'s `pingInterval` (25s) and
  `timeoutThreshold` (3s) are constructed with defaults *inside* `StreamWebSocketClient` — there
  is no knob. Chat's current `healthCheckInterval` differs. Upstream ask.
- **The error frame may be lost.** `ERROR_LAYER.md` mandates draining pending frames before
  reacting to a close, because the server sends the error text frame *before* the close frame, and
  the close code carries almost no signal (auth, token and permission failures all close 1000).
  `StreamWebSocketEngine._onDone` closes immediately. Verify empirically whether chat's refusal
  reasons survive; if they don't, that is an upstream fix, not a chat workaround.
- **`RetryQueue` must keep draining.** It listens for `EventType.connectionRecovered`. Confirm
  that event is still emitted at the same moment relative to the new state machine, or queued
  messages silently stop retrying.

## Upstream `stream_core` work

- Injectable `WebSocketHealthMonitor` cadence (`pingInterval`, `timeoutThreshold`) through
  `StreamWebSocketClient`.
- Drain pending frames in `StreamWebSocketEngine` before reacting to a close, per `ERROR_LAYER.md`.

## Definition of done

- [ ] `Event extends WsEvent`, landed separately and ahead of the rest.
- [ ] `websocket.dart` and `timer_helper.dart` deleted.
- [ ] `ChatWsCodec` covers `connection.ok`, `health.check` and `connection.error`; a malformed
      frame is logged and dropped without disconnecting.
- [ ] `connectUser` is rebuilt on `connectionState` observation, still returns `OwnUser`, and
      still surfaces a failed connect as a thrown `StreamException` with a useful message.
- [ ] Initial-connect retry behaviour preserved, with its new home recorded here.
- [ ] `wsConnectionStatus` still works, deprecated, deriving from the sealed state; neither
      Flutter package needed changes in this PR.
- [ ] `NetworkStateProvider` / `LifecycleStateProvider` implemented in `stream_chat_flutter_core`
      and injected; `stream_chat_core.dart`'s hand-rolled lifecycle/connectivity code deleted.
- [ ] `RetryQueue` still drains on reconnect — asserted by a test, not assumed.
- [ ] **Test harness:** stub `WebSocketChannel.ready` / `stream` / `sink` off a **broadcast**
      controller (broadcast specifically so the engine can re-listen after a disconnect) and
      auto-reply `health.check`. `stream_feeds_test/helpers/web_socket_mocks.dart` and
      `testers/base_tester.dart` are the template — they run the *real* core stack with only the
      transport swapped, which is the level this phase needs.
- [ ] **Hand-verified in `sample_app`**, all six: cold connect; token expiry mid-session;
      airplane mode off and on; backgrounding past the ping interval and returning;
      server-initiated close; and a queued failed message draining after reconnect.
- [ ] `melos bootstrap && melos run analyze && melos run test:dart && melos run test:flutter`.
- [ ] `refactor(llc)!:` title, `🛑️ Breaking` CHANGELOG entries, `migrations/v11-migration.md`
      Symbol Map row for `ConnectionStatus`, plus a feature section on the new connection state.
- [ ] Decisions recorded here, status box ticked in `README.md`.
