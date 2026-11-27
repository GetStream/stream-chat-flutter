import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

class _FakeAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancel) async {
    return ResponseBody.fromString(
      jsonEncode(const {'duration': '12ms'}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

// Sends one GET through [create]'s interceptor and returns every line it reported.
Future<String> _linesOf(
  LoggingInterceptor Function(LogPrint logPrint) create, {
  String path = '/test',
  Map<String, Object?> headers = const {},
  Map<String, Object?>? queryParameters,
}) async {
  final lines = <String>[];
  final dio = Dio(BaseOptions(baseUrl: 'https://example.com', headers: headers))
    ..httpClientAdapter = _FakeAdapter()
    ..interceptors.add(create((_, line) => lines.add('$line')));

  await dio.get<void>(path, queryParameters: queryParameters);
  return lines.join('\n');
}

void main() {
  test('redacts the Authorization header by default', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(requestHeader: true, logPrint: logPrint),
      headers: const {'Authorization': 'authorization-value'},
    );

    expect(log, contains('Authorization: <redacted>'));
    expect(log, isNot(contains('authorization-value')));
  });

  test('redacts the Cookie and Proxy-Authorization headers by default', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(requestHeader: true, logPrint: logPrint),
      headers: const {'Cookie': 'cookie-value', 'Proxy-Authorization': 'proxy-value'},
    );

    expect(log, isNot(contains('cookie-value')));
    expect(log, isNot(contains('proxy-value')));
  });

  test('redacts the Authorization header by default whatever its case', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(requestHeader: true, logPrint: logPrint),
      headers: const {'authorization': 'authorization-value'},
    );

    expect(log, contains('authorization: <redacted>'));
    expect(log, isNot(contains('authorization-value')));
  });

  test('redacts the headers it is given along with the default ones', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(
        requestHeader: true,
        redactedHeaders: {...LoggingInterceptor.defaultRedactedHeaders, 'x-session'},
        logPrint: logPrint,
      ),
      headers: const {'X-Session': 'session-value', 'Authorization': 'authorization-value'},
    );

    expect(log, isNot(contains('session-value')));
    expect(log, isNot(contains('authorization-value')));
  });

  test('reports every header as is when no header is to be redacted', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(requestHeader: true, redactedHeaders: const {}, logPrint: logPrint),
      headers: const {'Authorization': 'authorization-value'},
    );

    expect(log, contains('authorization-value'));
  });

  test('redacts the query parameters it is given, whatever their case', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(requestHeader: true, redactedQueryParameters: {'API_KEY'}, logPrint: logPrint),
      path: '/test?api_key=key-value&page=2',
    );

    expect(log, contains('api_key=<redacted>&page=2'));
    expect(log, isNot(contains('key-value')));
  });

  test('redacts a query parameter whose name is encoded in the URL', () async {
    final log = await _linesOf(
      (logPrint) =>
          LoggingInterceptor(requestHeader: true, redactedQueryParameters: {'filter[id]'}, logPrint: logPrint),
      path: '/test?filter%5Bid%5D=filter-value',
    );

    expect(log, contains('filter%5Bid%5D=<redacted>'));
    expect(log, isNot(contains('filter-value')));
  });

  test('keeps repeated query parameters in the order they were sent', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(redactedQueryParameters: {'b'}, logPrint: logPrint),
      path: '/test?a=1&b=2&a=3',
    );

    expect(log, contains('/test?a=1&b=<redacted>&a=3'));
  });

  test('keeps the encoding of the query parameters it does not redact', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(redactedQueryParameters: {'api_key'}, logPrint: logPrint),
      path: '/test?q=a%20b&api_key=key-value',
    );

    expect(log, contains('/test?q=a%20b&api_key=<redacted>'));
  });

  test('logs a query parameter whose name is not valid UTF-8', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(redactedQueryParameters: {'api_key'}, logPrint: logPrint),
      path: '/test?name%FF=1&api_key=key-value',
    );

    expect(log, contains('/test?name%FF=1&api_key=<redacted>'));
  });

  test('redacts a response header it is given', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(responseHeader: true, redactedHeaders: {'Content-Type'}, logPrint: logPrint),
    );

    expect(log, contains('content-type'));
    expect(log, isNot(contains(Headers.jsonContentType)));
  });

  test('redacts a query parameter passed apart from the path', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(requestHeader: true, redactedQueryParameters: {'api_key'}, logPrint: logPrint),
      queryParameters: const {'api_key': 'key-value'},
    );

    expect(log, contains('api_key: <redacted>'));
    expect(log, isNot(contains('key-value')));
  });
}
