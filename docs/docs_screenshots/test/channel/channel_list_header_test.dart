import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

Widget _buildListHeaderScaffold({
  required MockClient client,
  StreamChannelListHeader? header,
}) {
  return MaterialApp(
    theme: docsScreenshotsTheme(),
    debugShowCheckedModeBanner: false,
    home: StreamChat(
      client: client,
      connectivityStream: Stream.value([ConnectivityResult.mobile]),
      child: Scaffold(appBar: header),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  docsGoldenTest(
    'channel list header default',
    fileName: 'channel_list_header',
    constraints: const BoxConstraints.tightFor(width: 375, height: 72),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(ownUser);

      return _buildListHeaderScaffold(
        client: client,
        header: const StreamChannelListHeader(),
      );
    },
  );

  docsGoldenTest(
    'channel list header with custom subtitle',
    fileName: 'channel_list_header_custom_subtitle',
    constraints: const BoxConstraints.tightFor(width: 375, height: 72),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(ownUser);

      return _buildListHeaderScaffold(
        client: client,
        header: const StreamChannelListHeader(
          subtitle: Text('12 channels'),
        ),
      );
    },
  );
}
