import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';

void main() {
  group('ScheduledMessageRules', () {
    late StreamChatClient client;

    setUp(() {
      client = _createMockClient();
    });

    group('isCommand', () {
      test('is true for a command in a channel with commands', () {
        final channel = _createChannel(client, commands: [Command(name: 'giphy')]);

        expect(ScheduledMessageRules.isCommand(Message(text: '/giphy cats'), channel), isTrue);
      });

      test('is true for an unknown command in a channel with commands', () {
        final channel = _createChannel(client, commands: [Command(name: 'giphy')]);

        expect(ScheduledMessageRules.isCommand(Message(text: '/unknown'), channel), isTrue);
      });

      test('is false in a channel without commands', () {
        final channel = _createChannel(client);

        expect(ScheduledMessageRules.isCommand(Message(text: '/giphy cats'), channel), isFalse);
      });

      test("is false when the channel isn't loaded", () {
        expect(ScheduledMessageRules.isCommand(Message(text: '/giphy cats'), null), isFalse);
      });

      test('is false when the text starts with a space', () {
        final channel = _createChannel(client, commands: [Command(name: 'giphy')]);

        expect(ScheduledMessageRules.isCommand(Message(text: ' /giphy cats'), channel), isFalse);
      });

      test('is false without text', () {
        final channel = _createChannel(client, commands: [Command(name: 'giphy')]);

        expect(ScheduledMessageRules.isCommand(Message(), channel), isFalse);
      });
    });

    group('quotesDeletedMessage', () {
      final deleted = Message(id: 'quoted', text: 'Gone', type: MessageType.deleted);

      test('is true for a quote the loaded channel knows was deleted', () {
        final channel = _createChannel(client, messages: [deleted]);
        final message = Message(text: 'About that', quotedMessageId: 'quoted');

        expect(ScheduledMessageRules.quotesDeletedMessage(message, channel), isTrue);
      });

      test('is true for a quoted message that is deleted', () {
        final message = Message(text: 'About that', quotedMessageId: 'quoted', quotedMessage: deleted);

        expect(ScheduledMessageRules.quotesDeletedMessage(message, null), isTrue);
      });

      test('is true for a quoted message with a deletion time', () {
        final quoted = Message(id: 'quoted', text: 'Gone', deletedAt: DateTime.utc(2026, 10, 30));
        final message = Message(text: 'About that', quotedMessageId: 'quoted', quotedMessage: quoted);

        expect(ScheduledMessageRules.quotesDeletedMessage(message, null), isTrue);
      });

      test("prefers the loaded channel's copy of the quoted message", () {
        final channel = _createChannel(client, messages: [deleted]);
        final stale = Message(id: 'quoted', text: 'Still here');
        final message = Message(text: 'About that', quotedMessageId: 'quoted', quotedMessage: stale);

        expect(ScheduledMessageRules.quotesDeletedMessage(message, channel), isTrue);
      });

      test('is false for a quoted message that is not deleted', () {
        final quoted = Message(id: 'quoted', text: 'Still here');
        final message = Message(text: 'About that', quotedMessageId: 'quoted', quotedMessage: quoted);

        expect(ScheduledMessageRules.quotesDeletedMessage(message, null), isFalse);
      });

      test('is false without a quote', () {
        final channel = _createChannel(client, messages: [deleted]);

        expect(ScheduledMessageRules.quotesDeletedMessage(Message(text: 'Hello'), channel), isFalse);
      });
    });
  });
}

Logger _createLogger(String name) => Logger.detached(name);

StreamChatClient _createMockClient() {
  final client = MockStreamChatClient();
  final clientState = FakeClientState(currentUser: OwnUser(id: 'current-user-id'));

  when(() => client.state).thenReturn(clientState);
  when(() => client.detachedLogger(any())).thenAnswer((invocation) {
    return _createLogger(invocation.positionalArguments.first as String);
  });
  when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));
  when(() => client.retryPolicy).thenReturn(
    RetryPolicy(shouldRetry: (_, __, ___) => false),
  );

  return client;
}

Channel _createChannel(
  StreamChatClient client, {
  List<Command> commands = const [],
  List<Message> messages = const [],
}) {
  final channelState = ChannelState(
    channel: ChannelModel(
      cid: 'test:channel-1',
      config: ChannelConfig(commands: commands),
    ),
    messages: messages,
  );

  return Channel.fromState(client, channelState);
}
