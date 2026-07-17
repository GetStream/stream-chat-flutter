import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../allure/allure.dart';

/// Captures debug artifacts from the running app and attaches them to the
/// current Allure test. Called on failure, before the result is emitted.
///
/// Screenshot and widget hierarchy are grabbed in-process from the live render
/// tree; [log] is the output captured during the test body. Video is recorded
/// host-side by the Fastlane lane (it can't be captured in-process). Every
/// capture is best-effort — a failure to grab one artifact never masks the
/// original test failure.
Future<void> captureFailureArtifacts(WidgetTester tester, String log) async {
  await _attachScreenshot(tester);
  _attachWidgetHierarchy();
  Allure.instance.attachText('Log', log, ext: 'log');
}

Future<void> _attachScreenshot(WidgetTester tester) async {
  try {
    final view = tester.binding.renderViews.first;
    final layer = view.debugLayer;
    if (layer is! OffsetLayer) return;

    // Capped at 2.0 rather than the full device pixel ratio: the PNG is
    // streamed to the device log as base64 chunks, and a huge image risks
    // logcat dropping lines (which would corrupt the reassembled file). 2.0
    // stays readable while keeping the volume manageable.
    final pixelRatio = view.flutterView.devicePixelRatio.clamp(1.0, 2.0);
    final image = await layer.toImage(view.paintBounds, pixelRatio: pixelRatio);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) return;
      Allure.instance.attachBytes(
        'Screenshot',
        data.buffer.asUint8List(),
        type: 'image/png',
        ext: 'png',
      );
    } finally {
      image.dispose();
    }
  } catch (_) {
    // Best-effort: never let a capture failure hide the real one.
  }
}

void _attachWidgetHierarchy() {
  try {
    final tree = WidgetsBinding.instance.rootElement?.toStringDeep();
    if (tree == null) return;
    Allure.instance.attachText('Widget hierarchy', tree, ext: 'txt');
  } catch (_) {
    // Best-effort.
  }
}
