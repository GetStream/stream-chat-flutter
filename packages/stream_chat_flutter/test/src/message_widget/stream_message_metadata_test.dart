import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_sending_status.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  final currentUser = OwnUser(id: 'me', name: 'Luke Skywalker');
  final otherUser = User(id: 'han', name: 'Han Solo');

  Widget wrap(Widget body) {
    final client = MockClient();
    final clientState = MockClientState();
    final channel = MockChannel();
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
          child: Scaffold(
            body: StreamMessageLayout(
              data: const StreamMessageLayoutData(alignment: StreamMessageAlignment.end),
              child: Align(alignment: Alignment.topLeft, child: body),
            ),
          ),
        ),
      ),
    );
  }

  Message message({
    User? user,
    DateTime? messageTextUpdatedAt,
  }) {
    return Message(
      id: 'test-message',
      text: 'Are we still meeting tomorrow',
      createdAt: DateTime(2026, 8, 26, 15),
      user: user ?? currentUser,
      state: MessageState.sent,
      messageTextUpdatedAt: messageTextUpdatedAt,
    );
  }

  List<String> labelsOf(WidgetTester tester) {
    return tester.semantics.simulatedAccessibilityTraversal().map((it) => it.label).toList();
  }

  group('deleted message metadata', () {
    final deleted = Message(
      id: 'deleted-message',
      type: MessageType.deleted,
      createdAt: DateTime(2026, 8, 26, 15),
      deletedAt: DateTime(2026, 8, 26, 16),
      user: currentUser,
      state: MessageState.sent,
      messageTextUpdatedAt: DateTime(2026, 8, 26, 15, 30),
    );

    // The design shows a deleted message with the same timestamp and delivery
    // status as any other. Asserting on the composed label alone would pass
    // even if the footer stopped rendering, since the label is built from the
    // message rather than from what was laid out.
    testWidgets('renders the footer below the placeholder', (tester) async {
      await tester.pumpWidget(wrap(StreamMessageItem(message: deleted)));
      await tester.pumpAndSettle();

      expect(find.byType(StreamMessageFooter), findsOneWidget);
      expect(find.byType(StreamTimestamp), findsOneWidget);
    });

    testWidgets('renders the delivery status below the placeholder', (tester) async {
      await tester.pumpWidget(wrap(StreamMessageItem(message: deleted)));
      await tester.pumpAndSettle();

      expect(find.byType(StreamMessageSendingStatus), findsOneWidget);
    });

    testWidgets('drops the edited marker', (tester) async {
      await tester.pumpWidget(wrap(StreamMessageItem(message: deleted)));
      await tester.pumpAndSettle();

      // There is no text left to have been edited, so the marker would
      // describe history the reader can no longer see.
      final edited = DefaultTranslations.instance.editedMessageLabel;
      expect(find.text(edited), findsNothing);
    });

    testWidgets('keeps the edited marker on a message that still has text', (tester) async {
      await tester.pumpWidget(
        wrap(StreamMessageItem(message: message(messageTextUpdatedAt: DateTime(2026, 8, 26, 15, 30)))),
      );
      await tester.pumpAndSettle();

      final edited = DefaultTranslations.instance.editedMessageLabel;
      expect(find.text(edited), findsOneWidget);
    });
  });

  group('footer semantics outside a labeled row', () {
    // StreamGiphyEphemeralMessage builds a footer without going through
    // StreamMessageItem, so nothing composes a row label to speak its
    // metadata. Excluding the footer there would leave it announcing nothing
    // at all.
    testWidgets('announces its own parts', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(wrap(StreamMessageFooter(message: message())));
      await tester.pumpAndSettle();

      final a11y = DefaultTranslations.instance.accessibility;
      expect(labelsOf(tester), contains(a11y.messageSentStatusLabel));

      handle.dispose();
    });

    testWidgets('announces the timestamp', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(wrap(StreamMessageFooter(message: message())));
      await tester.pumpAndSettle();

      expect(labelsOf(tester).where((it) => it.contains('3:00 PM')), isNotEmpty);

      handle.dispose();
    });

    testWidgets('stays silent inside a row that speaks for it', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(wrap(StreamMessageItem(message: message())));
      await tester.pumpAndSettle();

      // The row label ends with the status, so the footer announcing it again
      // would cost a second stop that repeats what the row just said.
      final a11y = DefaultTranslations.instance.accessibility;
      final sent = labelsOf(tester).where((it) => it.contains(a11y.messageSentStatusLabel));
      expect(sent, hasLength(1));
      expect(sent.single, isNot(equals(a11y.messageSentStatusLabel)));

      handle.dispose();
    });

    testWidgets('announces the author name that a labeled row would suppress', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        wrap(
          StreamMessageLayout(
            data: const StreamMessageLayoutData(channelKind: StreamMessageChannelKind.group),
            child: StreamMessageFooter(message: message(user: otherUser)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(labelsOf(tester), contains('Han Solo'));

      handle.dispose();
    });
  });
}
