import 'package:dio/dio.dart';
import 'package:stream_chat/src/core/error/error.dart';

/// Error class specific to StreamChat and Dio
class StreamChatDioError extends DioException {
  /// Initialize a stream chat dio error
  StreamChatDioError({
    required this.error,
    required super.requestOptions,
    super.response,
    super.type,
    StackTrace? stackTrace,
    super.message,
  }) : super(
         error: error,
         stackTrace: stackTrace ?? StackTrace.current,
       );

  @override
  final StreamChatNetworkError error;
}
