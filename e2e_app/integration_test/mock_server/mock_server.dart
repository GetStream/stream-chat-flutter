import 'dart:convert';
import 'dart:io';

// ignore: implementation_imports
import 'package:test_api/src/backend/invoker.dart' show Invoker;

class MockServer {
  MockServer._(this.url, this.wsUrl);

  final String url;
  final String wsUrl;

  static String get _host => Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';

  static const _driverPort = String.fromEnvironment('MOCK_DRIVER_PORT', defaultValue: '4568');

  static const _httpTimeout = Duration(seconds: 10);
  static const _pingTimeout = Duration(seconds: 2);

  // `/start` spawns a whole server process and can sit in the cold driver's
  // accept backlog on a loaded CI runner, so it gets a much larger budget.
  static const _driverStartTimeout = Duration(seconds: 60);

  static Future<MockServer> start({String? testName}) async {
    final name = testName ?? _currentTestName();
    final driverUrl = 'http://$_host:$_driverPort';
    final port = (await _get('$driverUrl/start/$name', timeout: _driverStartTimeout)).trim();
    final server = MockServer._('http://$_host:$port', 'ws://$_host:$port');
    await server.waitUntilReady();
    return server;
  }

  static String _currentTestName() {
    final name = Invoker.current?.liveTest.test.name ?? 'flutter_test';
    return name.replaceAll(RegExp('[^A-Za-z0-9_]+'), '_');
  }

  Future<void> stop() => _get('$url/stop').catchError((_) => '');

  Future<void> post(String endpoint, {String? body}) async {
    final client = HttpClient()..connectionTimeout = _httpTimeout;
    try {
      final req = await client.postUrl(Uri.parse('$url/$endpoint'));
      if (body != null) {
        req.headers.contentType = ContentType.text;
        req.write(body);
      }
      final res = await req.close().timeout(_httpTimeout);
      await res.drain<void>();
    } finally {
      client.close(force: true);
    }
  }

  Future<String> get(String endpoint) => _get('$url/$endpoint');

  Future<void> waitUntilReady({
    Duration timeout = const Duration(seconds: 45),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      final ready = await _statusCode(
        '$url/ping',
        timeout: _pingTimeout,
      ).then((code) => code == 200).catchError((Object _) => false);
      if (ready) return;
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
    throw StateError('Mock server at $url did not become ready in $timeout');
  }

  static Future<String> _get(
    String url, {
    Duration timeout = _httpTimeout,
  }) async {
    final client = HttpClient()..connectionTimeout = timeout;
    try {
      final req = await client.getUrl(Uri.parse(url));
      final res = await req.close().timeout(timeout);
      // Await the body before the `finally` force-closes the client; a bare
      // `return` runs the close first and kills the connection mid-receive.
      return await res.transform(utf8.decoder).join().timeout(timeout);
    } finally {
      client.close(force: true);
    }
  }

  static Future<int> _statusCode(String url, {Duration? timeout}) async {
    final client = HttpClient()..connectionTimeout = timeout ?? _httpTimeout;
    try {
      final req = await client.getUrl(Uri.parse(url));
      final res = await req.close().timeout(_httpTimeout);
      await res.drain<void>();
      return res.statusCode;
    } finally {
      client.close(force: true);
    }
  }
}
