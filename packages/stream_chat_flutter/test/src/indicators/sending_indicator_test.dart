import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../material_app_wrapper.dart';

void main() {
  testWidgets(
    'StreamSendingIndicator shows sizedBox if message state is initial',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData(),
            child: Scaffold(
              body: Center(
                child: StreamSendingIndicator(
                  message: Message(),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
    },
  );

  goldenTest(
    'golden test for StreamSendingIndicator with Icon checkAll',
    fileName: 'sending_indicator_0',
    constraints: const BoxConstraints.tightFor(width: 50, height: 50),
    builder: () => MaterialAppWrapper(
      home: StreamChatTheme(
        data: StreamChatThemeData(),
        child: Scaffold(
          body: Center(
            child: StreamSendingIndicator(
              isMessageRead: true,
              message: Message(),
            ),
          ),
        ),
      ),
    ),
  );

  goldenTest(
    'golden test for StreamSendingIndicator with Icon checkAll '
    '(delivered)',
    fileName: 'sending_indicator_1',
    constraints: const BoxConstraints.tightFor(width: 50, height: 50),
    builder: () => MaterialAppWrapper(
      home: StreamChatTheme(
        data: StreamChatThemeData(),
        child: Scaffold(
          body: Center(
            child: StreamSendingIndicator(
              isMessageDelivered: true,
              message: Message(
                state: MessageState.sent,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  goldenTest(
    'golden test for StreamSendingIndicator with Icon check',
    fileName: 'sending_indicator_2',
    constraints: const BoxConstraints.tightFor(width: 50, height: 50),
    builder: () => MaterialAppWrapper(
      home: StreamChatTheme(
        data: StreamChatThemeData(),
        child: Scaffold(
          body: Center(
            child: StreamSendingIndicator(
              message: Message(
                state: MessageState.sent,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  goldenTest(
    'golden test for StreamSendingIndicator with clock icon',
    fileName: 'sending_indicator_3',
    constraints: const BoxConstraints.tightFor(width: 50, height: 50),
    builder: () => MaterialAppWrapper(
      home: StreamChatTheme(
        data: StreamChatThemeData(),
        child: Scaffold(
          body: Center(
            child: StreamSendingIndicator(
              message: Message(
                state: MessageState.sending,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  testWidgets(
    'shows checkAll icon with textLowEmphasis color when message is delivered',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData(),
            child: Scaffold(
              body: Center(
                child: StreamSendingIndicator(
                  isMessageDelivered: true,
                  message: Message(
                    state: MessageState.sent,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(
        find.byType(Icon),
      );

      expect(icon.icon, StreamIconData.checks);
      expect(
        icon.color,
        StreamColorScheme.light().textSecondary,
      );
    },
  );

  testWidgets(
    'shows checkAll icon with accentPrimary color when message is read',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData(),
            child: Scaffold(
              body: Center(
                child: StreamSendingIndicator(
                  isMessageRead: true,
                  message: Message(
                    state: MessageState.sent,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(
        find.byType(Icon),
      );

      expect(icon.icon, StreamIconData.checks);
      expect(
        icon.color,
        StreamColorScheme.light().accentPrimary,
      );
    },
  );

  testWidgets(
    'prioritizes read over delivered when both are true',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData(),
            child: Scaffold(
              body: Center(
                child: StreamSendingIndicator(
                  isMessageRead: true,
                  isMessageDelivered: true,
                  message: Message(
                    state: MessageState.sent,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(
        find.byType(Icon),
      );

      expect(icon.icon, StreamIconData.checks);
      // Should use accentPrimary (read) not textLowEmphasis (delivered)
      expect(
        icon.color,
        StreamColorScheme.light().accentPrimary,
      );
    },
  );

  // An explicit color is what lets the long-press preview draw the indicator in
  // white against the modal scrim, where both accentPrimary and textSecondary
  // lack contrast. See FLU-647.
  group('StreamSendingIndicator color override', () {
    const override = Color(0xFF4CAF50);

    Future<Icon> pumpIndicator(
      WidgetTester tester, {
      required Message message,
      bool isMessageRead = false,
      bool isMessageDelivered = false,
      Color? color,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData(),
            child: Scaffold(
              body: Center(
                child: StreamSendingIndicator(
                  message: message,
                  isMessageRead: isMessageRead,
                  isMessageDelivered: isMessageDelivered,
                  color: color,
                ),
              ),
            ),
          ),
        ),
      );

      return tester.widget<Icon>(find.byType(Icon));
    }

    testWidgets('applies to the read indicator', (tester) async {
      final icon = await pumpIndicator(
        tester,
        message: Message(state: MessageState.sent),
        isMessageRead: true,
        color: override,
      );

      expect(icon.color, override);
    });

    testWidgets('applies to the delivered indicator', (tester) async {
      final icon = await pumpIndicator(
        tester,
        message: Message(state: MessageState.sent),
        isMessageDelivered: true,
        color: override,
      );

      expect(icon.color, override);
    });

    testWidgets('applies to the sent indicator', (tester) async {
      final icon = await pumpIndicator(
        tester,
        message: Message(state: MessageState.sent),
        color: override,
      );

      expect(icon.color, override);
    });

    testWidgets('applies to the sending indicator', (tester) async {
      final icon = await pumpIndicator(
        tester,
        message: Message(state: MessageState.sending),
        color: override,
      );

      expect(icon.color, override);
    });

    testWidgets('falls back to the theme colors when null', (tester) async {
      final colorScheme = StreamColorScheme.light();

      final read = await pumpIndicator(
        tester,
        message: Message(state: MessageState.sent),
        isMessageRead: true,
      );
      expect(read.color, colorScheme.accentPrimary);

      final sent = await pumpIndicator(
        tester,
        message: Message(state: MessageState.sent),
      );
      expect(sent.color, colorScheme.textSecondary);
    });
  });
}
