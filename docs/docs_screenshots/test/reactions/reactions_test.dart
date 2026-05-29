import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(const PaginationParams());
    registerFallbackValue(Filter.equal('type', 'like'));
  });

  // --------------------------------------------------------------------------
  // StreamMessageReactionPicker — quick-pick reaction bar
  // --------------------------------------------------------------------------

  docsGoldenTest(
    'reaction picker bar',
    fileName: 'reaction_picker',
    constraints: const BoxConstraints.tightFor(width: 375, height: 80),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(ownUser);

      final message = Message(
        id: 'msg-1',
        text: 'Hello!',
        user: noahSmith,
        createdAt: DateTime(2024, 6, 1, 10, 0),
        ownReactions: [
          Reaction(
            type: 'love',
            messageId: 'msg-1',
            userId: ownUser.id,
            createdAt: DateTime(2024, 6, 1, 10, 1),
          ),
        ],
      );

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Center(
            child: StreamMessageReactionPicker(
              message: message,
              onReactionPicked: (_) {},
            ),
          ),
        ),
      );
    },
  );

  // --------------------------------------------------------------------------
  // ReactionDetailSheet — bottom sheet with count, filter chips, and reactor
  // list. The sheet is opened via a post-frame callback so it animates in
  // before the golden is taken.
  // --------------------------------------------------------------------------

  {
    final mockClient = MockClient();
    final mockClientState = MockClientState();
    when(() => mockClient.state).thenReturn(mockClientState);
    when(() => mockClientState.currentUser).thenReturn(ownUser);

    final reactions = [
      Reaction(
        type: 'love',
        messageId: 'msg-2',
        userId: noahSmith.id,
        user: noahSmith,
        createdAt: DateTime(2024, 6, 1, 10, 0),
      ),
      Reaction(
        type: 'love',
        messageId: 'msg-2',
        userId: liamJohnson.id,
        user: liamJohnson,
        createdAt: DateTime(2024, 6, 1, 10, 1),
      ),
      Reaction(
        type: 'haha',
        messageId: 'msg-2',
        userId: sophiaLee.id,
        user: sophiaLee,
        createdAt: DateTime(2024, 6, 1, 10, 2),
      ),
      Reaction(
        type: 'like',
        messageId: 'msg-2',
        userId: elenaBarros.id,
        user: elenaBarros,
        createdAt: DateTime(2024, 6, 1, 10, 3),
      ),
    ];

    final detailMessage = Message(
      id: 'msg-2',
      text: 'Great update!',
      user: noahSmith,
      createdAt: DateTime(2024, 6, 1, 9, 55),
      reactionGroups: {
        'love': ReactionGroup(
          count: 2,
          sumScores: 2,
          firstReactionAt: DateTime(2024, 6, 1, 10, 0),
          lastReactionAt: DateTime(2024, 6, 1, 10, 1),
        ),
        'haha': ReactionGroup(
          count: 1,
          sumScores: 1,
          firstReactionAt: DateTime(2024, 6, 1, 10, 2),
          lastReactionAt: DateTime(2024, 6, 1, 10, 2),
        ),
        'like': ReactionGroup(
          count: 1,
          sumScores: 1,
          firstReactionAt: DateTime(2024, 6, 1, 10, 3),
          lastReactionAt: DateTime(2024, 6, 1, 10, 3),
        ),
      },
    );

    docsGoldenTest(
      'reaction detail sheet',
      fileName: 'reaction_detail_sheet',
      constraints: const BoxConstraints.tightFor(width: 375, height: 720),
      // StreamChat must live in MaterialApp.builder so that the modal overlay
      // route can still find it via StreamChat.of(context).
      app: (home) => MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        builder: (context, child) => StreamChat(
          client: mockClient,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: child ?? const SizedBox.shrink(),
        ),
        home: home,
      ),
      builder: () {
        when(
          () => mockClient.queryReactions(
            any(),
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
        ).thenAnswer(
          (_) async => QueryReactionsResponse()
            ..reactions = reactions
            ..next = null,
        );

        return Scaffold(
          backgroundColor: const Color(0xFFF0F2F5),
          body: _ReactionDetailSheetGoldenHost(message: detailMessage),
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  // StreamReactionListView — standalone paginated reactor list.
  // The stub must be set up before pumpWidget because PagedValueListView
  // calls doInitialLoad() in initState.
  // --------------------------------------------------------------------------

  {
    final listClient = MockClient();
    final listClientState = MockClientState();
    when(() => listClient.state).thenReturn(listClientState);
    when(() => listClientState.currentUser).thenReturn(ownUser);

    const listMessageId = 'msg-3';
    final listReactions = [
      Reaction(
        type: 'love',
        messageId: listMessageId,
        userId: noahSmith.id,
        user: noahSmith,
        createdAt: DateTime(2024, 6, 1, 10, 0),
      ),
      Reaction(
        type: 'haha',
        messageId: listMessageId,
        userId: sophiaLee.id,
        user: sophiaLee,
        createdAt: DateTime(2024, 6, 1, 10, 1),
      ),
      Reaction(
        type: 'like',
        messageId: listMessageId,
        userId: elenaBarros.id,
        user: elenaBarros,
        createdAt: DateTime(2024, 6, 1, 10, 2),
      ),
    ];

    docsGoldenTest(
      'reaction list view',
      fileName: 'reaction_list_view',
      constraints: const BoxConstraints.tightFor(width: 375, height: 240),
      builder: () {
        // Stub before pump so doInitialLoad() finds the mock ready.
        when(
          () => listClient.queryReactions(
            any(),
            filter: any(named: 'filter'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          ),
        ).thenAnswer(
          (_) async => QueryReactionsResponse()
            ..reactions = listReactions
            ..next = null,
        );

        final controller = StreamReactionListController(
          client: listClient,
          messageId: listMessageId,
        );

        return StreamChat(
          client: listClient,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: StreamReactionListView(
              controller: controller,
              itemBuilder: (context, reactions, index) {
                final reaction = reactions[index];
                final user = reaction.user;
                if (user == null) return const SizedBox.shrink();
                return StreamListTile(
                  leading: StreamUserAvatar(size: StreamAvatarSize.md, user: user),
                  title: Text(user.name),
                  trailing: StreamEmoji(
                    size: StreamEmojiSize.md,
                    emoji: StreamChatConfiguration.of(context).reactionIconResolver.resolve(reaction.type),
                  ),
                );
              },
              emptyBuilder: (_) => const Center(child: Text('No reactions yet')),
            ),
          ),
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  // reactionOverlap configuration — side-by-side comparison showing a message
  // with overlap enabled vs. disabled.
  // --------------------------------------------------------------------------

  docsGoldenTest(
    'reaction overlap true',
    fileName: 'reaction_overlap_true',
    constraints: const BoxConstraints.tightFor(width: 375, height: 140),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(ownUser);

      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();
      setupMockChannel(client: client, clientState: clientState, channel: channel, channelState: channelState);

      final message = Message(
        id: 'msg-overlap',
        text: 'Nice work!',
        user: noahSmith,
        createdAt: DateTime(2024, 6, 1, 10, 0),
        reactionGroups: {
          'love': ReactionGroup(
            count: 3,
            sumScores: 3,
            firstReactionAt: DateTime(2024, 6, 1),
            lastReactionAt: DateTime(2024, 6, 1),
          ),
          'like': ReactionGroup(
            count: 2,
            sumScores: 2,
            firstReactionAt: DateTime(2024, 6, 1),
            lastReactionAt: DateTime(2024, 6, 1),
          ),
        },
      );

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        streamChatConfigData: StreamChatConfigurationData(reactionOverlap: true),
        child: StreamChannel(
          showLoading: false,
          channel: channel,
          child: Scaffold(
            body: Center(child: StreamMessageItem(message: message)),
          ),
        ),
      );
    },
  );

  docsGoldenTest(
    'reaction overlap false',
    fileName: 'reaction_overlap_false',
    constraints: const BoxConstraints.tightFor(width: 375, height: 140),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(ownUser);

      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();
      setupMockChannel(client: client, clientState: clientState, channel: channel, channelState: channelState);

      final message = Message(
        id: 'msg-no-overlap',
        text: 'Nice work!',
        user: noahSmith,
        createdAt: DateTime(2024, 6, 1, 10, 0),
        reactionGroups: {
          'love': ReactionGroup(
            count: 3,
            sumScores: 3,
            firstReactionAt: DateTime(2024, 6, 1),
            lastReactionAt: DateTime(2024, 6, 1),
          ),
          'like': ReactionGroup(
            count: 2,
            sumScores: 2,
            firstReactionAt: DateTime(2024, 6, 1),
            lastReactionAt: DateTime(2024, 6, 1),
          ),
        },
      );

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        streamChatConfigData: StreamChatConfigurationData(reactionOverlap: false),
        child: StreamChannel(
          showLoading: false,
          channel: channel,
          child: Scaffold(
            body: Center(child: StreamMessageItem(message: message)),
          ),
        ),
      );
    },
  );
}

/// Opens [ReactionDetailSheet] in a post-frame callback so the golden test
/// can pump once, settle, and capture the sheet over the scaffold.
class _ReactionDetailSheetGoldenHost extends StatefulWidget {
  const _ReactionDetailSheetGoldenHost({required this.message});

  final Message message;

  @override
  State<_ReactionDetailSheetGoldenHost> createState() => _ReactionDetailSheetGoldenHostState();
}

class _ReactionDetailSheetGoldenHostState extends State<_ReactionDetailSheetGoldenHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ReactionDetailSheet.show(context: context, message: widget.message);
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}
