import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_client_stubs.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';

Draft _makeDraft({
  required String channelId,
  required String channelName,
  required String text,
  String? parentId,
  Message? parentMessage,
}) {
  return Draft(
    channelCid: 'messaging:$channelId',
    createdAt: DateTime(2024, 6, 1, 10, 0),
    message: DraftMessage(text: text, parentId: parentId),
    channel: ChannelModel(
      id: channelId,
      type: 'messaging',
      extraData: {'name': channelName},
    ),
    parentId: parentId,
    parentMessage: parentMessage,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  goldenTest(
    'draft list view',
    fileName: 'draft_list_view',
    constraints: const BoxConstraints.tightFor(width: 375, height: 400),
    builder: () {
      final client = MockClient();
      stubMockClientCurrentUser(client, OwnUser(id: 'user-1', name: 'Alice'));

      final drafts = [
        _makeDraft(
          channelId: 'general',
          channelName: 'General',
          text: 'Has anyone seen the latest release notes?',
        ),
        _makeDraft(
          channelId: 'design',
          channelName: 'Design',
          text: 'I have some feedback on the new color scheme…',
        ),
        _makeDraft(
          channelId: 'random',
          channelName: 'Random',
          text: 'Anyone up for lunch tomorrow?',
        ),
      ];

      final controller = StreamDraftListController.fromValue(
        PagedValue(items: drafts),
        client: client,
      );

      stubQueryDraftsForGoldens(client, drafts);

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: StreamDraftListView(
              controller: controller,
              shrinkWrap: true,
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
    'channel draft message tile',
    fileName: 'channel_draft_message',
    constraints: const BoxConstraints.tightFor(width: 375, height: 80),
    builder: () {
      final client = MockClient();
      stubMockClientCurrentUser(client, OwnUser(id: 'user-1', name: 'Alice'));

      final draft = _makeDraft(
        channelId: 'general',
        channelName: 'General',
        text: 'I was thinking about the new feature…',
      );

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: StreamDraftListTile(
              draft: draft,
              currentUser: User(id: 'user-1', name: 'Alice'),
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
    'thread draft message tile',
    fileName: 'thread_draft_message',
    constraints: const BoxConstraints.tightFor(width: 375, height: 80),
    builder: () {
      final client = MockClient();
      stubMockClientCurrentUser(client, OwnUser(id: 'user-1', name: 'Alice'));

      final parentMessage = Message(
        id: 'parent-msg',
        text: 'Has anyone seen the latest release?',
        user: User(id: 'user-2', name: 'Bob'),
        createdAt: DateTime(2024, 6, 1, 9, 0),
      );

      final draft = _makeDraft(
        channelId: 'general',
        channelName: 'General',
        text: 'Yes, the new streaming API looks great!',
        parentId: 'parent-msg',
        parentMessage: parentMessage,
      );

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: StreamDraftListTile(
              draft: draft,
              currentUser: User(id: 'user-1', name: 'Alice'),
            ),
          ),
        ),
      );
    },
  );
}
