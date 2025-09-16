import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

void main() {
  final user = User(id: 'uid1', name: 'User 1');
  final createdAt = DateTime.parse('2022-07-20T16:00:00.000Z');
  final draft = Draft(
    channelCid: 'messaging:123',
    channel: ChannelModel(
      cid: 'messaging:123',
      extraData: const {'name': 'Group chat'},
    ),
    createdAt: createdAt,
    message: DraftMessage(
      text: 'This is a draft message that I want to save for later',
    ),
  );

  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamDraftListTile looks fine',
      fileName: 'stream_draft_list_tile_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 120),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        StreamDraftListTile(draft: draft, currentUser: user),
      ),
    );
  }
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  Brightness? brightness,
}) {
  final client = MockClient();
  final clientState = MockClientState();
  final currentUser = OwnUser(id: 'current-user-id', name: 'Current User');

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(currentUser);

  return MaterialApp(
    theme: ThemeData(
      useMaterial3: true,
      brightness: brightness ?? Brightness.light,
    ),
    home: StreamChat(
      client: client,
      streamChatConfigData: StreamChatConfigurationData(),
      connectivityStream: Stream.value(InternetStatus.connected),
      streamChatThemeData: StreamChatThemeData(brightness: brightness),
      child: Builder(
        builder: (context) {
          final theme = StreamChatTheme.of(context);
          return Scaffold(
            backgroundColor: theme.colorTheme.appBg,
            body: Center(child: widget),
          );
        },
      ),
    ),
  );
}
