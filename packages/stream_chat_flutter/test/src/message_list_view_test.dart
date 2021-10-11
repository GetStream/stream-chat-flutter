import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  late StreamChatClient client;
  late Channel channel;

  setUp(() {
    client = MockClient();
    channel = MockChannel();
    when(() => channel.on(any(), any(), any(), any()))
        .thenAnswer((_) => const Stream.empty());
    final channelClientState = MockChannelState();
    when(() => channel.state).thenReturn(channelClientState);
    when(() => channelClientState.threadsStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.messagesStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.messages).thenReturn([]);
    when(() => channelClientState.isUpToDate).thenReturn(true);
    when(() => channelClientState.isUpToDateStream)
        .thenAnswer((_) => Stream.value(true));
  });

  // https://github.com/GetStream/stream-chat-flutter/issues/674
  testWidgets('renders empty message list view', (tester) async {
    const emptyWidgetKey = Key('empty_widget');

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: MessageListView(
              emptyBuilder: (_) => Container(key: emptyWidgetKey),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MessageListView), findsOneWidget);
    expect(find.byKey(emptyWidgetKey), findsOneWidget);
  });
}
