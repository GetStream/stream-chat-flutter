// How the tabbed attachment picker's tabs fit the shorter picker on a short
// screen, such as a phone in landscape.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  // The tabs that show a prompt and a button until their picker opens.
  const tabs = ['image-picker', 'video-picker', 'file-picker', 'poll-creator'];

  // Just below and at the height where the picker grows to its regular size.
  for (final screenHeight in [479.0, 480.0]) {
    for (final tab in tabs) {
      testWidgets('StreamTabbedAttachmentPicker fits its $tab tab on a $screenHeight-tall screen', (tester) async {
        final overflows = await _pumpPickerTab(tester, tab: tab, screenHeight: screenHeight);

        expect(overflows, isEmpty);
      });
    }
  }
}

// Pumps the default tabbed picker on [tab] at the bottom of a screen
// [screenHeight] tall, and returns the layout overflows it reported.
//
// Each tab opens its platform picker once shown, which has no platform channel
// in a widget test; those errors are collected too but aren't overflows.
Future<List<FlutterErrorDetails>> _pumpPickerTab(
  WidgetTester tester, {
  required String tab,
  required double screenHeight,
}) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = Size(900, screenHeight);
  addTearDown(tester.view.reset);

  final controller = StreamAttachmentPickerController();
  addTearDown(controller.dispose);

  final errors = <FlutterErrorDetails>[];
  final onError = FlutterError.onError;
  FlutterError.onError = errors.add;
  try {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData(),
          child: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: Builder(
                builder: (context) {
                  final picker = tabbedAttachmentPickerBuilder(context: context, controller: controller);
                  final options = (picker as StreamTabbedAttachmentPicker).options;
                  return StreamTabbedAttachmentPicker(
                    controller: controller,
                    options: options,
                    initialOption: options.firstWhere((it) => it.key == tab),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  } finally {
    FlutterError.onError = onError;
  }

  return [
    for (final error in errors)
      if (error.exceptionAsString().contains('overflowed')) error,
  ];
}
