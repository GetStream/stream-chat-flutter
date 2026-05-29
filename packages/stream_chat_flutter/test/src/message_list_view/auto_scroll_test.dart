// Pins `StreamMessageListView`'s auto-scroll-on-new-message behaviour:
// the listener subscribes to `channel.state.messagesStream` so it
// triggers on optimistic local sends too (not just server-confirmed
// `messageNew` events), and the SPL scroll math + listener timing must
// not race with anchor preservation.

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
  late OwnUser ownUser;

  late StreamController<bool> isUpToDateController;
  late StreamController<int> unreadCountController;
  late StreamController<List<Message>> messagesController;

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    when(() => client.state).thenAnswer((_) => clientState);
    ownUser = OwnUser(id: 'ownid');
    when(() => clientState.currentUser).thenReturn(ownUser);
    when(() => clientState.currentUserStream)
        .thenAnswer((_) => Stream.value(ownUser));

    isUpToDateController = StreamController<bool>.broadcast();
    unreadCountController = StreamController<int>.broadcast();
    messagesController = StreamController<List<Message>>.broadcast();
    addTearDown(isUpToDateController.close);
    addTearDown(unreadCountController.close);
    addTearDown(messagesController.close);

    channel = MockChannel();
    channelClientState = MockChannelState();
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelClientState);

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

    when(() => channel.markRead(messageId: any(named: 'messageId')))
        .thenAnswer((_) async => EmptyResponse());
  });

  Future<void> pumpMessageList(
    WidgetTester tester, {
    required List<Message> messages,
    bool isUpToDate = true,
    int unreadCount = 0,
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
                child: const StreamMessageListView(),
              ),
            ),
          ),
        ),
      );
      isUpToDateController.add(isUpToDate);
      unreadCountController.add(unreadCount);
      messagesController.add(messages);
      await tester.pumpAndSettle();
    });
  }

  // Appends to the end because production state.messages is oldest-first.
  // Mirrors what `state.updateMessage(...)` does for both optimistic local
  // sends and server-confirmed `messageNew` events: it updates
  // `channel.state.messages` and the stream emits the new list.
  Future<void> deliverNewMessage(
    WidgetTester tester, {
    required Message newMessage,
    required List<Message> existing,
  }) async {
    final updated = [...existing, newMessage];
    when(() => channelClientState.messages).thenReturn(updated);
    await tester.runAsync(() async {
      messagesController.add(updated);
      await tester.pumpAndSettle();
    });
  }

  group('auto-scroll on new message', () {
    testWidgets(
      'new message from another user while at bottom → renders at the bottom',
      (tester) async {
        final other = User(id: 'otherid');
        final messages =
            generateConversation(20, users: [other]).reversed.toList();

        await pumpMessageList(tester, messages: messages);
        expect(find.byType(FloatingActionButton), findsNothing);

        final newMessage = Message(
          id: 'new-msg-other',
          text: 'A fresh incoming message',
          user: other,
          createdAt: DateTime.now(),
        );
        await deliverNewMessage(tester,
            newMessage: newMessage, existing: messages);

        expect(find.text(newMessage.text!), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsNothing);
      },
    );

    testWidgets(
      'new message from another user while scrolled up → does NOT auto-scroll',
      (tester) async {
        final other = User(id: 'otherid');
        final messages =
            generateConversation(40, users: [other]).reversed.toList();

        await pumpMessageList(tester, messages: messages);

        await tester.drag(
            find.byType(StreamMessageListView), const Offset(0, 400));
        await tester.pumpAndSettle();
        expect(find.byType(FloatingActionButton), findsOneWidget);

        final newMessage = Message(
          id: 'new-msg-other-while-scrolled-up',
          text: 'Should NOT pull the user back',
          user: other,
          createdAt: DateTime.now(),
        );
        await deliverNewMessage(tester,
            newMessage: newMessage, existing: messages);

        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.text(newMessage.text!), findsNothing);
      },
    );

    testWidgets(
      'own message while scrolled up → DOES auto-scroll to bottom',
      (tester) async {
        final other = User(id: 'otherid');
        final messages =
            generateConversation(40, users: [other]).reversed.toList();

        await pumpMessageList(tester, messages: messages);

        await tester.drag(
            find.byType(StreamMessageListView), const Offset(0, 400));
        await tester.pumpAndSettle();
        expect(find.byType(FloatingActionButton), findsOneWidget);

        final ownMessage = Message(
          id: 'new-msg-own',
          text: 'My own outgoing message',
          user: ownUser,
          createdAt: DateTime.now(),
        );
        await deliverNewMessage(tester,
            newMessage: ownMessage, existing: messages);

        expect(find.text(ownMessage.text!), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsNothing);
      },
    );

    // The whole point of this listener change: the user's outgoing
    // message hits state via `state.updateMessage(...)` before the
    // server confirms (no `messageNew` event yet). Subscribing to the
    // messages stream covers that path.
    testWidgets(
      'optimistic local message → auto-scrolls before server confirmation',
      (tester) async {
        final other = User(id: 'otherid');
        final messages =
            generateConversation(20, users: [other]).reversed.toList();

        await pumpMessageList(tester, messages: messages);
        expect(find.byType(FloatingActionButton), findsNothing);

        final ownLocalMessage = Message(
          id: 'optimistic-local',
          text: 'Sending…',
          user: ownUser,
          localCreatedAt: DateTime.now(),
          state: MessageState.sending,
        );
        await deliverNewMessage(tester,
            newMessage: ownLocalMessage, existing: messages);

        expect(find.text(ownLocalMessage.text!), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsNothing);
      },
    );

    // Same message id with different createdAt (local→server confirm,
    // failed→retry, edit, reaction…) must NOT re-trigger auto-scroll.
    // After the first fire we scroll up, then the server confirms the
    // same id with a different createdAt — the user must stay scrolled
    // up.
    testWidgets(
      'server confirmation of optimistic message → does NOT scroll twice',
      (tester) async {
        final other = User(id: 'otherid');
        final messages =
            generateConversation(40, users: [other]).reversed.toList();

        await pumpMessageList(tester, messages: messages);

        final localCreatedAt = DateTime.now();
        final ownLocalMessage = Message(
          id: 'optimistic-confirm-probe',
          text: 'Hello',
          user: ownUser,
          localCreatedAt: localCreatedAt,
          state: MessageState.sending,
        );
        await deliverNewMessage(tester,
            newMessage: ownLocalMessage, existing: messages);
        expect(find.text(ownLocalMessage.text!), findsOneWidget);

        // User scrolls away from the bottom while the server is round-tripping.
        await tester.drag(
            find.byType(StreamMessageListView), const Offset(0, 400));
        await tester.pumpAndSettle();
        expect(find.byType(FloatingActionButton), findsOneWidget);

        // Server confirms: same id, different createdAt (server clock).
        final confirmedMessage = ownLocalMessage.copyWith(
          createdAt: localCreatedAt.add(const Duration(milliseconds: 250)),
          state: MessageState.sent,
        );
        final updated = [...messages, confirmedMessage];
        when(() => channelClientState.messages).thenReturn(updated);
        await tester.runAsync(() async {
          messagesController.add(updated);
          await tester.pumpAndSettle();
        });

        // Listener must NOT fire on the confirmation: user stays scrolled up.
        expect(find.byType(FloatingActionButton), findsOneWidget);
      },
    );

    // Pins listener teardown on dispose: cancelling subscriptions in
    // dispose() must not throw, and a delivery after dispose must be a
    // no-op (no exceptions on a stale subscription).
    testWidgets(
      'listener is torn down on widget dispose',
      (tester) async {
        final other = User(id: 'otherid');
        final messages =
            generateConversation(20, users: [other]).reversed.toList();

        await pumpMessageList(tester, messages: messages);

        // Replace with an empty widget tree — disposes the message list.
        await tester.pumpWidget(const SizedBox.shrink());

        // Pushing after dispose must not throw.
        final stale = Message(
          id: 'after-dispose',
          text: 'late arrival',
          user: other,
          createdAt: DateTime.now(),
        );
        final updated = [...messages, stale];
        when(() => channelClientState.messages).thenReturn(updated);
        await tester.runAsync(() async {
          messagesController.add(updated);
          await tester.pumpAndSettle();
        });

        // No widget to render the new message; just ensure no exception.
        expect(tester.takeException(), isNull);
      },
    );

    // Real burst: emit 5 messages back-to-back in the same microtask
    // cycle, settle once at the end. The previous version awaited
    // `pumpAndSettle` between each emit, which means no two messages
    // were ever in flight together — that's not a burst.
    testWidgets(
      'rapid burst of messages while at bottom → final layout shows newest',
      (tester) async {
        final other = User(id: 'otherid');
        final messages =
            generateConversation(20, users: [other]).reversed.toList();

        await pumpMessageList(tester, messages: messages);
        expect(find.byType(FloatingActionButton), findsNothing);

        var existing = messages;
        late Message latest;
        await tester.runAsync(() async {
          for (var i = 0; i < 5; i++) {
            latest = Message(
              id: 'burst-$i',
              text: 'Burst message $i',
              user: other,
              createdAt: DateTime.now().add(Duration(milliseconds: i)),
            );
            existing = [...existing, latest];
            when(() => channelClientState.messages).thenReturn(existing);
            messagesController.add(existing);
          }
          await tester.pumpAndSettle();
        });

        expect(find.text(latest.text!), findsOneWidget);
        expect(find.byType(FloatingActionButton), findsNothing);
      },
    );
  });
}
