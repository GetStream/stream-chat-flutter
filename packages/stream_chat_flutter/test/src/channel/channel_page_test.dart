import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/src/message_input/stream_chat_message_input.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  testWidgets('renders a header, a message list and a composer', (tester) async {
    await _pumpChannelPage(tester);

    expect(find.byType(StreamChannelHeader), findsOneWidget);
    expect(find.byType(StreamMessageListView), findsOneWidget);
    expect(find.byType(StreamMessageComposer), findsOneWidget);
  });

  testWidgets('renders a typing indicator above the composer', (tester) async {
    await _pumpChannelPage(tester, surfaceStyle: StreamSurfaceStyle.floating);

    final indicator = tester.getRect(_bodyTypingIndicator());
    final composer = tester.getRect(find.byType(StreamMessageComposer));

    expect(indicator.bottom, lessThanOrEqualTo(composer.top));
  });

  testWidgets('tapping the channel avatar invokes onChannelAvatarPressed', (tester) async {
    Channel? pressedChannel;
    await _pumpChannelPage(tester, onChannelAvatarPressed: (_, channel) => pressedChannel = channel);

    await tester.tap(_channelAvatarTapTarget());
    await tester.pumpAndSettle();

    expect(pressedChannel, isNotNull);
  });

  testWidgets('tapping back invokes onBackPressed', (tester) async {
    var backPressed = 0;
    await _pumpChannelPage(tester, onBackPressed: () => backPressed++);

    await tester.tap(find.byType(StreamBackButton));
    await tester.pumpAndSettle();

    expect(backPressed, 1);
  });

  testWidgets('onBackPressed replaces the default pop', (tester) async {
    await _pumpChannelPage(tester, onBackPressed: () {}, pushOntoARoute: true);

    await tester.tap(find.byType(StreamBackButton));
    await tester.pumpAndSettle();

    expect(find.byType(StreamChannelPage), findsOneWidget);
  });

  testWidgets('pops the route when onBackPressed is not set', (tester) async {
    await _pumpChannelPage(tester, pushOntoARoute: true);

    await tester.tap(find.byType(StreamBackButton));
    await tester.pumpAndSettle();

    expect(find.byType(StreamChannelPage), findsNothing);
  });

  testWidgets('replying to a message quotes it in the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await _pumpChannelPage(tester);
    _messageListView(tester).onReplyTap!(message);
    await tester.pumpAndSettle();

    expect(_composerController(tester).message.quotedMessage, message);
  });

  testWidgets('replying to a message focuses the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await _pumpChannelPage(tester);
    _messageListView(tester).onReplyTap!(message);
    await tester.pumpAndSettle();

    expect(_composerFocusNode(tester).hasFocus, isTrue);
  });

  testWidgets('editing a message loads it into the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await _pumpChannelPage(tester);
    _messageListView(tester).onEditMessageTap!(message);
    await tester.pumpAndSettle();

    expect(_composerController(tester).messageBeingEdited, message);
  });

  testWidgets('editing a message focuses the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await _pumpChannelPage(tester);
    _messageListView(tester).onEditMessageTap!(message);
    await tester.pumpAndSettle();

    expect(_composerFocusNode(tester).hasFocus, isTrue);
  });

  testWidgets('opens a thread page for the tapped parent message', (tester) async {
    final parentMessage = Message(id: 'parent-id', text: 'Hello world!');

    await _pumpChannelPage(tester);
    final context = tester.element(find.byType(StreamMessageListView));
    final thread = _messageListView(tester).threadBuilder!(context, parentMessage);

    expect(thread, isA<StreamThreadPage>().having((it) => it.parent, 'parent', parentMessage));
  });

  testWidgets('insets the message list behind a floating app bar and composer', (tester) async {
    await _pumpChannelPage(tester, surfaceStyle: StreamSurfaceStyle.floating);

    // The floating scaffold injects the bar extents into MediaQuery.padding,
    // which the message list consumes to inset its content behind the chrome.
    final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));

    expect(padding.top, greaterThan(0));
    expect(padding.bottom, greaterThan(0));
  });

  testWidgets('does not inset the message list when the app style is regular', (tester) async {
    await _pumpChannelPage(tester);

    // Regular bars occupy their own space, so nothing is injected into padding.
    final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));

    expect(padding.top, 0);
    expect(padding.bottom, 0);
  });

  testWidgets(
    'a floating composer override insets the list even when the app style is regular',
    (tester) async {
      await _pumpChannelPage(
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
      await _pumpChannelPage(
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
      await _pumpChannelPage(tester, headerSurfaceStyle: StreamSurfaceStyle.floating);

      final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));
      expect(padding.top, greaterThan(0));
      expect(_backButtonIsFloating(tester), isTrue);
    },
  );

  testWidgets(
    'a regular header theme docks the header and drops the top inset together',
    (tester) async {
      await _pumpChannelPage(
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
    await _pumpChannelPage(tester);
    final controller = _composerController(tester);

    // A bare widget, so the whole app subtree unmounts.
    await tester.pumpWidget(const SizedBox.shrink());

    // A disposed ChangeNotifier throws when listened to again.
    expect(() => controller.addListener(() {}), throwsFlutterError);
  });
}

/// Whether the composer rendered its floating appearance.
bool _composerIsFloating(WidgetTester tester) {
  return tester.widget<StreamChatMessageInput>(find.byType(StreamChatMessageInput)).isFloating;
}

