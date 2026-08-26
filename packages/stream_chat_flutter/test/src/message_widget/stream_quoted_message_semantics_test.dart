import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  group('StreamQuotedMessage reply attribution', () {
    final currentUser = OwnUser(id: 'me', name: 'Luke Skywalker');
    final han = User(id: 'han', name: 'Han Solo');
    final leia = User(id: 'leia', name: 'Leia Organa');

    const quotedText = 'are we still meeting tomorrow';

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
                data: const StreamMessageLayoutData(),
                child: Align(alignment: Alignment.topLeft, child: body),
              ),
            ),
          ),
        ),
      );
    }

    Widget buildScene(Message message) => wrap(StreamMessageItem(message: message));

    Message reply({required User by, required User to}) {
      return Message(
        id: 'reply',
        text: 'sure thing',
        createdAt: DateTime(2026, 8, 26, 15),
        user: by,
        state: MessageState.sent,
        quotedMessage: Message(
          id: 'quoted',
          text: quotedText,
          createdAt: DateTime(2026, 8, 26, 14),
          user: to,
          state: MessageState.sent,
        ),
      );
    }

    // The label the quoted preview contributes, merged with the body preview
    // below it into a single focus stop.
    Future<String> quotedLabel(WidgetTester tester, Message message) async {
      await tester.pumpWidget(buildScene(message));
      await tester.pumpAndSettle();

      return tester.semantics
          .simulatedAccessibilityTraversal()
          .map((it) => it.label)
          .singleWhere((it) => it.contains(quotedText));
    }

    testWidgets('someone replying to the current user names their message', (tester) async {
      final handle = tester.ensureSemantics();

      final label = await quotedLabel(tester, reply(by: han, to: currentUser));

      // Without this the preview announced only "Han Solo", saying nothing
      // about who was replied to.
      expect(label, startsWith('Han Solo replied to your message'));
      expect(label, contains(quotedText));

      handle.dispose();
    });

    testWidgets('the current user replying to someone names that someone', (tester) async {
      final handle = tester.ensureSemantics();

      final label = await quotedLabel(tester, reply(by: currentUser, to: leia));

      expect(label, startsWith("You replied to Leia Organa's message"));

      handle.dispose();
    });

    testWidgets('a reply between two other people names both', (tester) async {
      final handle = tester.ensureSemantics();

      final label = await quotedLabel(tester, reply(by: han, to: leia));

      expect(label, startsWith("Han Solo replied to Leia Organa's message"));

      handle.dispose();
    });

    testWidgets('the current user replying to themselves', (tester) async {
      final handle = tester.ensureSemantics();

      final label = await quotedLabel(tester, reply(by: currentUser, to: currentUser));

      expect(label, startsWith('You replied to your message'));

      handle.dispose();
    });

    testWidgets('the quoted preview stays a stop of its own', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(buildScene(reply(by: han, to: currentUser)));
      await tester.pumpAndSettle();

      final labels = tester.semantics.simulatedAccessibilityTraversal().map((it) => it.label).toList();

      // The row phrase comes first, the quote is reachable one level deeper
      // and can be activated to jump to the original.
      expect(labels.first, startsWith('Han Solo said, sure thing'));
      expect(labels[1], startsWith('Han Solo replied to your message'));

      handle.dispose();
    });

    testWidgets('falls back to the author name without a replying message', (tester) async {
      final handle = tester.ensureSemantics();

      // A consumer building the preview directly gets today's behaviour.
      await tester.pumpWidget(
        wrap(
          StreamQuotedMessage(
            quotedMessage: Message(
              id: 'quoted',
              text: quotedText,
              createdAt: DateTime(2026, 8, 26, 14),
              user: leia,
              state: MessageState.sent,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Leia Organa'), findsOneWidget);
      final labels = tester.semantics.simulatedAccessibilityTraversal().map((it) => it.label).toList();
      expect(labels.where((it) => it.contains('replied to')), isEmpty);

      handle.dispose();
    });
  });
}
