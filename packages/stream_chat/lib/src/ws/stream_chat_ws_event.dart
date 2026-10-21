import 'dart:convert';

import 'package:stream_core/stream_core.dart';

import '../event_type.dart';
import 'events/event.dart';
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
    final json = jsonDecode(message.toString()) as Map<String, dynamic>;

    return switch (json['type']) {
      EventType.healthCheck => HealthCheckEvent.fromJson(json),
      EventType.connectionError => ConnectionErrorEvent.fromJson(json),
      _ => Event.fromJson(json),
    };
  }
}
