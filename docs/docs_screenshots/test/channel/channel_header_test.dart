import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_theme.dart';
import '../src/mocks.dart';

Widget _buildChannelHeaderScaffold({
  required MockClient client,
  required MockChannel channel,
  StreamChannelHeader? header,
}) {
  return MaterialApp(
    theme: docsScreenshotsTheme(),
    debugShowCheckedModeBanner: false,
    home: StreamChat(
      client: client,
      connectivityStream: Stream.value([ConnectivityResult.mobile]),
      child: StreamChannel(
        showLoading: false,
        channel: channel,
        child: Scaffold(appBar: header),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  docsGoldenTest(
    'channel header default',
    fileName: 'channel_header',
    constraints: const BoxConstraints.tightFor(width: 375, height: 72),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      setupMockChannel(
        client: client,
        clientState: clientState,
        channel: channel,
        channelState: channelState,
        channelName: 'General',
      );

      return _buildChannelHeaderScaffold(
        client: client,
        channel: channel,
        header: const StreamChannelHeader(
          automaticallyImplyLeading: false,
        ),
      );
    },
  );

  docsGoldenTest(
    'channel header with custom title',
    fileName: 'channel_header_custom_title',
    constraints: const BoxConstraints.tightFor(width: 375, height: 72),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      setupMockChannel(
        client: client,
        clientState: clientState,
        channel: channel,
        channelState: channelState,
        channelName: 'General',
      );

      return _buildChannelHeaderScaffold(
        client: client,
        channel: channel,
        header: const StreamChannelHeader(
          title: Text('My Custom Title'),
          automaticallyImplyLeading: false,
        ),
      );
    },
  );
}
