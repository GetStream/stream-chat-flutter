import 'dart:convert';
import 'dart:io';

/// Client for the stream-chat-test-mock-server.
///
/// Talks to the long-running driver (`driver.rb`), which forks a fresh mock
/// server per test.
class MockServer {
  MockServer._(this.httpUrl, this.wsUrl);

  final String httpUrl;
  final String wsUrl;

  /// Android emulator reaches the host loopback via `10.0.2.2`; the iOS
  /// simulator uses `localhost`.
  static String get _host => Platform.isAndroid ? '10.0.2.2' : 'localhost';

  static const _driverPort =
      String.fromEnvironment('MOCK_DRIVER_PORT', defaultValue: '4568');

  static Future<MockServer> start({required String testName}) async {
    final driverUrl = 'http://$_host:$_driverPort';
    final port = (await _get('$driverUrl/start/$testName')).trim();
    final server = MockServer._('http://$_host:$port', 'ws://$_host:$port');
    await server._waitUntilReady();
    return server;
  }

  /// The driver spawns `server.rb` asynchronously; it needs ~0.5–1s to boot
  /// puma before it answers. Poll `/ping` until ready.
  Future<void> _waitUntilReady({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      try {
        if ((await _statusCode('$httpUrl/ping')) == 200) return;
      } catch (_) {
        // server not up yet
      }
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
    throw StateError('Mock server at $httpUrl did not become ready in $timeout');
  }

  Future<void> generateChannels({int channels = 1, int messages = 0}) async {
    await _post('$httpUrl/mock?channels=$channels&messages=$messages');
  }

  // The per-test server is reaped by the driver.
  Future<void> stop() async {}

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

  static Future<void> _post(String url) async {
    final client = HttpClient();
    try {
      final req = await client.postUrl(Uri.parse(url));
      final res = await req.close();
      await res.drain<void>();
    } finally {
      client.close(force: true);
    }
  }
}
