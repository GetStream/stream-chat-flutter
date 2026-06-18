import 'dart:convert';
import 'dart:io';

// ignore: implementation_imports
import 'package:test_api/src/backend/invoker.dart' show Invoker;

/// Client for the stream-chat-test-mock-server.
///
/// Talks to the long-running driver (`driver.rb`), which forks a fresh mock
/// server per test. [BackendRobot] and [ParticipantRobot] drive it through
/// [post]/[get].
class MockServer {
  MockServer._(this.url, this.wsUrl);

  /// REST base URL of the per-test mock server.
  final String url;

  /// WebSocket base URL of the per-test mock server.
  final String wsUrl;

  /// Android emulator reaches the host loopback via `10.0.2.2`; the iOS
  /// simulator uses `localhost`.
  static String get _host => Platform.isAndroid ? '10.0.2.2' : 'localhost';

  static const _driverPort =
      String.fromEnvironment('MOCK_DRIVER_PORT', defaultValue: '4568');

  /// Asks the driver to spawn a fresh mock server and waits until it is ready.
  ///
  /// [testName] only labels the server's log file; it defaults to the running
  /// test's name.
  static Future<MockServer> start({String? testName}) async {
    final name = testName ?? _currentTestName();
    final driverUrl = 'http://$_host:$_driverPort';
    final port = (await _get('$driverUrl/start/$name')).trim();
    final server = MockServer._('http://$_host:$port', 'ws://$_host:$port');
    await server.waitUntilReady();
    return server;
  }

  /// The running test's name, sanitized for use as a URL segment / filename.
  static String _currentTestName() {
    final name = Invoker.current?.liveTest.test.name ?? 'flutter_test';
    return name.replaceAll(RegExp('[^A-Za-z0-9_]+'), '_');
  }

  /// Stops this per-test mock server.
  Future<void> stop() => _get('$url/stop').catchError((_) => '');

  /// POSTs to [endpoint] (path relative to [url]) with an optional text [body].
  Future<void> post(String endpoint, {String? body}) async {
    final client = HttpClient();
    try {
      final req = await client.postUrl(Uri.parse('$url/$endpoint'));
      if (body != null) {
        req.headers.contentType = ContentType.text;
        req.write(body);
      }
      final res = await req.close();
      await res.drain<void>();
    } finally {
      client.close(force: true);
    }
  }

  /// GETs [endpoint] (path relative to [url]) and returns the response body.
  Future<String> get(String endpoint) => _get('$url/$endpoint');

  /// The driver spawns `server.rb` asynchronously; it needs ~0.5–1s to boot
  /// puma before it answers. Poll `/ping` until ready.
  Future<void> waitUntilReady({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      try {
        if ((await _statusCode('$url/ping')) == 200) return;
      } catch (_) {
        // server not up yet
      }
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
    throw StateError('Mock server at $url did not become ready in $timeout');
  }

  static Future<String> _get(String url) async {
    final client = HttpClient();
    try {
      final req = await client.getUrl(Uri.parse(url));
      final res = await req.close();
      return res.transform(utf8.decoder).join();
    } finally {
      client.close(force: true);
    }
  }

  static Future<int> _statusCode(String url) async {
    final client = HttpClient();
    try {
      final req = await client.getUrl(Uri.parse(url));
      final res = await req.close();
      await res.drain<void>();
      return res.statusCode;
    } finally {
      client.close(force: true);
    }
  }
}
