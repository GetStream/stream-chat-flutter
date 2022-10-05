import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/dialogs/confirmation_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('ChannelInfoDialog shows info and members', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) {
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
          }),
        ),
      ),
    );

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Mute User'), findsOneWidget);
    expect(
        find.text('Are you sure you want to mute this user?'), findsOneWidget);
    expect(find.text('MUTE'), findsOneWidget);
  });

  testGoldens('golden test for ConfirmationDialog', (tester) async {
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

    await screenMatchesGolden(tester, 'confirmation_dialog_0');
  });
}
