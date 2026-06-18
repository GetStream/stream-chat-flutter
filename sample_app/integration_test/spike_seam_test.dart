import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:sample_app/app.dart';
import 'package:sample_app/auth/auth_controller.dart';
import 'package:sample_app/utils/app_config.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '_spike/mock_server.dart';

// The mock server doesn't verify the signature, but the client parses the JWT
// locally, so the token must be structurally valid.
const _qatest1Token =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoicWF0ZXN0MSJ9.fnelU7HcP7QoEEsCGteNlF1fppofzNlrnpDQuIgeKCU';

/// Boots the sample app against the local mock server and verifies it connects
/// and renders the channel list.
///
/// Runs twice in one bundle to confirm `debugReset()` isolates state between
/// tests (the shared app process would otherwise leak the client/credentials).
///
/// Needs the mock-server driver running:
/// `fastlane start_mock_server local_server:../stream-chat-test-mock-server`.
void main() {
  for (var run = 1; run <= 2; run++) {
    patrolTest('connects to the mock server (run $run)', ($) async {
      final mock = await MockServer.start(testName: 'spike_seam_$run');
      addTearDown(mock.stop);
      addTearDown(authController.debugReset);

      authController.debugConnectionOverride = StreamConnectionOverride(
        baseURL: mock.httpUrl,
        baseWsUrl: mock.wsUrl,
      );

      await mock.generateChannels(channels: 1, messages: 1);

      await $.pumpWidgetAndSettle(const StreamChatSampleApp());

      await authController.connect(
        apiKey: kDefaultStreamApiKey,
        user: User(id: 'qatest1'),
        token: _qatest1Token,
        persistCredentials: false,
      );
      await $.pumpAndSettle();

      expect($(StreamChannelListHeader), findsOneWidget);
    });
  }
}
