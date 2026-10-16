// How the paged lists' default loading, empty and error states keep clear of
// the side safe-area insets, while custom ones are laid out as built.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

const _padding = EdgeInsets.only(left: 47, right: 84);

void main() {
  testWidgets('StreamThreadListView centers its default empty state between the side insets', (tester) async {
    final controller = _FakeThreadListController(const PagedValue(items: []));

    await _pumpWithInsets(tester, StreamThreadListView(controller: controller));

    final content = find.descendant(of: find.byType(StreamScrollViewEmptyWidget), matching: find.byType(Column));
    expect(tester.getCenter(content).dx, moreOrLessEquals(_safeCenterX(tester)));
  });

  testWidgets('StreamThreadListView centers its default error state between the side insets', (tester) async {
    final controller = _FakeThreadListController(const PagedValue.error(StreamChatError('error')));

    await _pumpWithInsets(tester, StreamThreadListView(controller: controller));

    final content = find.descendant(of: find.byType(StreamScrollViewErrorWidget), matching: find.byType(Column));
    expect(tester.getCenter(content).dx, moreOrLessEquals(_safeCenterX(tester)));
  });

  testWidgets('StreamThreadListView keeps its default loading rows clear of the side insets', (tester) async {
    final controller = _FakeThreadListController(const PagedValue.loading());

    await _pumpWithInsets(tester, StreamThreadListView(controller: controller));

    final avatar = tester.getRect(find.byType(StreamSkeletonBox).first);
    expect(avatar.left, moreOrLessEquals(_padding.left));
  });

  testWidgets('StreamChannelListView keeps its default loading rows clear of the side insets', (tester) async {
    final controller = _FakeChannelListController(const PagedValue.loading());

    await _pumpWithInsets(tester, StreamChannelListView(controller: controller));

    final boxes = find.byType(StreamSkeletonBox);
    expect(tester.getRect(boxes.first).left, moreOrLessEquals(_padding.left));
    // The timestamp placeholder ends each row's first line.
    expect(tester.getRect(boxes.at(2)).right, moreOrLessEquals(_screenWidth(tester) - _padding.right));
  });

  testWidgets('StreamThreadListView lays out a custom empty state as built', (tester) async {
    const customEmptyKey = Key('custom-empty');
    final controller = _FakeThreadListController(const PagedValue(items: []));

    await _pumpWithInsets(
      tester,
      StreamThreadListView(
        controller: controller,
        emptyBuilder: (_) => const SizedBox.expand(key: customEmptyKey),
      ),
    );

    final rect = tester.getRect(find.byKey(customEmptyKey));
    expect(rect.left, 0);
    expect(rect.right, _screenWidth(tester));
  });

  testWidgets('StreamScrollViewLoadingWidget centers its spinner between the side insets', (tester) async {
    await _pumpWithInsets(tester, const Center(child: StreamScrollViewLoadingWidget()));

    expect(tester.getCenter(find.byType(StreamLoadingSpinner)).dx, moreOrLessEquals(_safeCenterX(tester)));
  });
}

// A thread list controller that holds [value] instead of loading from the client.
class _FakeThreadListController extends StreamThreadListController {
  _FakeThreadListController(PagedValue<String, Thread> value) : super(client: MockClient()) {
    this.value = value;
  }

  @override
  Future<void> doInitialLoad() async {}
}

// A channel list controller that holds [value] instead of loading from the client.
class _FakeChannelListController extends StreamChannelListController {
  _FakeChannelListController(PagedValue<int, Channel> value) : super(client: MockClient()) {
    this.value = value;
  }

  @override
  Future<void> doInitialLoad() async {}
}

// Pumps [child] as a scaffold body on a screen with [_padding] as its safe-area insets.
Future<void> _pumpWithInsets(WidgetTester tester, Widget child) async {
  final client = MockClient();
  final clientState = MockClientState();
  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user-id'));

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(padding: _padding),
          child: StreamChat(
            client: client,
            connectivityStream: Stream.value([ConnectivityResult.wifi]),
            child: Scaffold(body: child),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

double _screenWidth(WidgetTester tester) => tester.view.physicalSize.width / tester.view.devicePixelRatio;

// The horizontal center of the area between the side insets.
double _safeCenterX(WidgetTester tester) => (_padding.left + _screenWidth(tester) - _padding.right) / 2;
