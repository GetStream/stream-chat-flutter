// Tests for `StreamMessageListView`'s mark-read-at-the-bottom behavior.
//
// The logic lives in `_handleLastItemFullyVisible` →
// `_maybeMarkMessagesAsRead`. It fires `channel.markRead()` when the user
// reaches the bottom of the list, gated on:
//
//   1. `markReadWhenAtTheBottom` is true (the default).
//   2. `channel.state.isUpToDate` is true (or we're in a thread).
//   3. `channel.state.unreadCount > 0`.
//
// These tests pin the expected behavior so regressions in the underlying
// position-listener flow (SPL `itemPositions`, scroll wiring, etc.) surface
// here instead of as user-visible bugs.

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

  late StreamController<bool> isUpToDateController;
  late StreamController<int> unreadCountController;
  late StreamController<List<Message>> messagesController;

  setUpAll(() {
    registerFallbackValue(EventType.messageNew);
  });

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    when(() => client.state).thenAnswer((_) => clientState);
    final own = OwnUser(id: 'ownid');
    when(() => clientState.currentUser).thenReturn(own);
    when(() => clientState.currentUserStream)
        .thenAnswer((_) => Stream.value(own));

    channel = MockChannel();
    when(() => channel.on(any(), any(), any(), any()))
        .thenAnswer((_) => const Stream.empty());
    channelClientState = MockChannelState();
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelClientState);

    isUpToDateController = StreamController<bool>.broadcast();
    unreadCountController = StreamController<int>.broadcast();
    messagesController = StreamController<List<Message>>.broadcast();
    addTearDown(isUpToDateController.close);
    addTearDown(unreadCountController.close);
    addTearDown(messagesController.close);

    when(() => channelClientState.threadsStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.isUpToDateStream)
        .thenAnswer((_) => isUpToDateController.stream);
    when(() => channelClientState.unreadCountStream)
        .thenAnswer((_) => unreadCountController.stream);
    when(() => channelClientState.readStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.read).thenReturn([]);
    when(() => channelClientState.membersStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.members).thenReturn([]);
    when(() => channelClientState.currentUserRead).thenReturn(null);
    when(() => channelClientState.currentUserReadStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.messagesStream)
        .thenAnswer((_) => messagesController.stream);

    // Mark-read mock returns immediately.
    when(() => channel.markRead(messageId: any(named: 'messageId')))
        .thenAnswer((_) async => EmptyResponse());
  });

  Future<void> pumpMessageList(
    WidgetTester tester, {
    required List<Message> messages,
    required bool isUpToDate,
    required int unreadCount,
    bool markReadWhenAtTheBottom = true,
  }) async {
    when(() => channelClientState.isUpToDate).thenReturn(isUpToDate);
    when(() => channelClientState.unreadCount).thenReturn(unreadCount);
    when(() => channelClientState.messages).thenReturn(messages);

    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: rootBundle,
            child: StreamChat(
              client: client,
              streamChatThemeData: StreamChatThemeData.light(),
              child: StreamChannel(
                channel: channel,
                child: StreamMessageListView(
                  markReadWhenAtTheBottom: markReadWhenAtTheBottom,
                ),
              ),
            ),
          ),
        ),
      );
      // Prime the streams.
      isUpToDateController.add(isUpToDate);
      unreadCountController.add(unreadCount);
      messagesController.add(messages);
      await tester.pumpAndSettle();
    });
  }

  group('markRead gates', () {
    testWidgets(
      'fires when the user lands at the bottom with isUpToDate=true and '
      'unreadCount>0',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]);

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
        );

        verify(() => channel.markRead(messageId: any(named: 'messageId')))
            .called(1);
      },
    );

    testWidgets(
      'does NOT fire when isUpToDate=false (gate on incomplete state)',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]);

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: false,
          unreadCount: 5,
        );

        verifyNever(
          () => channel.markRead(messageId: any(named: 'messageId')),
        );
      },
    );

    testWidgets(
      'does NOT fire when unreadCount is 0',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]);

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 0,
        );

        verifyNever(
          () => channel.markRead(messageId: any(named: 'messageId')),
        );
      },
    );

    testWidgets(
      'does NOT fire when markReadWhenAtTheBottom is false',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]);

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 5,
          markReadWhenAtTheBottom: false,
        );

        verifyNever(
          () => channel.markRead(messageId: any(named: 'messageId')),
        );
      },
    );
  });

  group('scroll-to-bottom button visibility', () {
    testWidgets(
      'is hidden when the user lands at the bottom with isUpToDate=true',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]);

        await pumpMessageList(
          tester,
          messages: messages,
          isUpToDate: true,
          unreadCount: 0,
        );

        // The default scroll-to-bottom button is a FloatingActionButton.
        expect(find.byType(FloatingActionButton), findsNothing);
      },
    );
  });
}
