// Pins how `StreamMessageListView`'s floating overlays clear the safe area when
// the list applies the insets itself (`enableSafeArea`). Each edge is resolved
// on its own, since devices like a foldable iPhone report a side inset on one
// edge only.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../test_utils/data_generator.dart';
import '../mocks.dart';

void main() {
  late StreamChatClient client;
  late Channel channel;
  late ChannelClientState channelClientState;
  late ClientState clientState;

  late StreamController<List<Message>> messagesController;

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    when(() => client.state).thenAnswer((_) => clientState);
    final ownUser = OwnUser(id: 'ownid');
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
    when(() => channelClientState.unreadCount).thenReturn(0);
    when(() => channelClientState.unreadCountStream).thenAnswer((_) => Stream.value(0));
    when(() => channelClientState.readStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.read).thenReturn([]);
    when(() => channelClientState.membersStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.members).thenReturn([]);
    when(() => channelClientState.currentUserRead).thenReturn(null);
    when(() => channelClientState.currentUserReadStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.messagesStream).thenAnswer((_) => messagesController.stream);

    when(() => channel.markRead(messageId: any(named: 'messageId'))).thenAnswer((_) async => EmptyResponse());
  });

  Future<void> pumpMessageList(
    WidgetTester tester, {
    required EdgeInsets padding,
    TextDirection textDirection = TextDirection.ltr,
  }) async {
    final messages = generateConversation(40, users: [User(id: 'otherid')]).reversed.toList();
    when(() => channelClientState.messages).thenReturn(messages);

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
                      child: const StreamMessageListView(enableSafeArea: true),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      messagesController.add(messages);
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
}
