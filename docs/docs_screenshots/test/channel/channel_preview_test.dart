import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_client_stubs.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  docsGoldenTest(
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
            user: noahSmith,
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

  docsGoldenTest(
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
              user: noahSmith,
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
              user: charlotteAnderson,
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
              user: liamJohnson,
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
              user: elenaBarros,
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
      stubMockClientCurrentUser(client, ownUser);

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
              appBar: const StreamChannelListHeader(title: Text('Chats')),
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

  docsGoldenTest(
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
            user: noahSmith,
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
          child: Builder(
            builder: (context) {
              final icons = context.streamIcons;
              final colorScheme = context.streamColorScheme;
              return Scaffold(
                body: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 75,
                          height: 80,
                          child: ColoredBox(
                            color: colorScheme.backgroundSurface,
                            child: Center(child: Icon(icons.more, size: 20)),
                          ),
                        ),
                        SizedBox(
                          width: 75,
                          height: 80,
                          child: ColoredBox(
                            color: colorScheme.accentPrimary,
                            child: Center(
                              child: Icon(
                                icons.mute,
                                size: 20,
                                color: colorScheme.textOnAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Transform.translate(
                      offset: const Offset(-150, 0),
                      child: ColoredBox(
                        color: Colors.white,
                        child: StreamChannelListItem(channel: channel),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );

  docsGoldenTest(
    'slidable channel list with header',
    fileName: 'slidable_channel_list',
    constraints: const BoxConstraints.tightFor(width: 430, height: 932),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(ownUser);

      final channels = [
        fakeChannel(
          client: client,
          id: 'general',
          name: 'General',
          messages: [
            Message(
              id: 'msg-1',
              text: 'Hey, how is everyone doing?',
              user: noahSmith,
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
              user: charlotteAnderson,
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
              user: liamJohnson,
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
              user: elenaBarros,
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
                final icons = context.streamIcons;
                final colorScheme = context.streamColorScheme;
                return Scaffold(
                  appBar: const StreamChannelListHeader(title: Text('Chats')),
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
                                    color: colorScheme.backgroundSurface,
                                    child: Center(child: Icon(icons.more, size: 20)),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: ColoredBox(
                                    color: colorScheme.accentPrimary,
                                    child: Center(
                                      child: Icon(
                                        icons.mute,
                                        size: 20,
                                        color: colorScheme.textOnAccent,
                                      ),
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
