import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions());
  });

  test('can set custom HttpClientAdapter', () async {
    const apiKey = 'api-key';
    final mockAdapter = MockHttpClientAdapter();
    final httpClient = StreamHttpClient(apiKey, httpClientAdapter: mockAdapter);

    when(() => mockAdapter.fetch(any(), any(), any()))
        .thenAnswer((_) async => ResponseBody(
              Stream.value(Uint8List(0)),
              200,
            ));

    await httpClient.get('/');

    verify(() => mockAdapter.fetch(any(), any(), any())).called(1);
    verifyNoMoreInteractions(mockAdapter);
  });
}

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}
