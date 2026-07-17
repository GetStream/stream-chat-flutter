import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

extension E2EWidgetTester on WidgetTester {
  Future<void> scrollToText(String text) async {
    await scrollUntilVisible(
      find.text(text),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await pumpAndSettle();
  }

  Future<void> tapText(String text) async {
    await waitUntilVisible(find.text(text));
    await tap(find.text(text));
    await pumpAndSettle();
  }

  Future<void> tapByType(Type type, {int index = 0}) async {
    final finder = find.byType(type);
    await waitUntilVisible(finder.at(index));
    await tap(finder.at(index));
    await pumpAndSettle();
  }

  Future<void> tapByKey(Key key) async {
    final finder = find.byKey(key);
    await waitUntilVisible(finder);
    await tap(finder);
    await pumpAndSettle();
  }

  Future<void> enterTextInField(Type inputFieldType, String text) async {
    final finder = find.byType(inputFieldType);
    await waitUntilVisible(finder);
    await enterText(finder, text);
    await pumpAndSettle();
  }

  Future<void> waitUntilVisible(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await pump(const Duration(milliseconds: 100));
      if (finder.evaluate().isNotEmpty) {
        await pumpAndSettle();
        return;
      }
    }
    throw TestFailure('Timed out waiting for $finder');
  }

  Future<void> waitUntilNotVisible(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await pump(const Duration(milliseconds: 100));
      if (finder.evaluate().isEmpty) {
        await pumpAndSettle();
        return;
      }
    }
    throw TestFailure('Timed out waiting for $finder to disappear');
  }

  /// Long-presses [target] until [appears] shows up.
  ///
  /// A message's long-press handler is disabled while it is still being sent,
  /// so a single long-press can be a no-op; retrying until the reaction
  /// picker (or any expected widget) appears makes the gesture reliable.
  Future<void> longPressUntilVisible(
    Finder target,
    Finder appears, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await pump(const Duration(milliseconds: 100));
      if (appears.evaluate().isNotEmpty) return;

      bool resolves;
      try {
        resolves = target.evaluate().isNotEmpty;
      } catch (_) {
        resolves = false;
      }
      if (!resolves) continue;

      await longPress(target);
      await pumpAndSettle();
      if (appears.evaluate().isNotEmpty) return;
      await pump(const Duration(milliseconds: 150));
    }
    throw TestFailure('Timed out long-pressing $target waiting for $appears');
  }
}
