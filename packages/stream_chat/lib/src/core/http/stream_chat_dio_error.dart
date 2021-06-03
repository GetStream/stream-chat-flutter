import 'package:dio/dio.dart';
import 'package:stream_chat/src/core/error/error.dart';

///
class StreamChatDioError extends DioError {
  ///
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
