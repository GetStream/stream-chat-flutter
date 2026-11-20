// ignore_for_file: close_sinks

import 'dart:async';
import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_core/stream_core.dart' show WebSocketOptions;
import 'package:web_socket_channel/web_socket_channel.dart';

/// A chat server a test drives, in place of one on the other end of a socket.
///
/// Only the socket is stood in for: the client under test builds a real connect request, encodes
/// and decodes real frames, and reaches `connected` because this server greeted it — not because a
/// fake reported that it had.
///
/// The default behaviour is a healthy server: it greets every connection with a health check
/// signing in [user], and answers every ping.
class FakeChatServer {
  /// Creates a [FakeChatServer] that signs in [user].
  FakeChatServer({this.user});

  /// The user the hello frame signs in, and `null` for a server that names nobody.
  OwnUser? user;

  /// The refusal sent instead of a greeting, and `null` for a server that accepts the connection.
  ///
  /// Set to a [connectionErrorFrame] for a server that will not serve the credentials it was given.
  Map<String, Object?>? refusal;

  /// Whether the socket refuses to open at all.
  ///
  /// Set `true` for a server that cannot be reached, which is how a connection that fails on the
  /// transport rather than on its credentials is modelled.
  bool handshakeFails = false;

  /// Every socket this server has handed out, in the order they were opened.
  final sockets = <FakeWebSocketChannel>[];

  /// The socket of the connection in flight, which is the one frames are sent over.
  FakeWebSocketChannel get socket => sockets.last;

  /// Hands out a socket wired to this server, for a client's `wsProvider`.
  FakeWebSocketChannel connect(WebSocketOptions options) {
    final socket = FakeWebSocketChannel(
      onSent: _onSent,
      readyError: handshakeFails ? const StreamNetworkException(message: 'Error Connecting') : null,
    );
    sockets.add(socket);

    // A server either greets a connection it accepts, which is what establishes it, or refuses it.
    if (!handshakeFails) {
      scheduleMicrotask(() => socket.receive(refusal ?? healthCheckFrame(me: user)));
    }

    return socket;
  }

  /// Sends [frame] to the client over the connection in flight.
  void send(Map<String, Object?> frame) => socket.receive(frame);

  /// Drops the connection in flight, as a server hanging up does.
  void drop({int closeCode = 1000, String? closeReason}) {
    return socket.closeFromServer(closeCode, closeReason);
  }

  // Answers a ping with a pong, which is what keeps a connection alive.
  void _onSent(Object? frame) {
    final json = jsonDecode(frame! as String) as Map<String, Object?>;
    if (json['type'] == EventType.healthCheck) send(healthCheckFrame());
  }
}

/// The frame that establishes a connection, and the pong that keeps it alive.
///
/// [me] rides the first one only, which is how a connection learns who the server signed in.
Map<String, Object?> healthCheckFrame({OwnUser? me}) {
  return {
    'type': EventType.healthCheck,
    'connection_id': 'fake-connection-id',
    'created_at': DateTime.now().toIso8601String(),
    if (me != null) 'me': me.toJson(),
  };
}

/// The refusal a server sends before closing a connection it will not serve.
Map<String, Object?> connectionErrorFrame({int code = 40, int statusCode = 401}) {
  return {
    'type': EventType.connectionError,
    'error': {
      'code': code,
      'message': 'error $code',
      'StatusCode': statusCode,
      'details': <int>[],
      'duration': '0ms',
      'more_info': '',
    },
  };
}

/// A socket a test drives, recording what the client sent over it.
class FakeWebSocketChannel extends Fake implements WebSocketChannel {
  /// Creates a [FakeWebSocketChannel], calling [onSent] with each frame the client sends.
  FakeWebSocketChannel({void Function(Object? frame)? onSent, this._readyError}) {
    sink = _FakeWebSocketSink(_incoming, onSent);
  }

  final Object? _readyError;

  // Closed by `sink.close` or `closeFromServer`, which is how each peer ends a socket.
  final _incoming = StreamController<Object?>();

  @override
  late final WebSocketSink sink;

  @override
  Stream<dynamic> get stream => _incoming.stream;

  @override
  Future<void> get ready {
    if (_readyError case final error?) return Future.error(error);
    return Future.value();
  }

  @override
  int? get closeCode => _closeCode;
  int? _closeCode;

  @override
  String? get closeReason => _closeReason;
  String? _closeReason;

  /// Delivers [frame] to the client, as a server sending one does.
  void receive(Map<String, Object?> frame) {
    if (_incoming.isClosed) return;
    _incoming.add(jsonEncode(frame));
  }

  /// Ends the connection from the server's side.
  void closeFromServer(int closeCode, [String? closeReason]) {
    if (_incoming.isClosed) return;

    _closeCode = closeCode;
    _closeReason = closeReason;
    _incoming.close().ignore();
  }
}

class _FakeWebSocketSink extends Fake implements WebSocketSink {
  _FakeWebSocketSink(this._incoming, this._onSent);

  final StreamController<Object?> _incoming;
  final void Function(Object? frame)? _onSent;

  @override
  void add(Object? data) => _onSent?.call(data);

  @override
  Future<void> close([int? closeCode, String? closeReason]) async {
    if (!_incoming.isClosed) await _incoming.close();
  }

  @override
  Future<void> get done => _incoming.done;
}
