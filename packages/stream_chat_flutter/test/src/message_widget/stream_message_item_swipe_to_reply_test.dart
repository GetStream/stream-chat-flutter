import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  final currentUser = OwnUser(id: 'me', name: 'Luke Skywalker');
  final message = Message(
    id: 'test-message',
    text: 'Are we still meeting tomorrow',
    createdAt: DateTime(2026, 8, 26, 15),
    user: User(id: 'han', name: 'Han Solo'),
    state: MessageState.sent,
  );

  Widget wrap(Widget body, {required bool canQuoteMessage}) {
    final client = MockClient();
    final clientState = MockClientState();
    final channel = MockChannel(
      ownCapabilities: [
        ChannelCapability.sendMessage,
        if (canQuoteMessage) ChannelCapability.quoteMessage,
      ],
    );
    final channelState = MockChannelState();

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(currentUser);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelState);
    when(() => channelState.readStream).thenAnswer((_) => Stream.value(const []));

    return MaterialApp(
      home: StreamChat(
        client: client,
        connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
        child: StreamChannel(
          channel: channel,
          child: Scaffold(body: body),
        ),
      ),
    );
  }

  Future<List<Message>> swipe(WidgetTester tester, {required bool canQuoteMessage}) async {
    final replies = <Message>[];
    await tester.pumpWidget(
      wrap(
        StreamMessageItem(message: message, swipeToReply: true, onReplyTap: replies.add),
        canQuoteMessage: canQuoteMessage,
      ),
    );
    await tester.pumpAndSettle();

    await tester.timedDrag(
      find.byType(StreamMessageItem),
      const Offset(500, 0),
      const Duration(milliseconds: 300),
    );
    await tester.pumpAndSettle();
    return replies;
  }

  testWidgets('StreamMessageItem replies to a message swiped in a channel that allows quoting', (tester) async {
    expect(await swipe(tester, canQuoteMessage: true), [message]);
  });

  testWidgets('StreamMessageItem ignores a swipe in a channel that does not allow quoting', (tester) async {
    expect(await swipe(tester, canQuoteMessage: false), isEmpty);
  });
}
