import 'package:dio/dio.dart';

import '../../../../stream_chat.dart';

/// Interceptor that applies [StreamChatClient.additionalHeaders] to every
/// request.
///
/// The `X-Stream-Client` header is `stream_core`'s `HeadersInterceptor`; this
/// carries only the headers an integrator adds, which is a chat-only concept.
/// It is read on every request rather than captured once, so a change made
/// after the client was built still applies.
class AdditionalHeadersInterceptor extends Interceptor {
  /// Initialize a new [AdditionalHeadersInterceptor].
  const AdditionalHeadersInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll(StreamChatClient.additionalHeaders);
    return handler.next(options);
  }
}
