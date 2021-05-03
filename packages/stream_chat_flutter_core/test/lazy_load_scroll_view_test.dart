import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/src/lazy_load_scroll_view.dart';

void main() {
  testWidgets(
    'should render LazyLoadScrollView if child is provided',
    (tester) async {
      const lazyLoadScrollViewKey = Key('lazyLoadScrollView');
      final lazyLoadScrollView = LazyLoadScrollView(
        key: lazyLoadScrollViewKey,
        child: Offstage(),
      );

      await tester.pumpWidget(lazyLoadScrollView);

      expect(find.byKey(lazyLoadScrollViewKey), findsOneWidget);
    },
  );

  testWidgets(
    'should render LazyLoadScrollView if child is provided',
    (tester) async {
      const lazyLoadScrollViewKey = Key('lazyLoadScrollView');
      const childKey = Key('childKey');
      final lazyLoadScrollView = LazyLoadScrollView(
        key: lazyLoadScrollViewKey,
        child: Offstage(key: childKey),
      );

      await tester.pumpWidget(lazyLoadScrollView);

      expect(find.byKey(lazyLoadScrollViewKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);
    },
  );

  testWidgets(
    'should call onPageScrollStart if child scrollView scrolls',
    (tester) async {
      const lazyLoadScrollViewKey = Key('lazyLoadScrollView');
      const childListViewKey = Key('childListView');

      bool onPageScrollStartCalled = false;

      final lazyLoadScrollView = LazyLoadScrollView(
        key: lazyLoadScrollViewKey,
        onPageScrollStart: () {
          onPageScrollStartCalled = true;
        },
        child: ListView(
          key: childListViewKey,
          children: List.generate(
            12,
            (index) => Container(
              height: 100,
              child: Text('Item #$index'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: lazyLoadScrollView,
        ),
      );

      expect(find.byKey(lazyLoadScrollViewKey), findsOneWidget);
      expect(find.byKey(childListViewKey), findsOneWidget);
      expect(onPageScrollStartCalled, isFalse);

      await tester.startGesture(const Offset(100.0, 100.0));
      await tester.pump(const Duration(seconds: 1));

      expect(onPageScrollStartCalled, isTrue);
    },
  );

  testWidgets(
    'should call onPageScrollStart, onPageScrollEnd '
    'if child scrollView starts scrolling and ends',
    (tester) async {
      const lazyLoadScrollViewKey = Key('lazyLoadScrollView');
      const childListViewKey = Key('childListView');

      bool onPageScrollStartCalled = false;
      bool onPageScrollEndCalled = false;

      final lazyLoadScrollView = LazyLoadScrollView(
        key: lazyLoadScrollViewKey,
        onPageScrollStart: () {
          onPageScrollStartCalled = true;
        },
        onPageScrollEnd: () {
          onPageScrollEndCalled = true;
        },
        child: ListView(
          key: childListViewKey,
          children: List.generate(
            12,
            (index) => Container(
              height: 100,
              child: Text('Item #$index'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: lazyLoadScrollView,
        ),
      );

      expect(find.byKey(lazyLoadScrollViewKey), findsOneWidget);
      expect(find.byKey(childListViewKey), findsOneWidget);
      expect(onPageScrollStartCalled, isFalse);
      expect(onPageScrollEndCalled, isFalse);

      final gesture = await tester.createGesture();

      await gesture.down(const Offset(100.0, 100.0));
      await tester.pump(const Duration(seconds: 1));

      expect(onPageScrollStartCalled, isTrue);

      await gesture.up();
      await tester.pump(const Duration(seconds: 1));

      expect(onPageScrollEndCalled, isTrue);
    },
  );

  testWidgets(
    'should call onInBetweenOfPage if child scrollView '
    'scroll position is in-between of view',
    (tester) async {
      const lazyLoadScrollViewKey = Key('lazyLoadScrollView');
      const childListViewKey = Key('childListView');

      bool onInBetweenOfPageCalled = false;

      final lazyLoadScrollView = LazyLoadScrollView(
        key: lazyLoadScrollViewKey,
        onInBetweenOfPage: () async {
          onInBetweenOfPageCalled = true;
        },
        child: ListView(
          key: childListViewKey,
          children: List.generate(
            12,
            (index) => Container(
              height: 100,
              child: Text('Item #$index'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: lazyLoadScrollView,
        ),
      );

      expect(find.byKey(lazyLoadScrollViewKey), findsOneWidget);
      expect(find.byKey(childListViewKey), findsOneWidget);
      expect(onInBetweenOfPageCalled, isFalse);

      final gesture = await tester.createGesture();

      await gesture.down(const Offset(100.0, 100.0));
      await tester.pump(const Duration(seconds: 1));
      await gesture.moveBy(const Offset(-200.0, -200.0));
      await tester.pump(const Duration(seconds: 1));

      expect(onInBetweenOfPageCalled, isTrue);
    },
  );

  testWidgets(
    'should call onStartOfPage if child scrollView '
    'tends to reach the start',
    (tester) async {
      const lazyLoadScrollViewKey = Key('lazyLoadScrollView');
      const childListViewKey = Key('childListView');

      bool onStartOfPageCalled = false;

      final lazyLoadScrollView = LazyLoadScrollView(
        key: lazyLoadScrollViewKey,
        onStartOfPage: () async {
          onStartOfPageCalled = true;
        },
        child: ListView(
          key: childListViewKey,
          children: List.generate(
            12,
            (index) => Container(
              height: 100,
              child: Text('Item #$index'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: lazyLoadScrollView,
        ),
      );

      expect(find.byKey(lazyLoadScrollViewKey), findsOneWidget);
      expect(find.byKey(childListViewKey), findsOneWidget);
      expect(onStartOfPageCalled, isFalse);

      final gesture = await tester.createGesture();

      await gesture.down(const Offset(100.0, 100.0));
      await tester.pump(const Duration(seconds: 1));
      await gesture.moveBy(const Offset(-200.0, -200.0));
      await tester.pump(const Duration(seconds: 1));
      await gesture.moveBy(const Offset(201.0, 201.0));
      await tester.pump(const Duration(seconds: 1));

      expect(onStartOfPageCalled, isTrue);
    },
  );

  testWidgets(
    'should call onEndOfPage if child scrollView '
    'tends to reach the end',
    (tester) async {
      const lazyLoadScrollViewKey = Key('lazyLoadScrollView');
      const childListViewKey = Key('childListView');

      bool onEndOfPageCalled = false;

      final lazyLoadScrollView = LazyLoadScrollView(
        key: lazyLoadScrollViewKey,
        onEndOfPage: () async {
          onEndOfPageCalled = true;
        },
        child: ListView(
          key: childListViewKey,
          children: List.generate(
            12,
            (index) => Container(
              height: 100,
              child: Text('Item #$index'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: lazyLoadScrollView,
        ),
      );

      expect(find.byKey(lazyLoadScrollViewKey), findsOneWidget);
      expect(find.byKey(childListViewKey), findsOneWidget);
      expect(onEndOfPageCalled, isFalse);

      final gesture = await tester.createGesture();

      await gesture.down(const Offset(100.0, 100.0));
      await tester.pump(const Duration(seconds: 1));
      await gesture.moveBy(const Offset(-601.0, -601.0));
      await tester.pump(const Duration(seconds: 1));

      expect(onEndOfPageCalled, isTrue);
    },
  );
}
