// Tests for `ItemScrollController.isScrolling` and
// `ItemScrollController.isScrollingListenable` — the Flutter equivalent
// of Compose's `LazyListState.isScrollInProgress` that
// [StreamMessageListView] uses to gate auto-scroll-on-new-message.
//
// Pins:
// 1. Default value before attach + before first layout.
// 2. Flips true during a user drag, back to false after settle.
// 3. Flips true during a programmatic `scrollTo`, back to false after
//    the animation completes.
// 4. `jumpTo` produces no `isScrolling` transition (it's instantaneous).
// 5. The listenable notifies on every flip and is safe to subscribe to
//    before the controller is attached.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';

const _viewportHeight = 400.0;
const _viewportWidth = 400.0;
const _itemHeight = 40.0;

Future<void> _pump(
  WidgetTester tester, {
  required ItemScrollController controller,
  int itemCount = 100,
  bool reverse = false,
}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(_viewportWidth, _viewportHeight);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      home: ScrollablePositionedList.builder(
        itemCount: itemCount,
        itemScrollController: controller,
        reverse: reverse,
        itemBuilder: (context, i) => SizedBox(
          height: _itemHeight,
          child: Text('item-$i'),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('isScrolling default', () {
    test('reads false when the controller is unattached', () {
      final controller = ItemScrollController();
      expect(controller.isAttached, isFalse);
      expect(controller.isScrolling, isFalse);
    });

    testWidgets(
      'reads false at rest after mount and first layout',
      (tester) async {
        final controller = ItemScrollController();
        await _pump(tester, controller: controller);
        expect(controller.isAttached, isTrue);
        expect(controller.isScrolling, isFalse);
      },
    );
  });

  group('isScrolling during user drag', () {
    testWidgets(
      'flips true while a drag is in progress and false after it settles',
      (tester) async {
        final controller = ItemScrollController();
        await _pump(tester, controller: controller);

        // Start a drag and hold partway through — don't release.
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(ScrollablePositionedList)),
        );
        await gesture.moveBy(const Offset(0, -100));
        await tester.pump();

        expect(
          controller.isScrolling,
          isTrue,
          reason: 'should be true while finger is down and moving',
        );

        // Release. After the ballistic/idle settle, isScrolling drops.
        await gesture.up();
        await tester.pumpAndSettle();

        expect(
          controller.isScrolling,
          isFalse,
          reason: 'should be false once the scroll has fully settled',
        );
      },
    );
  });

  group('isScrolling during programmatic scrollTo', () {
    testWidgets(
      'flips true while a scrollTo animation is in flight, false at end',
      (tester) async {
        final controller = ItemScrollController();
        await _pump(tester, controller: controller, itemCount: 30);

        // Kick off an animated scroll. Deliberately not awaited — the
        // tester runs on a fake clock and the future only resolves
        // once `pumpAndSettle` advances time, so awaiting it before
        // pumping would deadlock the test.
        controller.scrollTo(
          index: 20,
          duration: const Duration(milliseconds: 300),
        );

        // Step a couple of frames into the animation, then sample.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        expect(
          controller.isScrolling,
          isTrue,
          reason: 'should be true while scrollTo is animating',
        );

        // Let the animation finish.
        await tester.pumpAndSettle();

        expect(
          controller.isScrolling,
          isFalse,
          reason: 'should be false after the animation completes',
        );
      },
    );
  });

  group('isScrolling during jumpTo', () {
    testWidgets(
      'never observes a true transition (jump is synchronous, no activity)',
      (tester) async {
        final controller = ItemScrollController();
        await _pump(tester, controller: controller, itemCount: 200);

        var observedTrue = false;
        void listener() {
          if (controller.isScrolling) observedTrue = true;
        }

        controller.isScrollingListenable.addListener(listener);
        addTearDown(() {
          controller.isScrollingListenable.removeListener(listener);
        });

        controller.jumpTo(index: 50);
        await tester.pumpAndSettle();

        expect(observedTrue, isFalse);
        expect(controller.isScrolling, isFalse);
      },
    );
  });

  group('isScrollingListenable', () {
    testWidgets(
      'fires for each true→false transition during a drag-then-release',
      (tester) async {
        final controller = ItemScrollController();
        await _pump(tester, controller: controller);

        final transitions = <bool>[];
        void listener() => transitions.add(controller.isScrolling);

        controller.isScrollingListenable.addListener(listener);
        addTearDown(() {
          controller.isScrollingListenable.removeListener(listener);
        });

        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(ScrollablePositionedList)),
        );
        await gesture.moveBy(const Offset(0, -120));
        await tester.pump();
        await gesture.up();
        await tester.pumpAndSettle();

        // At minimum we should have seen at least one true and one
        // final false. The exact count depends on how Flutter splits
        // drag vs. ballistic vs. idle activities, so don't pin it
        // exactly — just confirm the listenable produced observable
        // transitions.
        expect(transitions, contains(true));
        expect(transitions.last, isFalse);
      },
    );

    test(
      'is a safe no-op when the controller is unattached',
      () {
        final controller = ItemScrollController();
        // Should not throw despite the controller having no state to
        // proxy to.
        void listener() {}
        controller.isScrollingListenable.addListener(listener);
        controller.isScrollingListenable.removeListener(listener);
      },
    );
  });
}
