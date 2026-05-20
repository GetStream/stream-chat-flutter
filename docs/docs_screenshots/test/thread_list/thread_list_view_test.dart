import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_client_stubs.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

final _otherUser = noahSmith;

Thread _makeThread({
  required String id,
  required String channelName,
  required String parentText,
  required String latestReplyText,
  int unreadCount = 0,
}) {
  final parentMessage = Message(
    id: 'parent-$id',
    text: parentText,
    user: ownUser,
    createdAt: DateTime(2024, 6, 1, 9, 0),
  );
  final latestReply = Message(
    id: 'reply-$id',
    text: latestReplyText,
    user: _otherUser,
    parentId: 'parent-$id',
    createdAt: DateTime(2024, 6, 1, 10, 0),
  );

  return Thread(
    channelCid: 'messaging:$id',
    parentMessageId: 'parent-$id',
    createdByUserId: 'user-1',
    replyCount: 3,
    participantCount: 2,
    channel: ChannelModel(
      id: id,
      type: 'messaging',
      extraData: {'name': channelName},
    ),
    parentMessage: parentMessage,
    latestReplies: [latestReply],
    read: unreadCount > 0
        ? [
            Read(
              user: ownUser,
              lastRead: DateTime(2024, 6, 1, 8, 0),
              unreadMessages: unreadCount,
            ),
          ]
        : [],
  );
}

Widget _buildFullAppThreadScaffold({
  required MockClient client,
  required StreamThreadListController controller,
  Widget Function(BuildContext)? emptyBuilder,
  Widget Function(BuildContext, Thread)? customItemBuilder,
  Widget? banner,
}) {
  return MaterialApp(
    theme: docsScreenshotsTheme(),
    debugShowCheckedModeBanner: false,
    home: StreamChat(
      client: client,
      connectivityStream: Stream.value([ConnectivityResult.mobile]),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stream Chat'),
          actions: const [
            IconButton(icon: Icon(Icons.edit_outlined), onPressed: null),
          ],
        ),
        body: Column(
          children: [
            if (banner != null) banner,
            Expanded(
              child: StreamThreadListView(
                controller: controller,
                emptyBuilder: emptyBuilder,
                itemBuilder: customItemBuilder != null
                    ? (context, threads, index, defaultWidget) => customItemBuilder(context, threads[index])
                    : null,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 2,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alternate_email),
              label: 'Mentions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.comment_outlined),
              label: 'Threads',
            ),
          ],
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  docsGoldenTest(
    'thread list view with threads',
    fileName: 'thread_list_view',
    constraints: const BoxConstraints.tightFor(width: 375, height: 700),
    builder: () {
      final client = MockClient();
      stubMockClientCurrentUser(client, ownUser);

      final threads = [
        _makeThread(
          id: 'general',
          channelName: 'General',
          parentText: 'Has anyone tried the new Flutter version?',
          latestReplyText: 'Yes! The performance improvements are amazing.',
          unreadCount: 2,
        ),
        _makeThread(
          id: 'design',
          channelName: 'Design',
          parentText: 'The new color palette looks great!',
          latestReplyText: 'Agreed, especially the dark mode colors.',
        ),
        _makeThread(
          id: 'engineering',
          channelName: 'Engineering',
          parentText: 'We should refactor the auth module',
          latestReplyText: 'I can take that on next sprint.',
        ),
      ];

      final controller = StreamThreadListController.fromValue(
        PagedValue(items: threads),
        client: client,
      );

      stubQueryThreadsForGoldens(client, threads);

      return _buildFullAppThreadScaffold(client: client, controller: controller);
    },
  );

  docsGoldenTest(
    'thread list view empty state',
    fileName: 'thread_list_view_empty',
    constraints: const BoxConstraints.tightFor(width: 375, height: 700),
    builder: () {
      final client = MockClient();
      stubMockClientCurrentUser(client, ownUser);

      final controller = StreamThreadListController.fromValue(
        const PagedValue(items: []),
        client: client,
      );

      stubQueryThreadsForGoldens(client, const []);

      return _buildFullAppThreadScaffold(
        client: client,
        controller: controller,
        emptyBuilder: (context) => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.forum_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No threads yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'Threads will appear here once\nyou reply to a message.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    },
  );

  docsGoldenTest(
    'thread list tile custom',
    fileName: 'thread_list_tile_custom',
    constraints: const BoxConstraints.tightFor(width: 375, height: 120),
    builder: () {
      final client = MockClient();
      stubMockClientCurrentUser(client, ownUser);

      final thread = _makeThread(
        id: 'general',
        channelName: 'General',
        parentText: 'Has anyone tried the new Flutter version?',
        latestReplyText: 'Yes! The performance improvements are amazing.',
        unreadCount: 3,
      );

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.blue.shade700, width: 4),
                ),
              ),
              child: StreamThreadListTile(
                thread: thread,
                currentUser: ownUser,
              ),
            ),
          ),
        ),
      );
    },
  );

  docsGoldenTest(
    'thread list unread banner',
    fileName: 'thread_list_unread_banner',
    constraints: const BoxConstraints.tightFor(width: 375, height: 700),
    builder: () {
      final client = MockClient();
      stubMockClientCurrentUser(client, ownUser);

      final threads = [
        _makeThread(
          id: 'general',
          channelName: 'General',
          parentText: 'Has anyone tried the new Flutter version?',
          latestReplyText: 'Yes! The performance improvements are amazing.',
          unreadCount: 2,
        ),
        _makeThread(
          id: 'design',
          channelName: 'Design',
          parentText: 'The new color palette looks great!',
          latestReplyText: 'Agreed, especially the dark mode colors.',
        ),
        _makeThread(
          id: 'engineering',
          channelName: 'Engineering',
          parentText: 'We should refactor the auth module',
          latestReplyText: 'I can take that on next sprint.',
        ),
      ];

      final controller = StreamThreadListController.fromValue(
        PagedValue(items: threads),
        client: client,
      );

      stubQueryThreadsForGoldens(client, threads);

      return _buildFullAppThreadScaffold(
        client: client,
        controller: controller,
        banner: const StreamUnreadThreadsBanner(
          enabled: true,
          unreadThreads: {'thread-1', 'thread-2', 'thread-3'},
        ),
      );
    },
  );
}
