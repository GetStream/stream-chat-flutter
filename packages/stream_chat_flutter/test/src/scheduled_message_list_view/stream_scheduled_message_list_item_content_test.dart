import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';
import 'scheduled_message_list_item_harness.dart';

void main() {
  testWidgets('StreamScheduledMessageListItem shows when the message is sent', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: fakeScheduledMessage())),
    );

    expect(find.text('Send Wed, Oct 21 at 8:00\u202fAM'), findsOneWidget);
  });

  testWidgets(
    "StreamScheduledMessageListItem names the channel from the scheduled message's channel summary when the channel isn't loaded",
    (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: fakeScheduledMessage())),
      );

      expect(find.text('General'), findsOneWidget);
    },
  );

  testWidgets('StreamScheduledMessageListItem shows a preview of the message', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: fakeScheduledMessage())),
    );

    expect(find.textContaining('Can you review the venue shortlist?', findRichText: true), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListItem shows the no-title text for a channel without a name', (tester) async {
    final untitled = fakeScheduledMessage(channel: ChannelModel(cid: 'messaging:general'));

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: untitled)));

    expect(find.text(DefaultTranslations.instance.noTitleText), findsOneWidget);
    expect(find.text('messaging:general'), findsNothing);
  });

  testWidgets('StreamScheduledMessageListItem formats the scheduled time with the theme formatter', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessageListItem(scheduledMessage: fakeScheduledMessage()),
        chatTheme: StreamChatThemeData(
          scheduledMessageListItemTheme: StreamScheduledMessageListItemThemeData(
            scheduledAtFormatter: (_, date) => 'At ${date.hour}h',
          ),
        ),
      ),
    );

    expect(find.text('At 8h'), findsOneWidget);
    expect(find.text('Send Wed, Oct 21 at 8:00\u202fAM'), findsNothing);
  });

  testWidgets('StreamScheduledMessageListItem starts a reply in a thread with the thread-reply prefix', (tester) async {
    final reply = fakeScheduledMessage(text: 'Can someone review it?', parentId: 'parent');

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: reply)));

    expect(find.text('Thread reply:'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListItem starts a quoting message with the quoted author', (tester) async {
    final quoted = Message(
      id: 'quoted',
      text: 'Ready?',
      user: User(id: 'alex', name: 'Alex Ross'),
    );

    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessageListItem(scheduledMessage: fakeScheduledMessage(quotedMessage: quoted)),
      ),
    );

    expect(find.text('Reply to Alex Ross:'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListItem names a loaded direct message by its other member', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessageListItem(
          scheduledMessage: fakeScheduledMessage(channel: ChannelModel(cid: 'messaging:general')),
        ),
        channels: {'messaging:general': _loadedDirectMessage()},
      ),
    );

    expect(find.text('Maya Ross'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessageListItem names the author of a quoted message it finds in the channel', (
    tester,
  ) async {
    final quoted = Message(
      id: 'quoted-id',
      text: 'The venues',
      user: User(id: 'maya', name: 'Maya Ross'),
    );
    final scheduledMessage = fakeScheduledMessage(quotedMessageId: quoted.id);

    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessageListItem(scheduledMessage: scheduledMessage),
        channels: {
          'messaging:general': _loadedDirectMessage(messages: [quoted]),
        },
      ),
    );

    expect(find.text('Reply to Maya Ross:'), findsOneWidget);
  });
}

// A loaded direct message channel without a name, with [messages] loaded.
Channel _loadedDirectMessage({List<Message> messages = const []}) {
  final channel = MockChannel(type: 'messaging', id: 'general');
  final state = MockChannelState();
  final members = [
    Member(
      userId: 'current-user-id',
      user: User(id: 'current-user-id', name: 'Current User'),
    ),
    Member(
      userId: 'maya',
      user: User(id: 'maya', name: 'Maya Ross'),
    ),
  ];

  final client = MockClient();
  final clientState = MockClientState();
  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user-id'));

  when(() => channel.client).thenReturn(client);
  when(() => channel.state).thenReturn(state);
  when(() => channel.isOneToOne).thenReturn(true);
  when(() => channel.image).thenReturn(null);
  when(() => channel.imageStream).thenAnswer((_) => Stream.value(null));
  when(() => state.membersStream).thenAnswer((_) => const Stream.empty());
  when(() => state.channelState).thenReturn(ChannelState(channel: ChannelModel(cid: 'messaging:general')));
  when(() => state.members).thenReturn(members);
  when(() => state.messages).thenReturn(messages);
  when(() => state.threads).thenReturn({});
  return channel;
}
