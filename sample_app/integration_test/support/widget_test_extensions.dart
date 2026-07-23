// Catching the framework's StateError from dragUntilVisible is intentional
// (riding out a cold-boot scroll race) — see scrollToText.
// ignore_for_file: avoid_catching_errors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension E2EWidgetTester on WidgetTester {
  Future<void> scrollToText(String text) async {
    final target = find.text(text);
    final scrollable = find.byType(Scrollable).first;
    await waitUntilVisible(scrollable);
    // On a cold boot the chooser list rebuilds mid-drag, so dragUntilVisible can
    // momentarily see an empty scrollable and throw "Bad state: No element".
    // Retry until the entry is on screen (later logins hit this instantly).
    for (var attempt = 0; attempt < 10 && target.evaluate().isEmpty; attempt++) {
      try {
        await scrollUntilVisible(target, 100, scrollable: scrollable, maxScrolls: 30);
      } on StateError {
        await pump(const Duration(milliseconds: 300));
      }
    }
    await waitUntilVisible(target);
    await settle();
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

  /// Taps [finder], scrolling it into view first. Used for message-action rows
  /// that may sit below the fold of the (scrollable) actions modal.
  Future<void> tapFinder(Finder finder) async {
    await waitUntilVisible(finder);
    await ensureVisible(finder.first);
    await pumpAndSettle();
    await tap(finder.first);
    await pumpAndSettle();
  }

  Future<void> enterTextInField(Type inputFieldType, String text) async {
    final finder = find.byType(inputFieldType);
    await waitUntilVisible(finder);
    await enterText(finder, text);
    await pumpAndSettle();
  }

  /// Drags the message list by [delta] logical pixels. A positive [delta]
  /// drags the finger downwards, revealing older messages (scroll up); a
  /// negative [delta] reveals newer messages (scroll down).
  Future<void> scrollMessageList(double delta) async {
    final scrollable = find.byType(Scrollable).first;
    await waitUntilVisible(scrollable);
    await drag(scrollable, Offset(0, delta));
    await pumpAndSettle();
  }

  /// Repeatedly scrolls the message list up (towards older messages) until
  /// [finder] is visible, paging through history as needed.
  Future<void> scrollUpUntilVisible(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final scrollable = find.byType(Scrollable).first;
    await waitUntilVisible(scrollable);
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      if (finder.evaluate().isNotEmpty) {
        await pumpAndSettle();
        return;
      }
      await drag(scrollable, const Offset(0, 400));
      await pumpAndSettle();
    }
    throw TestFailure('Timed out scrolling up to reveal $finder');
  }

  Future<void> waitUntilVisible(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await pump(const Duration(milliseconds: 100));
      if (finder.evaluate().isNotEmpty) {
        await settle();
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
        await settle();
        return;
      }
    }
    throw TestFailure('Timed out waiting for $finder to disappear');
  }

  /// Like [pumpAndSettle] but bounded: a perpetual animation (e.g. a reconnect
  /// spinner shown while the SDK is re-establishing the WebSocket) would make an
  /// unbounded `pumpAndSettle` hang forever. The awaited widget is already
  /// present by the time this is called, so a short settle is enough.
  Future<void> settle([Duration timeout = const Duration(seconds: 5)]) async {
    try {
      await pumpAndSettle(const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, timeout);
    } catch (_) {
      // Timed out settling (perpetual animation) — safe to proceed.
    }
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

      // Integration tests: after a message has reactions, [WidgetTester.longPress]
      // can lose the gesture arena while [InkWell.onLongPress] is still wired.
      if (_tryInvokeMessageLongPress(target)) {
        await pumpAndSettle();
        if (appears.evaluate().isNotEmpty) return;
      }

      await pump(const Duration(milliseconds: 150));
    }
    throw TestFailure('Timed out long-pressing $target waiting for $appears');
  }

  bool _tryInvokeMessageLongPress(Finder target) {
    final inkWells = find.descendant(of: target, matching: find.byType(InkWell));
    if (inkWells.evaluate().isEmpty) return false;

    final onLongPress = widget<InkWell>(inkWells.first).onLongPress;
    if (onLongPress == null) return false;

    onLongPress();
    return true;
  }
}
