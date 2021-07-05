import 'package:dio/dio.dart';
import 'package:stream_chat/src/core/error/error.dart';

/// Error class specific to StreamChat and Dio
class StreamChatDioError extends DioError {
  /// Initialize a stream chat dio error
  StreamChatDioError({
    required this.error,
    required RequestOptions requestOptions,
    Response? response,
    DioErrorType type = DioErrorType.other,
  }) : super(
          error: error,
          requestOptions: requestOptions,
          response: response,
          type: type,
        );

  @override
  final StreamChatNetworkError error;
}
