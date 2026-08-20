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
    await _pumpThreadPage(tester);

    expect(find.byType(StreamThreadHeader), findsOneWidget);
    expect(find.byType(StreamMessageListView), findsOneWidget);
    expect(find.byType(StreamMessageComposer), findsOneWidget);
  });

  testWidgets('shows the thread of the parent message', (tester) async {
    final parent = Message(id: 'parent-id', text: 'Hello world!');

    await _pumpThreadPage(tester, parent: parent);

    expect(_messageListView(tester).parentMessage, parent);
  });

  testWidgets('addresses new messages to the parent thread', (tester) async {
    final parent = Message(id: 'parent-id', text: 'Hello world!');

    await _pumpThreadPage(tester, parent: parent);

    expect(_composerController(tester).message.parentId, 'parent-id');
  });

  testWidgets('hides the composer when the parent message is deleted', (tester) async {
    final parent = Message(id: 'parent-id', text: 'Hello world!', type: 'deleted');

    await _pumpThreadPage(tester, parent: parent);

    expect(find.byType(StreamMessageComposer), findsNothing);
  });

  testWidgets('still shows the thread when the parent message is deleted', (tester) async {
    final parent = Message(id: 'parent-id', text: 'Hello world!', type: 'deleted');

    await _pumpThreadPage(tester, parent: parent);

    expect(find.byType(StreamMessageListView), findsOneWidget);
  });

  testWidgets('replying to a message quotes it in the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await _pumpThreadPage(tester);
    _messageListView(tester).onReplyTap!(message);
    await tester.pumpAndSettle();

    expect(_composerController(tester).message.quotedMessage, message);
  });

  testWidgets('replying to a message focuses the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await _pumpThreadPage(tester);
    _messageListView(tester).onReplyTap!(message);
    await tester.pumpAndSettle();

    expect(_composerFocusNode(tester).hasFocus, isTrue);
  });

  testWidgets('editing a message loads it into the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await _pumpThreadPage(tester);
    _messageListView(tester).onEditMessageTap!(message);
    await tester.pumpAndSettle();

    expect(_composerController(tester).messageBeingEdited, message);
  });

  testWidgets('editing a message focuses the composer', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');

    await _pumpThreadPage(tester);
    _messageListView(tester).onEditMessageTap!(message);
    await tester.pumpAndSettle();

    expect(_composerFocusNode(tester).hasFocus, isTrue);
  });

  testWidgets('forwards onViewInChannelTap to the message list', (tester) async {
    final message = Message(id: 'message-id', text: 'Hello world!');
    Message? viewedInChannel;

    await _pumpThreadPage(tester, onViewInChannelTap: (message) => viewedInChannel = message);
    _messageListView(tester).onViewInChannelTap!(message);
    await tester.pumpAndSettle();

    expect(viewedInChannel, message);
  });

  testWidgets('insets the message list behind a floating app bar and composer', (tester) async {
    await _pumpThreadPage(tester, surfaceStyle: StreamSurfaceStyle.floating);

    // The floating scaffold injects the bar extents into MediaQuery.padding,
    // which the message list consumes to inset its content behind the chrome.
    final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));

    expect(padding.top, greaterThan(0));
    expect(padding.bottom, greaterThan(0));
  });

  testWidgets('does not inset the message list when the app style is regular', (tester) async {
    await _pumpThreadPage(tester);

    // Regular bars occupy their own space, so nothing is injected into padding.
    final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));

    expect(padding.top, 0);
    expect(padding.bottom, 0);
  });

  testWidgets('a floating header theme insets the list and floats the header together', (tester) async {
    // threadHeaderTheme lives on StreamChatThemeData, which StreamScaffold
    // cannot read; both halves are asserted together.
    await _pumpThreadPage(tester, headerSurfaceStyle: StreamSurfaceStyle.floating);

    final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));
    expect(padding.top, greaterThan(0));
    expect(_backButtonIsFloating(tester), isTrue);
  });

  testWidgets('a regular header theme docks the header and drops the top inset together', (tester) async {
    await _pumpThreadPage(
      tester,
      surfaceStyle: StreamSurfaceStyle.floating,
      headerSurfaceStyle: StreamSurfaceStyle.regular,
    );

    final padding = MediaQuery.paddingOf(tester.element(find.byType(StreamMessageListView)));
    expect(padding.top, 0);
    expect(_backButtonIsFloating(tester), isFalse);
  });

  testWidgets('tapping back invokes onBackPressed', (tester) async {
    var backPressed = 0;
    await _pumpThreadPage(tester, onBackPressed: () => backPressed++);

    await tester.tap(find.byType(StreamBackButton));
    await tester.pumpAndSettle();

    expect(backPressed, 1);
  });

  testWidgets('onBackPressed replaces the default pop', (tester) async {
    await _pumpThreadPage(tester, onBackPressed: () {}, pushOntoARoute: true);

    await tester.tap(find.byType(StreamBackButton));
    await tester.pumpAndSettle();

    expect(find.byType(StreamThreadPage), findsOneWidget);
  });

  testWidgets('pops the route when onBackPressed is not set', (tester) async {
    await _pumpThreadPage(tester, pushOntoARoute: true);

    await tester.tap(find.byType(StreamBackButton));
    await tester.pumpAndSettle();

    expect(find.byType(StreamThreadPage), findsNothing);
  });

  testWidgets('disposes its composer controller when removed from the tree', (tester) async {
    await _pumpThreadPage(tester);
    final controller = _composerController(tester);

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

StreamMessageListView _messageListView(WidgetTester tester) {
  return tester.widget<StreamMessageListView>(find.byType(StreamMessageListView));
}

// The controller the page created and handed to its composer.
StreamMessageComposerController _composerController(WidgetTester tester) {
  return tester.widget<StreamChatMessageInput>(find.byType(StreamChatMessageInput)).controller!;
}

// The focus node the page created and handed to its composer.
FocusNode _composerFocusNode(WidgetTester tester) {
  return tester.widget<StreamChatMessageInput>(find.byType(StreamChatMessageInput)).focusNode!;
}

Future<void> _pumpThreadPage(
  WidgetTester tester, {
  Message? parent,
  StreamSurfaceStyle surfaceStyle = StreamSurfaceStyle.regular,
  StreamSurfaceStyle? headerSurfaceStyle,
  void Function(Message message)? onViewInChannelTap,
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
  final parentMessage = parent ?? Message(id: 'parent-id', text: 'Hello world!');

  // The thread is loaded — an empty reply list, not a missing one, is what
  // takes the message list out of its skeleton-loading state.
  final threads = {parentMessage.id: <Message>[]};

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
  when(() => clientState.totalUnreadCount).thenReturn(0);
  when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(0));
  // Keyed by cid so the header's back button can resolve the channel's unread
  // count. Without it StreamUnreadIndicator.channels gets a null stream and
  // renders nothing, which silently makes the back button untappable.
  final channelsById = {channel.cid!: channel};
  when(() => clientState.channels).thenReturn(channelsById);
  when(() => clientState.channelsStream).thenAnswer((_) => Stream.value(channelsById));

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
  when(
    () => channel.getReplies(
      any(),
      options: any(named: 'options'),
      preferOffline: any(named: 'preferOffline'),
    ),
  ).thenAnswer((_) async => QueryRepliesResponse()..messages = []);

  when(() => channelState.members).thenReturn([]);
  when(() => channelState.membersStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.messages).thenReturn([]);
  when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.threads).thenReturn(threads);
  when(() => channelState.threadsStream).thenAnswer((_) => Stream.value(threads));
  when(() => channelState.draft).thenReturn(null);
  when(() => channelState.isUpToDateStream).thenAnswer((_) => Stream.value(true));
  when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(0));
  when(() => channelState.readStream).thenAnswer((_) => Stream.value([]));
  when(() => channelState.currentUserRead).thenReturn(null);
  when(() => channelState.currentUserReadStream).thenAnswer((_) => const Stream.empty());

  final page = StreamThreadPage(
    parent: parentMessage,
    onViewInChannelTap: onViewInChannelTap,
    onBackPressed: onBackPressed,
  );

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(extensions: [StreamTheme(surfaceStyle: surfaceStyle)]),
      // Chat context lives above the navigator so it survives a pop.
      builder: (context, child) => StreamChat(
        client: client,
        themeData: switch (headerSurfaceStyle) {
          final surfaceStyle? => StreamChatThemeData(
            threadHeaderTheme: StreamAppBarThemeData(style: StreamAppBarStyle(surfaceStyle: surfaceStyle)),
          ),
          _ => null,
        },
        child: StreamChannel(channel: channel, child: child!),
      ),
      // '/thread' seeds the stack with '/' underneath it, giving the back
      // button something to pop to.
      initialRoute: pushOntoARoute ? '/thread' : '/',
      routes: {
        '/': (_) => pushOntoARoute ? const Scaffold(body: SizedBox.shrink()) : page,
        '/thread': (_) => page,
      },
    ),
  );

  await tester.pumpAndSettle();
}
