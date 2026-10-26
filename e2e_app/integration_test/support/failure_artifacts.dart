import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../allure/allure.dart';

// Attachments are streamed to the device log as base64 chunks, so they must
// stay small — a full-resolution screenshot or a whole widget tree produces
// thousands of log lines per failure, floods CI, and risks logcat dropping
// chunks (which corrupts the reassembled file). These bounds keep each
// attachment to a few dozen lines while staying useful for triage.
const _maxScreenshotSide = 600.0; // longest edge, logical px * pixelRatio
const _maxTextChars = 20000;

/// Captures debug artifacts from the running app and attaches them to the
/// current Allure test. Called on failure, before the result is emitted.
///
/// Screenshot and widget hierarchy are grabbed in-process from the live render
/// tree; [log] is the output captured during the test body. Every capture is
/// best-effort — a failure to grab one artifact never masks the original test
/// failure.
Future<void> captureFailureArtifacts(WidgetTester tester, String log) async {
  await _attachScreenshot(tester);
  _attachWidgetHierarchy();
  Allure.instance.attachText('Log', _cap(log), ext: 'log');
}

Future<void> _attachScreenshot(WidgetTester tester) async {
  try {
    final view = tester.binding.renderViews.first;
    final layer = view.debugLayer;
    if (layer is! OffsetLayer) return;

    // Downscale so the longest edge is ~_maxScreenshotSide px, regardless of
    // device resolution — keeps the base64 payload small (see file header).
    final longestSide = view.paintBounds.size.longestSide;
    final pixelRatio = longestSide <= 0 ? 1.0 : (_maxScreenshotSide / longestSide).clamp(0.1, 1.5);

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
    Allure.instance.attachText('Widget hierarchy', _cap(tree), ext: 'txt');
  } catch (_) {
    // Best-effort.
  }
}

String _cap(String s) {
  if (s.length <= _maxTextChars) return s;
  final dropped = s.length - _maxTextChars;
  return '${s.substring(0, _maxTextChars)}\n…[truncated $dropped chars]';
}
