import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('AttachmentModalSheet tests', () {
    testWidgets('Appears on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) {
              return Center(
                child: ElevatedButton(
                  child: const Text('Show Modal'),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (_) => AttachmentModalSheet(
                      onFileTap: () {},
                      onPhotoTap: () {},
                      onVideoTap: () {},
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      );

      final button = find.byType(ElevatedButton);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.byType(AttachmentModalSheet), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(4));
    });

    testWidgets('onPhotoTap works', (tester) async {
      var called = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) {
              return Center(
                child: AttachmentModalSheet(
                  onPhotoTap: () => called = 1,
                  onFileTap: () {},
                  onVideoTap: () {},
                ),
              );
            }),
          ),
        ),
      );

      expect(find.byType(AttachmentModalSheet), findsOneWidget);
      final photoTile = find.widgetWithIcon(ListTile, Icons.image);
      expect(photoTile, findsOneWidget);
      await tester.tap(photoTile);
      await tester.pumpAndSettle();
      expect(called, 1);
    });

    testWidgets('onVideoTap works', (tester) async {
      var called = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) {
              return Center(
                child: AttachmentModalSheet(
                  onPhotoTap: () {},
                  onVideoTap: () => called = 1,
                  onFileTap: () {},
                ),
              );
            }),
          ),
        ),
      );

      expect(find.byType(AttachmentModalSheet), findsOneWidget);
      final videoTile = find.widgetWithIcon(ListTile, Icons.video_library);
      expect(videoTile, findsOneWidget);
      await tester.tap(videoTile);
      await tester.pumpAndSettle();
      expect(called, 1);
    });

    testWidgets('onFileTap works', (tester) async {
      var called = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) {
              return Center(
                child: AttachmentModalSheet(
                  onPhotoTap: () {},
                  onVideoTap: () {},
                  onFileTap: () => called = 1,
                ),
              );
            }),
          ),
        ),
      );

      expect(find.byType(AttachmentModalSheet), findsOneWidget);
      final fileTile = find.widgetWithIcon(ListTile, Icons.insert_drive_file);
      expect(fileTile, findsOneWidget);
      await tester.tap(fileTile);
      await tester.pumpAndSettle();
      expect(called, 1);
    });

    testGoldens(
      'golden test for AttachmentModalSheet',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(builder: (context) {
                return Center(
                  child: AttachmentModalSheet(
                    onPhotoTap: () {},
                    onVideoTap: () {},
                    onFileTap: () {},
                  ),
                );
              }),
            ),
          ),
        );

        await screenMatchesGolden(tester, 'attachment_modal_sheet_0');
      },
    );
  });
}
