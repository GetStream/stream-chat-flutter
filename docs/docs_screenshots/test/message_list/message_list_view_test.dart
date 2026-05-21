import 'package:device_preview/device_preview.dart' show Devices;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

final _otherUser = noahSmith;

List<Message> _buildMessages({bool withPinned = false, bool withThreads = false}) {
  return [
    Message(
      id: 'msg-1',
      text: 'Hey there! How are you?',
      user: _otherUser,
      createdAt: DateTime(2024, 6, 1, 10, 0),
    ),
    Message(
      id: 'msg-2',
      text: 'Doing great, thanks!',
      user: ownUser,
      createdAt: DateTime(2024, 6, 1, 10, 1),
    ),
    if (withPinned)
      Message(
        id: 'msg-pinned',
        text: 'This is an important announcement',
        user: _otherUser,
        createdAt: DateTime(2024, 6, 1, 10, 2),
        pinned: true,
        pinnedAt: DateTime(2024, 6, 1, 10, 3),
        pinnedBy: ownUser,
      ),
    Message(
      id: 'msg-3',
      text: 'What are you up to today?',
      user: _otherUser,
      createdAt: DateTime(2024, 6, 1, 10, 3),
      replyCount: withThreads ? 3 : 0,
    ),
    Message(
      id: 'msg-4',
      text: 'Working on some Flutter features!',
      user: ownUser,
      createdAt: DateTime(2024, 6, 1, 10, 4),
    ),
  ];
}

Widget _buildMessageListViewScaffold({
  required MockClient client,
  required MockChannel channel,
}) {
  return StreamChat(
    client: client,
    connectivityStream: Stream.value([ConnectivityResult.mobile]),
    child: StreamChannel(
      showLoading: false,
      channel: channel,
      child: const Scaffold(
        body: StreamMessageListView(),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  docsGoldenTest(
    'message list view default',
    fileName: 'message_list_view',
    constraints: const BoxConstraints.tightFor(width: 430, height: 932),
    deviceFrame: Devices.ios.iPhone13,
    builder: () {
      final messages = _buildMessages();
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();

      setupMockChannel(
        client: client,
        clientState: clientState,
        channel: channel,
        channelState: channelState,
        channelName: 'General',
        messages: messages,
      );
      when(() => clientState.currentUser).thenReturn(ownUser);

      return _buildMessageListViewScaffold(client: client, channel: channel);
    },
  );

  docsGoldenTest(
    'message list view with pinned message',
    fileName: 'message_list_view_pin',
    constraints: const BoxConstraints.tightFor(width: 375, height: 600),
    builder: () {
      final messages = _buildMessages(withPinned: true);
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();

      setupMockChannel(
        client: client,
        clientState: clientState,
        channel: channel,
        channelState: channelState,
        channelName: 'General',
        messages: messages,
      );
      when(() => clientState.currentUser).thenReturn(ownUser);

      return _buildMessageListViewScaffold(client: client, channel: channel);
    },
  );

  docsGoldenTest(
    'message list view with threads',
    fileName: 'message_list_view_threads',
    constraints: const BoxConstraints.tightFor(width: 375, height: 600),
    builder: () {
      final messages = _buildMessages(withThreads: true);
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel(type: 'messaging', id: 'general');
      final channelState = MockChannelState();

      setupMockChannel(
        client: client,
        clientState: clientState,
        channel: channel,
        channelState: channelState,
        channelName: 'General',
        messages: messages,
      );
      when(() => clientState.currentUser).thenReturn(ownUser);

      return _buildMessageListViewScaffold(client: client, channel: channel);
    },
  );
}
