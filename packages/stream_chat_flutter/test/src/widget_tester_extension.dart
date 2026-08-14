import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

extension WidgetTesterExtension on WidgetTester {
  Future<void> pumpWidgetWithSize(
    Widget widget, {
    required Size size,
    double textScaleSize = 1.0,
  }) async {
    await binding.setSurfaceSize(size);
    view
      ..physicalSize = size
      ..devicePixelRatio = 1.0;
    platformDispatcher.textScaleFactorTestValue = textScaleSize;

    await pumpWidget(widget);
    await pump();
  }
}
