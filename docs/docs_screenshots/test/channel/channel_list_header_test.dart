import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

Widget _buildListHeaderScaffold({
  required MockClient client,
  required PreferredSizeWidget Function(BuildContext) headerBuilder,
}) {
  return StreamChat(
    client: client,
    connectivityStream: Stream.value([ConnectivityResult.mobile]),
    child: Builder(
      builder: (context) => Scaffold(appBar: headerBuilder(context)),
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
        headerBuilder: (context) => StreamChannelListHeader(
          trailing: StreamButton.icon(
            icon: Icon(context.streamIcons.plus),
            onPressed: () {},
          ),
        ),
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
        headerBuilder: (context) => StreamChannelListHeader(
          subtitle: const Text('My Custom Subtitle'),
          trailing: StreamButton.icon(
            icon: Icon(context.streamIcons.plus),
            onPressed: () {},
          ),
        ),
      );
    },
  );

  docsGoldenTest(
    'channel list header with custom title',
    fileName: 'channel_list_header_custom_title',
    constraints: const BoxConstraints.tightFor(width: 375, height: 72),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(ownUser);

      return _buildListHeaderScaffold(
        client: client,
        headerBuilder: (context) => StreamChannelListHeader(
          title: StreamConnectionStatusBuilder(
            statusBuilder: (context, status) {
              return switch (status) {
                ConnectionStatus.connected => const Text('My Chat App'),
                ConnectionStatus.connecting => const Text('Connecting...'),
                ConnectionStatus.disconnected => const Text('Offline'),
              };
            },
          ),
          trailing: StreamButton.icon(
            icon: Icon(context.streamIcons.plus),
            onPressed: () {},
          ),
        ),
      );
    },
  );
}
