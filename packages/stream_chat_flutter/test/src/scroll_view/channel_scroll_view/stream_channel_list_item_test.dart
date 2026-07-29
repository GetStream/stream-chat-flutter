// Tests for the channel-list preview widget that derives the last-message
// text from the channel state.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

void main() {
  group('ChannelLastMessageText', () {
    const currentUserId = 'me';

    late MockClient client;
    late MockClientState clientState;
    late MockChannel channel;
    late MockChannelState channelState;

    setUp(() {
      client = MockClient();
      clientState = MockClientState();
      channel = MockChannel();
      channelState = MockChannelState();

      final currentUser = OwnUser(id: currentUserId, name: 'Me');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(currentUser);
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channelState.draft).thenReturn(null);
      when(() => channelState.channelState).thenReturn(const ChannelState());
    });

    Future<void> pumpWithMessages(
      WidgetTester tester,
      List<Message> messages,
    ) async {
      when(() => channelState.messages).thenReturn(messages);
      when(() => channelState.messagesStream).thenAnswer((_) => Stream.value(messages));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: ChannelLastMessageText(channel: channel),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('shows the latest message text as preview', (tester) async {
      final message = Message(
        text: 'hello world',
        user: User(id: 'other'),
        createdAt: DateTime(2024, 1, 1),
      );

      await pumpWithMessages(tester, [message]);

      expect(find.text('hello world'), findsOneWidget);
    });

    testWidgets('hides shadowed message from another user', (tester) async {
      final visible = Message(
        text: 'visible',
        user: User(id: 'other'),
        createdAt: DateTime(2024, 1, 1),
      );
      final shadowed = Message(
        text: 'shadowed',
        shadowed: true,
        user: User(id: 'other'),
        createdAt: DateTime(2024, 1, 2),
      );

      await pumpWithMessages(tester, [visible, shadowed]);

      expect(find.text('visible'), findsOneWidget);
      expect(find.text('shadowed'), findsNothing);
    });

    testWidgets(
      'shows current user own shadowed message',
      (tester) async {
        final mine = Message(
          text: 'my shadowed',
          shadowed: true,
          user: User(id: currentUserId),
          createdAt: DateTime(2024, 1, 1),
        );

        await pumpWithMessages(tester, [mine]);

        expect(find.text('my shadowed'), findsOneWidget);
      },
    );

    testWidgets('hides error and ephemeral messages', (tester) async {
      final visible = Message(
        text: 'visible',
        user: User(id: 'other'),
        createdAt: DateTime(2024, 1, 1),
      );
      final errored = Message(
        text: 'errored',
        type: MessageType.error,
        user: User(id: 'other'),
        createdAt: DateTime(2024, 1, 2),
      );
      final ephemeral = Message(
        text: 'ephemeral',
        type: MessageType.ephemeral,
        user: User(id: 'other'),
        createdAt: DateTime(2024, 1, 3),
      );

      await pumpWithMessages(tester, [visible, errored, ephemeral]);

      expect(find.text('visible'), findsOneWidget);
      expect(find.text('errored'), findsNothing);
      expect(find.text('ephemeral'), findsNothing);
    });

    testWidgets(
      'custom lastMessagePredicate fully replaces the default',
      (tester) async {
        final shadowedByOther = Message(
          text: 'shadowed by other',
          shadowed: true,
          user: User(id: 'other'),
          createdAt: DateTime(2024, 1, 1),
        );

        when(() => channelState.messages).thenReturn([shadowedByOther]);
        when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([shadowedByOther]));

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              child: Scaffold(
                body: ChannelLastMessageText(
                  channel: channel,
                  lastMessagePredicate: (_) => true,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('shadowed by other'), findsOneWidget);
      },
    );
  });

  group('ChannelListTileSubtitle', () {
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
  });

  group('StreamChannelListTile a11y', () {
    Widget wrap(Widget child) => MaterialApp(
      theme: ThemeData(extensions: [StreamTheme()]),
      home: Scaffold(body: child),
    );

    testWidgets('merges children into a single accessible node with the composed label', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        wrap(
          StreamChannelListTile(
            avatar: const _SilentAvatar(),
            title: const Text('General'),
            subtitle: const Text('Alice: 2 photos'),
            timestamp: const Text('2h'),
            unreadCount: 2,
            isMuted: true,
            onTap: () {},
          ),
        ),
      );

      // A silent avatar (a DM avatar wraps itself in ExcludeSemantics) must
      // contribute nothing to the merged label.
      expect(find.bySemanticsLabel('AVATAR-SENTINEL'), findsNothing);

      // The tile's composed label carries the name, muted state, unread
      // count, preview, and timestamp — merged into one accessible node.
      // MergeSemantics joins the child labels with newlines, so match with
      // `dotAll: true` so `.` crosses the line breaks.
      expect(
        find.bySemanticsLabel(
          RegExp(
            'General.*muted.*2h.*2 unread.*Alice: 2 photos',
            dotAll: true,
          ),
        ),
        findsOneWidget,
      );

      handle.dispose();
    });

    testWidgets('a labeled avatar contributes its label to the composed row announcement', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        wrap(
          StreamChannelListTile(
            avatar: const _LabeledAvatar('Group'),
            title: const Text('Team'),
            subtitle: const Text('Alice: sup'),
            timestamp: const Text('2h'),
            onTap: () {},
          ),
        ),
      );

      // A group avatar's semantics label (emitted by StreamChannelAvatar for
      // groups) is picked up by the row's MergeSemantics wrap and prepended
      // to the announcement, restoring the "this is a group" context that
      // the multi-avatar visual conveys to sighted users.
      expect(
        find.bySemanticsLabel(
          RegExp('Group.*Team.*Alice: sup', dotAll: true),
        ),
        findsOneWidget,
      );

      handle.dispose();
    });

    testWidgets('unreadCount == 0 omits the "unread" state from the label', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        wrap(
          StreamChannelListTile(
            avatar: const SizedBox.shrink(),
            title: const Text('General'),
            subtitle: const Text('Hi'),
            timestamp: const Text('2h'),
            onTap: () {},
          ),
        ),
      );

      expect(find.bySemanticsLabel(RegExp('General')), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp('unread')), findsNothing);

      handle.dispose();
    });

    testWidgets('isPinned adds the "pinned" fragment to the merged label', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        wrap(
          StreamChannelListTile(
            avatar: const _SilentAvatar(),
            title: const Text('General'),
            subtitle: const Text('Hi'),
            timestamp: const Text('2h'),
            isPinned: true,
            onTap: () {},
          ),
        ),
      );

      expect(
        find.bySemanticsLabel(RegExp('General.*pinned.*2h.*Hi', dotAll: true)),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('muted + pinned combined announce in order', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        wrap(
          StreamChannelListTile(
            avatar: const _SilentAvatar(),
            title: const Text('General'),
            subtitle: const Text('Hi'),
            timestamp: const Text('2h'),
            isMuted: true,
            isPinned: true,
            onTap: () {},
          ),
        ),
      );

      expect(
        find.bySemanticsLabel(RegExp('General.*muted.*pinned.*2h.*Hi', dotAll: true)),
        findsOneWidget,
      );
      handle.dispose();
    });
  });
}

// Simulates a DM avatar — silent (wraps its sentinel text in
// ExcludeSemantics). Keeps the a11y assertions independent of any real
// avatar widget's internals.
class _SilentAvatar extends StatelessWidget {
  const _SilentAvatar();

  @override
  Widget build(BuildContext context) => const ExcludeSemantics(child: Text('AVATAR-SENTINEL'));
}

// Simulates a group avatar — participates in semantics with a label,
// matching what StreamChannelAvatar emits for group channels.
class _LabeledAvatar extends StatelessWidget {
  const _LabeledAvatar(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Semantics(label: label, child: const SizedBox.shrink());
}
