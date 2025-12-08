import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/poll/creator/stream_delete_option_dialog.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  group('showPollDeleteOptionDialog', () {
    testWidgets(
      "returns 'True' when 'Delete' button is pressed",
      (tester) async {
        bool? value;

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            Builder(
              builder: (context) => Center(
                child: TextButton(
                  onPressed: () async {
                    value = await showPollDeleteOptionDialog(context: context);
                  },
                  child: const Text('Delete Option'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Delete Option'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('DELETE'));
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
                    value = await showPollDeleteOptionDialog(context: context);
                  },
                  child: const Text('Delete Option'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Delete Option'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('CANCEL'));
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
                    value = await showPollDeleteOptionDialog(context: context);
                  },
                  child: const Text('Delete Option'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Delete Option'));
        await tester.pumpAndSettle();

        await tester.tapAt(Offset.zero);
        await tester.pumpAndSettle();

        expect(value, isNull);
      },
    );
  });

  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> PollDeleteOptionDialog looks fine',
      fileName: 'poll_delete_option_dialog_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 400, height: 250),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        const PollDeleteOptionDialog(),
      ),
    );
  }
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  Brightness? brightness,
}) {
  return StreamChatTheme(
    data: StreamChatThemeData(brightness: brightness),
    child: MaterialApp(
      home: widget,
    ),
  );
}
