import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_reactions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

// Returns sentinels that no hardcoded English label could produce, so both the
// singular and the plural case prove the widget went through `translations`.
class _FakeLocalizations implements StreamChatLocalizations {
  @override
  String threadReplyCountText(int count) => count == 1 ? 'singular:$count' : 'plural:$count';

  // Strings the rest of the row needs; only the label under test is faked.
  @override
  AccessibilityTranslations get accessibility => DefaultTranslations.instance.accessibility;

  // Anything else throws instead of resolving to null, so an unstubbed lookup
  // fails the test loudly rather than rendering an empty label.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeLocalizationsDelegate extends LocalizationsDelegate<StreamChatLocalizations> {
  const _FakeLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<StreamChatLocalizations> load(Locale locale) async => _FakeLocalizations();

  @override
  bool shouldReload(_FakeLocalizationsDelegate old) => false;
}

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
        localizationsDelegates: const [_FakeLocalizationsDelegate()],
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

    testWidgets('takes the singular label from the injected translations', (tester) async {
      await tester.pumpWidget(buildScene(1));
      await tester.pumpAndSettle();

      expect(find.text('singular:1'), findsOneWidget);
      expect(find.text(DefaultTranslations.instance.threadReplyCountText(1)), findsNothing);
    });

    testWidgets('takes the plural label from the injected translations', (tester) async {
      await tester.pumpWidget(buildScene(3));
      await tester.pumpAndSettle();

      expect(find.text('plural:3'), findsOneWidget);
      expect(find.text(DefaultTranslations.instance.threadReplyCountText(3)), findsNothing);
    });

    testWidgets('is not rendered when there are no replies', (tester) async {
      await tester.pumpWidget(buildScene(0));
      await tester.pumpAndSettle();

      expect(find.textContaining('singular:'), findsNothing);
      expect(find.textContaining('plural:'), findsNothing);
      // A hardcoded label would render the default "0 replies" here.
      expect(find.text(DefaultTranslations.instance.threadReplyCountText(0)), findsNothing);
    });
  });

  group('StreamMessageItem reaction long press', () {
    final currentUser = OwnUser(id: 'current-user');
    final otherUser = User(id: 'other-user');

    Widget buildScene({
      OnReactionLongPress? onReactionLongPress,
      void Function(Message)? onMessageLongPress,
    }) {
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
        reactionGroups: {'love': ReactionGroup(count: 2)},
      );

      // Wrapping above the navigator keeps pushed routes — the reaction detail
      // sheet — under StreamChat and StreamChannel. The sheet renders shipped
      // strings, so this group uses the real translations.
      return MaterialApp(
        builder: (context, child) => StreamChat(
          client: client,
          connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
          child: StreamChannel(channel: channel, child: child!),
        ),
        home: Scaffold(
          body: StreamMessageItem(
            message: message,
            onReactionLongPress: onReactionLongPress,
            onMessageLongPress: onMessageLongPress,
          ),
        ),
      );
    }

    // The reaction chips sit inside the message row's own long-press InkWell,
    // so both recognizers enter the same gesture arena. The chip always
    // registers one, so it always wins over the message's own long press.
    Finder reactionChip() => find.descendant(
      of: find.byType(StreamMessageReactions),
      matching: find.byType(IconButton),
    );

    testWidgets('reports the long-pressed reaction', (tester) async {
      Reaction? longPressed;

      await tester.pumpWidget(
        buildScene(onReactionLongPress: (_, details) => longPressed = details.reaction),
      );
      await tester.pumpAndSettle();

      await tester.longPress(reactionChip().first);
      await tester.pumpAndSettle();

      expect(longPressed?.type, 'love');
    });

    testWidgets('takes precedence over the message long press', (tester) async {
      var messageLongPressed = false;

      await tester.pumpWidget(
        buildScene(
          onReactionLongPress: (_, __) {},
          onMessageLongPress: (_) => messageLongPressed = true,
        ),
      );
      await tester.pumpAndSettle();

      await tester.longPress(reactionChip().first);
      await tester.pumpAndSettle();

      expect(messageLongPressed, isFalse);
    });

    testWidgets('opens the detail sheet filtered to the reaction by default', (tester) async {
      // The sheet needs more height than the default test surface.
      tester.view.physicalSize = const Size(1200, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      var messageLongPressed = false;

      await tester.pumpWidget(
        buildScene(onMessageLongPress: (_) => messageLongPressed = true),
      );
      await tester.pumpAndSettle();

      await tester.longPress(reactionChip().first);
      await tester.pumpAndSettle();

      final sheet = tester.widget<ReactionDetailSheet>(find.byType(ReactionDetailSheet));
      expect(sheet.initialReactionType, 'love');
      // The default pre-empts the message's long press rather than falling
      // through to the actions modal.
      expect(messageLongPressed, isFalse);
    });
  });

  // The widget tests above deliberately never see the shipped strings, so pin
  // the default table's pluralization here.
  test('DefaultTranslations pluralizes the thread reply count', () {
    expect(DefaultTranslations.instance.threadReplyCountText(1), '1 reply');
    expect(DefaultTranslations.instance.threadReplyCountText(3), '3 replies');
  });
}
