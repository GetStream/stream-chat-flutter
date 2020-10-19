import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/reaction_bubble.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets(
    'it should show no reactions',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData(),
            child: Container(
              child: ReactionBubble(
                reactions: [],
                borderColor: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(StreamIcons.thumbs_up_reaction), findsNothing);
    },
  );

  testWidgets(
    'it should show a thumb up',
    (WidgetTester tester) async {
      final themeData = ThemeData();
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChatTheme(
            data: StreamChatThemeData.getDefaultTheme(themeData),
            child: Container(
              child: ReactionBubble(
                reactions: [
                  Reaction(
                    type: 'thumbs_up',
                  ),
                ],
                borderColor: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(StreamIcons.thumbs_up_reaction), findsOneWidget);
    },
  );
  testWidgets(
    'it should show two reactions',
    (WidgetTester tester) async {
      final themeData = ThemeData();
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChatTheme(
            data: StreamChatThemeData.getDefaultTheme(themeData),
            child: Container(
              child: ReactionBubble(
                reactions: [
                  Reaction(
                    type: 'thumbs_up',
                  ),
                  Reaction(
                    type: 'love',
                  ),
                ],
                borderColor: Colors.black,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(StreamIcons.thumbs_up_reaction), findsOneWidget);
      expect(find.byIcon(StreamIcons.love_reaction), findsOneWidget);
    },
  );
}
