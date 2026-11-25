import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:stream_chat/src/core/http/interceptor/logging_interceptor.dart';
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

/// Sends one GET through [create]'s interceptor and returns every line it reported.
Future<String> _linesOf(
  LoggingInterceptor Function(LogPrint logPrint) create, {
  String path = '/test',
  Map<String, Object?> headers = const {},
}) async {
  final lines = <String>[];
  final dio = Dio(BaseOptions(baseUrl: 'https://example.com', headers: headers))
    ..httpClientAdapter = _FakeAdapter()
    ..interceptors.add(create((_, line) => lines.add('$line')));

  await dio.get<void>(path);
  return lines.join('\n');
}

void main() {
  test('redacts the Authorization header by default', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(requestHeader: true, logPrint: logPrint),
      headers: const {'Authorization': 'authorization-value'},
    );

    expect(log, contains('Authorization'));
    expect(log, contains(LoggingInterceptor.redacted));
    expect(log, isNot(contains('authorization-value')));
  });

  test('redacts the headers it is given in place of Authorization', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(requestHeader: true, redactHeaders: {'x-session'}, logPrint: logPrint),
      headers: const {'X-Session': 'session-value', 'Authorization': 'authorization-value'},
    );

    expect(log, isNot(contains('session-value')));
    expect(log, contains('authorization-value'));
  });

  test('reports every header as is when no header is to be redacted', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(requestHeader: true, redactHeaders: const {}, logPrint: logPrint),
      headers: const {'Authorization': 'authorization-value'},
    );

    expect(log, contains('authorization-value'));
  });

  test('redacts the query parameters it is given, whatever their case', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(requestHeader: true, redactQueryParams: {'API_KEY'}, logPrint: logPrint),
      path: '/test?api_key=key-value&page=2',
    );

    expect(log, contains('api_key=${LoggingInterceptor.redacted}&page=2'));
    expect(log, isNot(contains('key-value')));
  });

  test('redacts a response header it is given', () async {
    final log = await _linesOf(
      (logPrint) => LoggingInterceptor(responseHeader: true, redactHeaders: {'Content-Type'}, logPrint: logPrint),
    );

    expect(log, contains('content-type'));
    expect(log, isNot(contains(Headers.jsonContentType)));
  });
}
