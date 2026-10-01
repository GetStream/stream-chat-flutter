import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_sending_status.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

void main() {
  final currentUser = OwnUser(id: 'me');
  final otherUser = User(id: 'other');
  final createdAt = DateTime(2026, 10, 1, 12);
  final message = Message(id: 'm1', text: 'Hi', createdAt: createdAt, user: currentUser, state: MessageState.sent);

  late StreamController<ChannelState> channelStates;
  late int listenCount;

  setUp(() {
    listenCount = 0;
    channelStates = StreamController<ChannelState>.broadcast(onListen: () => listenCount += 1);
    addTearDown(channelStates.close);
  });

  Widget wrap(Widget child) {
    final client = MockClient();
    final clientState = MockClientState();
    final channel = MockChannel();
    final channelState = MockChannelState();

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(currentUser);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelState);
    when(() => channelState.channelState).thenReturn(const ChannelState(read: []));
    when(() => channelState.channelStateStream).thenAnswer((_) => channelStates.stream);

    return MaterialApp(
      home: StreamChat(
        client: client,
        connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
        child: StreamChannel(
          channel: channel,
          child: Scaffold(body: child),
        ),
      ),
    );
  }

  Future<void> pumpStatus(WidgetTester tester, Message message) async {
    await tester.pumpWidget(wrap(StreamMessageSendingStatus(message: message)));
    await tester.pump();
  }

  StreamSendingIndicator indicatorOf(WidgetTester tester) => tester.widget(find.byType(StreamSendingIndicator));

  testWidgets('StreamMessageSendingStatus shows the message as read once a read covering it arrives', (tester) async {
    await pumpStatus(tester, message);

    channelStates.add(
      ChannelState(
        read: [Read(user: otherUser, lastRead: createdAt.add(const Duration(minutes: 1)))],
      ),
    );
    await tester.pump();

    expect(indicatorOf(tester).isMessageRead, isTrue);
  });

  testWidgets('StreamMessageSendingStatus does not rebuild for a read that leaves its status unchanged', (
    tester,
  ) async {
    await pumpStatus(tester, message);
    final before = indicatorOf(tester);

    channelStates.add(
      ChannelState(
        read: [Read(user: otherUser, lastRead: createdAt.subtract(const Duration(minutes: 1)))],
      ),
    );
    await tester.pump();

    expect(identical(indicatorOf(tester), before), isTrue);
  });

  testWidgets('StreamMessageSendingStatus keeps its subscription when it rebuilds', (tester) async {
    await pumpStatus(tester, message);
    await pumpStatus(tester, message.copyWith(text: 'Hi again'));

    expect(listenCount, 1);
  });
}
