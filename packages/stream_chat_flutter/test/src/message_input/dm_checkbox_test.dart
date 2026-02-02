import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_input/dm_checkbox.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';

@Deprecated('')
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
                        // ignore: deprecated_member_use
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

  goldenTest(
    'golden test for checked DmCheckbox with border',
    fileName: 'dm_checkbox_0',
    constraints: const BoxConstraints.tightFor(width: 200, height: 50),
    builder: () => MaterialAppWrapper(
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
                      // ignore: deprecated_member_use
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

  goldenTest(
    'golden test for checked DmCheckbox without border',
    fileName: 'dm_checkbox_1',
    constraints: const BoxConstraints.tightFor(width: 200, height: 50),
    builder: () => MaterialAppWrapper(
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

  goldenTest(
    'golden test for unchecked DmCheckbox with border',
    fileName: 'dm_checkbox_2',
    constraints: const BoxConstraints.tightFor(width: 200, height: 50),
    builder: () => MaterialAppWrapper(
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
                      // ignore: deprecated_member_use
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
}
