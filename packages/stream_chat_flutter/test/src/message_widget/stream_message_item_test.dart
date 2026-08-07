import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  group('StreamMessageItem thread replies label', () {
    final currentUser = OwnUser(id: 'current-user');
    final otherUser = User(id: 'other-user');

    Widget buildScene(int replyCount) {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(currentUser);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
      when(() => channel.client).thenReturn(client);
      when(() => channel.state).thenReturn(channelState);

      final message = Message(
        id: 'test-message',
        text: 'Parent message',
        createdAt: DateTime(2026),
        user: otherUser,
        state: MessageState.sent,
        replyCount: replyCount,
        threadParticipants: [otherUser],
      );

      return MaterialApp(
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: StreamMessageItem(message: message),
            ),
          ),
        ),
      );
    }

    // The label used to be a hardcoded `'$replyCount replies'`, which read
    // "1 replies" for a single reply. Asserting against
    // `threadReplyCountText` as well pins the label to the translations
    // table, so re-hardcoding it fails here even if the plural form is right.
    testWidgets('reads "1 reply" for a single reply', (tester) async {
      await tester.pumpWidget(buildScene(1));
      await tester.pumpAndSettle();

      expect(find.text('1 reply'), findsOneWidget);
      expect(
        find.text(DefaultTranslations.instance.threadReplyCountText(1)),
        findsOneWidget,
      );
    });

    testWidgets('reads "3 replies" for multiple replies', (tester) async {
      await tester.pumpWidget(buildScene(3));
      await tester.pumpAndSettle();

      expect(find.text('3 replies'), findsOneWidget);
      expect(
        find.text(DefaultTranslations.instance.threadReplyCountText(3)),
        findsOneWidget,
      );
    });

    testWidgets('is not rendered when there are no replies', (tester) async {
      await tester.pumpWidget(buildScene(0));
      await tester.pumpAndSettle();

      expect(find.textContaining('repl'), findsNothing);
    });
  });
}
