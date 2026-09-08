# 07 — WebSocket transport

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
| `StreamWebSocketError` (deferred from phase 03) | `DisconnectionSource.serverInitiated(error:)` |

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
`connect()` that fails is never retried by it. Chat's `connectUser` catches
`StreamWebSocketError.isRetriable` at `client.dart:459` and retries the initial connect itself;
that behaviour has to stay somewhere, and it is not in core.

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
      Symbol Map rows for `ConnectionStatus` and `StreamWebSocketError`, plus a feature section on
      the new connection state.
- [ ] Decisions recorded here, status box ticked in `README.md`.
