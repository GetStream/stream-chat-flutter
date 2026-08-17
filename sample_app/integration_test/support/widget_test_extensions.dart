// Catching the framework's StateError from dragUntilVisible is intentional
// (riding out a cold-boot scroll race) — see scrollToText.
// ignore_for_file: avoid_catching_errors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension E2EFinder on Finder {
  /// [evaluate], but empty instead of throwing when this finder narrows to a
  /// match that is not currently rendered.
  ///
  /// A narrowing finder raises from `evaluate()` when nothing matches yet,
  /// rather than resolving to nothing — `find.byType(X).at(0)` (including one
  /// used as the `of:` of a descendant finder) raises an `IndexError`, and
  /// `.first` / `.last` raise a `StateError`. For a loop that is *waiting* for
  /// something to appear that is not an error — it just is not there yet — and
  /// letting it throw kills the test on the first tick instead. It matters just
  /// as much when waiting for something to go away, where "no match" is the
  /// expected end state.
  List<Element> evaluateSafely() {
    try {
      // Materialized inside the `try` on purpose: the result can be lazy, so
      // returning it unconsumed would throw in the caller instead, after this
      // catch has unwound.
      return evaluate().toList();
    } on RangeError {
      // IndexError implements RangeError.
      return const [];
    } on StateError {
      // `Iterable.first` / `.last` on an empty match.
      return const [];
    }
  }
}

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
    await settle();
  }

  Future<void> tapByType(Type type, {int index = 0}) async {
    final finder = find.byType(type);
    await waitUntilVisible(finder.at(index));
    await tap(finder.at(index));
    await settle();
  }

  Future<void> tapByKey(Key key) async {
    final finder = find.byKey(key);
    await waitUntilVisible(finder);
    await tap(finder);
    await settle();
  }

  /// Taps [finder], scrolling it into view first. Used for message-action rows
  /// that may sit below the fold of the (scrollable) actions modal.
  Future<void> tapFinder(Finder finder) async {
    await waitUntilVisible(finder);
    await ensureVisible(finder.first);
    await settle();
    await tap(finder.first);
    await settle();
  }

  Future<void> enterTextInField(Type inputFieldType, String text) async {
    final finder = find.byType(inputFieldType);
    await waitUntilVisible(finder);
    await enterText(finder, text);
    await settle();
  }

  /// Drags the message list by [delta] logical pixels. A positive [delta]
  /// drags the finger downwards, revealing older messages (scroll up); a
  /// negative [delta] reveals newer messages (scroll down).
  Future<void> scrollMessageList(double delta) async {
    final scrollable = find.byType(Scrollable).first;
    await waitUntilVisible(scrollable);
    await drag(scrollable, Offset(0, delta));
    await settle();
  }

  /// Repeatedly scrolls the message list up (towards older messages) until
  /// [condition] holds, paging through history as needed. [description] names
  /// what was being waited for, completing the failure message.
  Future<void> scrollUpUntil(
    bool Function() condition, {
    required String description,
    Duration timeout = const Duration(seconds: 30),
  }) => _scrollUntil(condition, const Offset(0, 400), description: description, timeout: timeout);

  /// Repeatedly scrolls the list down (towards the end of the list) until
  /// [condition] holds, paging in further entries as needed.
  Future<void> scrollDownUntil(
    bool Function() condition, {
    required String description,
    Duration timeout = const Duration(seconds: 30),
  }) => _scrollUntil(condition, const Offset(0, -400), description: description, timeout: timeout);

  Future<void> _scrollUntil(
    bool Function() condition,
    Offset step, {
    required String description,
    required Duration timeout,
  }) async {
    final scrollable = find.byType(Scrollable).first;
    await waitUntilVisible(scrollable);
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      if (condition()) {
        await settle();
        return;
      }
      await drag(scrollable, step);
      // Bounded, so [timeout] is actually re-checked between iterations even
      // while a perpetual animation (e.g. a reconnect spinner) is running.
      await settle();
    }
    throw TestFailure('Timed out scrolling, waiting for $description');
  }

  /// The plain text the [Text] found by [finder] renders, or null when it is not
  /// in the tree.
  ///
  /// Handles both a plain [Text] (`data`) and a `Text.rich` (`textSpan`) — the
  /// SDK's message previews are the latter, and their spans can carry
  /// inline-icon [WidgetSpan]s (a deleted message, an attachment type). Dropping
  /// the placeholders leaves their separator spaces behind, hence collapsing the
  /// whitespace afterwards.
  String? renderedText(Finder finder) {
    final elements = finder.evaluateSafely();
    if (elements.isEmpty) return null;

    final text = elements.first.widget as Text;
    final rendered = text.data ?? text.textSpan?.toPlainText(includePlaceholders: false) ?? '';
    return rendered.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// Polls until the text rendered by [finder] equals [expected], then asserts —
  /// so a failure reports what was actually on screen instead of a bare timeout.
  Future<void> expectRenderedText(
    Finder finder,
    String expected, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    await waitUntilVisible(finder);

    final end = DateTime.now().add(timeout);
    while (renderedText(finder) != expected && DateTime.now().isBefore(end)) {
      await pump(const Duration(milliseconds: 100));
    }
    expect(renderedText(finder), expected);
  }

  Future<void> waitUntilVisible(
    Finder finder, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await pump(const Duration(milliseconds: 100));
      if (finder.evaluateSafely().isNotEmpty) {
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
      if (finder.evaluateSafely().isEmpty) {
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

  /// Swipes [target] from its start edge towards its end edge, far enough to
  /// pass the SDK's swipe-to-reply threshold (20% of the row's width).
  Future<void> swipeToReply(Finder target) async {
    await waitUntilVisible(target);
    await drag(target, Offset(getSize(target).width * 0.4, 0));
    await settle();
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

      if (target.evaluateSafely().isEmpty) continue;

      await longPress(target);
      await settle();
      if (appears.evaluate().isNotEmpty) return;

      // Integration tests: after a message has reactions, [WidgetTester.longPress]
      // can lose the gesture arena while [InkWell.onLongPress] is still wired.
      if (_tryInvokeMessageLongPress(target)) {
        await settle();
        if (appears.evaluate().isNotEmpty) return;
      }

      await pump(const Duration(milliseconds: 150));
    }
    throw TestFailure('Timed out long-pressing $target waiting for $appears');
  }

  bool _tryInvokeMessageLongPress(Finder target) {
    final inkWells = find.descendant(of: target, matching: find.byType(InkWell));
    if (inkWells.evaluateSafely().isEmpty) return false;

    final onLongPress = widget<InkWell>(inkWells.first).onLongPress;
    if (onLongPress == null) return false;

    onLongPress();
    return true;
  }
}
