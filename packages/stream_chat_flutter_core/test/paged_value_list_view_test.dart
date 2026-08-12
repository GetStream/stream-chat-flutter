import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class _TestController extends PagedValueNotifier<int, String> {
  _TestController(super.initialValue);

  _TestController.success(List<String> items, {int? nextPageKey, StreamChatError? error})
    : this(PagedValue(items: items, nextPageKey: nextPageKey, error: error));

  _TestController.loading() : this(const PagedValue.loading());

  _TestController.error(StreamChatError error) : this(PagedValue.error(error));

  final loadMoreCalls = <int>[];
  int initialLoadCount = 0;

  @override
  Future<void> doInitialLoad() async => initialLoadCount++;

  @override
  Future<void> loadMore(int nextPageKey) async => loadMoreCalls.add(nextPageKey);
}

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

PagedValueListView<int, String> _buildList(
  _TestController controller, {
  required List<int> builtIndices,
  int loadMoreTriggerIndex = 3,
}) {
  return PagedValueListView<int, String>(
    controller: controller,
    loadMoreTriggerIndex: loadMoreTriggerIndex,
    itemBuilder: (context, items, index) {
      builtIndices.add(index);
      return Text('item-$index');
    },
    separatorBuilder: (context, items, index) => const Divider(),
    emptyBuilder: (_) => const Text('empty'),
    loadMoreErrorBuilder: (_, __) => const Text('load-more-error'),
    loadMoreIndicatorBuilder: (_) => const Text('load-more-indicator'),
    loadingBuilder: (_) => const Text('loading'),
    errorBuilder: (_, __) => const Text('error'),
  );
}

void main() {
  group('PagedValueListView value states', () {
    testWidgets('renders loadingBuilder while loading', (tester) async {
      final controller = _TestController.loading();

      await tester.pumpWidget(_wrap(_buildList(controller, builtIndices: [])));
      await tester.pump();

      expect(find.text('loading'), findsOneWidget);
      expect(find.text('empty'), findsNothing);
    });

    testWidgets('renders errorBuilder on error', (tester) async {
      final controller = _TestController.error(const StreamChatError('Network error'));

      await tester.pumpWidget(_wrap(_buildList(controller, builtIndices: [])));
      await tester.pump();

      expect(find.text('error'), findsOneWidget);
    });

    testWidgets('renders emptyBuilder when there are no items', (tester) async {
      final controller = _TestController.success([]);
      final builtIndices = <int>[];

      await tester.pumpWidget(_wrap(_buildList(controller, builtIndices: builtIndices)));
      await tester.pump();

      expect(find.text('empty'), findsOneWidget);
      expect(builtIndices, isEmpty);
    });

    testWidgets('calls doInitialLoad on mount', (tester) async {
      final controller = _TestController.success(['a']);

      await tester.pumpWidget(_wrap(_buildList(controller, builtIndices: [])));
      await tester.pump();

      expect(controller.initialLoadCount, 1);
    });
  });

  group('PagedValueListView items', () {
    testWidgets('renders items starting at index 0 with separators', (tester) async {
      final controller = _TestController.success(['a', 'b', 'c']);
      final builtIndices = <int>[];

      await tester.pumpWidget(_wrap(_buildList(controller, builtIndices: builtIndices)));
      await tester.pump();

      expect(find.text('item-0'), findsOneWidget);
      expect(find.text('item-1'), findsOneWidget);
      expect(find.text('item-2'), findsOneWidget);
      expect(builtIndices, [0, 1, 2]);
      expect(find.byType(Divider), findsNWidgets(2));
    });

    testWidgets('renders no load-more slot when there is no next page', (tester) async {
      final controller = _TestController.success(['a', 'b']);

      await tester.pumpWidget(_wrap(_buildList(controller, builtIndices: [])));
      await tester.pump();

      expect(find.text('load-more-indicator'), findsNothing);
      expect(find.text('load-more-error'), findsNothing);
    });
  });

  group('PagedValueListView load more', () {
    testWidgets('renders load-more indicator after the last item', (tester) async {
      final controller = _TestController.success(['a', 'b'], nextPageKey: 1);
      final builtIndices = <int>[];

      await tester.pumpWidget(_wrap(_buildList(controller, builtIndices: builtIndices)));
      await tester.pump();

      expect(find.text('item-0'), findsOneWidget);
      expect(find.text('item-1'), findsOneWidget);
      expect(find.text('load-more-indicator'), findsOneWidget);
      expect(builtIndices, [0, 1]);
    });

    testWidgets('renders load-more error instead of the indicator when errored', (tester) async {
      final controller = _TestController.success(
        ['a', 'b'],
        nextPageKey: 1,
        error: const StreamChatError('Load more failed'),
      );

      await tester.pumpWidget(_wrap(_buildList(controller, builtIndices: [])));
      await tester.pump();

      expect(find.text('load-more-error'), findsOneWidget);
      expect(find.text('load-more-indicator'), findsNothing);
    });

    testWidgets('requests the next page when the trigger index is built', (tester) async {
      final controller = _TestController.success(['a', 'b', 'c'], nextPageKey: 7);

      // items.length (3) - triggerIndex (3) == 0, so building item 0 triggers.
      await tester.pumpWidget(_wrap(_buildList(controller, builtIndices: [])));
      await tester.pump();

      expect(controller.loadMoreCalls, [7]);
    });

    testWidgets('does not request the next page when there is no next page', (tester) async {
      final controller = _TestController.success(['a', 'b', 'c']);

      await tester.pumpWidget(_wrap(_buildList(controller, builtIndices: [])));
      await tester.pump();

      expect(controller.loadMoreCalls, isEmpty);
    });

    testWidgets('does not request the next page while an error is present', (tester) async {
      final controller = _TestController.success(
        ['a', 'b', 'c'],
        nextPageKey: 7,
        error: const StreamChatError('Load more failed'),
      );

      await tester.pumpWidget(_wrap(_buildList(controller, builtIndices: [])));
      await tester.pump();

      expect(controller.loadMoreCalls, isEmpty);
    });

    testWidgets('releases the duplicate guard once the scheduled request settles', (tester) async {
      final controller = _TestController.success(['a', 'b', 'c'], nextPageKey: 7);

      await tester.pumpWidget(_wrap(_buildList(controller, builtIndices: [])));
      await tester.pump();
      // The guard is reset by the post-frame callback, so a later rebuild at
      // the trigger index issues a fresh request rather than being swallowed.
      await tester.pumpWidget(_wrap(_buildList(controller, builtIndices: [])));
      await tester.pump();

      expect(controller.loadMoreCalls, [7, 7]);
    });
  });
}
