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
      'drops the cached message once the predicate stops accepting it',
      (tester) async {
        final message = Message(
          text: 'no longer previewable',
          user: User(id: 'other'),
          createdAt: DateTime(2024, 1, 1),
        );

        Future<void> pumpWithPredicate(bool Function(Message) predicate) {
          return tester.pumpWidget(
            MaterialApp(
              home: StreamChat(
                client: client,
                child: Scaffold(
                  body: ChannelLastMessageText(
                    channel: channel,
                    lastMessagePredicate: predicate,
                  ),
                ),
              ),
            ),
          );
        }

        when(() => channelState.messages).thenReturn([message]);
        when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([message]));

        await pumpWithPredicate((_) => true);
        await tester.pumpAndSettle();

        expect(find.text('no longer previewable'), findsOneWidget);

        // The channel starts reloading, so the cache is what the preview would
        // fall back to — but the new predicate rejects the cached message.
        when(() => channelState.isUpToDate).thenReturn(false);
        when(() => channelState.messages).thenReturn([]);
        when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([]));

        await pumpWithPredicate((_) => false);
        await tester.pumpAndSettle();

        expect(find.text('no longer previewable'), findsNothing);
      },
    );

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
    const currentUserId = 'me';

    late MockClient client;
    late MockChannel channel;
    late MockChannelState channelState;

    setUp(() {
      client = MockClient();
      final clientState = MockClientState();
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

    // Pumps the channel list subtitle with [message] as the last message,
    // drawing its delivery status as "sent".
    Future<void> pumpSubtitle(WidgetTester tester, Message message) async {
      when(() => channelState.messages).thenReturn([message]);
      when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([message]));
      when(() => channelState.draftStream).thenAnswer((_) => const Stream.empty());
      when(() => channelState.typingEventsStream).thenAnswer((_) => const Stream.empty());
      when(() => channelState.typingEvents).thenReturn({});

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: ChannelListTileSubtitle(
                channel: channel,
                sendingIndicatorBuilder: (_, _) => const Text('sent'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('shows the delivery status of a message from the current user', (tester) async {
      final message = Message(
        text: 'hello world',
        user: User(id: currentUserId),
        createdAt: DateTime(2024, 1, 1),
      );

      await pumpSubtitle(tester, message);

      expect(find.text('sent'), findsOneWidget);
    });

    testWidgets('hides the delivery status of a system message from the current user', (tester) async {
      final message = Message(
        text: 'Me truncated the channel',
        type: MessageType.system,
        user: User(id: currentUserId),
        createdAt: DateTime(2024, 1, 1),
      );

      await pumpSubtitle(tester, message);

      expect(find.text('Me truncated the channel'), findsOneWidget);
      expect(find.text('sent'), findsNothing);
    });
  });

  group('ChannelLastMessageDate', () {
    const currentUserId = 'me';

    // A date the preview must never show. Stubbed as `lastMessageAt` in every
    // test, so reading the channel model is a visible failure.
    final lastMessageAt = DateTime(2024, 6, 6, 6, 6);

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
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.lastMessageAtStream).thenAnswer((_) => Stream.value(lastMessageAt));
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
              // Raw timestamps, so the assertions don't depend on the default
              // formatter's relative-date wording.
              body: ChannelLastMessageDate(
                channel: channel,
                formatter: (context, date) => date.toIso8601String(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('shows the preview message date, not lastMessageAt', (tester) async {
      final createdAt = DateTime(2024, 1, 1, 10, 30);
      final message = Message(
        text: 'hello world',
        user: User(id: 'other'),
        createdAt: createdAt,
      );

      await pumpWithMessages(tester, [message]);

      expect(find.text(createdAt.toLocal().toIso8601String()), findsOneWidget);
      expect(find.text(lastMessageAt.toLocal().toIso8601String()), findsNothing);
    });

    testWidgets('shows nothing when the channel has no messages to preview', (tester) async {
      // A truncated channel: messages gone, `lastMessageAt` still set.
      await pumpWithMessages(tester, []);

      expect(find.byType(StreamTimestamp), findsNothing);
      expect(find.text(lastMessageAt.toLocal().toIso8601String()), findsNothing);
    });

    testWidgets('follows the same message the preview text does', (tester) async {
      // The newest message is filtered out of the preview, so the date has to
      // fall back with it.
      final visible = Message(
        text: 'visible',
        user: User(id: 'other'),
        createdAt: DateTime(2024, 1, 1, 10),
      );
      final errored = Message(
        text: 'errored',
        type: MessageType.error,
        user: User(id: 'other'),
        createdAt: DateTime(2024, 1, 2, 11),
      );

      await pumpWithMessages(tester, [visible, errored]);

      expect(find.text(visible.createdAt.toLocal().toIso8601String()), findsOneWidget);
      expect(find.text(errored.createdAt.toLocal().toIso8601String()), findsNothing);
    });
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

    testWidgets('shows "No messages yet" in the tertiary text color', (tester) async {
      await pumpSubtitle(tester, channelA);
      await tester.pumpAndSettle();

      final colorScheme = tester.element(find.text(emptyText)).streamColorScheme;
      expect(tester.widget<Text>(find.text(emptyText)).style?.color, colorScheme.textTertiary);
    });

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
      "rebinding to a not-up-to-date empty channel shows that channel's empty state",
      (tester) async {
        // Same State reused across channels, but B is still loading, so the
        // preserve-last-known fallback kicks in. It must not fall back to a
        // message belonging to channel A.
        final other = User(id: 'other');
        final msgA = Message(id: 'ma', text: 'channel-a-message', user: other);

        when(() => stateA.messages).thenReturn([msgA]);
        await pumpSubtitle(tester, channelA);
        messagesA.add([msgA]);
        await tester.pumpAndSettle();

        expect(find.text('channel-a-message'), findsOneWidget);

        isUpToDateB = false;
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

  testWidgets('StreamChannelListTile shows a deleted message in the tertiary text color', (tester) async {
    await _pumpTile(tester, message: _deletedMessage());

    final colorScheme = tester.element(find.byType(StreamChannelListTile)).streamColorScheme;
    expect(_deletedMessageColor(tester), colorScheme.textTertiary);
  });

  testWidgets('StreamChannelListTile shows a deleted message in an app-wide deleted style', (tester) async {
    await _pumpTile(
      tester,
      message: _deletedMessage(),
      chatTheme: StreamChatThemeData(
        messagePreviewTextTheme: const StreamMessagePreviewTextThemeData(
          deletedContentStyle: TextStyle(color: Colors.red),
        ),
      ),
    );

    expect(_deletedMessageColor(tester), Colors.red);
  });

  testWidgets('StreamChannelListTile shows the sender prefix semibold in the tertiary text color', (tester) async {
    await _pumpTile(
      tester,
      message: Message(
        text: 'Hello everyone',
        user: User(id: 'ann', name: 'Ann Lee'),
      ),
      channel: ChannelModel(id: 'general', type: 'messaging', memberCount: 3),
    );

    final element = tester.element(find.byType(StreamChannelListTile));
    final style = _paintedStyle(tester, 'Ann: ');
    expect(style?.color, element.streamColorScheme.textTertiary);
    expect(style?.fontWeight, element.streamTypography.fontWeight.semibold);
  });

  testWidgets('StreamChannelListTile keeps the tertiary color under an app-wide italic deleted style', (tester) async {
    await _pumpTile(
      tester,
      message: _deletedMessage(),
      chatTheme: StreamChatThemeData(
        messagePreviewTextTheme: const StreamMessagePreviewTextThemeData(
          deletedContentStyle: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    );

    final colorScheme = tester.element(find.byType(StreamChannelListTile)).streamColorScheme;
    expect(_deletedMessageColor(tester), colorScheme.textTertiary);
    expect(_deletedMessageFontStyle(tester), FontStyle.italic);
  });

  testWidgets('StreamChannelListTile shows a deleted message in the themed preview style', (tester) async {
    await _pumpTile(
      tester,
      message: _deletedMessage(),
      theme: const StreamChannelListItemThemeData(
        messagePreviewTextTheme: StreamMessagePreviewTextThemeData(
          deletedContentStyle: TextStyle(color: Colors.orange),
        ),
      ),
    );

    expect(_deletedMessageColor(tester), Colors.orange);
  });

  testWidgets('StreamChannelListTile prefers the themed preview style over enclosing and app-wide ones', (
    tester,
  ) async {
    await _pumpTile(
      tester,
      message: _deletedMessage(),
      chatTheme: StreamChatThemeData(
        messagePreviewTextTheme: const StreamMessagePreviewTextThemeData(
          deletedContentStyle: TextStyle(color: Colors.red),
        ),
      ),
      previewTextTheme: const StreamMessagePreviewTextThemeData(
        deletedContentStyle: TextStyle(color: Colors.blue),
      ),
      theme: const StreamChannelListItemThemeData(
        messagePreviewTextTheme: StreamMessagePreviewTextThemeData(
          deletedContentStyle: TextStyle(color: Colors.orange),
        ),
      ),
    );

    expect(_deletedMessageColor(tester), Colors.orange);
  });

  testWidgets('StreamChannelListTile colors only the preview icons with an app-wide icon color', (tester) async {
    await _pumpTile(
      tester,
      message: _deletedMessage(),
      chatTheme: StreamChatThemeData(
        messagePreviewTextTheme: const StreamMessagePreviewTextThemeData(iconColor: Colors.green),
      ),
    );

    final colorScheme = tester.element(find.byType(StreamChannelListTile)).streamColorScheme;
    expect(_previewIcon(tester).color, Colors.green);
    expect(_deletedMessageColor(tester), colorScheme.textTertiary);
  });
}

// Pumps a channel list tile whose subtitle previews [message].
Future<void> _pumpTile(
  WidgetTester tester, {
  required Message message,
  StreamChannelListItemThemeData? theme,
  StreamMessagePreviewTextThemeData? previewTextTheme,
  StreamChatThemeData? chatTheme,
  ChannelModel? channel,
}) {
  final client = MockClient();
  final clientState = MockClientState();
  final currentUser = OwnUser(id: 'me');

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);
  when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(currentUser));

  return tester.pumpWidget(
    MaterialApp(
      home: StreamChat(
        client: client,
        connectivityStream: Stream.value(const [ConnectivityResult.wifi]),
        themeData: chatTheme,
        child: Scaffold(
          body: StreamMessagePreviewTextTheme(
            data: previewTextTheme ?? const StreamMessagePreviewTextThemeData(),
            child: StreamChannelListItemTheme(
              data: theme ?? const StreamChannelListItemThemeData(),
              child: StreamChannelListTile(
                avatar: const _SilentAvatar(),
                title: const Text('General'),
                subtitle: StreamMessagePreviewText(message: message, channel: channel),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Message _deletedMessage() => Message(
  id: 'deleted',
  text: 'Original message',
  type: MessageType.deleted,
  user: User(id: 'jason', name: 'Jason Thompson'),
  deletedAt: DateTime.parse('2021-07-20T17:00:00.000Z'),
);

// The icon inside the message preview.
Icon _previewIcon(WidgetTester tester) {
  return tester.widget<Icon>(find.descendant(of: find.byType(StreamMessagePreviewText), matching: find.byType(Icon)));
}

// The color the "Message deleted" text paints with.
Color? _deletedMessageColor(WidgetTester tester) => _deletedMessageStyle(tester)?.color;

// The font style the "Message deleted" text paints with.
FontStyle? _deletedMessageFontStyle(WidgetTester tester) => _deletedMessageStyle(tester)?.fontStyle;

// The style the "Message deleted" text paints with.
TextStyle? _deletedMessageStyle(WidgetTester tester) => _paintedStyle(tester, 'Message deleted');

// The style the preview span with [text] paints with, after every ancestor
// span's style is applied.
TextStyle? _paintedStyle(WidgetTester tester, String text) {
  final richText = tester.widget<RichText>(
    find.descendant(of: find.byType(StreamMessagePreviewText), matching: find.byType(RichText)).first,
  );

  TextStyle? result;
  void visit(InlineSpan span, TextStyle? inherited) {
    if (span is! TextSpan) return;
    final style = inherited?.merge(span.style) ?? span.style;
    if (span.text == text) result = style;
    for (final child in span.children ?? const <InlineSpan>[]) {
      visit(child, style);
    }
  }

  visit(richText.text, null);
  return result;
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
