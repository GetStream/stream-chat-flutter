// Pins `StreamMessageListView`'s auto-scroll-on-new-message behaviour:
// the listener must scroll to bottom only when the user is already
// there or the message is their own, and the SPL math + listener
// timing must not race with anchor preservation.

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
  late StreamController<Event> messageNewController;

  setUpAll(() {
    registerFallbackValue(EventType.messageNew);
  });

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    when(() => client.state).thenAnswer((_) => clientState);
    ownUser = OwnUser(id: 'ownid');
    when(() => clientState.currentUser).thenReturn(ownUser);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(ownUser));

    isUpToDateController = StreamController<bool>.broadcast();
    unreadCountController = StreamController<int>.broadcast();
    messagesController = StreamController<List<Message>>.broadcast();
    // MockChannel.on filters this by event.type, so events pushed here
    // surface to channel.on(EventType.messageNew) subscribers.
    messageNewController = StreamController<Event>.broadcast();
    addTearDown(isUpToDateController.close);
    addTearDown(unreadCountController.close);
    addTearDown(messagesController.close);
    addTearDown(messageNewController.close);

    channel = MockChannel(eventStream: messageNewController.stream);
    channelClientState = MockChannelState();
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(channelClientState);

    when(() => channelClientState.threadsStream).thenAnswer((_) => const Stream.empty());
    when(() => channelClientState.isUpToDateStream).thenAnswer((_) => isUpToDateController.stream);
    when(() => channelClientState.unreadCountStream).thenAnswer((_) => unreadCountController.stream);
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
  Future<void> deliverMessageNew(
    WidgetTester tester, {
    required Message newMessage,
    required List<Message> existing,
  }) async {
    final updated = [...existing, newMessage];
    when(() => channelClientState.messages).thenReturn(updated);
    await tester.runAsync(() async {
      messagesController.add(updated);
      messageNewController.add(Event(type: EventType.messageNew, message: newMessage, cid: channel.cid));
      await tester.pumpAndSettle();
    });
  }

  group('auto-scroll on messageNew', () {
    testWidgets(
      'new message from another user while at bottom → renders at the bottom',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();

        await pumpMessageList(tester, messages: messages);

        expect(find.byType(StreamButton), findsNothing);

        final newMessage = Message(
          id: 'new-msg-other',
          text: 'A fresh incoming message',
          user: other,
          createdAt: DateTime.now(),
        );

        await deliverMessageNew(tester, newMessage: newMessage, existing: messages);

        expect(find.text(newMessage.text!), findsOneWidget);
        expect(find.byType(StreamButton), findsNothing);
      },
    );

    testWidgets(
      'new message from another user while scrolled up → does NOT auto-scroll',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(40, users: [other]).reversed.toList();

        await pumpMessageList(tester, messages: messages);

        await tester.drag(find.byType(StreamMessageListView), const Offset(0, 400));
        await tester.pumpAndSettle();
        expect(find.byType(StreamButton), findsOneWidget);

        final newMessage = Message(
          id: 'new-msg-other-while-scrolled-up',
          text: 'Should NOT pull the user back',
          user: other,
          createdAt: DateTime.now(),
        );

        await deliverMessageNew(tester, newMessage: newMessage, existing: messages);

        expect(find.byType(StreamButton), findsOneWidget);
        expect(find.text(newMessage.text!), findsNothing);
      },
    );

    testWidgets(
      'own message while scrolled up → DOES auto-scroll to bottom',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(40, users: [other]).reversed.toList();

        await pumpMessageList(tester, messages: messages);

        await tester.drag(find.byType(StreamMessageListView), const Offset(0, 400));
        await tester.pumpAndSettle();
        expect(find.byType(StreamButton), findsOneWidget);

        final ownMessage = Message(
          id: 'new-msg-own',
          text: 'My own outgoing message',
          user: ownUser,
          createdAt: DateTime.now(),
        );

        await deliverMessageNew(tester, newMessage: ownMessage, existing: messages);

        expect(find.text(ownMessage.text!), findsOneWidget);
        expect(find.byType(StreamButton), findsNothing);
      },
    );

    // Single `pump()` captures the frame after the new-messages rebuild
    // but before any post-frame follow-up runs. Fails loudly if the
    // listener ever stops clearing SPL's anchor key synchronously and
    // anchor preservation re-pins the layout.
    testWidgets(
      'messageNew while at bottom → previously-bottom message does not shift in frame N',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();
        final originallyAtBottom = messages.last;

        await pumpMessageList(tester, messages: messages);

        final rectBefore = tester.getRect(find.text(originallyAtBottom.text!));

        final newMessage = Message(
          id: 'new-msg-shift-probe',
          text: 'Shift probe',
          user: other,
          createdAt: DateTime.now(),
        );
        final updated = [...messages, newMessage];
        when(() => channelClientState.messages).thenReturn(updated);

        await tester.runAsync(() async {
          messagesController.add(updated);
          messageNewController.add(Event(type: EventType.messageNew, message: newMessage, cid: channel.cid));
          await tester.pump();
        });

        expect(tester.getRect(find.text(originallyAtBottom.text!)), rectBefore);

        await tester.pumpAndSettle();
        expect(find.text(newMessage.text!), findsOneWidget);
      },
    );

    testWidgets(
      'messageNew while at bottom → scroll position does not flap',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();

        await pumpMessageList(tester, messages: messages);

        final scrollable = tester.state<ScrollableState>(find.byType(Scrollable).first);
        final pixelsBefore = scrollable.position.pixels;

        final newMessage = Message(
          id: 'new-msg-pixels',
          text: 'Position-flap probe',
          user: other,
          createdAt: DateTime.now(),
        );
        final updated = [...messages, newMessage];
        when(() => channelClientState.messages).thenReturn(updated);

        var maxExcursion = 0.0;
        await tester.runAsync(() async {
          messagesController.add(updated);
          messageNewController.add(Event(type: EventType.messageNew, message: newMessage, cid: channel.cid));
          for (var i = 0; i < 20; i++) {
            await tester.pump(const Duration(milliseconds: 25));
            final delta = (scrollable.position.pixels - pixelsBefore).abs();
            if (delta > maxExcursion) maxExcursion = delta;
          }
          await tester.pumpAndSettle();
        });

        expect(maxExcursion, 0.0);
      },
    );

    testWidgets(
      'rapid burst of messages while at bottom → final layout shows newest',
      (tester) async {
        final other = User(id: 'otherid');
        final messages = generateConversation(20, users: [other]).reversed.toList();

        await pumpMessageList(tester, messages: messages);
        expect(find.byType(StreamButton), findsNothing);

        var existing = messages;
        late Message latest;
        for (var i = 0; i < 5; i++) {
          latest = Message(
            id: 'burst-$i',
            text: 'Burst message $i',
            user: other,
            createdAt: DateTime.now().add(Duration(milliseconds: i)),
          );
          await deliverMessageNew(tester, newMessage: latest, existing: existing);
          existing = [...existing, latest];
        }

        expect(find.text(latest.text!), findsOneWidget);
        expect(find.byType(StreamButton), findsNothing);
      },
    );
  });
}
