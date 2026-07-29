import 'dart:async';

import 'package:flutter/widgets.dart' show AppLifecycleState;
import 'package:flutter_test/flutter_test.dart';
import 'package:sample_app/app.dart';
import 'package:sample_app/auth/auth_controller.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../mock_server/mock_server.dart';
import '../robots/backend_robot.dart';
import '../robots/participant_robot.dart';
import '../robots/user_robot.dart';
import 'fake_url_launcher.dart';

class StreamTestEnv {
  MockServer? _mockServer;
  MockServer get mockServer => _mockServer!;
  late final BackendRobot backendRobot;
  late final ParticipantRobot participantRobot;
  late final UserRobot userRobot;
  late final WidgetTester _tester;

  // Drives the app's connectivity in place of the real `connectivity_plus`
  // monitor, so tests can toggle offline/online deterministically.
  final _connectivity = StreamController<List<ConnectivityResult>>.broadcast();
  var _connectivityPrimed = false;

  // Records every external URL the app tries to open (tapping a link or a link
  // preview routes through the SDK's `launchURL`) instead of handing it to the
  // real browser. Installed in [setUp], restored in [tearDown].
  final _urlLauncher = FakeUrlLauncher();
  UrlLauncherPlatform? _realUrlLauncher;

  /// The external URLs the app has opened so far, in order.
  List<String> get launchedUrls => _urlLauncher.launchedUrls;

  Future<void> setUp(WidgetTester tester, {bool persistence = false}) async {
    _tester = tester;
    _realUrlLauncher = UrlLauncherPlatform.instance;
    UrlLauncherPlatform.instance = _urlLauncher;

    final server = _mockServer = await MockServer.start();
    backendRobot = BackendRobot(server);
    participantRobot = ParticipantRobot(server);
    userRobot = UserRobot(tester);

    authController
      ..debugConnectionOverride = StreamConnectionOverride(
        baseURL: server.url,
        baseWsUrl: server.wsUrl,
        usePersistence: persistence,
      )
      ..debugConnectivityStream = _connectivity.stream;

    await tester.pumpWidget(const StreamChatSampleApp());
    await tester.pumpAndSettle();
  }

  /// Waits until the app opens an external URL (via url_launcher), mirroring the
  /// native "link opens the browser" assertion without a real browser.
  ///
  /// When [url] is given, the launch must be for that exact URL.
  Future<void> assertBrowserOpened({
    String? url,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await _tester.pump(const Duration(milliseconds: 100));
      if (url == null && launchedUrls.isNotEmpty) return;
      if (url != null && launchedUrls.contains(url)) return;
    }
    throw TestFailure(
      'Expected the browser to open${url == null ? '' : ' with $url'}, '
      'but the launched URLs were: $launchedUrls',
    );
  }

  /// Simulates a full network outage: the SDK's HTTP requests all fail and the
  /// WebSocket is closed. Mirrors the native `disableInternetConnection` /
  /// `setConnectivity(.off)`. Missed server-side events are recovered on
  /// [goOnline].
  Future<void> goOffline() => _setConnectivity(online: false);

  /// Restores the network: HTTP works again and the SDK reconnects + recovers.
  Future<void> goOnline() => _setConnectivity(online: true);

  /// Simulates the app being sent to the background. `StreamChatCore` pauses
  /// reconnection and (after its keep-alive) disconnects. Mirrors the native
  /// `deviceRobot.moveApplication(to: .background)`.
  Future<void> moveToBackground() async {
    _tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await _tester.pump();
  }

  /// Simulates the app returning to the foreground. `StreamChatCore` resumes and
  /// reconnects, recovering anything missed. Mirrors `moveApplication(to: .foreground)`.
  Future<void> moveToForeground() async {
    _tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await _tester.pump();
  }

  Future<void> _setConnectivity({required bool online}) async {
    // Gate HTTP first so it matches the connectivity state before/through the
    // transition: block before closing the WS going offline; unblock before
    // reconnecting so recovery (sync/queryChannels) can reach the network.
    authController.debugForceOffline = !online;

    // StreamChatCore skips the first connectivity event (it races the initial
    // connectUser), so prime the stream with a throwaway before the first real
    // toggle. The debounce collapses the primer and the real value together.
    if (!_connectivityPrimed) {
      _connectivity.add([ConnectivityResult.wifi]);
      _connectivityPrimed = true;
    }
    _connectivity.add([if (online) ConnectivityResult.wifi else ConnectivityResult.none]);
    await _waitForConnection(online ? ConnectionStatus.connected : ConnectionStatus.disconnected);
  }

  Future<void> _waitForConnection(
    ConnectionStatus status, {
    // Generous: StreamChatCore debounces connectivity changes ~3s before
    // acting, then the WebSocket (re)connects.
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await _tester.pump(const Duration(milliseconds: 200));
      if (authController.client?.wsConnectionStatus == status) return;
    }
    throw TestFailure('Timed out waiting for connection status: $status');
  }

  Future<void> tearDown() async {
    try {
      await authController.debugReset();
    } finally {
      // Null when tearDown runs before setUp installed the fake.
      if (_realUrlLauncher case final real?) UrlLauncherPlatform.instance = real;
      await _connectivity.close();
      // Null when MockServer.start() itself failed during setUp.
      await _mockServer?.stop();
    }
  }
}
