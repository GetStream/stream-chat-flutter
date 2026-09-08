import 'package:dio/dio.dart';
import 'package:stream_core/stream_core.dart' show SystemEnvironmentManager;

import '../../../../stream_chat.dart';

/// Interceptor that sets additional headers for all requests.
class AdditionalHeadersInterceptor extends Interceptor {
  /// Initialize a new [AdditionalHeadersInterceptor].
  const AdditionalHeadersInterceptor([this._systemEnvironmentManager]);

  final SystemEnvironmentManager? _systemEnvironmentManager;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final userAgent = _systemEnvironmentManager?.userAgent;

    options.headers = {
      ...options.headers,
      ...StreamChatClient.additionalHeaders,
      if (userAgent != null) 'X-Stream-Client': userAgent,
    };
    return handler.next(options);
  }
}
