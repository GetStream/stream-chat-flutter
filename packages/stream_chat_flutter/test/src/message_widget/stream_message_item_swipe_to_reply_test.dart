import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets('StreamMessageItem replies to a message swiped in a channel that allows quoting', (tester) async {
    final message = _message();
    final replies = <Message>[];
    await _pumpMessageItem(tester, message, canQuoteMessage: true, onReplyTap: replies.add);

    await _swipe(tester);

    expect(replies, [message]);
  });

  testWidgets('StreamMessageItem ignores a swipe in a channel that does not allow quoting', (tester) async {
    final replies = <Message>[];
    await _pumpMessageItem(tester, _message(), canQuoteMessage: false, onReplyTap: replies.add);

    await _swipe(tester);

    expect(replies, isEmpty);
  });
}

Message _message() {
  return Message(
    id: 'test-message',
    text: 'Are we still meeting tomorrow',
    createdAt: DateTime(2026, 8, 26, 15),
    user: User(id: 'han', name: 'Han Solo'),
    state: MessageState.sent,
  );
}

Future<void> _pumpMessageItem(
  WidgetTester tester,
  Message message, {
  required bool canQuoteMessage,
  required ValueChanged<Message> onReplyTap,
}) async {
  final currentUser = OwnUser(id: 'me', name: 'Luke Skywalker');
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(
    ownCapabilities: [if (canQuoteMessage) ChannelCapability.quoteMessage],
  );
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
  when(() => channel.client).thenReturn(client);
  when(() => channel.state).thenReturn(channelState);
  when(() => channelState.readStream).thenAnswer((_) => Stream.value(const []));

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
        child: StreamChannel(
          channel: channel,
          child: Scaffold(
            body: StreamMessageItem(message: message, swipeToReply: true, onReplyTap: onReplyTap),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _swipe(WidgetTester tester) async {
  await tester.timedDrag(
    find.byType(StreamMessageItem),
    const Offset(500, 0),
    const Duration(milliseconds: 300),
  );
  await tester.pumpAndSettle();
}
