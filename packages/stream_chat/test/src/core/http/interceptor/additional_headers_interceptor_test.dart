import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/core/http/interceptor/additional_headers_interceptor.dart';
import 'package:stream_chat/src/core/http/stream_chat_dio_error.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../../mocks.dart';

void main() {
  late StreamHttpClient client;
  late AdditionalHeadersInterceptor additionalHeadersInterceptor;

  setUp(() {
    client = MockHttpClient();
    additionalHeadersInterceptor = AdditionalHeadersInterceptor();
  });

  test(
    '`onRequest` should add additional headers in the request',
    () async {
      final options = RequestOptions(path: 'test-path');
      final handler = RequestInterceptorHandler();

      StreamChatClient.additionalHeaders = {'test-header': 'test-value'};
      additionalHeadersInterceptor.onRequest(options, handler);

      final updatedOptions = (await handler.future).data as RequestOptions;
      final updateHeaders = updatedOptions.headers;

      expect(updateHeaders.containsKey('test-header'), isTrue);
      expect(updateHeaders['test-header'], 'test-value');
    },
  );
}
