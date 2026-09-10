# stream_chat_test

Internal BDD-style test helpers and utilities for testing the `stream_chat` package.

This package is **not published** — it is a dev dependency for the packages in this
monorepo. It ports the test algebra of `stream_feeds_test` (from the
stream-feeds-flutter repository) to chat, keeping strict shape parity: file names,
public API, and lifecycle semantics match, so knowledge transfers between the two
packages file-for-file.

## What it provides

A test is one function call with named phases — two imports, no boilerplate:

```dart
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  chatClientTest(
    'stubs and verifies API calls with exact arguments',
    body: (tester) async {
      final message = createDefaultMessage(id: 'message-id');
      tester.mockApi(
        (api) => api.message.getMessage('message-id'),
        result: createDefaultGetMessageResponse(message: message),
      );

      final response = await tester.client.getMessage('message-id');

      expect(response.message.id, 'message-id');
      tester.verifyApi((api) => api.message.getMessage('message-id'));
    },
  );
}
```

Under the hood every test gets a **real** `StreamChatClient` with exactly three seams
replaced:

| Seam | Replaced with |
|---|---|
| REST API | `FakeChatApi` — a `StreamChatApi` whose sub-APIs are mocktail mocks |
| WebSocket transport | A mocked `WebSocketChannel` driven by `WebSocketTester`; the real `WebSocket` engine (URI building, frame decoding, health checks, reconnection) stays in play |
| Persistence | Optional `chatPersistenceClient:` parameter (none by default) |

Everything above those seams — client, channels, state, event routing, token
handling — is production code.

### Lifecycle

Each test runs the phases `connect → setUp → body → verify → tearDown` inside a
guarded zone (errors from event handlers, timers and unawaited futures fail the
test). The default connect phase mocks successful authentication, connects the
client as `luke_skywalker` with a development token, and asserts the connection.
Pass `connect:` to replace it — e.g. to test failed connections, or to skip the
socket entirely with `connect: (_) {}`.

```dart
chatClientTest(
  'fails to connect when authentication is rejected',
  connect: (tester) => tester.mockFailedAuth(errorCode: 43),
  body: (tester) async {
    await expectLater(
      tester.client.connectUser(tester.user, createTestToken(tester.user.id).rawValue),
      throwsA(isA<StreamWebSocketError>()),
    );
  },
);
```

### Testers

- `chatClientTest` / `ChatClientTester` — subject is the `StreamChatClient`;
  aliases: `clientState`, `connectionStatus`, `events`. Tag: `chat-client`.
- `channelTest` / `ChannelTester` — subject is a `Channel`; aliases: `channel`,
  `channelState`; `tester.watch()` seeds the channel (stubs the query with the
  exact request shape the SDK sends **and** performs it), with a
  `modifyResponse:` hook to adjust the canonical fixture. Tag: `channel`.

```dart
channelTest(
  'adds a new message on message.new event',
  setUp: (tester) => tester.watch(),
  body: (tester) async {
    await tester.emitEvent(
      createDefaultEvent(
        type: EventType.messageNew,
        cid: tester.channel.cid,
        message: createDefaultMessage(id: 'new-message'),
      ),
    );

    expect(tester.channelState?.messages.map((m) => m.id), contains('new-message'));
  },
);
```

More testers (for controllers and other state objects) follow the same three-part
template: an `@isTest` entry function, a `final class XxxTester extends BaseTester<X>`
with alias getters and a seeding method, and a private factory matching
`TesterFactory`.

### Helpers

- `ApiMockerMixin` — `mockApi` / `mockApiFailure` / `verifyApi` / `verifyApiCalled` /
  `captureApi` / `verifyNeverCalled`. Pass **exact** argument values, not `any()`:
  a mocktail stub only answers on a match, so stubbing doubles as request
  verification.
- `WebSocketTester` — `mockSuccessfulAuth` / `mockFailedAuth` / `mockConnectionError` /
  `emitEvent` / `emitRawFrame`. Emitted events are serialized with server fidelity
  (`serverEventJson`): nested message/reaction payloads keep the server-assigned fields
  (`user`, timestamps, reactions, ...) that their request-shaped `toJson` omits.
  Chat authenticates through the connect URI (token and
  user payload in query parameters), so the fake server validates credentials from
  the URI it receives and answers with the `health.check` + `me` handshake. Outgoing
  health-check pings are acknowledged automatically.
- `test_data.dart` — `createDefaultXxx` fixture factories with fully-defaulted
  parameters and deterministic timestamps (`DateTime(2021, 1, 1)` /
  `DateTime(2021, 2, 1)`).
- `mocks.dart` — mocks for all 12 sub-APIs, `FakeChatApi`,
  `registerChatFallbackValues()` (called automatically by the lifecycle).

## Known parity-inherited limitations

Kept 1:1 with `stream_feeds_test` on purpose; fix upstream and here together:

- The guarded zone drops async errors that arrive **after** the test body has
  completed (a timer armed during the test that fires in the teardown window fails
  silently instead of failing the test, which plain `package:test` would report).
- `skip:` is typed `bool`, so the skip *reason* required by `STYLE_GUIDE.md` cannot
  be provided (`package:test` accepts a String for this).

## Token handling — known limitation

The harness gives the injected `WebSocket` its **own** `TokenManager`, pre-loaded
with the harness `token:`/`tokenProvider:`, because the client's manager is private
and only wired into the WebSocket the client builds itself. Consequence: the token
argument passed to `client.connectUser(user, token)` never reaches the connect URI —
the harness credentials are what authenticate, so "rejects a bad token" cannot be
tested through `connectUser` (a self-test pins this behavior). The fake server still
validates everything it can see: the connect payload's user id and the `user_id`
claim of the token in the URI.

The proper fix is a `@visibleForTesting TokenManager?` seam on the
`StreamChatClient` constructor, letting the client and the injected WebSocket share
one manager. That approach has been validated (the full `stream_chat` test suite
passes with it) but is deliberately not applied yet — adopt it together with the
internals-access re-evaluation below. Adopting it later is contained: tests using
the default credentials behave identically with either wiring, so the only test
whose outcome changes is the pinning one above (flip it to expect rejection).

## Tags

Tests declared through `chatClientTest` / `channelTest` are tagged `chat-client` /
`channel` by default (`flutter test --tags channel` filters on them). This package
declares the tags in its own `dart_test.yaml`; consuming packages must declare them
in their own `dart_test.yaml` to avoid `package:test` warnings. Passing `tags:`
explicitly *replaces* the default tag.

## Internals access — re-evaluate

> **NOTE(re-evaluate):** this package imports `package:stream_chat/src/...` for seams
> that are not exported from the public barrel (`WebSocket`, `TokenManager`, `Token`,
> and the sub-API classes), with the `implementation_imports` lint disabled in this
> package's `analysis_options.yaml`. Re-evaluate once `stream_chat` exposes a
> dedicated testing entrypoint (e.g. `lib/testing.dart`) or exports these types from
> the main barrel.

## Long-term: convergence with `stream_feeds_test`

The domain-free parts of this package (the `testWithTester` lifecycle, the
mocker-mixin pattern, the websocket-channel harness) are candidates for extraction
into a shared `stream_core` test package. The chat-specific parts (`WebSocketTester`
internals, the throwing-API mocker) map one-to-one to where chat's low-level client
diverges from `stream_core`; they become replaceable by shared core equivalents if
chat's client moves onto `stream_core`. Until then, keep the file names and public
API in sync with `stream_feeds_test` when extending this package.
