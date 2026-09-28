// Pins how `StreamMessageListView`'s floating overlays clear the safe area when
// the list applies the insets itself (`enableSafeArea`). Each edge is resolved
// on its own, since devices like a foldable iPhone report a side inset on one
// edge only.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_list_view/floating_date_divider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../test_utils/data_generator.dart';
import '../mocks.dart';

void main() {
  late StreamChatClient client;
  late Channel channel;
  late ChannelClientState channelClientState;
  late ClientState clientState;
  late OwnUser ownUser;

  late StreamController<List<Message>> messagesController;

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    when(() => client.state).thenAnswer((_) => clientState);
    ownUser = OwnUser(id: 'ownid');
    when(() => clientState.currentUser).thenReturn(ownUser);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(ownUser));

    messagesController = StreamController<List<Message>>.broadcast();
    addTearDown(messagesController.close);

    channel = MockChannel();
    channelClientState = MockChannelState();
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelClientState);

    when(() => channelClientState.threadsStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.isUpToDate).thenReturn(true);
    when(() => channelClientState.isUpToDateStream).thenAnswer((_) => Stream.value(true));
    when(() => channelClientState.readStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.read).thenReturn([]);
    when(() => channelClientState.membersStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.members).thenReturn([]);
    when(() => channelClientState.messagesStream).thenAnswer((_) => messagesController.stream);

    when(() => channel.markRead(messageId: any(named: 'messageId'))).thenAnswer((_) async => EmptyResponse());
  });

  Future<void> pumpMessageList(
    WidgetTester tester, {
    required EdgeInsets padding,
    TextDirection textDirection = TextDirection.ltr,
    List<Message>? messages,
    int unreadCount = 0,
    Read? currentUserRead,
    bool openAtFirstUnread = false,
    StreamMessageListViewConfiguration config = const StreamMessageListViewConfiguration(),
  }) async {
    final effectiveMessages = messages ?? generateConversation(40, users: [User(id: 'otherid')]).reversed.toList();
    when(() => channelClientState.messages).thenReturn(effectiveMessages);
    when(() => channelClientState.unreadCount).thenReturn(unreadCount);
    when(() => channelClientState.unreadCountStream).thenAnswer((_) => Stream.value(unreadCount));
    when(() => channelClientState.currentUserRead).thenReturn(currentUserRead);
    when(() => channelClientState.currentUserReadStream).thenAnswer((_) => Stream.value(currentUserRead));

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(padding: padding),
              child: Directionality(
                textDirection: textDirection,
                child: DefaultAssetBundle(
                  bundle: rootBundle,
                  child: StreamChat(
                    client: client,
                    child: StreamChannel(
                      channel: channel,
                      openAtFirstUnread: openAtFirstUnread,
                      child: StreamMessageListView(enableSafeArea: true, config: config),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      messagesController.add(effectiveMessages);
      await tester.pumpAndSettle();
    });
  }

  // Scrolls away from the newest message so the scroll-to-bottom button shows.
  Future<Rect> scrollToBottomButtonRect(WidgetTester tester) async {
    await tester.drag(find.byType(StreamMessageListView), const Offset(0, 400));
    await tester.pumpAndSettle();
    return tester.getRect(find.byType(StreamButton));
  }

  testWidgets('the scroll-to-bottom button clears a right inset in a left-to-right layout', (tester) async {
    // The margin is added on top of the inset, so the button lines up with the
    // bubbles, which the list also insets by the safe area before their padding.
    const rightInset = 84.0;
    await pumpMessageList(tester, padding: const EdgeInsets.only(right: rightInset));

    final rect = await scrollToBottomButtonRect(tester);

    final spacing = tester.element(find.byType(StreamMessageListView)).streamSpacing;
    final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(rect.right, moreOrLessEquals(screenWidth - rightInset - spacing.md));
  });

  testWidgets('the scroll-to-bottom button clears a left inset in a right-to-left layout', (tester) async {
    const leftInset = 84.0;
    await pumpMessageList(
      tester,
      padding: const EdgeInsets.only(left: leftInset),
      textDirection: TextDirection.rtl,
    );

    final rect = await scrollToBottomButtonRect(tester);

    final spacing = tester.element(find.byType(StreamMessageListView)).streamSpacing;
    expect(rect.left, moreOrLessEquals(leftInset + spacing.md));
  });

  testWidgets('the floating date divider centers over the content area, not the full width', (tester) async {
    const padding = EdgeInsets.only(right: 84);
    await pumpMessageList(
      tester,
      padding: padding,
      messages: _messagesOverFourDays(),
      config: _opaqueFloatingDateDividerConfig,
    );

    await tester.drag(find.byType(StreamMessageListView), const Offset(0, 300));
    await tester.pumpAndSettle();

    expect(tester.getCenter(_floatingDateDividerFinder).dx, moreOrLessEquals(_contentCenterX(tester, padding)));
  });

  testWidgets('the floating date divider lines up with the inline divider it hands off to', (tester) async {
    // Offset from each other, the two pills read as one clipped label next to
    // another ("Toda Today") while the floating one fades out.
    await pumpMessageList(
      tester,
      padding: const EdgeInsets.only(right: 84),
      messages: _messagesOverFourDays(),
      config: _opaqueFloatingDateDividerConfig,
    );

    // Brings an inline divider up under the floating pill, where they hand off.
    await tester.drag(find.byType(StreamMessageListView), const Offset(0, 400));
    await tester.pumpAndSettle();

    final inline = find
        .byType(StreamDateDivider)
        .evaluate()
        .firstWhere((element) => element.findAncestorWidgetOfExactType<FloatingDateDivider>() == null);
    final inlineBox = inline.renderObject! as RenderBox;
    final inlineCenter = inlineBox.localToGlobal(inlineBox.size.center(Offset.zero));

    expect(tester.getCenter(_floatingDateDividerFinder).dx, moreOrLessEquals(inlineCenter.dx));
  });

  testWidgets('the unread indicator centers over the content area, not the full width', (tester) async {
    const padding = EdgeInsets.only(right: 84);
    final messages = generateConversation(20, users: [User(id: 'otherid')]).reversed.toList();

    await pumpMessageList(
      tester,
      padding: padding,
      messages: messages,
      unreadCount: 5,
      currentUserRead: Read(
        user: ownUser,
        lastRead: DateTime.now(),
        unreadMessages: 5,
        lastReadMessageId: messages[10].id,
      ),
      config: const StreamMessageListViewConfiguration(markReadWhenAtTheBottom: false),
    );

    expect(
      tester.getCenter(find.byType(UnreadIndicatorButton)).dx,
      moreOrLessEquals(_contentCenterX(tester, padding)),
    );
  });

  testWidgets('the unread indicator keeps its own width rather than spanning the content area', (tester) async {
    const rightInset = 84.0;
    final messages = generateConversation(20, users: [User(id: 'otherid')]).reversed.toList();

    await pumpMessageList(
      tester,
      padding: const EdgeInsets.only(right: rightInset),
      messages: messages,
      unreadCount: 5,
      currentUserRead: Read(
        user: ownUser,
        lastRead: DateTime.now(),
        unreadMessages: 5,
        lastReadMessageId: messages[10].id,
      ),
      config: const StreamMessageListViewConfiguration(markReadWhenAtTheBottom: false),
    );

    final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(tester.getSize(find.byType(UnreadIndicatorButton)).width, lessThan(screenWidth - rightInset));
  });
}

// The horizontal center of the area left between the side insets.
double _contentCenterX(WidgetTester tester, EdgeInsets padding) {
  final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;
  return padding.left + (screenWidth - padding.left - padding.right) / 2;
}

// Ten messages a day over four days, oldest first, so inline date dividers
// scroll through the viewport.
List<Message> _messagesOverFourDays() => [
  for (var day = 3; day >= 0; day--)
    for (var i = 0; i < 10; i++)
      Message(
        id: 'day$day-$i',
        text: 'Message $i on day $day',
        user: User(id: 'otherid'),
        createdAt: DateTime(2026, 9, 20 - day, 9, i),
      ),
];

// Keeps the floating pill opaque while an inline divider is near it, so both
// stay in the tree for the comparison.
const _opaqueFloatingDateDividerConfig = StreamMessageListViewConfiguration(fadeFloatingDateDividerNearInline: false);

final _floatingDateDividerFinder = find.descendant(
  of: find.byType(FloatingDateDivider),
  matching: find.byType(StreamDateDivider),
);
