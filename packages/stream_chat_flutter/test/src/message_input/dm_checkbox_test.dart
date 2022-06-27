import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/message_input/dm_checkbox.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('DmCheckbox onTap works', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: DmCheckbox(
                foregroundDecoration: BoxDecoration(
                  border: Border.all(
                    color: StreamChatThemeData.light()
                        .colorTheme
                        .textHighEmphasis
                        .withOpacity(0.5),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
                color: StreamChatThemeData.light().colorTheme.accentPrimary,
                onTap: () {
                  count++;
                },
                crossFadeState: CrossFadeState.showFirst,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(AnimatedCrossFade), findsOneWidget);
    final checkbox = find.byType(InkWell);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();
    expect(count, 1);
  });

  testGoldens('golden test for checked DmCheckbox with border', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: DmCheckbox(
                foregroundDecoration: BoxDecoration(
                  border: Border.all(
                    color: StreamChatThemeData.light()
                        .colorTheme
                        .textHighEmphasis
                        .withOpacity(0.5),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
                color: StreamChatThemeData.light().colorTheme.accentPrimary,
                onTap: () {},
                crossFadeState: CrossFadeState.showFirst,
              ),
            ),
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'dm_checkbox_0');
  });

  testGoldens('golden test for checked DmCheckbox without border',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: DmCheckbox(
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                ),
                color: StreamChatThemeData.light().colorTheme.accentPrimary,
                onTap: () {},
                crossFadeState: CrossFadeState.showFirst,
              ),
            ),
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'dm_checkbox_1');
  });

  testGoldens('golden test for unchecked DmCheckbox with border',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: DmCheckbox(
                foregroundDecoration: BoxDecoration(
                  border: Border.all(
                    color: StreamChatThemeData.light()
                        .colorTheme
                        .textHighEmphasis
                        .withOpacity(0.5),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
                color: StreamChatThemeData.light().colorTheme.barsBg,
                onTap: () {},
                crossFadeState: CrossFadeState.showSecond,
              ),
            ),
          ),
        ),
      ),
    );

    await screenMatchesGolden(tester, 'dm_checkbox_2');
  });
}
