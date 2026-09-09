import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart' as test;

import '../helpers/mocks.dart';
import '../helpers/test_data.dart';
import 'base_tester.dart';
import 'websocket_tester.dart';

/// Test helper for testing [Channel] behavior.
///
/// By default the subject is a fresh, non-initialized channel of
/// [channelType]/[channelId]; pass [build] to construct it differently (e.g.
/// via [Channel.fromState]). Use [ChannelTester.watch] in [setUp] to seed the
/// channel with an initial state before emitting events.
///
/// Example:
/// ```dart
/// channelTest(
///   'adds a new message on message.new event',
///   setUp: (tester) => tester.watch(),
///   body: (tester) async {
///     final message = createDefaultMessage(id: 'new-message');
///     await tester.emitEvent(
///       createDefaultEvent(
///         type: EventType.messageNew,
///         cid: tester.channel.cid,
///         message: message,
///       ),
///     );
///
///     expect(tester.channelState?.messages, contains(message));
///   },
/// );
/// ```
@isTest
void channelTest(
  String description, {
  String channelType = 'messaging',
  String channelId = 'test-channel',
  Channel Function(StreamChatClient client)? build,
  User? user,
  Token? token,
  TokenProvider? tokenProvider,
  ChatPersistenceClient? chatPersistenceClient,
  Level logLevel = Level.OFF,
  FutureOr<void> Function(ChannelTester tester)? connect,
  FutureOr<void> Function(ChannelTester tester)? setUp,
  required FutureOr<void> Function(ChannelTester tester) body,
  FutureOr<void> Function(ChannelTester tester)? verify,
  FutureOr<void> Function(ChannelTester tester)? tearDown,
  bool skip = false,
  Iterable<String> tags = const ['channel'],
  test.Timeout? timeout,
}) {
  return testWithTester<Channel, ChannelTester>(
    description,
    user: user,
    token: token,
    tokenProvider: tokenProvider,
    chatPersistenceClient: chatPersistenceClient,
    logLevel: logLevel,
    build: build ?? (client) => client.channel(channelType, id: channelId),
    createTesterFn: _createChannelTester,
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

/// Test utility for [Channel] tests.
///
/// Provides channel-state aliases and a [watch] seeding method on top of the
/// shared [BaseTester] functionality.
final class ChannelTester extends BaseTester<Channel> {
  const ChannelTester._({
    required super.subject,
    required super.user,
    required super.client,
    required super.chatApi,
    required super.wsTester,
  });

  /// The channel being tested.
  Channel get channel => subject;

  /// The channel's state.
  ///
  /// Null until the channel has been initialized, e.g. by calling [watch].
  ChannelClientState? get channelState => channel.state;

  /// Stubs the channel query and watches the channel, seeding it with an
  /// initial state.
  ///
  /// Call this in event tests to set up initial state before emitting events.
  /// Skip this in tests that only verify API calls.
  ///
  /// The stub matches the exact request the SDK sends for a watch — including
  /// `channelData: channel.extraData` — so it doubles as verification of the
  /// request shape. Use [modifyResponse] to adjust the canonical seeded state:
  ///
  /// ```dart
  /// setUp: (tester) => tester.watch(
  ///   modifyResponse: (state) => state.copyWith(
  ///     messages: [createDefaultMessage(id: 'my-message')],
  ///   ),
  /// ),
  /// ```
  Future<ChannelState> watch({
    ChannelState Function(ChannelState state)? modifyResponse,
  }) {
    final defaultChannelState = createDefaultChannelState(
      channel: createDefaultChannelModel(
        cid: '${channel.type}:${channel.id}',
      ),
      messages: [
        createDefaultMessage(id: 'message-1'),
        createDefaultMessage(id: 'message-2'),
        createDefaultMessage(id: 'message-3'),
      ],
      membership: createDefaultMember(user: currentUser ?? user),
    );

    mockApi(
      (api) => api.channel.queryChannel(
        channel.type,
        channelId: channel.id,
        channelData: channel.extraData,
        state: true,
        watch: true,
        presence: false,
      ),
      result: switch (modifyResponse) {
        final modifier? => modifier(defaultChannelState),
        _ => defaultChannelState,
      },
    );

    return channel.watch();
  }

  @override
  Future<void> dispose() async {
    channel.dispose();
    await super.dispose();
  }
}

// Factory function conforming to [TesterFactory] for creating
// [ChannelTester] instances.
Future<ChannelTester> _createChannelTester({
  required Channel subject,
  required User user,
  required StreamChatClient client,
  required FakeChatApi chatApi,
  required WebSocketTester wsTester,
}) {
  return createTester(
    create: () => ChannelTester._(
      subject: subject,
      user: user,
      client: client,
      chatApi: chatApi,
      wsTester: wsTester,
    ),
  );
}
