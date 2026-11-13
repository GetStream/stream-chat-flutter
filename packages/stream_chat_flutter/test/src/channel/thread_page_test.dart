import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'thread_page_harness.dart';

void main() {
  testWidgets('renders a header, a message list and a composer', (tester) async {
    await pumpThreadPage(tester);

    expect(find.byType(StreamThreadHeader), findsOneWidget);
    expect(find.byType(StreamMessageListView), findsOneWidget);
    expect(find.byType(StreamMessageComposer), findsOneWidget);
  });

  testWidgets('shows the thread of the parent message', (tester) async {
    final parent = Message(id: 'parent-id', text: 'Hello world!');

    await pumpThreadPage(tester, parent: parent);

    expect(messageListView(tester).parentMessage, parent);
  });

  testWidgets('addresses new messages to the parent thread', (tester) async {
    final parent = Message(id: 'parent-id', text: 'Hello world!');

    await pumpThreadPage(tester, parent: parent);

    expect(composerController(tester).message.parentId, 'parent-id');
  });

  testWidgets('hides the composer when the deleted parent message has no replies', (tester) async {
    final parent = Message(id: 'parent-id', text: 'Hello world!', type: 'deleted');

    await pumpThreadPage(tester, parent: parent);

    expect(find.byType(StreamMessageComposer), findsNothing);
  });

  testWidgets('shows the composer when the deleted parent message has replies', (tester) async {
    final parent = Message(id: 'parent-id', text: 'Hello world!', type: 'deleted', replyCount: 1);

    await pumpThreadPage(tester, parent: parent);

    expect(find.byType(StreamMessageComposer), findsOneWidget);
  });

  testWidgets('still shows the thread when the parent message is deleted', (tester) async {
    final parent = Message(id: 'parent-id', text: 'Hello world!', type: 'deleted');

    await pumpThreadPage(tester, parent: parent);

    expect(find.byType(StreamMessageListView), findsOneWidget);
  });

  testWidgets('replying to a message quotes it in the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await pumpThreadPage(tester);
    messageListView(tester).onReplyTap!(message);
    await tester.pumpAndSettle();

    expect(composerController(tester).message.quotedMessage, message);
  });

  testWidgets('replying to a message focuses the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await pumpThreadPage(tester);
    messageListView(tester).onReplyTap!(message);
    await tester.pumpAndSettle();

    expect(composerFocusNode(tester).hasFocus, isTrue);
  });

  testWidgets('editing a message loads it into the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await pumpThreadPage(tester);
    messageListView(tester).onEditMessageTap!(message);
    await tester.pumpAndSettle();

    expect(composerController(tester).messageBeingEdited, message);
  });

  testWidgets('editing a message focuses the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await pumpThreadPage(tester);
    messageListView(tester).onEditMessageTap!(message);
    await tester.pumpAndSettle();

    expect(composerFocusNode(tester).hasFocus, isTrue);
  });

  testWidgets('forwards onViewInChannelTap to the message list', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');
    Message? viewedInChannel;

    await pumpThreadPage(tester, onViewInChannelTap: (message) => viewedInChannel = message);
    messageListView(tester).onViewInChannelTap!(message);
    await tester.pumpAndSettle();

    expect(viewedInChannel, message);
  });

  testWidgets('insets the message list behind a floating app bar and composer', (tester) async {
    await pumpThreadPage(tester, surfaceStyle: StreamSurfaceStyle.floating);

    // The floating scaffold injects the bar extents into MediaQuery.padding,
    // which the message list consumes to inset its content behind the chrome.
    final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));

    expect(padding.top, greaterThan(0));
    expect(padding.bottom, greaterThan(0));
  });

  testWidgets('does not inset the message list when the app style is regular', (tester) async {
    await pumpThreadPage(tester);

    // Regular bars occupy their own space, so nothing is injected into padding.
    final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));

    expect(padding.top, 0);
    expect(padding.bottom, 0);
  });

  testWidgets('a floating header theme insets the list and floats the header together', (tester) async {
    // threadHeaderTheme lives on StreamChatThemeData, which StreamScaffold
    // cannot read; both halves are asserted together.
    await pumpThreadPage(tester, headerSurfaceStyle: StreamSurfaceStyle.floating);

    final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));
    expect(padding.top, greaterThan(0));
    expect(_backButtonIsFloating(tester), isTrue);
  });

  testWidgets('a regular header theme docks the header and drops the top inset together', (tester) async {
    await pumpThreadPage(
      tester,
      surfaceStyle: StreamSurfaceStyle.floating,
      headerSurfaceStyle: StreamSurfaceStyle.regular,
    );

    final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));
    expect(padding.top, 0);
    expect(_backButtonIsFloating(tester), isFalse);
  });

  testWidgets('shows a back button by default', (tester) async {
    await pumpThreadPage(tester);

    expect(find.byType(StreamBackButton), findsOneWidget);
  });

  testWidgets('hides the back button when automaticallyImplyLeading is false', (tester) async {
    await pumpThreadPage(tester, automaticallyImplyLeading: false);

    expect(find.byType(StreamBackButton), findsNothing);
  });

  testWidgets('tapping back invokes onBackPressed', (tester) async {
    var backPressed = 0;
    await pumpThreadPage(tester, onBackPressed: () => backPressed++);

    await tester.tap(find.byType(StreamBackButton));
    await tester.pumpAndSettle();

    expect(backPressed, 1);
  });

  testWidgets('onBackPressed replaces the default pop', (tester) async {
    await pumpThreadPage(tester, onBackPressed: () {}, pushOntoARoute: true);

    await tester.tap(find.byType(StreamBackButton));
    await tester.pumpAndSettle();

    expect(find.byType(StreamThreadPage), findsOneWidget);
  });

  testWidgets('pops the route when onBackPressed is not set', (tester) async {
    await pumpThreadPage(tester, pushOntoARoute: true);

    await tester.tap(find.byType(StreamBackButton));
    await tester.pumpAndSettle();

    expect(find.byType(StreamThreadPage), findsNothing);
  });

  testWidgets('disposes its composer controller when removed from the tree', (tester) async {
    await pumpThreadPage(tester);
    final controller = composerController(tester);

    // A bare widget, so the whole app subtree unmounts.
    await tester.pumpWidget(const SizedBox.shrink());

    // A disposed ChangeNotifier throws when listened to again.
    expect(() => controller.addListener(() {}), throwsFlutterError);
  });
}

// Whether the header's default back button rendered its floating appearance.
bool? _backButtonIsFloating(WidgetTester tester) {
  final button = find.descendant(of: find.byType(StreamBackButton), matching: find.byType(StreamButton));
  return tester.widget<StreamButton>(button).props.isFloating;
}
