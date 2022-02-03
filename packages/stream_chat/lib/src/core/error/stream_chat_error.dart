import 'package:equatable/equatable.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

///
class StreamChatError with EquatableMixin implements Exception {
  ///
  const StreamChatError(this.message);

  /// Error message
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'StreamChatError(message: $message)';
}

///
class StreamWebSocketError extends StreamChatError {
  ///
  const StreamWebSocketError(
    String message, {
    this.data,
  }) : super(message);

  ///
  factory StreamWebSocketError.fromStreamError(Map<String, Object?> error) {
    final data = ErrorResponse.fromJson(error);
    final message = data.message ?? '';
    return StreamWebSocketError(message, data: data);
  }

  ///
  factory StreamWebSocketError.fromWebSocketChannelError(
    WebSocketChannelException error,
  ) {
    final message = error.message ?? '';
    return StreamWebSocketError(message);
  }

  ///
  int? get code => data?.code;

  ///
  ChatErrorCode? get errorCode {
    final code = this.code;
    if (code == null) return null;
    return chatErrorCodeFromCode(code);
  }

  /// Response body. please refer to [ErrorResponse].
  final ErrorResponse? data;

  ///
  bool get isRetriable => data == null;

  @override
  List<Object?> get props => [...super.props, code];

  @override
  String toString() {
    var params = 'message: $message';
    if (data != null) params += ', data: $data';
    return 'WebSocketError($params)';
  }
}

///
class StreamChatNetworkError extends StreamChatError {
  ///
  StreamChatNetworkError(
    ChatErrorCode errorCode, {
    int? statusCode,
    this.data,
  })  : code = errorCode.code,
        statusCode = statusCode ?? data?.statusCode,
        super(errorCode.message);

  ///
  StreamChatNetworkError.raw({
    required this.code,
    required String message,
    this.statusCode,
    this.data,
  }) : super(message);

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
      message:
          errorResponse?.message ?? response?.statusMessage ?? error.message,
      statusCode: errorResponse?.statusCode ?? response?.statusCode,
      data: errorResponse,
    )..stackTrace = error.stackTrace;
  }

  /// Error code
  final int code;

  /// HTTP status code
  final int? statusCode;

  /// Response body. please refer to [ErrorResponse].
  final ErrorResponse? data;

  StackTrace? _stackTrace;

  ///
  set stackTrace(StackTrace? stack) => _stackTrace = stack;

  ///
  ChatErrorCode? get errorCode => chatErrorCodeFromCode(code);

  ///
  bool get isRetriable => data == null;

  @override
  List<Object?> get props => [...super.props, code, statusCode];

  @override
  String toString({bool printStackTrace = false}) {
    var params = 'code: $code, message: $message';
    if (statusCode != null) params += ', statusCode: $statusCode';
    if (data != null) params += ', data: $data';
    var msg = 'StreamChatNetworkError($params)';

    if (printStackTrace && _stackTrace != null) {
      msg += '\n$_stackTrace';
    }
    return msg;
  }
}
