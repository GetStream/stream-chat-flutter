import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:sample_app/app.dart';
import 'package:sample_app/auth/auth_controller.dart';
import 'package:sample_app/utils/app_config.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '_spike/mock_server.dart';

/// Boots the sample app against the local mock server and verifies it connects
/// and renders the channel list.
///
/// Needs the mock-server driver running:
/// `fastlane start_mock_server local_server:../stream-chat-test-mock-server`.
void main() {
  patrolTest('sample app connects to the mock server', ($) async {
    final mock = await MockServer.start(testName: 'spike_seam');
    addTearDown(mock.stop);

    authController.debugConnectionOverride = StreamConnectionOverride(
      baseURL: mock.httpUrl,
      baseWsUrl: mock.wsUrl,
    );
    addTearDown(() => authController.debugConnectionOverride = null);

    await mock.generateChannels(channels: 1, messages: 1);

    await $.pumpWidgetAndSettle(const StreamChatSampleApp());

    // The mock server doesn't verify the signature, but the client parses the
    // JWT locally, so the token must be structurally valid.
    const qatest1Token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicWF0ZXN0MSJ9.fnelU7HcP7QoEEsCGteNlF1fppofzNlrnpDQuIgeKCU';
    await authController.connect(
      apiKey: kDefaultStreamApiKey,
      user: User(id: 'qatest1'),
      token: qatest1Token,
      persistCredentials: false,
    );
    await $.pumpAndSettle();

    expect($(StreamChannelListHeader), findsOneWidget);
  });
}
