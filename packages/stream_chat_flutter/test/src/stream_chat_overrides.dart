import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

const _asyncRunZoned = runZoned;

class _StreamChatOverridesScopes extends StreamChatOverrides {
  _StreamChatOverridesScopes({
    ClientState? clientState,
    StreamChatClient? client,
    Channel? channel,
  })  : _clientState = clientState ?? MockClientState(),
        _channel = channel ?? MockChannel(),
        _client = client ?? MockClient();
  final ClientState _clientState;
  final StreamChatClient _client;
  final Channel _channel;

  @override
  ClientState get clientState => _clientState;

  @override
  StreamChatClient get client => _client;

  @override
  Channel get channel => _channel;
}

abstract class StreamChatOverrides {
  static final _token = Object();
  static StreamChatOverrides? get current {
    return Zone.current[_token] as StreamChatOverrides?;
  }

  ClientState get clientState;
  StreamChatClient get client;

  Channel get channel;
  static R runZoned<R>(
    R Function() body, {
    ClientState Function()? clientState,
    StreamChatClient Function()? client,
    Channel Function()? channel,
  }) {
    final overrides = _StreamChatOverridesScopes(
        clientState: clientState?.call(),
        client: client?.call(),
        channel: channel?.call());
    when(() => overrides.client.state).thenReturn(overrides.clientState);
    when(() => overrides.clientState.currentUser)
        .thenReturn(OwnUser(id: 'user-id'));

    return _asyncRunZoned(body, zoneValues: {_token: overrides});
  }
}
