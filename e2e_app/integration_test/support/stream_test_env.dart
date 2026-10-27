import 'dart:async';

import 'package:e2e_app/app.dart';
import 'package:e2e_app/auth/auth_controller.dart';
import 'package:e2e_app/widgets/e2e_message_actions.dart' show lastCopiedMessageId;
import 'package:flutter/widgets.dart' show AppLifecycleState, FlutterError, SizedBox, debugPrint;
import 'package:flutter_test/flutter_test.dart';
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

  Future<void> setUp(WidgetTester tester, {bool persistence = false, bool jwt = false}) async {
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
        // The mock server hands out a short-lived JWT and plays the token
        // failure scenarios the backend robot sets up.
        tokenProvider: jwt
            ? (_) {
                _tokenRequests += 1;
                return server.get('jwt/get');
              }
            : null,
      )
      ..debugConnectivityStream = _connectivity.stream;

    await tester.pumpWidget(const E2eApp());
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

  /// Waits for, and clears, the framework error a test expected to provoke.
  ///
  /// `streamTest` fails a test that leaves one behind, so a test asserting a
  /// failure path has to take it. Times out rather than passing when nothing was
  /// reported, so it can't silently outlive the behaviour it covers.
  Future<void> takeExpectedError({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      if (_tester.binding.takeException() != null) {
        // The same failure can be reported more than once (e.g. by the composer
        // and by the send itself); drain the repeats so none outlives the test.
        final drainEnd = DateTime.now().add(const Duration(seconds: 2));
        while (DateTime.now().isBefore(drainEnd)) {
          await _tester.pump(const Duration(milliseconds: 100));
          _tester.binding.takeException();
        }
        return;
      }
      await _tester.pump(const Duration(milliseconds: 100));
    }
    throw TestFailure('Timed out waiting for a framework error to be reported');
  }

  var _tokenRequests = 0;

  StreamSubscription<ConnectionStatus>? _connectionStatusSubscription;
  var _disconnections = 0;

  /// Waits until the user is connected, and from then on counts how often the
  /// connection drops. Mirrors the native JWT screen's connection status.
  Future<void> assertConnected({Duration timeout = const Duration(seconds: 30)}) async {
    await _waitForConnection(ConnectionStatus.connected, timeout: timeout);
    _connectionStatusSubscription ??= authController.client!.wsConnectionStatusStream.listen((status) {
      if (status != ConnectionStatus.connected) _disconnections++;
    });
  }

  /// Waits until the connection has dropped at least once since
  /// [assertConnected], which is what an expired token causes before the SDK
  /// refreshes it.
  Future<void> assertTokenHasExpired({Duration timeout = const Duration(seconds: 30)}) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      if (_disconnections > 0) return;
      await _tester.pump(const Duration(milliseconds: 200));
    }
    throw TestFailure('The connection never dropped, so the token never expired');
  }

  /// Waits until the connection is disconnected.
  Future<void> assertDisconnected({Duration timeout = const Duration(seconds: 30)}) async {
    await _waitForConnection(ConnectionStatus.disconnected, timeout: timeout);
  }

  /// Asserts the app has requested [count] tokens from the mock server.
  void assertTokenRequests(int count) {
    if (_tokenRequests == count) return;
    throw TestFailure('Expected $count token requests, but the app made $_tokenRequests');
  }

  /// Lets the mock server's short-lived token (5 s) run out.
  Future<void> waitForTokenToExpire() async {
    final end = DateTime.now().add(const Duration(seconds: 6));
    while (DateTime.now().isBefore(end)) {
      await _tester.pump(const Duration(milliseconds: 200));
    }
  }

  /// Truncates the channel the user currently has open, leaving the system
  /// message [withSystemMessage] behind when one is given.
  ///
  /// This calls the SDK rather than driving the UI because there is nothing to
  /// drive: the native suites reach truncation through their test app's debug
  /// menu, and the channel page here is the SDK's own. Truncation is a
  /// server-side event as far as the app is concerned, so what the tests care
  /// about is how the message list and the channel preview react to it.
  Future<void> truncateChannel({String? withSystemMessage}) async {
    final context = _tester.element(find.byType(StreamMessageListView));
    final channel = StreamChannel.of(context).channel;

    await channel.truncate(
      message: switch (withSystemMessage) {
        final text? => Message(text: text),
        _ => null,
      },
    );
    await _tester.pump();
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
  ///
  /// Nothing may be pumped until [moveToForeground]: a backgrounded lifecycle
  /// state sets `SchedulerBinding.framesEnabled` to false, which turns
  /// `scheduleFrame()` into a no-op. The app still observes the change (the
  /// states are dispatched to the observers synchronously) and the WebSocket
  /// keeps delivering events, since neither needs frames.
  Future<void> moveToBackground() async {
    await _tester.pump();
    _dispatchLifecycle(_toBackground);
  }

  /// Simulates the app returning to the foreground. `StreamChatCore` resumes and
  /// reconnects, recovering anything missed. Mirrors `moveApplication(to: .foreground)`.
  Future<void> moveToForeground() async {
    _dispatchLifecycle(_toForeground);
    // Frames are enabled again, so pumping is safe.
    await _tester.pump();
  }

  // The whole chain the OS would send has to be replayed, not just the final
  // state: the framework's own listeners assert on the transition order (see
  // `AppLifecycleListener.didChangeAppLifecycleState`), so jumping straight
  // from paused to resumed throws.
  static const _toBackground = [
    AppLifecycleState.inactive,
    AppLifecycleState.hidden,
    AppLifecycleState.paused,
  ];

  static const _toForeground = [
    AppLifecycleState.hidden,
    AppLifecycleState.inactive,
    AppLifecycleState.resumed,
  ];

  void _dispatchLifecycle(List<AppLifecycleState> states) {
    for (final state in states) {
      _tester.binding.handleAppLifecycleStateChanged(state);
    }
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
    await _connectionStatusSubscription?.cancel();
    try {
      // Unmount the app while the client is still alive. A test that fails with
      // a page open leaves its widgets mounted, and disposing the client first
      // makes their deactivate() throw (the composer saves its draft on the way
      // out). That aborts the unmount, and the half-disposed tree keeps global
      // pointer routes that break every later test sharing the process.
      try {
        await _tester.pumpWidget(const SizedBox.shrink());
        // The conflict is reported as a FlutterError, which is an Error.
        // ignore: avoid_catching_errors
      } on FlutterError catch (e) {
        // A test that failed while one of its pumps was still running (an async
        // error) leaves that pump guarded, and pumping again is a "Guarded function
        // conflict". The test has already failed; still reset the client below.
        debugPrint('Could not unmount the app before resetting the client: ${e.message}');
      }
      await authController.debugReset();
      lastCopiedMessageId = null;
    } finally {
      // Null when tearDown runs before setUp installed the fake.
      if (_realUrlLauncher case final real?) UrlLauncherPlatform.instance = real;
      await _connectivity.close();
      // Null when MockServer.start() itself failed during setUp.
      await _mockServer?.stop();
    }
  }
}
