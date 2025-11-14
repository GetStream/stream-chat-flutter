import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

  group('Formatter Tests', () {
    testWidgets(
      'StreamDraftListTile displays custom formatted timestamp',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithMaterialApp(
            StreamDraftListTileTheme(
              data: StreamDraftListTileThemeData(
                draftTimestampFormatter: (context, timestamp) {
                  return 'CUSTOM_FORMAT_20_07_2022';
                },
              ),
              child: StreamDraftListTile(draft: draft, currentUser: user),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify the custom formatted text is visible
        expect(find.text('CUSTOM_FORMAT_20_07_2022'), findsOneWidget);
      },
    );

    testWidgets(
      'StreamDraftListTile inner theme overrides outer theme',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithMaterialApp(
            StreamDraftListTileTheme(
              data: StreamDraftListTileThemeData(
                draftTimestampFormatter: (context, timestamp) {
                  return 'OUTER_FORMATTER';
                },
              ),
              child: StreamDraftListTileTheme(
                data: StreamDraftListTileThemeData(
                  draftTimestampFormatter: (context, timestamp) {
                    return 'INNER_FORMATTER';
                  },
                ),
                child: StreamDraftListTile(draft: draft, currentUser: user),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Inner formatter should be used
        expect(find.text('INNER_FORMATTER'), findsOneWidget);
        expect(find.text('OUTER_FORMATTER'), findsNothing);
      },
    );
  });
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
      connectivityStream: Stream.value([ConnectivityResult.wifi]),
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
