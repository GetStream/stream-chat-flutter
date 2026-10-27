import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  final jason = User(id: 'jason', name: 'Jason Thompson');
  final maya = User(id: 'maya', name: 'Maya Ross');

  final parent = Message(
    id: 'parent',
    text: 'Planning the offsite',
    createdAt: DateTime(2026, 8, 26, 14),
    user: jason,
    state: MessageState.sent,
    replyCount: 2,
  );

  Message quoting(Message quoted) => Message(
    id: 'quoting',
    text: 'Agreed',
    createdAt: DateTime(2026, 8, 26, 16),
    user: maya,
    state: MessageState.sent,
    quotedMessageId: quoted.id,
    quotedMessage: quoted,
  );

  testWidgets('opens the thread of a quoted reply that is only in the thread', (tester) async {
    final threadReply = Message(
      id: 'thread-reply',
      text: 'Lisbon in May',
      createdAt: DateTime(2026, 8, 26, 15),
      user: jason,
      state: MessageState.sent,
      parentId: parent.id,
    );
    final openedThreads = <Message>[];

    await _pumpMessageList(
      tester,
      [parent, quoting(threadReply)],
      onThreadTap: (opened, _) => openedThreads.add(opened),
    );
    await tester.tap(find.byType(StreamQuotedMessage));
    await tester.pumpAndSettle();

    expect(openedThreads.map((it) => it.id), [parent.id]);
  });

  testWidgets('does not open a thread for a quoted reply also sent to the channel', (tester) async {
    final channelReply = Message(
      id: 'channel-reply',
      text: 'Lisbon in May',
      createdAt: DateTime(2026, 8, 26, 15),
      user: jason,
      state: MessageState.sent,
      parentId: parent.id,
      showInChannel: true,
    );
    final openedThreads = <Message>[];

    await _pumpMessageList(
      tester,
      [parent, channelReply, quoting(channelReply)],
      onThreadTap: (opened, _) => openedThreads.add(opened),
    );
    await tester.tap(find.byType(StreamQuotedMessage));
    await tester.pumpAndSettle();

    expect(openedThreads, isEmpty);
  });

  testWidgets('does not open a thread for a quoted reply inside the thread', (tester) async {
    final threadReply = Message(
      id: 'thread-reply',
      text: 'Lisbon in May',
      createdAt: DateTime(2026, 8, 26, 15),
      user: jason,
      state: MessageState.sent,
      parentId: parent.id,
    );
    final quotingReply = quoting(threadReply).copyWith(parentId: parent.id);
    final openedThreads = <Message>[];

    await _pumpMessageList(
      tester,
      [threadReply, quotingReply],
      parentMessage: parent,
      onThreadTap: (opened, _) => openedThreads.add(opened),
    );
    await tester.tap(find.byType(StreamQuotedMessage));
    await tester.pumpAndSettle();

    expect(openedThreads, isEmpty);
  });

  testWidgets('opens the thread of a quoted reply on that reply', (tester) async {
    final replies = [
      for (var i = 0; i < 20; i++)
        Message(
          id: 'reply-$i',
          text: 'Offsite idea $i',
          createdAt: DateTime(2026, 8, 26, 15, i),
          user: jason,
          state: MessageState.sent,
          parentId: parent.id,
        ),
    ];

    await _pumpMessageList(
      tester,
      [parent, quoting(replies.first)],
      replies: replies,
      threadBuilder: (_, parent) => StreamMessageListView(parentMessage: parent),
    );
    await tester.tap(find.byType(StreamQuotedMessage));
    await tester.pumpAndSettle();

    final quotedReply = find.textContaining('Offsite idea 0', findRichText: true).hitTestable();
    expect(quotedReply, findsOneWidget);
  });
}

Future<void> _pumpMessageList(
  WidgetTester tester,
  List<Message> messages, {
  ThreadTapCallback? onThreadTap,
  ThreadBuilder? threadBuilder,
  Message? parentMessage,
  List<Message>? replies,
}) async {
  final currentUser = OwnUser(id: 'maya', name: 'Maya Ross');
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
  when(() => channel.client).thenReturn(client);
  when(() => channel.state).thenReturn(channelState);
  final threads = {
    if (parentMessage != null) parentMessage.id: messages,
    for (final reply in [...?replies]) reply.parentId!: replies!,
  };
  when(() => channelState.threadsStream).thenAnswer((_) => Stream.value(threads));
  when(() => channelState.threads).thenReturn(threads);
  when(
    () => channel.getReplies(
      any(),
      options: any(named: 'options'),
      preferOffline: any(named: 'preferOffline'),
    ),
  ).thenAnswer((_) async => QueryRepliesResponse()..messages = replies ?? messages);
  when(() => channelState.messagesStream).thenAnswer((_) => Stream.value(messages));
  when(() => channelState.messages).thenReturn([?parentMessage, ...messages]);
  when(() => channelState.isUpToDate).thenReturn(true);
  when(() => channelState.isUpToDateStream).thenAnswer((_) => Stream.value(true));
  when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(0));
  when(() => channelState.unreadCount).thenReturn(0);
  when(() => channelState.readStream).thenAnswer((_) => const Stream.empty());
  when(() => channelState.read).thenReturn([]);
  when(() => channelState.membersStream).thenAnswer((_) => const Stream.empty());
  when(() => channelState.members).thenReturn([]);
  when(() => channelState.currentUserRead).thenReturn(null);
  when(() => channelState.currentUserReadStream).thenAnswer((_) => const Stream.empty());

  await tester.pumpWidget(
    MaterialApp(
      // Above the navigator, so a thread page pushed from the list has it too.
      builder: (context, child) => StreamChat(
        client: client,
        connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
        child: child!,
      ),
      home: StreamChannel(
        channel: channel,
        child: StreamMessageListView(
          parentMessage: parentMessage,
          onThreadTap: onThreadTap,
          threadBuilder: threadBuilder,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
