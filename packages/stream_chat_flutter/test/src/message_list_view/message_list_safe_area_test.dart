// How `StreamMessageListView` clears the side safe-area insets with
// `enableSafeArea` on.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_list_view/floating_date_divider.dart';
import 'package:stream_chat_flutter/src/message_list_view/stream_message_list_empty_state.dart';
import 'package:stream_chat_flutter/src/message_list_view/stream_message_list_skeleton_loading.dart';
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
    List<Message>? messages,
    StreamMessageListViewConfiguration config = const StreamMessageListViewConfiguration(),
    StreamChatThemeData? themeData,
    StreamMessageListViewBuilders builders = const StreamMessageListViewBuilders(),
    bool enableSafeArea = true,
    Message? parentMessage,
    bool settle = true,
  }) async {
    final effectiveMessages = messages ?? generateConversation(40, users: [User(id: 'otherid')]).reversed.toList();
    when(() => channelClientState.messages).thenReturn(effectiveMessages);

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(padding: padding),
              child: DefaultAssetBundle(
                bundle: rootBundle,
                child: StreamChat(
                  client: client,
                  themeData: themeData,
                  child: StreamChannel(
                    channel: channel,
                    child: StreamMessageListView(
                      enableSafeArea: enableSafeArea,
                      config: config,
                      builders: builders,
                      parentMessage: parentMessage,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      messagesController.add(effectiveMessages);
      if (settle) {
        await tester.pumpAndSettle();
      } else {
        await tester.pump();
      }
    });
  }

  testWidgets('StreamMessageListView keeps the scroll-to-bottom button clear of a side inset', (tester) async {
    const rightInset = 84.0;
    await pumpMessageList(tester, padding: const EdgeInsets.only(right: rightInset));

    await tester.drag(find.byType(StreamMessageListView), const Offset(0, 400));
    await tester.pumpAndSettle();

    final spacing = tester.element(find.byType(StreamMessageListView)).streamSpacing;
    final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(tester.getRect(find.byType(StreamButton)).right, moreOrLessEquals(screenWidth - rightInset - spacing.md));
  });

  testWidgets('StreamMessageListView centers the floating date divider over the content area', (tester) async {
    const padding = EdgeInsets.only(right: 84);
    await pumpMessageList(
      tester,
      padding: padding,
      messages: _messagesOverFourDays(),
      config: _opaqueFloatingDateDividerConfig,
    );

    await tester.drag(find.byType(StreamMessageListView), const Offset(0, 300));
    await tester.pumpAndSettle();

    final floatingDateDivider = find.descendant(
      of: find.byType(FloatingDateDivider),
      matching: find.byType(StreamDateDivider),
    );
    expect(tester.getCenter(floatingDateDivider).dx, moreOrLessEquals(_contentCenterX(tester, padding)));
  });

  testWidgets('StreamMessageListView centers the empty state over the content area', (tester) async {
    const padding = EdgeInsets.only(right: 84);
    await pumpMessageList(tester, padding: padding, messages: []);

    expect(
      tester.getCenter(find.byType(StreamMessageListEmptyState)).dx,
      moreOrLessEquals(_contentCenterX(tester, padding)),
    );
  });

  testWidgets('StreamMessageListView keeps its background full width under a side inset', (tester) async {
    const backgroundColor = Color(0xFF00FF00);
    await pumpMessageList(
      tester,
      padding: const EdgeInsets.only(right: 84),
      themeData: StreamChatThemeData(
        messageListViewTheme: const StreamMessageListViewThemeData(backgroundColor: backgroundColor),
      ),
    );

    final background = find.byWidgetPredicate(
      (widget) => switch (widget) {
        DecoratedBox(decoration: BoxDecoration(color: backgroundColor)) => true,
        _ => false,
      },
    );
    final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(tester.getSize(background).width, moreOrLessEquals(screenWidth));
  });

  testWidgets('StreamMessageListView insets message rows by a side inset only once', (tester) async {
    const rightInset = 84.0;
    await pumpMessageList(tester, padding: const EdgeInsets.only(right: rightInset));

    final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(tester.getRect(find.byType(StreamMessageItem).first).right, moreOrLessEquals(screenWidth - rightInset));
  });

  testWidgets('StreamMessageListView centers a custom empty state over the content area', (tester) async {
    const padding = EdgeInsets.only(right: 84);
    const customEmptyKey = Key('custom-empty');
    await pumpMessageList(
      tester,
      padding: padding,
      messages: [],
      builders: StreamMessageListViewBuilders(empty: (_) => const SizedBox.expand(key: customEmptyKey)),
    );

    expect(tester.getCenter(find.byKey(customEmptyKey)).dx, moreOrLessEquals(_contentCenterX(tester, padding)));
  });

  testWidgets('StreamMessageListView keeps the loading state clear of a side inset', (tester) async {
    // A thread whose replies never arrive stays in its loading state.
    when(() => channelClientState.threads).thenReturn(const {});
    when(
      () => channel.getReplies(
        any(),
        options: any(named: 'options'),
        preferOffline: any(named: 'preferOffline'),
      ),
    ).thenAnswer((_) => Completer<QueryRepliesResponse>().future);

    const rightInset = 84.0;
    await pumpMessageList(
      tester,
      padding: const EdgeInsets.only(right: rightInset),
      parentMessage: Message(
        id: 'parent',
        text: 'Parent',
        user: User(id: 'otherid'),
      ),
      // The skeleton shimmers forever, so it never settles.
      settle: false,
    );

    final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(
      tester.getRect(find.byType(StreamMessageListSkeletonLoading)).right,
      moreOrLessEquals(screenWidth - rightInset),
    );
  });

  testWidgets('StreamMessageListView leaves the empty state on the full width when enableSafeArea is off', (
    tester,
  ) async {
    const padding = EdgeInsets.only(right: 84);
    await pumpMessageList(tester, padding: padding, messages: [], enableSafeArea: false);

    final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(tester.getCenter(find.byType(StreamMessageListEmptyState)).dx, moreOrLessEquals(screenWidth / 2));
  });
}

// The horizontal center of the area left between the side insets.
double _contentCenterX(WidgetTester tester, EdgeInsets padding) {
  final screenWidth = tester.view.physicalSize.width / tester.view.devicePixelRatio;
  return padding.left + (screenWidth - padding.left - padding.right) / 2;
}

// Ten messages a day over four days, oldest first.
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

// Keeps the floating divider in the tree next to an inline one.
const _opaqueFloatingDateDividerConfig = StreamMessageListViewConfiguration(fadeFloatingDateDividerNearInline: false);
