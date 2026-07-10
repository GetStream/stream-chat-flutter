import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_config_option.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: StreamChatTheme(
      data: StreamChatThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  // The merged toggle node is identified by its hasToggledState flag.
  Finder findToggle() => find.bySemanticsLabel(RegExp('(Multiple answers|Anonymous)'));

  group('PollConfigOption semantics', () {
    testWidgets('header merges title + description + switch into one toggleable stop', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          PollConfigOption(
            title: 'Multiple answers',
            description: 'Allow up to 5 votes per person',
            value: false,
            onChanged: (_) {},
          ),
        ),
      );

      expect(
        tester.getSemantics(findToggle()),
        matchesSemantics(
          label: 'Multiple answers\nAllow up to 5 votes per person',
          hasEnabledState: true,
          isEnabled: true,
          hasToggledState: true,
          isToggled: false,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );

      handle.dispose();
    });

    testWidgets('toggled state reflects value', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          PollConfigOption(
            key: const ValueKey('header'),
            title: 'Anonymous',
            value: true,
            onChanged: (_) {},
          ),
        ),
      );

      final data = tester.getSemantics(findToggle()).getSemanticsData();
      expect(data.flagsCollection.isToggled, Tristate.isTrue);

      handle.dispose();
    });

    testWidgets('label has no description suffix when description is null', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          PollConfigOption(
            key: const ValueKey('header'),
            title: 'Anonymous',
            value: false,
            onChanged: (_) {},
          ),
        ),
      );

      expect(tester.getSemantics(findToggle()).getSemanticsData().label, equals('Anonymous'));
      handle.dispose();
    });

    testWidgets('onChanged null → no tap action, disabled', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          const PollConfigOption(
            key: ValueKey('header'),
            title: 'Anonymous',
            value: false,
          ),
        ),
      );

      final data = tester.getSemantics(findToggle()).getSemanticsData();
      expect(data.hasAction(SemanticsAction.tap), isFalse);
      expect(data.flagsCollection.isEnabled, Tristate.isFalse);

      handle.dispose();
    });

    testWidgets('tap action toggles value via onChanged', (tester) async {
      final handle = tester.ensureSemantics();
      bool? received;
      await tester.pumpWidget(
        _wrap(
          PollConfigOption(
            key: const ValueKey('header'),
            title: 'Anonymous',
            value: false,
            onChanged: (v) => received = v,
          ),
        ),
      );

      final id = tester.getSemantics(findToggle()).id;
      // rootPipelineOwner.semanticsOwner is null in test env; deprecated
      // pipelineOwner path still resolves to the semantic root.
      // ignore: deprecated_member_use
      tester.binding.pipelineOwner.semanticsOwner!.performAction(id, SemanticsAction.tap);
      expect(received, isTrue);

      handle.dispose();
    });

    testWidgets('inner text + switch produce no extra interactive stops', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          PollConfigOption(
            key: const ValueKey('header'),
            title: 'Multiple answers',
            description: 'Allow up to 5 votes per person',
            value: false,
            onChanged: (_) {},
          ),
        ),
      );

      final interactive = tester.semantics.simulatedAccessibilityTraversal().where((node) {
        final data = node.getSemanticsData();
        return data.hasAction(SemanticsAction.tap) || data.flagsCollection.isToggled != Tristate.none;
      }).toList();

      // Only the merged header — not the inner StreamSwitch.
      expect(interactive, hasLength(1));

      handle.dispose();
    });
  });
}
