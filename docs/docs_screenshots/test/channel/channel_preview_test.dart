import 'package:alchemist/alchemist.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
            connectivityStream: Stream.value([ConnectivityResult.mobile]),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Stream Chat'),
                actions: const [
                  IconButton(icon: Icon(Icons.edit_outlined), onPressed: null),
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
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                  color: Colors.grey[200],
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      Text('Delete', style: TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(-80, 0),
                  child: ColoredBox(
                    color: Colors.white,
                    child: StreamChannelListItem(channel: channel),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  goldenTest(
    'slidable channel list with header',
    fileName: 'slidable_channel_list',
    constraints: const BoxConstraints.tightFor(width: 430, height: 932),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id', name: 'Alice'));

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
            connectivityStream: Stream.value([ConnectivityResult.mobile]),
            child: Builder(
              builder: (context) {
                final chatTheme = StreamChatTheme.of(context);
                final backgroundColor = context.streamColorScheme.backgroundSurface;
                return Scaffold(
                  appBar: const StreamChannelListHeader(),
                  body: Column(
                    children: [
                      // First channel shown swiped to reveal slidable actions
                      SizedBox(
                        height: 80,
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: ColoredBox(
                                    color: backgroundColor,
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.more_horiz),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: ColoredBox(
                                    color: backgroundColor,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.delete_outline,
                                          color: context.streamColorScheme.accentError,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Transform.translate(
                              offset: const Offset(-160, 0),
                              child: ColoredBox(
                                color: Colors.white,
                                child: StreamChannelListItem(channel: channels[0]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: StreamChannelListView(
                          controller: StreamChannelListController.fromValue(
                            PagedValue(items: channels.sublist(1)),
                            client: client,
                          ),
                          shrinkWrap: true,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
