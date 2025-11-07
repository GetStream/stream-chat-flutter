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
            data: StreamChatThemeData.light(),
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
    'golden test for StreamSendingIndicator with StreamSvgIcon.checkAll',
    fileName: 'sending_indicator_0',
    constraints: const BoxConstraints.tightFor(width: 50, height: 50),
    builder: () => MaterialAppWrapper(
      home: StreamChatTheme(
        data: StreamChatThemeData.light(),
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
    'golden test for StreamSendingIndicator with StreamSvgIcon.checkAll '
    '(delivered)',
    fileName: 'sending_indicator_1',
    constraints: const BoxConstraints.tightFor(width: 50, height: 50),
    builder: () => MaterialAppWrapper(
      home: StreamChatTheme(
        data: StreamChatThemeData.light(),
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
    'golden test for StreamSendingIndicator with StreamSvgIcon.check',
    fileName: 'sending_indicator_2',
    constraints: const BoxConstraints.tightFor(width: 50, height: 50),
    builder: () => MaterialAppWrapper(
      home: StreamChatTheme(
        data: StreamChatThemeData.light(),
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
    'golden test for StreamSendingIndicator with StreamSvgIcons.time',
    fileName: 'sending_indicator_3',
    constraints: const BoxConstraints.tightFor(width: 50, height: 50),
    builder: () => MaterialAppWrapper(
      home: StreamChatTheme(
        data: StreamChatThemeData.light(),
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
            data: StreamChatThemeData.light(),
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

      final streamSvgIcon = tester.widget<StreamSvgIcon>(
        find.byType(StreamSvgIcon),
      );

      expect(streamSvgIcon.icon, StreamSvgIcons.checkAll);
      expect(
        streamSvgIcon.color,
        StreamChatThemeData.light().colorTheme.textLowEmphasis,
      );
    },
  );

  testWidgets(
    'shows checkAll icon with accentPrimary color when message is read',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData.light(),
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

      final streamSvgIcon = tester.widget<StreamSvgIcon>(
        find.byType(StreamSvgIcon),
      );

      expect(streamSvgIcon.icon, StreamSvgIcons.checkAll);
      expect(
        streamSvgIcon.color,
        StreamChatThemeData.light().colorTheme.accentPrimary,
      );
    },
  );

  testWidgets(
    'prioritizes read over delivered when both are true',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData.light(),
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

      final streamSvgIcon = tester.widget<StreamSvgIcon>(
        find.byType(StreamSvgIcon),
      );

      expect(streamSvgIcon.icon, StreamSvgIcons.checkAll);
      // Should use accentPrimary (read) not textLowEmphasis (delivered)
      expect(
        streamSvgIcon.color,
        StreamChatThemeData.light().colorTheme.accentPrimary,
      );
    },
  );
}
