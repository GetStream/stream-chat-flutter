// ignore_for_file: invalid_use_of_protected_member

import 'package:dio/dio.dart';
import 'package:stream_chat/src/core/http/interceptor/additional_headers_interceptor.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_core/stream_core.dart' show HeadersInterceptor, SystemEnvironmentManager;
import 'package:test/test.dart';

void main() {
  Future<Map<String, dynamic>> headersAfter(Interceptor interceptor) async {
    final options = RequestOptions(path: 'test-path');
    final handler = RequestInterceptorHandler();

    interceptor.onRequest(options, handler);

    final updatedOptions = (await handler.future).data as RequestOptions;
    return updatedOptions.headers;
  }

  group('AdditionalHeadersInterceptor', () {
    test('applies the headers an integrator added', () async {
      StreamChatClient.additionalHeaders = {'test-header': 'test-value'};
      addTearDown(() => StreamChatClient.additionalHeaders = {});

      final headers = await headersAfter(const AdditionalHeadersInterceptor());

      expect(headers['test-header'], 'test-value');
      // The user agent is `HeadersInterceptor`'s job, not this one's.
      expect(headers.containsKey('X-Stream-Client'), isFalse);
    });

    test('reads the headers on every request, not once', () async {
      const interceptor = AdditionalHeadersInterceptor();
      addTearDown(() => StreamChatClient.additionalHeaders = {});

      StreamChatClient.additionalHeaders = {'test-header': 'first'};
      expect((await headersAfter(interceptor))['test-header'], 'first');

      StreamChatClient.additionalHeaders = {'test-header': 'second'};
      expect((await headersAfter(interceptor))['test-header'], 'second');
    });

    test('adds nothing when none were added', () async {
      final headers = await headersAfter(const AdditionalHeadersInterceptor());

      expect(headers.containsKey('test-header'), isFalse);
    });
  });

  // `HeadersInterceptor` is `stream_core`'s, but `stream_core` has no test for
  // it, and this is the environment manager this SDK hands it.
  group('HeadersInterceptor', () {
    test('reports the SDK identity in the Stream client header', () async {
      final headers = await headersAfter(HeadersInterceptor(FakeSystemEnvironmentManager()));

      expect(headers['X-Stream-Client'], 'test-user-agent');
    });
  });
}

class FakeSystemEnvironmentManager extends SystemEnvironmentManager {
  FakeSystemEnvironmentManager()
    : super(
        environment: const SystemEnvironment(
          sdkName: 'stream-chat',
          sdkIdentifier: 'dart',
          sdkVersion: '0.0.0',
        ),
      );

  @override
  String get userAgent => 'test-user-agent';
}
