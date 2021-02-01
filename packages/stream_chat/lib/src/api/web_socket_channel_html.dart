import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Html version of websocket implementation
/// Used in Flutter web version
WebSocketChannel connectWebSocket(String url, {Iterable<String> protocols}) =>
    HtmlWebSocketChannel.connect(url, protocols: protocols);
