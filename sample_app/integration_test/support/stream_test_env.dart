import 'package:flutter_test/flutter_test.dart';
import 'package:sample_app/app.dart';
import 'package:sample_app/auth/auth_controller.dart';

import '../mock_server/mock_server.dart';
import '../robots/backend_robot.dart';
import '../robots/participant_robot.dart';
import '../robots/user_robot.dart';

class StreamTestEnv {
  late final MockServer mockServer;
  late final BackendRobot backendRobot;
  late final ParticipantRobot participantRobot;
  late final UserRobot userRobot;

  Future<void> setUp(WidgetTester tester) async {
    mockServer = await MockServer.start();
    backendRobot = BackendRobot(mockServer);
    participantRobot = ParticipantRobot(mockServer);
    userRobot = UserRobot(tester);

    authController.debugConnectionOverride = StreamConnectionOverride(
      baseURL: mockServer.url,
      baseWsUrl: mockServer.wsUrl,
    );

    await tester.pumpWidget(const StreamChatSampleApp());
    await tester.pumpAndSettle();
  }

  Future<void> tearDown() async {
    try {
      await authController.debugReset();
    } finally {
      await mockServer.stop();
    }
  }
}
