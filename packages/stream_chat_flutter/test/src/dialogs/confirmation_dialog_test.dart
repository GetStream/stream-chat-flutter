import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:stream_chat_flutter/src/dialogs/confirmation_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';

void main() {
  group('ConfirmationDialog tests', () {
    testWidgets('renders with title, prompt, and action', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Center(
                  child: StreamChatTheme(
                    data: StreamChatThemeData.light(),
                    child: ConfirmationDialog(
                      titleText: context.translations
                          .toggleMuteUnmuteUserText(isMuted: false),
                      promptText: context.translations
                          .toggleMuteUnmuteUserQuestion(isMuted: false),
                      affirmativeText: context.translations
                          .toggleMuteUnmuteAction(isMuted: false),
                      onConfirmation: () {},
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Mute User'), findsOneWidget);
      expect(find.text('Are you sure you want to mute this user?'),
          findsOneWidget);
      expect(find.text('MUTE'), findsOneWidget);
    });

    goldenTest(
      'golden test for ConfirmationDialog',
      fileName: 'confirmation_dialog_0',
      constraints: const BoxConstraints.tightFor(width: 400, height: 300),
      builder: () => MaterialAppWrapper(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return Center(
                child: StreamChatTheme(
                  data: StreamChatThemeData.light(),
                  child: ConfirmationDialog(
                    titleText: context.translations
                        .toggleMuteUnmuteUserText(isMuted: false),
                    promptText: context.translations
                        .toggleMuteUnmuteUserQuestion(isMuted: false),
                    affirmativeText: context.translations
                        .toggleMuteUnmuteAction(isMuted: false),
                    onConfirmation: () {},
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  });
}
