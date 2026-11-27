import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_list_view/floating_date_divider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets('StreamMessageListView labels the day of the message at the top of the list', (tester) async {
    await _pumpMessageList(tester);

    expect(_floatingDividerDay(tester), _dayOfTopMessage(tester));
  });

  testWidgets('StreamMessageListView labels the day of the message at the top after scrolling up', (tester) async {
    await _pumpMessageList(tester);

    await tester.drag(find.byType(StreamMessageListView), const Offset(0, 600));
    await tester.pumpAndSettle();

    expect(_floatingDividerDay(tester), _dayOfTopMessage(tester));
  });
}

// The day the floating date divider shows.
DateTime _floatingDividerDay(WidgetTester tester) {
  final divider = find.descendant(of: find.byType(FloatingDateDivider), matching: find.byType(StreamDateDivider));
  return tester.widget<StreamDateDivider>(divider).dateTime;
}

// The day of the topmost message still in view below the top of the list.
//
// Each message's text names its day, as written by [_messagesOnSeparateDays].
DateTime _dayOfTopMessage(WidgetTester tester) {
  final listTop = tester.getRect(find.byType(StreamMessageListView)).top;
  final texts = find.textContaining(RegExp(r'^Message on day \d+$'), findRichText: true);

  Element? topText;
  var topEdge = double.infinity;
  for (final element in texts.evaluate()) {
    final rect = tester.getRect(find.byElementPredicate((it) => it == element));
    if (rect.bottom <= listTop) continue;
    if (rect.top >= topEdge) continue;

    topText = element;
    topEdge = rect.top;
  }

  final text = switch (topText!.widget) {
    final RichText richText => richText.text.toPlainText(),
    final Text plainText => plainText.data!,
    final other => throw StateError('Unexpected text widget: $other'),
  };
  final day = int.parse(RegExp(r'on day (\d+)$').firstMatch(text)!.group(1)!);
  return _dateOfDay(day);
}

// The start of day [day] of [_messagesOnSeparateDays].
DateTime _dateOfDay(int day) => DateTime(2026, 9, 1 + day);

// Thirty messages, oldest first, each sent on a day of its own.
//
// A message one item away from another is always from a different day.
List<Message> _messagesOnSeparateDays() => [
  for (var day = 0; day < 30; day += 1)
    Message(
      id: 'day$day',
      text: 'Message on day $day',
      user: User(id: 'otherid'),
      createdAt: _dateOfDay(day).add(const Duration(hours: 9)),
    ),
];

// Pumps a [StreamMessageListView] showing [_messagesOnSeparateDays].
//
// The floating date divider is kept opaque so it stays in the tree.
Future<void> _pumpMessageList(WidgetTester tester) async {
  final client = MockClient();
  final clientState = MockClientState();
  when(() => client.state).thenAnswer((_) => clientState);
  final ownUser = OwnUser(id: 'ownid');
  when(() => clientState.currentUser).thenReturn(ownUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(ownUser));

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
  when(
    () => channel.markRead(messageId: any(named: 'messageId')),
  ).thenAnswer((_) async => const Result.success(MarkReadResponse(duration: '0ms')));

  final messages = _messagesOnSeparateDays();
  when(() => channelClientState.messages).thenReturn(messages);

  await tester.runAsync(() async {
    await tester.pumpWidget(
      MaterialApp(
        home: DefaultAssetBundle(
          bundle: rootBundle,
          child: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: const StreamMessageListView(
                config: StreamMessageListViewConfiguration(fadeFloatingDateDividerNearInline: false),
              ),
            ),
          ),
        ),
      ),
    );
    messagesController.add(messages);
    await tester.pumpAndSettle();
  });
}
