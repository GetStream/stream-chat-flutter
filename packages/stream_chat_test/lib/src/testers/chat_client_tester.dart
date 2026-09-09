import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart' as test;

import '../helpers/mocks.dart';
import 'base_tester.dart';
import 'websocket_tester.dart';

/// Test helper for testing [StreamChatClient] behavior.
///
/// Automatically sets up a real client with mocked API and WebSocket seams,
/// connects it (unless [connect] is overridden), and coordinates the test
/// lifecycle: `connect → setUp → body → verify → tearDown`.
///
/// Example:
/// ```dart
/// chatClientTest(
///   'should connect successfully',
///   body: (tester) async {
///     expect(tester.connectionStatus, ConnectionStatus.connected);
///     expect(tester.currentUser?.id, tester.user.id);
///   },
/// );
/// ```
@isTest
void chatClientTest(
  String description, {
  User? user,
  Token? token,
  TokenProvider? tokenProvider,
  ChatPersistenceClient? chatPersistenceClient,
  Level logLevel = Level.OFF,
  FutureOr<void> Function(ChatClientTester tester)? connect,
  FutureOr<void> Function(ChatClientTester tester)? setUp,
  required FutureOr<void> Function(ChatClientTester tester) body,
  FutureOr<void> Function(ChatClientTester tester)? verify,
  FutureOr<void> Function(ChatClientTester tester)? tearDown,
  bool skip = false,
  Iterable<String> tags = const ['chat-client'],
  test.Timeout? timeout,
}) {
  return testWithTester<StreamChatClient, ChatClientTester>(
    description,
    user: user,
    token: token,
    tokenProvider: tokenProvider,
    chatPersistenceClient: chatPersistenceClient,
    logLevel: logLevel,
    build: (client) => client,
    createTesterFn: _createChatClientTester,
    connect: connect,
    setUp: setUp,
    body: body,
    verify: verify,
    tearDown: tearDown,
    skip: skip,
    tags: tags,
    timeout: timeout,
  );
}

/// Test utility for [StreamChatClient] tests.
///
/// The subject is the client itself; this tester adds client-state aliases on
/// top of the shared [BaseTester] functionality.
final class ChatClientTester extends BaseTester<StreamChatClient> {
  const ChatClientTester._({
    required super.subject,
    required super.user,
    required super.client,
    required super.chatApi,
    required super.wsTester,
  });

  /// The client's state (current user, channels, unread counts).
  ClientState get clientState => client.state;

  /// The client's current WebSocket connection status.
  ConnectionStatus get connectionStatus => client.wsConnectionStatus;

  /// The stream of events received by the client.
  Stream<Event> get events => client.eventStream;
}

// Factory function conforming to [TesterFactory] for creating
// [ChatClientTester] instances.
Future<ChatClientTester> _createChatClientTester({
  required StreamChatClient subject,
  required User user,
  required StreamChatClient client,
  required FakeChatApi chatApi,
  required WebSocketTester wsTester,
}) {
  return createTester(
    create: () => ChatClientTester._(
      subject: subject,
      user: user,
      client: client,
      chatApi: chatApi,
      wsTester: wsTester,
    ),
  );
}
