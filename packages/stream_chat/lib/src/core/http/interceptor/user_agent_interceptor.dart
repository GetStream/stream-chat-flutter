import 'package:dio/dio.dart';
import 'package:stream_chat/src/core/platform_detector/platform_detector.dart';
import 'package:stream_chat/version.dart';

/// User agent interceptor that sets the user agent header
class UserAgentInterceptor extends Interceptor {
  final _defaultUserAgent = 'stream-chat-dart-client-'
      '${CurrentPlatform.name}-'
      '${PACKAGE_VERSION.split('+')[0]}';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['X-Stream-Client'] =
        '$_defaultUserAgent-${usedPackage.name}';
    return handler.next(options);
  }
}
