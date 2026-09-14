import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../stream_chat.dart';

/// Base class for all errors surfaced by the Stream Chat SDK.
///
/// See also:
///
///  * [StreamWebSocketError], raised on the realtime connection.
///  * [StreamChatException], raised by failed HTTP requests.
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

  /// The [StreamErrorCode] for this error, or null if the server sent none.
  StreamErrorCode? get errorCode {
    final code = this.code;
    if (code == null) return null;
    return StreamErrorCode(code);
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
