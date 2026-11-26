import 'dart:convert';

import 'package:stream_chat/open_api/models.dart' as api;
import 'package:stream_chat/src/ws/events/events.dart';
import 'package:stream_chat/src/ws/stream_chat_ws_event.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_core/stream_core.dart' show HealthCheckInfo, HealthCheckPingEvent;
import 'package:test/test.dart';

import 'fake_chat_server.dart';

void main() {
  test('StreamChatWsCodec decodes a health check as the event that establishes a connection', () {
    final event = _codec().decode(_frame({'type': EventType.healthCheck, 'connection_id': 'test-connection-id'}));

    expect(event, isA<HealthCheckFrame>());
    expect(event.error, isNull);
    expect(event.healthCheckInfo, const HealthCheckInfo(connectionId: 'test-connection-id'));
  });

  test('StreamChatWsCodec decodes the frame that opens a connection as a health check', () {
    final event = _codec().decode(_frame({'type': 'connection.ok', 'me': _user}));

    expect(
      event,
      isA<HealthCheckFrame>()
          .having((it) => it.connectionId, 'connectionId', 'test-connection-id')
          .having((it) => it.me?.id, 'me.id', 'test-user-id'),
    );
  });

  test('StreamChatWsCodec reads a health check timestamped in epoch nanoseconds', () {
    final at = DateTime.utc(2026, 11, 25, 13, 45, 11, 66, 434);
    final event = _codec().decode(_frame({'created_at': at.microsecondsSinceEpoch * 1000}));

    expect(event, isA<HealthCheckFrame>().having((it) => it.createdAt, 'createdAt', at));
  });

  test('StreamChatWsCodec refuses a health check that names no connection', () {
    // Every request made over the connection names its id, so a frame without one cannot establish
    // it. The server always sends it; failing to decode is how a frame that did not say so is told
    // apart from one naming a connection the client then cannot use.
    expect(
      () => _codec().decode(_frame({'connection_id': null})),
      throwsA(isA<StreamClientException>().having((it) => it.cause, 'cause', isA<TypeError>())),
    );
  });

  test('StreamChatWsCodec reads the user the server signed in off a health check', () {
    // The connection learns who it belongs to here and nowhere else.
    final event = _codec().decode(_frame({'me': _user}));

    expect(
      event,
      isA<HealthCheckFrame>().having(
        (it) => it.me,
        'me',
        isA<OwnUser>().having((it) => it.id, 'id', 'test-user-id').having((it) => it.name, 'name', 'Test User'),
      ),
    );
  });

  test('StreamChatWsCodec decodes a health check that names no user', () {
    // Every health check after the first carries none.
    final event = _codec().decode(_frame({}));

    expect(event, isA<HealthCheckFrame>().having((it) => it.me, 'me', isNull));
  });

  test('StreamChatWsCodec still opens the connection when the user it names cannot be read', () {
    final event = _codec().decode(
      _frame({
        'type': 'connection.ok',
        'me': {..._user}..remove('role'),
      }),
    );

    expect(
      event,
      isA<HealthCheckFrame>()
          .having((it) => it.connectionId, 'connectionId', 'test-connection-id')
          .having((it) => it.me, 'me', isNull),
    );
  });

  test('StreamChatWsCodec tolerates the health check fields it does not model', () {
    // `cid` is always the literal `*` on a chat health check, and `custom` and `received_at` ride
    // along from the server's base event.
    final event = _codec().decode(
      _frame({
        'cid': '*',
        'custom': {'some_key': 'some_value'},
        'received_at': '2020-01-29T03:22:48.63613Z',
      }),
    );

    expect(event, isA<HealthCheckFrame>().having((it) => it.createdAt, 'createdAt', isA<DateTime>()));
  });

  test('StreamChatWsCodec decodes a health check the server timestamped with nothing', () {
    // Decoded rather than refused: a health check that failed to decode would be a connection that
    // never reports itself established.
    final event = _codec().decode(jsonEncode({'type': EventType.healthCheck, 'connection_id': 'test-connection-id'}));

    expect(event, isA<HealthCheckFrame>().having((it) => it.createdAt, 'createdAt', isNull));
  });

  test('StreamChatWsCodec decodes a refusal as a ConnectionErrorFrame', () {
    final event = _codec().decode(_frame({'type': EventType.connectionError, 'error': _tokenExpiredError}));

    expect(event, isA<ConnectionErrorFrame>());
    expect(event.healthCheckInfo, isNull);
    expect(
      event.error,
      isA<StreamApiError>()
          .having((it) => it.code, 'code', StreamErrorCode.tokenExpired)
          .having((it) => it.message, 'message', 'Token expired'),
    );
  });

  test('StreamChatWsCodec decodes a refusal the server timestamped with nothing', () {
    // A refusal the client cannot read costs it the reason it was refused, and an expired token
    // then reads as a session the server ended.
    final event = _codec().decode(jsonEncode({'type': EventType.connectionError, 'error': _tokenExpiredError}));

    expect(event, isA<ConnectionErrorFrame>().having((it) => it.error, 'error', isA<StreamApiError>()));
  });

  test('StreamChatWsCodec decodes any other frame as its generated event', () {
    final event = _codec().decode(
      jsonEncode({
        'type': EventType.typingStart,
        'cid': 'messaging:test-channel-id',
        'created_at': '2020-01-29T03:22:47.63613Z',
        'custom': <String, Object?>{},
      }),
    );

    expect(event, isA<api.TypingStartEvent>().having((it) => it.cid, 'cid', 'messaging:test-channel-id'));
    // Neither, so the client publishes it rather than acting on it.
    expect(event.healthCheckInfo, isNull);
    expect(event.error, isNull);
  });

  test('StreamChatWsCodec decodes a frame of a type it has no model for as an unknown event', () {
    final event = _codec().decode(
      jsonEncode({
        'type': 'party_started',
        'created_at': '2020-01-29T03:22:47.63613Z',
        'custom': {'theme': 'disco'},
      }),
    );

    expect(event, isA<api.UnknownWSEvent>().having((it) => it.type, 'type', 'party_started'));
  });

  test('StreamChatWsCodec throws on a known frame missing what its model requires', () {
    // The engine drops it, as it drops any frame the codec cannot decode.
    expect(
      () => _codec().decode(
        jsonEncode({
          'type': EventType.messageNew,
          'cid': 'messaging:test-channel-id',
          'created_at': '2020-01-29T03:22:47.63613Z',
          'custom': <String, Object?>{},
        }),
      ),
      throwsA(isA<StreamClientException>()),
    );
  });

  test('StreamChatWsCodec throws on a frame it cannot parse', () {
    // The engine turns this into a dropped message rather than a failed connection, so throwing is
    // how the codec rejects a frame.
    expect(() => _codec().decode('not json'), throwsA(anything));
  });

  test('StreamChatWsCodec encodes a ping as the health check the server expects', () {
    const ping = HealthCheckPingEvent(connectionId: 'test-connection-id');

    final encoded = _codec().encode(ping);

    expect(jsonDecode(encoded as String), {'type': EventType.healthCheck, 'client_id': 'test-connection-id'});
  });
}

final _user = ownUserResponseJson(OwnUser(id: 'test-user-id', name: 'Test User'));

const _tokenExpiredError = {
  'code': 40,
  'message': 'Token expired',
  'StatusCode': 401,
  'details': <int>[],
  'duration': '0.1ms',
  'more_info': 'https://getstream.io/chat/docs/api_errors_response',
};

// A health check the server would send, with [overrides] applied. Every field the codec does not
// decide on is noise in a test about the one that does.
String _frame(Map<String, Object?> overrides) => jsonEncode({
  'type': EventType.healthCheck,
  'connection_id': 'test-connection-id',
  'created_at': '2020-01-29T03:22:47.63613Z',
  ...overrides,
});

StreamChatWsCodec _codec() => const StreamChatWsCodec();
