import 'dart:convert';

import 'package:stream_core/stream_core.dart';

import '../../open_api/models.dart' as api;
import '../event_type.dart';
import 'events/events.dart';

/// Encodes and decodes Stream Chat WebSocket messages.
///
/// Decodes each frame into the event it represents, and encodes the requests sent back over the
/// connection.
class StreamChatWsCodec implements WebSocketMessageCodec<WsEvent, WsRequest> {
  /// Creates a [StreamChatWsCodec].
  const StreamChatWsCodec();

  @override
  Object encode(WsRequest message) => jsonEncode(message.toJson());

  @override
  WsEvent decode(Object message) {
    final json = jsonDecode(message.toString()) as Map<String, Object?>;
    final type = json['type'];

    try {
      return switch (type) {
        _connectionOk || EventType.healthCheck => HealthCheckFrame.fromJson(json),
        EventType.connectionError => ConnectionErrorFrame.fromJson(json),
        _ => api.WSEvent.fromJson(json),
      };
    } on Object catch (error, stackTrace) {
      // Names the frame's type, which the error alone does not.
      final exception = StreamClientException(message: 'Could not read a $type frame', cause: error);
      Error.throwWithStackTrace(exception, stackTrace);
    }
  }
}

// The frame that opens a connection.
const _connectionOk = 'connection.ok';
