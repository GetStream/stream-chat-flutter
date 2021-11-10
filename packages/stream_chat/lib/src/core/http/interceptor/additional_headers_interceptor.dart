import 'package:dio/dio.dart';
import 'package:stream_chat/stream_chat.dart';

/// Interceptor that sets additional headers for all requests.
class AdditionalHeadersInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers = {
      ...options.headers,
      ...StreamChatClient.additionalHeaders,
    };
    return handler.next(options);
  }
}
