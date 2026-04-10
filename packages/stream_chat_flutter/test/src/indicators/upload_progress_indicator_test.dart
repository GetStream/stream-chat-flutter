import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';

void main() {
  testWidgets('StreamUploadProgressIndicator at 0% with no background', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: const Scaffold(
            body: Center(
              child: StreamUploadProgressIndicator(
                total: 100,
                uploaded: 0,
                showBackground: false,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('0%'), findsOneWidget);
  });

  testWidgets('StreamUploadProgressIndicator at 50% with no background', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: const Scaffold(
            body: Center(
              child: StreamUploadProgressIndicator(
                total: 100,
                uploaded: 50,
                showBackground: false,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('50%'), findsOneWidget);
  });

  testWidgets('StreamUploadProgressIndicator at 100% with no background', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: const Scaffold(
            body: Center(
              child: StreamUploadProgressIndicator(
                total: 100,
                uploaded: 100,
                showBackground: false,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('100%'), findsOneWidget);
  });

  testWidgets('StreamUploadProgressIndicator at 50% with background', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: const Scaffold(
            body: Center(
              child: StreamUploadProgressIndicator(
                total: 100,
                uploaded: 50,
              ),
            ),
          ),
        ),
      ),
    );

    final backgroundColor =
        ((find.byType(DecoratedBox).evaluate().first.widget as DecoratedBox).decoration as BoxDecoration).color;

    expect(const Color(0x99000000), backgroundColor);
  });

  goldenTest(
    'golden test for StreamUploadProgressIndicator at 0% with background',
    fileName: 'upload_progress_indicator_0',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    pumpBeforeTest: pumpOnce,
    builder: () => MaterialAppWrapper(
      home: StreamChatTheme(
        data: StreamChatThemeData.light(),
        child: const Scaffold(
          body: Center(
            child: StreamUploadProgressIndicator(
              total: 100,
              uploaded: 0,
            ),
          ),
        ),
      ),
    ),
  );

  goldenTest(
    'golden test for StreamUploadProgressIndicator at 50% with background',
    fileName: 'upload_progress_indicator_1',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    pumpBeforeTest: pumpOnce,
    builder: () => MaterialAppWrapper(
      home: StreamChatTheme(
        data: StreamChatThemeData.light(),
        child: const Scaffold(
          body: Center(
            child: StreamUploadProgressIndicator(
              total: 100,
              uploaded: 50,
            ),
          ),
        ),
      ),
    ),
  );

  goldenTest(
    'golden test for StreamUploadProgressIndicator at 100% with background',
    fileName: 'upload_progress_indicator_2',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    pumpBeforeTest: pumpOnce,
    builder: () => MaterialAppWrapper(
      home: StreamChatTheme(
        data: StreamChatThemeData.light(),
        child: const Scaffold(
          body: Center(
            child: StreamUploadProgressIndicator(
              total: 100,
              uploaded: 100,
            ),
          ),
        ),
      ),
    ),
  );
}
