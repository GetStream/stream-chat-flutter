// ignore_for_file: invalid_use_of_protected_member

import 'package:dio/dio.dart';
import 'package:stream_chat/src/core/http/interceptor/additional_headers_interceptor.dart';
import 'package:stream_chat/src/core/http/system_environment_manager.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  group('AdditionalHeadersInterceptor tests', () {
    group('without SystemEnvironmentManager', () {
      late AdditionalHeadersInterceptor additionalHeadersInterceptor;

      setUp(() {
        additionalHeadersInterceptor = const AdditionalHeadersInterceptor();
      });

      test('should add additional headers in the request', () async {
        StreamChatClient.additionalHeaders = {'test-header': 'test-value'};
        addTearDown(() => StreamChatClient.additionalHeaders = {});

        final options = RequestOptions(path: 'test-path');
        final handler = RequestInterceptorHandler();

        await additionalHeadersInterceptor.onRequest(options, handler);

        final updatedOptions = (await handler.future).data as RequestOptions;
        final updateHeaders = updatedOptions.headers;

        expect(updateHeaders.containsKey('test-header'), isTrue);
        expect(updateHeaders['test-header'], 'test-value');
        expect(updateHeaders.containsKey('X-Stream-Client'), isFalse);
      });
    });

    group('with SystemEnvironmentManager', () {
      late AdditionalHeadersInterceptor additionalHeadersInterceptor;

      setUp(() {
        additionalHeadersInterceptor = AdditionalHeadersInterceptor(
          FakeSystemEnvironmentManager(),
        );
      });

      test('should add user agent header when available', () async {
        StreamChatClient.additionalHeaders = {'test-header': 'test-value'};
        addTearDown(() => StreamChatClient.additionalHeaders = {});

        final options = RequestOptions(path: 'test-path');
        final handler = RequestInterceptorHandler();

        await additionalHeadersInterceptor.onRequest(options, handler);

        final updatedOptions = (await handler.future).data as RequestOptions;
        final updateHeaders = updatedOptions.headers;

        expect(updateHeaders.containsKey('test-header'), isTrue);
        expect(updateHeaders['test-header'], 'test-value');
        expect(updateHeaders.containsKey('X-Stream-Client'), isTrue);
        expect(updateHeaders['X-Stream-Client'], 'test-user-agent');
      });
    });
  });
}

class FakeSystemEnvironmentManager extends SystemEnvironmentManager {
  @override
  String get userAgent => 'test-user-agent';
}
