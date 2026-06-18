import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:sample_app/app.dart';
import 'package:sample_app/auth/auth_controller.dart';
import 'package:sample_app/utils/app_config.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mock_server/mock_server.dart';
import 'pages/channel_list_page.dart';
import 'pages/message_list_page.dart';
import 'robots/backend_robot.dart';

const _qatest1Token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicWF0ZXN0MSJ9.fnelU7HcP7QoEEsCGteNlF1fppofzNlrnpDQuIgeKCU';

void main() {
  patrolTest('user sends a message via the composer', ($) async {
    final mock = await MockServer.start();
    addTearDown(mock.stop);
    addTearDown(authController.debugReset);

    authController.debugConnectionOverride = StreamConnectionOverride(
      baseURL: mock.url,
      baseWsUrl: mock.wsUrl,
    );

    await BackendRobot(mock).generateChannels(channelsCount: 1);

    await $.pumpWidgetAndSettle(const StreamChatSampleApp());
    await authController.connect(
      apiKey: kDefaultStreamApiKey,
      user: User(id: 'qatest1'),
      token: _qatest1Token,
      persistCredentials: false,
    );
    await $.pumpAndSettle();

    // Open the channel.
    await $(ChannelListPage.channelTile).waitUntilVisible();
    await $(ChannelListPage.channelTile).tap();

    // Type and send via the composer page object.
    const text = 'Hello from e2e';
    await $(MessageListPage.composer.inputField).enterText(text);
    await $(MessageListPage.composer.sendButton).tap();

    // The sent message should render in the list.
    await $(text).waitUntilVisible();
  });
}