/// Whether the header's default back button rendered its floating appearance.
bool? _backButtonIsFloating(WidgetTester tester) {
  final button = find.descendant(of: find.byType(StreamBackButton), matching: find.byType(StreamButton));
  return tester.widget<StreamButton>(button).props.isFloating;
}

StreamMessageListView _messageListView(WidgetTester tester) {
  return tester.widget<StreamMessageListView>(find.byType(StreamMessageListView));
}

/// The typing indicator the page renders in its body.
///
/// The header renders one of its own as part of the channel subtitle, so the
/// plain type finder is ambiguous.
Finder _bodyTypingIndicator() {
  final inHeader = find
      .descendant(of: find.byType(StreamChannelHeader), matching: find.byType(StreamTypingIndicator))
      .evaluate()
      .toSet();

  return find.byElementPredicate((element) {
    return element.widget is StreamTypingIndicator && !inHeader.contains(element);
  });
}

/// The gesture detector wrapping the header's channel avatar.
Finder _channelAvatarTapTarget() {
  return find.ancestor(
    of: find.byType(StreamChannelAvatar),
    matching: find.byType(GestureDetector),
  );
}

/// The controller the page created and handed to its composer.
StreamMessageComposerController _composerController(WidgetTester tester) {
  return tester.widget<StreamChatMessageInput>(find.byType(StreamChatMessageInput)).controller!;
}

/// The focus node the page created and handed to its composer.
FocusNode _composerFocusNode(WidgetTester tester) {
  return tester.widget<StreamChatMessageInput>(find.byType(StreamChatMessageInput)).focusNode!;
}

Future<void> _pumpChannelPage(
  WidgetTester tester, {
  StreamSurfaceStyle surfaceStyle = StreamSurfaceStyle.regular,
  StreamSurfaceStyle? composerSurfaceStyle,
  StreamSurfaceStyle? headerSurfaceStyle,
  void Function(BuildContext context, Channel channel)? onChannelAvatarPressed,
  VoidCallback? onBackPressed,
  bool pushOntoARoute = false,
}) async {
  final originalRecordPlatform = RecordPlatform.instance;
  RecordPlatform.instance = FakeRecordPlatform();
  addTearDown(() => RecordPlatform.instance = originalRecordPlatform);

  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();
  final channelState = MockChannelState();
  final currentUser = OwnUser(id: 'user-id');

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
  when(() => clientState.totalUnreadCount).thenReturn(0);
  when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(0));
  // Keyed by cid so the header's back button can resolve the open channel's
  // unread count and exclude it from the total.
  when(() => clientState.channels).thenReturn({channel.cid!: channel});

  when(() => channel.client).thenReturn(client);
  when(() => channel.state).thenReturn(channelState);
  when(channel.getRemainingCooldown).thenReturn(0);
  when(() => channel.lastMessageAt).thenReturn(null);
  when(() => channel.name).thenReturn('test');
  when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
  when(() => channel.image).thenReturn(null);
  when(() => channel.imageStream).thenAnswer((_) => Stream.value(null));
  when(() => channel.isMuted).thenReturn(false);
  when(() => channel.isMutedStream).thenAnswer((_) => Stream.value(false));
  when(() => channel.extraData).thenReturn({'name': 'test'});
  when(() => channel.extraDataStream).thenAnswer((_) => Stream.value({'name': 'test'}));

  when(() => channelState.members).thenReturn([]);
  when(() => channelState.membersStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.messages).thenReturn([]);
  when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.threadsStream).thenAnswer((_) => const Stream.empty());
  when(() => channelState.draft).thenReturn(null);
  when(() => channelState.isUpToDateStream).thenAnswer((_) => Stream.value(true));
  when(() => channelState.unreadCount).thenReturn(0);
  when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(0));
  when(() => channelState.readStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.currentUserRead).thenReturn(null);
  when(() => channelState.currentUserReadStream).thenAnswer((_) => const Stream.empty());

  final page = StreamChannelPage(
    onChannelAvatarPressed: onChannelAvatarPressed,
    onBackPressed: onBackPressed,
  );

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(extensions: [StreamTheme(surfaceStyle: surfaceStyle)]),
      // Chat context lives above the navigator so it survives a pop.
      builder: (context, child) {
        Widget content = StreamChannel(channel: channel, child: child!);
        if (composerSurfaceStyle != null) {
          content = StreamMessageComposerTheme(
            data: StreamMessageComposerThemeData(surfaceStyle: composerSurfaceStyle),
            child: content,
          );
        }
        return StreamChat(
          client: client,
          themeData: switch (headerSurfaceStyle) {
            final surfaceStyle? => StreamChatThemeData(
              channelHeaderTheme: StreamAppBarThemeData(style: StreamAppBarStyle(surfaceStyle: surfaceStyle)),
            ),
            _ => null,
          },
          child: content,
        );
      },
      // '/channel' seeds the stack with '/' underneath it, giving the back
      // button something to pop to.
      initialRoute: pushOntoARoute ? '/channel' : '/',
      routes: {
        '/': (_) => pushOntoARoute ? const Scaffold(body: SizedBox.shrink()) : page,
        '/channel': (_) => page,
      },
    ),
  );

  await tester.pumpAndSettle();
}
