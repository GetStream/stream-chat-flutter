import 'package:alchemist/alchemist.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_theme.dart';
import '../src/mocks.dart';

final _currentUser = User(id: 'user-1', name: 'Alice');
final _otherUser = User(id: 'user-2', name: 'Bob');

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
      user: _currentUser,
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
        pinnedBy: _currentUser,
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
      user: _currentUser,
      createdAt: DateTime(2024, 6, 1, 10, 4),
    ),
  ];
}

Widget _buildMessageListViewInDevice({
  required MockClient client,
  required MockChannel channel,
}) {
  return DeviceFrame(
    device: Devices.ios.iPhone13,
    isFrameVisible: true,
    screen: MaterialApp(
      theme: docsScreenshotsTheme(),
      debugShowCheckedModeBanner: false,
      home: StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: StreamChannel(
          showLoading: false,
          channel: channel,
          child: const Scaffold(
            body: StreamMessageListView(),
          ),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  goldenTest(
    'message list view default',
    fileName: 'message_list_view',
    constraints: const BoxConstraints.tightFor(width: 430, height: 932),
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
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-1', name: 'Alice'));

      return _buildMessageListViewInDevice(client: client, channel: channel);
    },
  );

  goldenTest(
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
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-1', name: 'Alice'));

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: StreamChannel(
            showLoading: false,
            channel: channel,
            child: const Scaffold(
              body: StreamMessageListView(),
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
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
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-1', name: 'Alice'));

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: StreamChannel(
            showLoading: false,
            channel: channel,
            child: const Scaffold(
              body: StreamMessageListView(),
            ),
          ),
        ),
      );
    },
  );
}
