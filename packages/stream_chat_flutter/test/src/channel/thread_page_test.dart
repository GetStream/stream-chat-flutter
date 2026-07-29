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
    _ignoreDeletedBubbleOverflow(tester);

    expect(find.byType(StreamMessageComposer), findsNothing);
  });

  testWidgets('still shows the thread when the parent message is deleted', (tester) async {
    final parent = Message(id: 'parent-id', text: 'Hello world!', type: 'deleted');

    await _pumpThreadPage(tester, parent: parent);
    _ignoreDeletedBubbleOverflow(tester);

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
    await _pumpThreadPage(tester, appStyle: StreamAppStyle.floating);

    final messageListView = _messageListView(tester);

    expect(messageListView.topPadding, greaterThan(0));
    expect(messageListView.bottomPadding, greaterThan(0));
  });

  testWidgets('does not inset the message list when the app style is regular', (tester) async {
    await _pumpThreadPage(tester);

    final messageListView = _messageListView(tester);

    expect(messageListView.topPadding, 0);
    expect(messageListView.bottomPadding, 0);
  });

  testWidgets('disposes its composer controller when removed from the tree', (tester) async {
    await _pumpThreadPage(tester);
    final controller = _composerController(tester);

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

    // A disposed ChangeNotifier throws when listened to again.
    expect(() => controller.addListener(() {}), throwsFlutterError);
  });
}

StreamMessageListView _messageListView(WidgetTester tester) {
  return tester.widget<StreamMessageListView>(find.byType(StreamMessageListView));
}

/// Drains the overflow [FlutterError] the deleted-message bubble reports.
///
/// `StreamMessageDeleted` lays out its icon and label in a fixed-width bubble.
/// The test font is squarer — and so wider — than the font that ships with the
/// app, which pushes the label a few pixels past the bubble. It fits in a real
/// app, so it is not what these tests are about.
void _ignoreDeletedBubbleOverflow(WidgetTester tester) {
  final exception = tester.takeException();
  if (exception == null) return;

  expect(exception, isFlutterError);
  expect('$exception', contains('overflowed'));
}

/// The controller the page created and handed to its composer.
StreamMessageComposerController _composerController(WidgetTester tester) {
  return tester.widget<StreamChatMessageInput>(find.byType(StreamChatMessageInput)).controller!;
}

/// The focus node the page created and handed to its composer.
FocusNode _composerFocusNode(WidgetTester tester) {
  return tester.widget<StreamChatMessageInput>(find.byType(StreamChatMessageInput)).focusNode!;
}

Future<void> _pumpThreadPage(
  WidgetTester tester, {
  Message? parent,
  StreamAppStyle appStyle = StreamAppStyle.regular,
  void Function(Message message)? onViewInChannelTap,
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
  when(() => clientState.channels).thenReturn({});
  when(() => clientState.channelsStream).thenAnswer((_) => Stream.value({}));

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

  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(extensions: [StreamTheme(appStyle: appStyle)]),
      home: StreamChat(
        client: client,
        child: StreamChannel(
          channel: channel,
          child: StreamThreadPage(
            parent: parentMessage,
            onViewInChannelTap: onViewInChannelTap,
          ),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}
