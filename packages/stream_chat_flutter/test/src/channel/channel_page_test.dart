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
    await _pumpChannelPage(tester, appStyle: StreamAppStyle.floating);

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
    await _pumpChannelPage(tester, appStyle: StreamAppStyle.floating);

    final messageListView = _messageListView(tester);

    expect(messageListView.topPadding, greaterThan(0));
    expect(messageListView.bottomPadding, greaterThan(0));
  });

  testWidgets('does not inset the message list when the app style is regular', (tester) async {
    await _pumpChannelPage(tester);

    final messageListView = _messageListView(tester);

    expect(messageListView.topPadding, 0);
    expect(messageListView.bottomPadding, 0);
  });

  testWidgets('disposes its composer controller when removed from the tree', (tester) async {
    await _pumpChannelPage(tester);
    final controller = _composerController(tester);

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

    // A disposed ChangeNotifier throws when listened to again.
    expect(() => controller.addListener(() {}), throwsFlutterError);
  });
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
  StreamAppStyle appStyle = StreamAppStyle.regular,
  void Function(BuildContext context, Channel channel)? onChannelAvatarPressed,
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
          child: StreamChannelPage(onChannelAvatarPressed: onChannelAvatarPressed),
        ),
      ),
    ),
  );

  await tester.pumpAndSettle();
}
