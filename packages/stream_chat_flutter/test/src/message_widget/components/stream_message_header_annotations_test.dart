import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../../mocks.dart';

void main() {
  group('DefaultStreamMessageHeader show-in-channel annotation', () {
    final currentUser = OwnUser(id: 'current-user');

    Future<void> pumpHeader(
      WidgetTester tester, {
      required Message message,
      core.StreamMessageListKind listKind = .channel,
      VoidCallback? onViewChannelTap,
    }) {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(currentUser);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));

      return tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: core.StreamMessageLayout(
                data: core.StreamMessageLayoutData(listKind: listKind),
                child: DefaultStreamMessageHeader(
                  props: StreamMessageHeaderProps(
                    message: message,
                    onViewChannelTap: onViewChannelTap,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final threadReply = Message(
      id: 'thread-reply',
      text: 'Also visible in the channel',
      createdAt: DateTime(2026),
      user: User(id: 'other-user'),
      showInChannel: true,
    );

    testWidgets('reads "Replied to a thread" when shown in a channel list', (tester) async {
      await pumpHeader(tester, message: threadReply, listKind: .channel);

      expect(find.text('Replied to a thread'), findsOneWidget);
      expect(find.text('·'), findsOneWidget);
      expect(find.text('View'), findsOneWidget);
    });

    testWidgets('reads "Also sent in channel" when shown in a thread list', (tester) async {
      await pumpHeader(tester, message: threadReply, listKind: .thread);

      expect(find.text('Also sent in channel'), findsOneWidget);
      expect(find.text('·'), findsOneWidget);
      expect(find.text('View'), findsOneWidget);
    });

    testWidgets('invokes onViewChannelTap when the "View" link is tapped', (tester) async {
      var tapped = false;
      await pumpHeader(
        tester,
        message: threadReply,
        onViewChannelTap: () => tapped = true,
      );

      await tester.tap(find.text('View'));
      expect(tapped, isTrue);
    });

    testWidgets('is absent when showInChannel is false', (tester) async {
      final message = threadReply.copyWith(showInChannel: false);
      await pumpHeader(tester, message: message);

      expect(find.text('Replied to a thread'), findsNothing);
      expect(find.text('Also sent in channel'), findsNothing);
    });
  });

  group('DefaultStreamMessageHeader reminder annotation', () {
    final currentUser = OwnUser(id: 'current-user');

    Future<void> pumpHeader(WidgetTester tester, {required Message message}) {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(currentUser);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));

      return tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: core.StreamMessageLayout(
                data: const core.StreamMessageLayoutData(),
                child: DefaultStreamMessageHeader(
                  props: StreamMessageHeaderProps(message: message),
                ),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('shows the reminder label and separator when remindAt is set', (tester) async {
      final remindAt = DateTime(2026, 1, 1, 18);
      final message = Message(
        id: 'reminded-message',
        text: 'Do not forget',
        createdAt: DateTime(2026),
        user: User(id: 'other-user'),
        reminder: MessageReminder(
          messageId: 'reminded-message',
          channelCid: 'messaging:test',
          userId: currentUser.id,
          remindAt: remindAt,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      );

      await pumpHeader(tester, message: message);

      expect(find.text('Reminder set'), findsOneWidget);
      expect(find.text('Today at 6:00 PM'), findsOneWidget);
      expect(find.text('·'), findsOneWidget);
    });
  });
}
