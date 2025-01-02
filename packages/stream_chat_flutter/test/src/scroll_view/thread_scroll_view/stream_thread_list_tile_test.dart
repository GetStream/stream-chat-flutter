import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  final user1 = User(id: 'uid1', name: 'User 1');
  final user2 = User(id: 'uid2', name: 'User 2');
  final createdAt = DateTime.parse('2021-07-20T16:00:00.000Z');
  final thread = Thread(
    activeParticipantCount: 2,
    channelCid: 'channel-type:channel-id',
    channel: ChannelModel(
      cid: 'channel-type:channel-id',
      extraData: const {'name': 'Group ride'},
    ),
    parentMessageId: 'parent-message-id',
    parentMessage: Message(
      id: 'parent-message-id',
      text: "Hey everyone, who's up for a group ride this Saturday morning?",
    ),
    createdByUserId: 'uid1',
    createdBy: user2,
    participantCount: 2,
    threadParticipants: [
      ThreadParticipant(
        user: user1,
        channelCid: '',
        createdAt: createdAt,
        lastReadAt: createdAt,
      ),
      ThreadParticipant(
        user: user2,
        channelCid: '',
        createdAt: createdAt,
        lastReadAt: createdAt,
      ),
    ],
    lastMessageAt: createdAt,
    createdAt: createdAt,
    updatedAt: createdAt,
    title: 'Group ride preparation and discussion',
    replyCount: 1,
    latestReplies: [
      Message(
        id: 'mid1',
        text: 'See you all there, stay safe on the roads!',
        user: user1,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    ],
    read: [
      Read(
        user: user2,
        lastRead: createdAt,
        unreadMessages: 3,
      ),
    ],
  );

  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamThreadListTile looks fine',
      fileName: 'stream_thread_list_tile_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 150),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        StreamThreadListTile(thread: thread, currentUser: user2),
      ),
    );
  }
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  Brightness? brightness,
}) {
  return MaterialApp(
    home: StreamChatConfiguration(
      data: StreamChatConfigurationData(),
      child: StreamChatTheme(
        data: StreamChatThemeData(brightness: brightness),
        child: Builder(builder: (context) {
          final theme = StreamChatTheme.of(context);
          return Scaffold(
            backgroundColor: theme.colorTheme.appBg,
            body: Center(child: widget),
          );
        }),
      ),
    ),
  );
}
