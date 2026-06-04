// ignore_for_file: lines_longer_than_80_chars, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

void main() {
  group('StreamScope', () {
    testWidgets('exposes the State to descendants via of()', (tester) async {
      _CounterState? captured;

      await tester.pumpWidget(
        MaterialApp(
          home: _Counter(
            child: Builder(
              builder: (context) {
                captured = _Counter.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(captured, isNotNull);
      expect(captured!.value, 0);
    });

    testWidgets('maybeOf returns null when no scope is present',
        (tester) async {
      _CounterState? captured;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              captured = _Counter.maybeOf(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(captured, isNull);
    });

    testWidgets('of() throws a FlutterError when no scope is present',
        (tester) async {
      Object? caught;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              try {
                _Counter.of(context);
              } catch (e) {
                caught = e;
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(caught, isA<FlutterError>());
    });

    testWidgets('reads the nearest scope when multiple are nested',
        (tester) async {
      _CounterState? captured;

      await tester.pumpWidget(
        MaterialApp(
          home: _Counter(
            child: _Counter(
              child: Builder(
                builder: (context) {
                  captured = _Counter.of(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      );

      final all =
          tester.stateList<_CounterState>(find.byType(_Counter)).toList();
      expect(captured, isNotNull);
      expect(captured, same(all.last));
    });

    testWidgets(
      'of() does not register the caller as a dependent on the scope',
      (tester) async {
        // The whole point of using getElementForInheritedWidgetOfExactType in
        // StreamScope.maybeOf is to preserve the dependency-free semantics of
        // the old findAncestorStateOfType-based implementation. If a future
        // change accidentally switches to dependOnInheritedWidgetOfExactType,
        // every consumer of StreamChannel.of / StreamChat.of would start
        // getting rebuilt unnecessarily — this test guards against that.
        BuildContext? leafContext;

        await tester.pumpWidget(
          MaterialApp(
            home: _Counter(
              child: Builder(
                builder: (context) {
                  leafContext = context;
                  _Counter.of(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        final scopeElement = leafContext!
            .getElementForInheritedWidgetOfExactType<
                StreamScope<_CounterState>>()!;
        final isDependent = (leafContext! as Element)
            .doesDependOnInheritedElement(scopeElement);

        expect(
          isDependent,
          isFalse,
          reason: 'StreamScope.of must not register the caller as a dependent.',
        );
      },
    );
  });
}

// ---- Test fixtures ---------------------------------------------------------

class _Counter extends StatefulWidget {
  const _Counter({required this.child});

  final Widget child;

  static _CounterState of(BuildContext context) =>
      StreamScope.of<_CounterState>(context);

  static _CounterState? maybeOf(BuildContext context) =>
      StreamScope.maybeOf<_CounterState>(context);

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int value = 0;

  void increment() => setState(() => value++);

  @override
  Widget build(BuildContext context) {
    return StreamScope(state: this, child: widget.child);
  }
}
