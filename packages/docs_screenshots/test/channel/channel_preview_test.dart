import 'package:alchemist/alchemist.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_client_stubs.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  goldenTest(
    'channel preview tile',
    fileName: 'channel_preview',
    constraints: const BoxConstraints.tightFor(width: 375, height: 80),
    builder: () {
      final client = MockClient();
      final channel = fakeChannel(
        client: client,
        id: 'general',
        name: 'General',
        messages: [
          Message(
            id: 'msg-1',
            text: 'Hey everyone!',
            user: User(id: 'user-2', name: 'Bob'),
            createdAt: DateTime(2024, 6, 1, 10, 30),
          ),
        ],
      );

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          streamChatThemeData: docsStreamChatThemeData(),
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: StreamChannelListItem(channel: channel),
          ),
        ),
      );
    },
  );

  goldenTest(
    'channel list view',
    fileName: 'channel_list_view',
    constraints: const BoxConstraints.tightFor(width: 430, height: 932),
    builder: () {
      final client = MockClient();

      final channels = [
        fakeChannel(
          client: client,
          id: 'general',
          name: 'General',
          messages: [
            Message(
              id: 'msg-1',
              text: 'Hey, how is everyone doing?',
              user: User(id: 'user-2', name: 'Bob'),
              createdAt: DateTime(2024, 6, 1, 10, 30),
            ),
          ],
          unreadCount: 2,
        ),
        fakeChannel(
          client: client,
          id: 'design',
          name: 'Design',
          messages: [
            Message(
              id: 'msg-2',
              text: 'New mockups are ready!',
              user: User(id: 'user-3', name: 'Carol'),
              createdAt: DateTime(2024, 6, 1, 9, 15),
            ),
          ],
        ),
        fakeChannel(
          client: client,
          id: 'random',
          name: 'Random',
          messages: [
            Message(
              id: 'msg-3',
              text: 'Anyone up for lunch?',
              user: User(id: 'user-4', name: 'Dave'),
              createdAt: DateTime(2024, 5, 31, 12, 0),
            ),
          ],
        ),
        fakeChannel(
          client: client,
          id: 'engineering',
          name: 'Engineering',
          messages: [
            Message(
              id: 'msg-4',
              text: 'PR #42 is ready for review',
              user: User(id: 'user-5', name: 'Eve'),
              createdAt: DateTime(2024, 5, 30, 15, 45),
            ),
          ],
        ),
      ];

      final controller = StreamChannelListController.fromValue(
        PagedValue(items: channels),
        client: client,
      );

      stubQueryChannelsForGoldens(client, channels);

      return DeviceFrame(
        device: Devices.ios.iPhone13,
        isFrameVisible: true,
        screen: MaterialApp(
          theme: docsScreenshotsTheme(),
          debugShowCheckedModeBanner: false,
          home: StreamChat(
            client: client,
            streamChatThemeData: docsStreamChatThemeData(),
            connectivityStream: Stream.value([ConnectivityResult.mobile]),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Stream Chat'),
                actions: [
                  IconButton(icon: const Icon(Icons.edit_outlined), onPressed: null),
                ],
              ),
              body: StreamChannelListView(
                controller: controller,
                shrinkWrap: true,
              ),
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
    'swipe channel to reveal actions',
    fileName: 'swipe_channel',
    constraints: const BoxConstraints.tightFor(width: 375, height: 80),
    builder: () {
      final client = MockClient();
      final channel = fakeChannel(
        client: client,
        id: 'general',
        name: 'General',
        messages: [
          Message(
            id: 'msg-1',
            text: 'Hey, how is everyone doing?',
            user: User(id: 'user-2', name: 'Bob'),
            createdAt: DateTime(2024, 6, 1, 10, 30),
          ),
        ],
      );

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          streamChatThemeData: docsStreamChatThemeData(),
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      Text('Delete', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(-80, 0),
                  child: StreamChannelListItem(channel: channel),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
