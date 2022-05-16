import 'package:dio/dio.dart';
import 'package:stream_chat/src/core/error/error.dart';

/// Error class specific to StreamChat and Dio
class StreamChatDioError extends DioError {
  /// Initialize a stream chat dio error
  StreamChatDioError({
    required this.error,
    required super.requestOptions,
    super.response,
    super.type,
  }) : super(
          error: error,
        );

  @override
  final StreamChatNetworkError error;
}
