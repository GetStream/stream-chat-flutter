// How `StreamMessageListView`'s default loading, empty and error states fit a
// list with little room, such as in landscape with the attachment picker open.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_list_view/stream_message_list_error_state.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

const _listHeight = 120.0;

void main() {
  testWidgets('StreamMessageListView fits its default empty state into a short list', (tester) async {
    await _pumpShortMessageList(tester);

    expect(tester.takeException(), isNull);
  });

  testWidgets('StreamMessageListErrorState fits into a short list', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: _client(),
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: _listHeight,
              child: StreamMessageListErrorState(
                error: const StreamClientException(message: 'error'),
                onRetryPressed: () {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('StreamMessageListView fits its default loading state into a short list', (tester) async {
    await _pumpShortMessageList(
      tester,
      parentMessage: Message(
        id: 'parent',
        text: 'Parent',
        user: User(id: 'otherid'),
      ),
      // A thread whose replies never arrive stays in its loading state.
      stubChannel: (channel, state) {
        when(() => state.threads).thenReturn(const {});
        when(
          () => channel.getReplies(
            any(),
            options: any(named: 'options'),
            preferOffline: any(named: 'preferOffline'),
          ),
        ).thenAnswer((_) => Completer<QueryRepliesResponse>().future);
      },
    );

    expect(find.byType(StreamSkeletonBox), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}

// Pumps a [StreamMessageListView] with no messages into a box [_listHeight]
// tall. [stubChannel] adds stubs a test needs beyond the defaults.
Future<void> _pumpShortMessageList(
  WidgetTester tester, {
  Message? parentMessage,
  void Function(Channel channel, ChannelClientState state)? stubChannel,
}) async {
  final client = _client();

  final messagesController = StreamController<List<Message>>.broadcast();
  addTearDown(messagesController.close);

  final channel = MockChannel();
  final channelClientState = MockChannelState();
  when(() => channel.client).thenReturn(client);
  when(() => channel.state).thenReturn(channelClientState);

  when(() => channelClientState.threadsStream).thenAnswer((_) => const Stream.empty());
  when(() => channelClientState.isUpToDate).thenReturn(true);
  when(() => channelClientState.isUpToDateStream).thenAnswer((_) => Stream.value(true));
  when(() => channelClientState.unreadCount).thenReturn(0);
  when(() => channelClientState.unreadCountStream).thenAnswer((_) => Stream.value(0));
  when(() => channelClientState.readStream).thenAnswer((_) => const Stream.empty());
  when(() => channelClientState.read).thenReturn([]);
  when(() => channelClientState.membersStream).thenAnswer((_) => const Stream.empty());
  when(() => channelClientState.members).thenReturn([]);
  when(() => channelClientState.currentUserRead).thenReturn(null);
  when(() => channelClientState.currentUserReadStream).thenAnswer((_) => const Stream.empty());
  when(() => channelClientState.messagesStream).thenAnswer((_) => messagesController.stream);
  when(() => channelClientState.messages).thenReturn([]);
  stubChannel?.call(channel, channelClientState);

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        child: StreamChannel(
          channel: channel,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: _listHeight,
              child: StreamMessageListView(parentMessage: parentMessage),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.pump();
  await tester.pump();
}

// A client signed in as a user.
StreamChatClient _client() {
  final client = MockClient();
  final clientState = MockClientState();
  when(() => client.state).thenAnswer((_) => clientState);
  final ownUser = OwnUser(id: 'ownid');
  when(() => clientState.currentUser).thenReturn(ownUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(ownUser));
  return client;
}
