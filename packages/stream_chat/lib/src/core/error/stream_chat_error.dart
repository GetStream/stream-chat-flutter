import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../stream_chat.dart';

/// Base class for all errors surfaced by the Stream Chat SDK.
///
/// See also:
///
///  * [StreamChatNetworkError], raised by failed HTTP requests.
///  * [StreamWebSocketError], raised on the realtime connection.
class StreamChatError extends Equatable implements Exception {
  /// Creates a new [StreamChatError] with the given [message].
  const StreamChatError(this.message);

  /// A human-readable description of what went wrong.
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'StreamChatError(message: $message)';
}

/// An error received over the realtime (WebSocket) connection.
class StreamWebSocketError extends StreamChatError {
  /// Creates a new [StreamWebSocketError] with the given [message].
  const StreamWebSocketError(
    super.message, {
    this.data,
  });

  /// Creates a [StreamWebSocketError] from a Stream error payload.
  factory StreamWebSocketError.fromStreamError(Map<String, Object?> error) {
    final data = ErrorResponse.fromJson(error);
    final message = data.message ?? '';
    return StreamWebSocketError(message, data: data);
  }

  /// Creates a [StreamWebSocketError] from a [WebSocketChannelException].
  factory StreamWebSocketError.fromWebSocketChannelError(
    WebSocketChannelException error,
  ) {
    final message = error.message ?? '';
    return StreamWebSocketError(message);
  }

  /// The structured error returned by the server, if any.
  final ErrorResponse? data;

  /// The Stream error code, if one was provided.
  int? get code => data?.code;

  /// The [ChatErrorCode] for this error, or null if unrecognised.
  ChatErrorCode? get errorCode {
    final code = this.code;
    if (code == null) return null;
    return chatErrorCodeFromCode(code);
  }

  /// Whether the operation can be retried.
  bool get isRetriable => data == null;

  @override
  List<Object?> get props => [...super.props, code];

  @override
  String toString() {
    var params = 'message: $message';
    if (code case final code?) params = 'code: $code, $params';
    if (data != null) params += ', data: $data';
    return 'StreamWebSocketError($params)';
  }
}

/// An error raised when a network request to Stream fails.
class StreamChatNetworkError extends StreamChatError {
  /// Creates a [StreamChatNetworkError] for a known [errorCode].
  StreamChatNetworkError(
    ChatErrorCode errorCode, {
    int? statusCode,
    this.data,
    StackTrace? stacktrace,
    @Deprecated('Set type to StreamChatNetworkErrorType.cancel instead') this._isRequestCancelledError,
    this.type = .unknown,
  }) : code = errorCode.code,
       statusCode = statusCode ?? data?.statusCode,
       stackTrace = stacktrace ?? StackTrace.current,
       super(errorCode.message);

  /// Creates a [StreamChatNetworkError] from raw values.
  StreamChatNetworkError.raw({
    required this.code,
    required String message,
    this.statusCode,
    this.data,
    StackTrace? stacktrace,
    @Deprecated('Set type to StreamChatNetworkErrorType.cancel instead') this._isRequestCancelledError,
    this.type = .unknown,
  }) : stackTrace = stacktrace ?? StackTrace.current,
       super(message);

  /// Creates a [StreamChatNetworkError] from a [DioException].
  factory StreamChatNetworkError.fromDioException(DioException exception) {
    final response = exception.response;
    ErrorResponse? errorResponse;
    final data = response?.data;
    if (data is Map<String, Object?>) {
      errorResponse = ErrorResponse.fromJson(data);
    } else if (data is String) {
      // Edge/proxy responses (e.g. Cloudflare 5xx, gateway 504) may return
      // a plain-text body like 'upstream request timeout'. Guard the
      // decode so a non-JSON body doesn't mask the original DioException;
      // the surrounding factory falls back to statusMessage / message.
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, Object?>) {
          errorResponse = ErrorResponse.fromJson(decoded);
        }
      } on FormatException {
        // Leave errorResponse null; handled by fallback below.
      }
    }
    return StreamChatNetworkError.raw(
      code: errorResponse?.code ?? -1,
      message: errorResponse?.message ?? response?.statusMessage ?? exception.message ?? '',
      statusCode: errorResponse?.statusCode ?? response?.statusCode,
      data: errorResponse,
      stacktrace: exception.stackTrace,
      type: _networkErrorTypeFromDio(exception.type),
    );
  }

  /// The Stream error code. See [ChatErrorCode].
  final int code;

  /// The HTTP status code of the response, if any.
  final int? statusCode;

  /// The structured error returned by the server, if any.
  final ErrorResponse? data;

  /// The kind of transport failure that caused this error.
  ///
  /// Defaults to [StreamChatNetworkErrorType.unknown] when it can't be
  /// determined.
  final StreamChatNetworkErrorType type;

  /// The optional stack trace attached to the error.
  final StackTrace? stackTrace;

  /// Whether the request was cancelled before it completed.
  @Deprecated('Use type == StreamChatNetworkErrorType.cancel instead')
  bool get isRequestCancelledError => _isRequestCancelledError ?? type == .cancel;
  final bool? _isRequestCancelledError;

  /// The [ChatErrorCode] for this error, or null if unrecognised.
  ChatErrorCode? get errorCode => chatErrorCodeFromCode(code);

  /// Whether the operation can be retried.
  bool get isRetriable => data == null;

  @override
  List<Object?> get props => [...super.props, code, statusCode, type];

  @override
  String toString({bool printStackTrace = false}) {
    var params = 'code: $code, message: $message';
    if (type != .unknown) params += ', type: ${type.name}';
    if (statusCode != null) params += ', statusCode: $statusCode';
    if (data != null) params += ', data: $data';
    var msg = 'StreamChatNetworkError($params)';

    if (printStackTrace && stackTrace != null) {
      msg += '\n$stackTrace';
    }
    return msg;
  }
}

/// The kind of transport failure that caused a [StreamChatNetworkError].
///
/// Lets callers tell a lost connection apart from a timeout, a cancellation,
/// or a server response — for example, to show a tailored error message.
enum StreamChatNetworkErrorType {
  /// The server could not be reached (e.g. no internet connection).
  connectionError,

  /// Opening the connection timed out.
  connectionTimeout,

  /// Sending the request timed out.
  sendTimeout,

  /// Receiving the response timed out.
  receiveTimeout,

  /// Transforming the response (e.g. background JSON decoding) timed out.
  transformTimeout,

  /// The server responded with a non-success status.
  badResponse,

  /// The request was cancelled before it completed.
  cancel,

  /// The connection's certificate could not be validated.
  badCertificate,

  /// The failure could not be attributed to a specific transport cause.
  unknown,
}

StreamChatNetworkErrorType _networkErrorTypeFromDio(DioExceptionType type) {
  return switch (type) {
    DioExceptionType.connectionError => StreamChatNetworkErrorType.connectionError,
    DioExceptionType.connectionTimeout => StreamChatNetworkErrorType.connectionTimeout,
    DioExceptionType.sendTimeout => StreamChatNetworkErrorType.sendTimeout,
    DioExceptionType.receiveTimeout => StreamChatNetworkErrorType.receiveTimeout,
    DioExceptionType.transformTimeout => StreamChatNetworkErrorType.transformTimeout,
    DioExceptionType.badResponse => StreamChatNetworkErrorType.badResponse,
    DioExceptionType.cancel => StreamChatNetworkErrorType.cancel,
    DioExceptionType.badCertificate => StreamChatNetworkErrorType.badCertificate,
    // DioExceptionType.unknown and any future dio types map to unknown.
    _ => StreamChatNetworkErrorType.unknown,
  };
}
