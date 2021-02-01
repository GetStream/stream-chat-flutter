import 'package:web_socket_channel/web_socket_channel.dart';

/// Stub version of websocket implementation
/// Used just for conditional library import
WebSocketChannel connectWebSocket(String url,
        {Iterable<String> protocols,
        Map<String, dynamic> headers,
        Duration pingInterval}) =>
    throw UnimplementedError();
