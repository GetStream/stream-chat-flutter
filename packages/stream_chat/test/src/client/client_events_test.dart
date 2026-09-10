import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  group('WS events', () {
    group('User messages deleted event', () {
      chatClientTest(
        'should broadcast global user.messages.deleted event to all channels',
        body: (tester) async {
          // Add messages from the user to be deleted
          final bannedUser = User(id: 'banned-user', name: 'Banned User');
          final message1 = Message(
            id: 'msg-1',
            text: 'Message in channel 1',
            user: bannedUser,
          );
          final message2 = Message(
            id: 'msg-2',
            text: 'Message in channel 2',
            user: bannedUser,
          );

          // Setup: Create multiple channels with state
          final channelState1 = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: 'messaging:channel-1'),
            messages: [message1],
          );
          final channelState2 = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: 'messaging:channel-2'),
            messages: [message2],
          );

          final channel1 = Channel.fromState(tester.client, channelState1);
          final channel2 = Channel.fromState(tester.client, channelState2);

          // Register channels in client state
          tester.clientState.addChannels({
            'messaging:channel-1': channel1,
            'messaging:channel-2': channel2,
          });

          // Verify initial state
          expect(channel1.state?.messages.length, equals(1));
          expect(channel2.state?.messages.length, equals(1));

          // Emit a global (cid-less) user.messages.deleted event;
          // ClientState rebroadcasts it to every registered channel.
          final event = createDefaultEvent(
            type: EventType.userMessagesDeleted,
            user: bannedUser,
            hardDelete: false,
          );

          await tester.emitEvent(event);

          // Verify messages are soft deleted in all channels
          final channel1Message = channel1.state?.messages.first;
          expect(channel1Message?.type, equals(MessageType.deleted));
          expect(channel1Message?.state.isDeleted, isTrue);

          final channel2Message = channel2.state?.messages.first;
          expect(channel2Message?.type, equals(MessageType.deleted));
          expect(channel2Message?.state.isDeleted, isTrue);
        },
      );

      chatClientTest(
        'should broadcast global hard delete to all channels',
        body: (tester) async {
          // Add messages from the user to be deleted
          final bannedUser = User(id: 'banned-user', name: 'Banned User');
          final otherUser = User(id: 'other-user', name: 'Other User');

          final message1 = Message(
            id: 'msg-1',
            text: 'Message in channel 1',
            user: bannedUser,
          );
          final message2 = Message(
            id: 'msg-2',
            text: 'Message in channel 2',
            user: bannedUser,
          );
          final message3 = Message(
            id: 'msg-3',
            text: 'Safe message',
            user: otherUser,
          );

          // Setup: Create multiple channels with state
          final channelState1 = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: 'messaging:channel-1'),
            messages: [message1, message3],
          );
          final channelState2 = createDefaultChannelState(
            channel: createDefaultChannelModel(cid: 'messaging:channel-2'),
            messages: [message2],
          );

          final channel1 = Channel.fromState(tester.client, channelState1);
          final channel2 = Channel.fromState(tester.client, channelState2);

          // Register channels in client state
          tester.clientState.addChannels({
            'messaging:channel-1': channel1,
            'messaging:channel-2': channel2,
          });

          // Verify initial state
          expect(channel1.state?.messages.length, equals(2));
          expect(channel2.state?.messages.length, equals(1));

          // Emit a global (cid-less) user.messages.deleted event;
          // ClientState rebroadcasts it to every registered channel.
          final event = createDefaultEvent(
            type: EventType.userMessagesDeleted,
            user: bannedUser,
            hardDelete: true,
          );

          await tester.emitEvent(event);

          // Verify banned user's messages are removed from all channels
          expect(channel1.state?.messages.length, equals(1));
          expect(
            channel1.state?.messages.any((m) => m.user?.id == 'banned-user'),
            isFalse,
          );
          expect(channel2.state?.messages.length, equals(0));

          // Verify other user's message is unaffected
          final safeMessage = channel1.state?.messages.firstWhere((m) => m.id == 'msg-3');
          expect(safeMessage?.user?.id, equals('other-user'));
        },
      );
    });
  });
}
