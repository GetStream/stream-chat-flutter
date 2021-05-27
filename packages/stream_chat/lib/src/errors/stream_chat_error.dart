import 'package:equatable/equatable.dart';
import 'package:stream_chat/src/errors/chat_error_code.dart';
import 'package:stream_chat/stream_chat.dart';

///
class StreamChatError extends Equatable implements Exception {
  ///
  StreamChatError(ChatErrorCode errorCode)
      : code = errorCode.code,
        message = errorCode.message;

  ///
  const StreamChatError.raw(this.code, this.message);

  /// Error code
  final int code;

  /// Error message
  final String message;

  @override
  List<Object?> get props => [code, message];

  @override
  String toString() => 'StreamChatError(code: $code, message: $message)';
}

///
class StreamChatNetworkError extends StreamChatError {
  ///
  StreamChatNetworkError({
    required ChatErrorCode errorCode,
    int? statusCode,
    this.data,
  })  : statusCode = statusCode ?? data?.statusCode,
        super(errorCode);

  ///
  const StreamChatNetworkError.raw({
    required int code,
    required String message,
    this.statusCode,
    this.data,
  }) : super.raw(code, message);

  ///
  factory StreamChatNetworkError.fromDioError(DioError error) {
    final response = error.response;
    ErrorResponse? errorResponse;
    final data = response?.data;
    if (data != null) {
      errorResponse = ErrorResponse.fromJson(data);
    }
    return StreamChatNetworkError.raw(
      code: errorResponse?.code ?? -1,
      message: errorResponse?.message ?? response?.statusMessage ?? '',
      statusCode: errorResponse?.statusCode ?? response?.statusCode,
      data: errorResponse,
    );
  }

  /// HTTP status code
  final int? statusCode;

  /// Response body. please refer to [ErrorResponse].
  final ErrorResponse? data;

  @override
  List<Object?> get props => [...super.props, statusCode];

  @override
  String toString() => 'StreamChatNetworkError('
      'code: $code, '
      'message: $message, '
      'statusCode: $statusCode, '
      'data: $data)';
}
