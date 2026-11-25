import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:stream_chat/src/core/http/interceptor/logging_interceptor.dart';
import 'package:test/test.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.body);

  final Map<String, Object?> body;

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancel) async {
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Future<String> _logOf(Map<String, Object?> body, {Map<String, Object?> headers = const {}}) async {
  final lines = <String>[];
  final dio = Dio(BaseOptions(baseUrl: 'https://example.com', headers: headers))
    ..httpClientAdapter = _FakeAdapter(body)
    ..interceptors.add(LoggingInterceptor(requestHeader: true, logPrint: (_, line) => lines.add('$line')));

  await dio.get<void>('/guest');
  return lines.join('\n');
}

void main() {
  test('reports the Authorization header as <redacted>', () async {
    final log = await _logOf(const {'ok': true}, headers: const {'Authorization': 'header.payload.signature'});

    expect(log, contains('Authorization'));
    expect(log, contains('<redacted>'));
    expect(log, isNot(contains('header.payload.signature')));
  });

  test('reports an access_token in a response body as <redacted>', () async {
    final log = await _logOf(const {'access_token': 'header.payload.signature', 'duration': '12ms'});

    expect(log, contains('access_token'));
    expect(log, contains('12ms'));
    expect(log, isNot(contains('header.payload.signature')));
  });
}
