import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

void main() {
  testWidgets('PagedValueListView keeps its empty state clear of the safe area', (tester) async {
    final controller = _Controller(const PagedValue(items: []));
    addTearDown(controller.dispose);

    await _pump(tester, _list(controller));

    expect(tester.getRect(find.byKey(_stateKey)).right, moreOrLessEquals(_screenWidth(tester) - _rightInset));
  });

  testWidgets('PagedValueListView keeps its loading state clear of the safe area', (tester) async {
    final controller = _Controller(const PagedValue.loading());
    addTearDown(controller.dispose);

    await _pump(tester, _list(controller));

    expect(tester.getRect(find.byKey(_stateKey)).right, moreOrLessEquals(_screenWidth(tester) - _rightInset));
  });

  testWidgets('PagedValueListView keeps its error state clear of the safe area', (tester) async {
    final controller = _Controller(const PagedValue.error(StreamChatError('error')));
    addTearDown(controller.dispose);

    await _pump(tester, _list(controller));

    expect(tester.getRect(find.byKey(_stateKey)).right, moreOrLessEquals(_screenWidth(tester) - _rightInset));
  });

  testWidgets('PagedValueListView leaves its empty state alone when given an explicit padding', (tester) async {
    // An explicit padding means the caller handles the safe area.
    final controller = _Controller(const PagedValue(items: []));
    addTearDown(controller.dispose);

    await _pump(tester, _list(controller, padding: EdgeInsets.zero));

    expect(tester.getRect(find.byKey(_stateKey)).right, moreOrLessEquals(_screenWidth(tester)));
  });

  testWidgets('PagedValueGridView keeps its empty state clear of the safe area', (tester) async {
    final controller = _Controller(const PagedValue(items: []));
    addTearDown(controller.dispose);

    await _pump(tester, _grid(controller));

    expect(tester.getRect(find.byKey(_stateKey)).right, moreOrLessEquals(_screenWidth(tester) - _rightInset));
  });

  testWidgets('PagedValueGridView keeps its loading state clear of the safe area', (tester) async {
    final controller = _Controller(const PagedValue.loading());
    addTearDown(controller.dispose);

    await _pump(tester, _grid(controller));

    expect(tester.getRect(find.byKey(_stateKey)).right, moreOrLessEquals(_screenWidth(tester) - _rightInset));
  });

  testWidgets('PagedValueGridView keeps its error state clear of the safe area', (tester) async {
    final controller = _Controller(const PagedValue.error(StreamChatError('error')));
    addTearDown(controller.dispose);

    await _pump(tester, _grid(controller));

    expect(tester.getRect(find.byKey(_stateKey)).right, moreOrLessEquals(_screenWidth(tester) - _rightInset));
  });

  testWidgets('PagedValueGridView leaves its empty state alone when given an explicit padding', (tester) async {
    // An explicit padding means the caller handles the safe area.
    final controller = _Controller(const PagedValue(items: []));
    addTearDown(controller.dispose);

    await _pump(tester, _grid(controller, padding: EdgeInsets.zero));

    expect(tester.getRect(find.byKey(_stateKey)).right, moreOrLessEquals(_screenWidth(tester)));
  });
}

const _rightInset = 84.0;
const _stateKey = Key('state');

class _Controller extends PagedValueNotifier<int, String> {
  _Controller(super.value);

  @override
  Future<void> doInitialLoad() async {}

  @override
  Future<void> loadMore(int nextPageKey) async {}
}

Widget _state(BuildContext context) => const SizedBox.expand(key: _stateKey);

PagedValueListView<int, String> _list(_Controller controller, {EdgeInsetsGeometry? padding}) {
  return PagedValueListView<int, String>(
    controller: controller,
    padding: padding,
    itemBuilder: (_, __, ___) => const SizedBox(),
    separatorBuilder: (_, __, ___) => const SizedBox(),
    emptyBuilder: _state,
    loadMoreErrorBuilder: (_, __) => const SizedBox(),
    loadMoreIndicatorBuilder: (_) => const SizedBox(),
    loadingBuilder: _state,
    errorBuilder: (context, _) => _state(context),
  );
}

PagedValueGridView<int, String> _grid(_Controller controller, {EdgeInsetsGeometry? padding}) {
  return PagedValueGridView<int, String>(
    controller: controller,
    padding: padding,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    itemBuilder: (_, __, ___) => const SizedBox(),
    emptyBuilder: _state,
    loadMoreErrorBuilder: (_, __) => const SizedBox(),
    loadMoreIndicatorBuilder: (_) => const SizedBox(),
    loadingBuilder: _state,
    errorBuilder: (context, _) => _state(context),
  );
}

Future<void> _pump(WidgetTester tester, Widget scrollView) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(padding: const EdgeInsets.only(right: _rightInset)),
          child: Scaffold(body: scrollView),
        ),
      ),
    ),
  );
  await tester.pump();
}

double _screenWidth(WidgetTester tester) => tester.view.physicalSize.width / tester.view.devicePixelRatio;
