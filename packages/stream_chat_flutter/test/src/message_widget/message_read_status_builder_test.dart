import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter/src/message_widget/message_read_status_builder.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  final currentUser = OwnUser(id: 'me');
  final otherUser = User(id: 'other');
  final createdAt = DateTime(2026, 10, 1, 12);
  final message = Message(id: 'm1', text: 'Hi', createdAt: createdAt, user: currentUser, state: MessageState.sent);

  late BehaviorSubject<ChannelState> channelStates;
  late Channel channel;

  setUp(() {
    channelStates = BehaviorSubject.seeded(const ChannelState(read: []));
    addTearDown(channelStates.close);

    final channelState = MockChannelState();
    when(() => channelState.channelState).thenAnswer((_) => channelStates.value);
    when(() => channelState.channelStateStream).thenAnswer((_) => channelStates.stream);

    channel = MockChannel();
    when(() => channel.state).thenReturn(channelState);
  });

  Widget buildStatusOf(Message message) {
    return MessageReadStatusBuilder(
      channel: channel,
      message: message,
      builder: (context, status) => Text(status.isMessageRead ? 'read' : 'unread', textDirection: .ltr),
    );
  }

  testWidgets('MessageReadStatusBuilder recomputes the status when the message is re-dated', (tester) async {
    await tester.pumpWidget(buildStatusOf(message));
    channelStates.add(
      ChannelState(
        read: [Read(user: otherUser, lastRead: createdAt.subtract(const Duration(minutes: 1)))],
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('unread'), findsOneWidget);

    await tester.pumpWidget(buildStatusOf(message.copyWith(createdAt: createdAt.subtract(const Duration(minutes: 2)))));
    await tester.pumpAndSettle();

    expect(find.text('read'), findsOneWidget);
  });
}
