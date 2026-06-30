// Tests for the channel-list preview widget that derives the last-message
// text from the channel state.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

void main() {
  // The default English translation; matches `context.translations.emptyMessagesText`.
  const emptyText = 'No messages yet';

  late MockClient client;
  late MockClientState clientState;
  late OwnUser currentUser;

  late MockChannel channelA;
  late MockChannelState stateA;
  late StreamController<List<Message>> messagesA;
  late bool isUpToDateA;

  late MockChannel channelB;
  late MockChannelState stateB;
  late StreamController<List<Message>> messagesB;
  late bool isUpToDateB;

  void wireChannel({
    required MockChannel channel,
    required MockChannelState state,
    required StreamController<List<Message>> controller,
    required bool Function() isUpToDate,
    required String cid,
  }) {
    when(() => channel.client).thenReturn(client);
    when(() => channel.state).thenReturn(state);

    when(() => state.messagesStream).thenAnswer((_) => controller.stream);
    when(() => state.messages).thenReturn(<Message>[]);
    when(() => state.draft).thenReturn(null);
    when(() => state.draftStream).thenAnswer((_) => Stream.value(null));
    when(() => state.read).thenReturn(const []);
    when(() => state.readStream).thenAnswer((_) => const Stream.empty());
    when(() => state.typingEvents).thenReturn(const {});
    when(() => state.typingEventsStream).thenAnswer((_) => Stream.value(const {}));
    when(() => state.unreadCount).thenReturn(0);
    when(() => state.unreadCountStream).thenAnswer((_) => Stream.value(0));
    when(() => state.isUpToDate).thenAnswer((_) => isUpToDate());
    when(() => state.channelState).thenReturn(
      ChannelState(channel: ChannelModel(cid: cid)),
    );
  }

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    currentUser = OwnUser(id: 'me');

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(currentUser);
    when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));

    isUpToDateA = true;
    channelA = MockChannel(id: 'a', type: 'messaging');
    stateA = MockChannelState();
    messagesA = StreamController<List<Message>>.broadcast();
    addTearDown(messagesA.close);
    wireChannel(
      channel: channelA,
      state: stateA,
      controller: messagesA,
      isUpToDate: () => isUpToDateA,
      cid: 'messaging:a',
    );

    isUpToDateB = true;
    channelB = MockChannel(id: 'b', type: 'messaging');
    stateB = MockChannelState();
    messagesB = StreamController<List<Message>>.broadcast();
    addTearDown(messagesB.close);
    wireChannel(
      channel: channelB,
      state: stateB,
      controller: messagesB,
      isUpToDate: () => isUpToDateB,
      cid: 'messaging:b',
    );
  });

  Future<void> pumpSubtitle(WidgetTester tester, Channel channel) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StreamChat(
            client: client,
            themeData: StreamChatThemeData(),
            child: ChannelListTileSubtitle(channel: channel),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'preserves the last-known message when state is not up-to-date and emits empty',
    (tester) async {
      final other = User(id: 'other');
      final msg1 = Message(id: 'm1', text: 'hello', user: other);

      when(() => stateA.messages).thenReturn([msg1]);
      await pumpSubtitle(tester, channelA);
      messagesA.add([msg1]);
      await tester.pumpAndSettle();

      expect(find.text('hello'), findsOneWidget);
      expect(find.text(emptyText), findsNothing);

      // While loading a historical window, isUpToDate flips false and the
      // intermediate state emits an empty messages list.
      isUpToDateA = false;
      when(() => stateA.messages).thenReturn([]);
      messagesA.add([]);
      await tester.pumpAndSettle();

      expect(find.text(emptyText), findsNothing);
      expect(find.text('hello'), findsOneWidget);

      // The loaded window arrives; isUpToDate restored.
      final msg2 = Message(id: 'm2', text: 'world', user: other);
      when(() => stateA.messages).thenReturn([msg1, msg2]);
      messagesA.add([msg1, msg2]);
      isUpToDateA = true;
      await tester.pumpAndSettle();

      expect(find.text('world'), findsOneWidget);
      expect(find.text(emptyText), findsNothing);
    },
  );

  testWidgets(
    "rebinding the widget to a different channel shows that channel's state, not the previous one's",
    (tester) async {
      // List reordering reuses the underlying State across channels (no key
      // on the list item). Channel B is empty; channel A had a message —
      // the cell must render B's empty state, not A's last message.
      final other = User(id: 'other');
      final msgA = Message(id: 'ma', text: 'channel-a-message', user: other);

      when(() => stateA.messages).thenReturn([msgA]);
      await pumpSubtitle(tester, channelA);
      messagesA.add([msgA]);
      await tester.pumpAndSettle();

      expect(find.text('channel-a-message'), findsOneWidget);

      when(() => stateB.messages).thenReturn([]);
      await pumpSubtitle(tester, channelB);
      messagesB.add([]);
      await tester.pumpAndSettle();

      expect(find.text('channel-a-message'), findsNothing);
      expect(find.text(emptyText), findsOneWidget);
    },
  );

  testWidgets(
    'shows the empty-state when the channel is truncated while up-to-date',
    (tester) async {
      // A channel.truncated event clears messages but leaves isUpToDate true.
      // The preview must reflect the now-empty channel.
      final other = User(id: 'other');
      final msg1 = Message(id: 'm1', text: 'hello', user: other);

      when(() => stateA.messages).thenReturn([msg1]);
      await pumpSubtitle(tester, channelA);
      messagesA.add([msg1]);
      await tester.pumpAndSettle();

      expect(find.text('hello'), findsOneWidget);

      when(() => stateA.messages).thenReturn([]);
      messagesA.add([]);
      await tester.pumpAndSettle();

      expect(find.text('hello'), findsNothing);
      expect(find.text(emptyText), findsOneWidget);
    },
  );
}
