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

    expect(log, contains('Authorization: ██'));
  });

  test('redacts the Authorization header by default whatever its case', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(requestHeader: true, logPrint: logPrint),
      headers: const {'authorization': 'authorization-value'},
    );

    expect(log, contains('authorization: ██'));
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

    expect(log, contains('api_key=██&page=2'));
    expect(log, isNot(contains('key-value')));
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

    expect(log, isNot(contains('key-value')));
  });
}
