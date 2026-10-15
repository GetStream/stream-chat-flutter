// How the paged lists' default loading, empty and error states clear the side
// safe-area insets, while custom ones are left as built.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

class MockStreamThreadListController extends Mock implements StreamThreadListController {
  MockStreamThreadListController(this.value);

  @override
  PagedValue<String, Thread> value;

  @override
  ValueListenable<Set<String>> get unseenThreadIds => ValueNotifier(const {});
}

class MockStreamChannelListController extends Mock implements StreamChannelListController {
  MockStreamChannelListController(this.value);

  @override
  PagedValue<int, Channel> value;
}

const _padding = EdgeInsets.only(left: 47, right: 84);

void main() {
  late StreamChatClient client;

  setUp(() {
    client = MockClient();
    final clientState = MockClientState();
    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user-id'));
  });

  Future<void> pumpList(WidgetTester tester, Widget list) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(padding: _padding),
            child: StreamChat(
              client: client,
              configData: StreamChatConfigurationData(),
              connectivityStream: Stream.value([ConnectivityResult.wifi]),
              child: Scaffold(body: list),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  StreamThreadListView threadList(PagedValue<String, Thread> value, {WidgetBuilder? emptyBuilder}) {
    final controller = MockStreamThreadListController(value);
    when(controller.doInitialLoad).thenAnswer((_) async {});
    return StreamThreadListView(controller: controller, emptyBuilder: emptyBuilder);
  }

  double screenWidth(WidgetTester tester) => tester.view.physicalSize.width / tester.view.devicePixelRatio;

  // The horizontal center of the area between the side insets.
  double safeCenterX(WidgetTester tester) => (_padding.left + screenWidth(tester) - _padding.right) / 2;

  testWidgets('centers the default empty state between the side insets', (tester) async {
    await pumpList(tester, threadList(const PagedValue(items: [])));

    final content = find.descendant(of: find.byType(StreamScrollViewEmptyWidget), matching: find.byType(Column));
    expect(tester.getCenter(content).dx, moreOrLessEquals(safeCenterX(tester)));
  });

  testWidgets('centers the default error state between the side insets', (tester) async {
    await pumpList(tester, threadList(const PagedValue.error(StreamChatError('error'))));

    final content = find.descendant(of: find.byType(StreamScrollViewErrorWidget), matching: find.byType(Column));
    expect(tester.getCenter(content).dx, moreOrLessEquals(safeCenterX(tester)));
  });

  testWidgets('keeps the default thread skeleton clear of the side insets', (tester) async {
    await pumpList(tester, threadList(const PagedValue.loading()));

    final avatar = tester.getRect(find.byType(StreamSkeletonBox).first);
    expect(avatar.left, moreOrLessEquals(_padding.left));
  });

  testWidgets('keeps the default channel skeleton clear of the side insets', (tester) async {
    final controller = MockStreamChannelListController(const PagedValue.loading());
    when(controller.doInitialLoad).thenAnswer((_) async {});
    await pumpList(tester, StreamChannelListView(controller: controller));

    final boxes = find.byType(StreamSkeletonBox);
    expect(tester.getRect(boxes.first).left, moreOrLessEquals(_padding.left));
    // The timestamp placeholder ends each row's first line.
    expect(tester.getRect(boxes.at(2)).right, moreOrLessEquals(screenWidth(tester) - _padding.right));
  });

  testWidgets('leaves a custom empty state as built', (tester) async {
    const key = Key('custom-empty');
    await pumpList(
      tester,
      threadList(
        const PagedValue(items: []),
        emptyBuilder: (_) => const SizedBox.expand(key: key),
      ),
    );

    final rect = tester.getRect(find.byKey(key));
    expect(rect.left, 0);
    expect(rect.right, screenWidth(tester));
  });

  testWidgets('StreamScrollViewLoadingWidget centers between the side insets', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(padding: _padding),
            child: const Center(child: StreamScrollViewLoadingWidget()),
          ),
        ),
      ),
    );

    final spinner = find.byType(StreamLoadingSpinner);
    expect(tester.getCenter(spinner).dx, moreOrLessEquals(safeCenterX(tester)));
  });
}
