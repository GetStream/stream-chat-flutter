import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class _TestController extends PagedValueNotifier<int, String> {
  _TestController(List<String> items, {int? nextPageKey}) : super(PagedValue(items: items, nextPageKey: nextPageKey));

  @override
  Future<void> doInitialLoad() async {}

  @override
  Future<void> loadMore(int nextPageKey) async {}
}

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

PagedValueGridView<int, String> _buildGrid(
  _TestController controller, {
  WidgetBuilder? leadingItemBuilder,
  required List<int> builtIndices,
}) {
  return PagedValueGridView<int, String>(
    controller: controller,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    leadingItemBuilder: leadingItemBuilder,
    itemBuilder: (context, items, index) {
      builtIndices.add(index);
      return Text('item-$index');
    },
    emptyBuilder: (_) => const Text('empty'),
    loadMoreErrorBuilder: (_, __) => const Text('load-more-error'),
    loadMoreIndicatorBuilder: (_) => const Text('load-more-indicator'),
    loadingBuilder: (_) => const Text('loading'),
    errorBuilder: (_, __) => const Text('error'),
  );
}

void main() {
  group('PagedValueGridView without leadingItemBuilder', () {
    testWidgets('renders items starting at index 0', (tester) async {
      final controller = _TestController(['a', 'b', 'c']);
      final builtIndices = <int>[];

      await tester.pumpWidget(_wrap(_buildGrid(controller, builtIndices: builtIndices)));
      await tester.pump();

      expect(find.text('item-0'), findsOneWidget);
      expect(find.text('item-1'), findsOneWidget);
      expect(find.text('item-2'), findsOneWidget);
      expect(builtIndices, [0, 1, 2]);
    });

    testWidgets('does not render a leading item', (tester) async {
      final controller = _TestController(['a']);
      final builtIndices = <int>[];

      await tester.pumpWidget(_wrap(_buildGrid(controller, builtIndices: builtIndices)));
      await tester.pump();

      expect(find.text('leading'), findsNothing);
      expect(builtIndices, [0]);
    });
  });

  group('PagedValueGridView with leadingItemBuilder', () {
    testWidgets('renders the leading item before the paged items', (tester) async {
      final controller = _TestController(['a', 'b', 'c']);
      final builtIndices = <int>[];

      await tester.pumpWidget(
        _wrap(
          _buildGrid(
            controller,
            leadingItemBuilder: (_) => const Text('leading'),
            builtIndices: builtIndices,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('leading'), findsOneWidget);
      expect(find.text('item-0'), findsOneWidget);
      expect(find.text('item-1'), findsOneWidget);
      expect(find.text('item-2'), findsOneWidget);
    });

    testWidgets('itemBuilder receives item indices starting at 0, not offset', (tester) async {
      final controller = _TestController(['a', 'b', 'c']);
      final builtIndices = <int>[];

      await tester.pumpWidget(
        _wrap(
          _buildGrid(
            controller,
            leadingItemBuilder: (_) => const Text('leading'),
            builtIndices: builtIndices,
          ),
        ),
      );
      await tester.pump();

      expect(builtIndices, [0, 1, 2]);
    });

    testWidgets('renders leading item even with a single paged item', (tester) async {
      final controller = _TestController(['a']);
      final builtIndices = <int>[];

      await tester.pumpWidget(
        _wrap(
          _buildGrid(
            controller,
            leadingItemBuilder: (_) => const Text('leading'),
            builtIndices: builtIndices,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('leading'), findsOneWidget);
      expect(find.text('item-0'), findsOneWidget);
      expect(builtIndices, [0]);
    });

    testWidgets('renders load-more indicator at correct position with leading item', (tester) async {
      final controller = _TestController(['item-0', 'item-1'], nextPageKey: 1);
      final builtIndices = <int>[];

      await tester.pumpWidget(
        _wrap(
          _buildGrid(
            controller,
            leadingItemBuilder: (_) => const Text('leading'),
            builtIndices: builtIndices,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('leading'), findsOneWidget);
      expect(find.text('item-0'), findsOneWidget);
      expect(find.text('item-1'), findsOneWidget);
      expect(find.text('load-more-indicator'), findsOneWidget);
      expect(builtIndices, [0, 1]);
    });
  });
}
