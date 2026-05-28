// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_end_vote_dialog.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  group('showPollEndVoteDialog', () {
    testWidgets(
      "returns 'True' when 'End' button is pressed",
      (tester) async {
        bool? value;

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            Builder(
              builder: (context) => Center(
                child: TextButton(
                  onPressed: () async {
                    value = await showPollEndVoteDialog(context: context);
                  },
                  child: const Text('End Vote'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('End Vote'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('End'));
        await tester.pumpAndSettle();

        expect(value, isTrue);
      },
    );

    testWidgets(
      "returns 'False' when 'Cancel' button is pressed",
      (tester) async {
        bool? value;

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            Builder(
              builder: (context) => Center(
                child: TextButton(
                  onPressed: () async {
                    value = await showPollEndVoteDialog(context: context);
                  },
                  child: const Text('End Vote'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('End Vote'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(value, isFalse);
      },
    );

    testWidgets(
      "returns 'null' when dialog is dismissed",
      (tester) async {
        bool? value;

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            Builder(
              builder: (context) => Center(
                child: TextButton(
                  onPressed: () async {
                    value = await showPollEndVoteDialog(context: context);
                  },
                  child: const Text('End Vote'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('End Vote'));
        await tester.pumpAndSettle();

        await tester.tapAt(Offset.zero);

        expect(value, isNull);
      },
    );
  });

  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> PollEndVoteDialog looks fine',
      fileName: 'poll_end_vote_dialog_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 400, height: 220),
      builder: () => _wrapWithMaterialApp(
        const PollEndVoteDialog(),
        brightness: brightness,
      ),
    );
  }
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  Brightness brightness = Brightness.light,
}) {
  return StreamChatTheme(
    data: StreamChatThemeData(),
    child: MaterialApp(
      theme: ThemeData(brightness: brightness),
      home: widget,
    ),
  );
}
