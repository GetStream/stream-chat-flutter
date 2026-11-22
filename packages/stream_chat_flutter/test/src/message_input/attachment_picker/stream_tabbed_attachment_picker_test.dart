import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  final images = _option('images', AttachmentPickerType.images);
  final files = _option('files', AttachmentPickerType.files);
  final poll = _option('poll', AttachmentPickerType.poll);

  testWidgets('selects the initial option', (tester) async {
    await _pumpPicker(tester, options: {images, files}, initialOption: files);

    expect(find.text('files view'), findsOneWidget);
  });

  testWidgets('ignores an initial option that is not one of the options', (tester) async {
    await _pumpPicker(tester, options: {images, files}, initialOption: poll);

    expect(find.text('images view'), findsOneWidget);
  });

  testWidgets('builds without options', (tester) async {
    await _pumpPicker(tester, options: {});

    expect(tester.takeException(), isNull);
  });

  testWidgets('moves to a remaining option when the selected one disappears', (tester) async {
    final controller = _controller();
    await _pumpPicker(tester, controller: controller, options: {images, files});
    expect(find.text('images view'), findsOneWidget);

    await _pumpPicker(tester, controller: controller, options: {files});

    expect(find.text('files view'), findsOneWidget);
  });

  testWidgets('keeps building when its options become empty', (tester) async {
    final controller = _controller();
    await _pumpPicker(tester, controller: controller, options: {images});

    await _pumpPicker(tester, controller: controller, options: {});

    expect(tester.takeException(), isNull);
  });
}

TabbedAttachmentPickerOption _option(String key, AttachmentPickerType type) {
  return TabbedAttachmentPickerOption(
    key: key,
    icon: Icons.attach_file,
    supportedTypes: [type],
    optionViewBuilder: (context, controller) => Text('$key view'),
  );
}

StreamAttachmentPickerController _controller() {
  final controller = StreamAttachmentPickerController();
  addTearDown(controller.dispose);
  return controller;
}

Future<void> _pumpPicker(
  WidgetTester tester, {
  required Set<TabbedAttachmentPickerOption> options,
  StreamAttachmentPickerController? controller,
  TabbedAttachmentPickerOption? initialOption,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: StreamChatTheme(
        data: StreamChatThemeData(),
        child: Scaffold(
          body: StreamTabbedAttachmentPicker(
            controller: controller ?? _controller(),
            options: options,
            initialOption: initialOption,
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}
