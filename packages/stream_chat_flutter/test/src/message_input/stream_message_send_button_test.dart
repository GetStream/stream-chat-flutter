// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/message_input/stream_message_input_icon_button.dart';
import 'package:stream_chat_flutter/src/message_input/stream_message_send_button.dart';
import 'package:stream_chat_flutter/src/theme/message_input_theme.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

import '../utils/finders.dart';

void main() {
  group('StreamMessageSendButton', () {
    testWidgets(
      'renders countdown button when timeout > 0',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamMessageSendButton(
              timeOut: 5,
              onSendMessage: () {},
            ),
          ),
        );

        expect(find.byKey(const Key('countdown_button')), findsOneWidget);
        expect(find.byKey(const Key('send_button')), findsNothing);
      },
    );

    testWidgets(
      'renders idle send button when isIdle is true',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamMessageSendButton(
              isIdle: true,
              onSendMessage: () {},
            ),
          ),
        );

        final button = find.byKey(const Key('send_button'));
        expect(button, findsOneWidget);

        // Verify the button is disabled
        final iconButton = tester.widget<StreamMessageInputIconButton>(button);
        expect(iconButton.onPressed, isNull);

        // Verify default idle icon is shown
        expect(find.bySvgIcon(StreamSvgIcons.sendMessage), findsOneWidget);
      },
    );

    testWidgets(
      'renders active send button when isIdle is false',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamMessageSendButton(
              isIdle: false,
              onSendMessage: () {},
            ),
          ),
        );

        final button = find.byKey(const Key('send_button'));
        expect(button, findsOneWidget);

        // Verify the button is enabled
        final iconButton = tester.widget<StreamMessageInputIconButton>(button);
        expect(iconButton.onPressed, isNotNull);

        // Verify default active icon is shown
        expect(find.bySvgIcon(StreamSvgIcons.circleUp), findsOneWidget);
      },
    );

    testWidgets(
      'uses custom idle button when provided',
      (tester) async {
        final customIdleButton = Container(key: const Key('custom_idle'));

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamMessageSendButton(
              isIdle: true,
              idleSendButton: customIdleButton,
              onSendMessage: () {},
            ),
          ),
        );

        expect(find.byKey(const Key('custom_idle')), findsOneWidget);
        expect(find.byType(StreamSvgIcon), findsNothing);
      },
    );

    testWidgets(
      'uses custom active button when provided',
      (tester) async {
        final customActiveButton = Container(key: const Key('custom_active'));

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamMessageSendButton(
              isIdle: false,
              activeSendButton: customActiveButton,
              onSendMessage: () {},
            ),
          ),
        );

        expect(find.byKey(const Key('custom_active')), findsOneWidget);
        expect(find.byType(StreamSvgIcon), findsNothing);
      },
    );

    testWidgets(
      'calls onSendMessage when active button is pressed',
      (tester) async {
        var wasPressed = false;

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamMessageSendButton(
              isIdle: false,
              onSendMessage: () => wasPressed = true,
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('send_button')));
        expect(wasPressed, isTrue);
      },
    );

    testWidgets(
      'applies theme colors correctly',
      (tester) async {
        const theme = StreamMessageInputThemeData(
          sendButtonColor: Colors.blue,
          sendButtonIdleColor: Colors.grey,
          sendAnimationDuration: Duration(milliseconds: 100),
        );

        await tester.pumpWidget(
          _wrapWithStreamChatApp(
            StreamMessageInputTheme(
              data: theme,
              child: StreamMessageSendButton(
                isIdle: false,
                onSendMessage: () {},
              ),
            ),
          ),
        );

        final iconButton = tester.widget<StreamMessageInputIconButton>(
          find.byKey(const Key('send_button')),
        );

        expect(iconButton.color, Colors.blue);
        expect(iconButton.disabledColor, Colors.grey);
      },
    );
  });
}

Widget _wrapWithStreamChatApp(
  Widget widget, {
  Brightness? brightness,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StreamChatTheme(
      data: StreamChatThemeData(brightness: brightness),
      child: Builder(builder: (context) {
        final theme = StreamChatTheme.of(context);
        return Scaffold(
          backgroundColor: theme.colorTheme.appBg,
          bottomNavigationBar: Material(
            elevation: 10,
            color: theme.colorTheme.barsBg,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: widget,
            ),
          ),
        );
      }),
    ),
  );
}
