import 'package:dio/dio.dart';
import 'package:stream_chat/src/core/http/interceptor/additional_headers_interceptor.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../../mocks.dart';

void main() {
  late AdditionalHeadersInterceptor additionalHeadersInterceptor;

  setUp(() {
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
