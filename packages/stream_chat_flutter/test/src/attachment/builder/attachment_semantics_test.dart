import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

void main() {
  group('media attachment semantics', () {
    final currentUser = OwnUser(id: 'current-user');
    final otherUser = User(id: 'other-user', name: 'Han Solo');

    Widget buildScene(Message message) {
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
                child: StreamMessageItem(message: message),
              ),
            ),
          ),
        ),
      );
    }

    Message message(List<Attachment> attachments, {String? text}) {
      return Message(
        id: 'test-message',
        text: text,
        createdAt: DateTime(2026, 8, 26, 15),
        user: otherUser,
        state: MessageState.sent,
        attachments: attachments,
      );
    }

    Attachment image({String? title}) {
      return Attachment(
        type: AttachmentType.image,
        title: title,
        imageUrl: 'https://example.com/image.png',
      );
    }

    List<String> labelsOf(WidgetTester tester) {
      return tester.semantics.simulatedAccessibilityTraversal().map((it) => it.label).toList();
    }

    testWidgets('a single image tile announces its type', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(buildScene(message([image()], text: 'look')));
      await tester.pumpAndSettle();

      // Without a label the tile is still focusable — it opens a preview on
      // tap — but announces nothing at all.
      final a11y = DefaultTranslations.instance.accessibility;
      expect(labelsOf(tester), contains(a11y.imageAttachmentLabel()));

      handle.dispose();
    });

    testWidgets('a titled image tile announces its title', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(buildScene(message([image(title: 'sunset.png')])));
      await tester.pumpAndSettle();

      final a11y = DefaultTranslations.instance.accessibility;
      expect(labelsOf(tester), contains(a11y.imageAttachmentLabel(title: 'sunset.png')));

      handle.dispose();
    });

    testWidgets('gallery tiles announce their position', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildScene(message([image(), image(title: 'sunset.png'), image()])),
      );
      await tester.pumpAndSettle();

      // Otherwise identical thumbnails need telling apart.
      expect(
        labelsOf(tester),
        containsAllInOrder([
          'Photo, 1 of 3',
          'Photo, sunset.png, 2 of 3',
          'Photo, 3 of 3',
        ]),
      );

      handle.dispose();
    });

    testWidgets('the row summary is announced before its tiles', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(buildScene(message([image(), image()])));
      await tester.pumpAndSettle();

      final labels = labelsOf(tester);
      expect(labels.first, startsWith('Han Solo said,'));
      expect(labels.skip(1), everyElement(startsWith('Photo,')));

      handle.dispose();
    });

    testWidgets('an over-full gallery does not announce the overflow badge', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildScene(message(List.generate(6, (_) => image()))),
      );
      await tester.pumpAndSettle();

      final labels = labelsOf(tester);
      // Only four tiles are rendered; their "of 6" already says the gallery
      // holds more, so the "+2" badge would be a second, cryptic stop.
      expect(labels.where((it) => it.contains('of 6')), hasLength(4));
      expect(labels, isNot(contains('+2')));

      handle.dispose();
    });
  });
}
