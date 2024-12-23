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

  testWidgets(
    'StreamSendingIndicator shows an Icon if message state is sending',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
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

      expect(find.byType(Icon), findsOneWidget);
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
    'golden test for StreamSendingIndicator with StreamSvgIcon.check',
    fileName: 'sending_indicator_1',
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
    'golden test for StreamSendingIndicator with Icon(Icons.access_time)',
    fileName: 'sending_indicator_2',
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
}
