import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_input/stream_chat_message_input.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'channel_page_harness.dart';

void main() {
  testWidgets('renders a header, a message list and a composer', (tester) async {
    await pumpChannelPage(tester);

    expect(find.byType(StreamChannelHeader), findsOneWidget);
    expect(find.byType(StreamMessageListView), findsOneWidget);
    expect(find.byType(StreamMessageComposer), findsOneWidget);
  });

  testWidgets('tapping the channel avatar invokes onChannelAvatarPressed', (tester) async {
    Channel? pressedChannel;
    await pumpChannelPage(tester, onChannelAvatarPressed: (_, channel) => pressedChannel = channel);

    await tester.tap(_channelAvatarTapTarget());
    await tester.pumpAndSettle();

    expect(pressedChannel, isNotNull);
  });

  testWidgets('shows a back button by default', (tester) async {
    await pumpChannelPage(tester);

    expect(find.byType(StreamBackButton), findsOneWidget);
  });

  testWidgets('hides the back button when automaticallyImplyLeading is false', (tester) async {
    await pumpChannelPage(tester, automaticallyImplyLeading: false);

    expect(find.byType(StreamBackButton), findsNothing);
  });

  testWidgets('tapping back invokes onBackPressed', (tester) async {
    var backPressed = 0;
    await pumpChannelPage(tester, onBackPressed: () => backPressed++);

    await tester.tap(find.byType(StreamBackButton));
    await tester.pumpAndSettle();

    expect(backPressed, 1);
  });

  testWidgets('onBackPressed replaces the default pop', (tester) async {
    await pumpChannelPage(tester, onBackPressed: () {}, pushOntoARoute: true);

    await tester.tap(find.byType(StreamBackButton));
    await tester.pumpAndSettle();

    expect(find.byType(StreamChannelPage), findsOneWidget);
  });

  testWidgets('pops the route when onBackPressed is not set', (tester) async {
    await pumpChannelPage(tester, pushOntoARoute: true);

    await tester.tap(find.byType(StreamBackButton));
    await tester.pumpAndSettle();

    expect(find.byType(StreamChannelPage), findsNothing);
  });

  testWidgets('replying to a message quotes it in the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await pumpChannelPage(tester);
    messageListView(tester).onReplyTap!(message);
    await tester.pumpAndSettle();

    expect(composerController(tester).message.quotedMessage, message);
  });

  testWidgets('replying to a message focuses the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await pumpChannelPage(tester);
    messageListView(tester).onReplyTap!(message);
    await tester.pumpAndSettle();

    expect(composerFocusNode(tester).hasFocus, isTrue);
  });

  testWidgets('editing a message loads it into the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await pumpChannelPage(tester);
    messageListView(tester).onEditMessageTap!(message);
    await tester.pumpAndSettle();

    expect(composerController(tester).messageBeingEdited, message);
  });

  testWidgets('editing a message focuses the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await pumpChannelPage(tester);
    messageListView(tester).onEditMessageTap!(message);
    await tester.pumpAndSettle();

    expect(composerFocusNode(tester).hasFocus, isTrue);
  });

  testWidgets('opens a thread page for the tapped parent message', (tester) async {
    final parentMessage = Message(id: 'parent-id', text: 'Hello world!');

    await pumpChannelPage(tester);
    final context = tester.element(find.byType(StreamMessageListView));
    final thread = messageListView(tester).threadBuilder!(context, parentMessage);

    expect(thread, isA<StreamThreadPage>().having((it) => it.parent, 'parent', parentMessage));
  });

  testWidgets('insets the message list behind a floating app bar and composer', (tester) async {
    await pumpChannelPage(tester, surfaceStyle: StreamSurfaceStyle.floating);

    // The floating scaffold injects the bar extents into MediaQuery.padding,
    // which the message list consumes to inset its content behind the chrome.
    final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));

    expect(padding.top, greaterThan(0));
    expect(padding.bottom, greaterThan(0));
  });

  testWidgets('does not inset the message list when the app style is regular', (tester) async {
    await pumpChannelPage(tester);

    // Regular bars occupy their own space, so nothing is injected into padding.
    final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));

    expect(padding.top, 0);
    expect(padding.bottom, 0);
  });

  testWidgets(
    'a floating composer override insets the list even when the app style is regular',
    (tester) async {
      await pumpChannelPage(
        tester,
        composerSurfaceStyle: StreamSurfaceStyle.floating,
      );

      // The composer's own theme is floating, so the scaffold must publish the
      // bottom inset for it even though the ambient app style is regular. The
      // app bar stays regular, so only the bottom is inset.
      final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));

      expect(padding.top, 0);
      expect(padding.bottom, greaterThan(0));
      expect(_composerIsFloating(tester), isTrue);
    },
  );

  testWidgets(
    'a regular composer override drops the bottom inset even when the app style is floating',
    (tester) async {
      await pumpChannelPage(
        tester,
        surfaceStyle: StreamSurfaceStyle.floating,
        composerSurfaceStyle: StreamSurfaceStyle.regular,
      );

      // The composer docks itself via its own theme, so the scaffold must not
      // inset the list for it — but the floating app bar still insets the top.
      final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));

      expect(padding.top, greaterThan(0));
      expect(padding.bottom, 0);
      expect(_composerIsFloating(tester), isFalse);
    },
  );

  testWidgets(
    'a floating header theme insets the list and floats the header together',
    (tester) async {
      // channelHeaderTheme lives on StreamChatThemeData, which StreamScaffold
      // cannot read; both halves are asserted together.
      await pumpChannelPage(tester, headerSurfaceStyle: StreamSurfaceStyle.floating);

      final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));
      expect(padding.top, greaterThan(0));
      expect(_backButtonIsFloating(tester), isTrue);
    },
  );

  testWidgets(
    'a regular header theme docks the header and drops the top inset together',
    (tester) async {
      await pumpChannelPage(
        tester,
        surfaceStyle: StreamSurfaceStyle.floating,
        headerSurfaceStyle: StreamSurfaceStyle.regular,
      );

      final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));
      expect(padding.top, 0);
      expect(_backButtonIsFloating(tester), isFalse);
    },
  );

  testWidgets('disposes its composer controller when removed from the tree', (tester) async {
    await pumpChannelPage(tester);
    final controller = composerController(tester);

    // A bare widget, so the whole app subtree unmounts.
    await tester.pumpWidget(const SizedBox.shrink());

    // A disposed ChangeNotifier throws when listened to again.
    expect(() => controller.addListener(() {}), throwsFlutterError);
  });
}

// Whether the composer rendered its floating appearance.
bool _composerIsFloating(WidgetTester tester) {
  return tester.widget<StreamChatMessageInput>(find.byType(StreamChatMessageInput)).isFloating;
}

// Whether the header's default back button rendered its floating appearance.
bool? _backButtonIsFloating(WidgetTester tester) {
  final button = find.descendant(of: find.byType(StreamBackButton), matching: find.byType(StreamButton));
  return tester.widget<StreamButton>(button).props.isFloating;
}

// The gesture detector wrapping the header's channel avatar.
Finder _channelAvatarTapTarget() {
  return find.ancestor(
    of: find.byType(StreamChannelAvatar),
    matching: find.byType(GestureDetector),
  );
}
