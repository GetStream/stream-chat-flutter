import 'dart:convert';

import 'package:stream_chat/src/ws/events/events.dart';
import 'package:stream_chat/src/ws/stream_chat_ws_event.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_core/stream_core.dart' show HealthCheckInfo, HealthCheckPingEvent;
import 'package:test/test.dart';

void main() {
  const codec = StreamChatWsCodec();

  // Freezed generates equality over the fields each event declares, so it covers what identifies
  // the frame and not the 40 inherited ones a connection frame never carries.
  test('HealthCheckEvent compares by the connection it names', () {
    final event = HealthCheckEvent(connectionId: 'test-connection-id');

    expect(event, HealthCheckEvent(connectionId: 'test-connection-id'));
    expect(event, isNot(HealthCheckEvent(connectionId: 'another-connection-id')));
  });

  test('ConnectionErrorEvent compares by the error it carries', () {
    final error = StreamApiError.fromJson(_tokenExpiredError);
    final event = ConnectionErrorEvent(error: error);

    expect(event, ConnectionErrorEvent(error: error));
    expect(event, isNot(ConnectionErrorEvent(error: StreamApiError.fromJson({..._tokenExpiredError, 'code': 41}))));
  });

  test('StreamChatWsCodec decodes a health check as the event that establishes a connection', () {
    final event = codec.decode(_frame({'type': EventType.healthCheck, 'connection_id': 'test-connection-id'}));

    expect(event, isA<HealthCheckEvent>());
    expect(event.error, isNull);
    expect(event.healthCheckInfo, const HealthCheckInfo(connectionId: 'test-connection-id'));
    // `HealthCheckEvent` narrows `connectionId` to non-null with a field of its own, so the one it
    // shadows on `Event` has to hold the same id — everything reading an `Event` sees that one.
    expect((event as Event).connectionId, 'test-connection-id');
  });

  test('StreamChatWsCodec refuses a health check that names no connection', () {
    // Every request made over the connection names its id, so a frame without one cannot establish
    // it. The server always sends it; failing to decode is how a frame that did not say so is told
    // apart from one naming a connection the client then cannot use.
    expect(
      () => codec.decode(_frame({'type': EventType.healthCheck, 'connection_id': null})),
      throwsA(isA<TypeError>()),
    );
  });

  test('StreamChatWsCodec reads the user the server signed in off a health check', () {
    // The connection learns who it belongs to here and nowhere else.
    final event = codec.decode(_frame({'me': _user}));

    expect(
      event,
      isA<HealthCheckEvent>().having(
        (it) => it.me,
        'me',
        isA<OwnUser>().having((it) => it.id, 'id', 'test-user-id'),
      ),
    );
  });

  test('StreamChatWsCodec decodes a health check that names no user', () {
    // Every health check after the first carries none.
    final event = codec.decode(_frame({}));

    expect(event, isA<HealthCheckEvent>().having((it) => it.me, 'me', isNull));
  });

  test('StreamChatWsCodec tolerates the health check fields it does not model', () {
    // `cid` is always the literal `*` on a chat health check, and `custom` and `received_at` ride
    // along from the server's base event.
    final event = codec.decode(
      _frame({
        'cid': '*',
        'custom': {'some_key': 'some_value'},
        'received_at': '2020-01-29T03:22:48.63613Z',
      }),
    );

    expect(event, isA<HealthCheckEvent>().having((it) => it.createdAt, 'createdAt', isA<DateTime>()));
  });

  test('StreamChatWsCodec decodes a health check the server timestamped with nothing', () {
    // Stamped locally rather than refused: a health check that failed to decode would be a
    // connection that never reports itself established.
    final event = codec.decode(jsonEncode({'type': EventType.healthCheck, 'connection_id': 'test-connection-id'}));

    expect(event, isA<HealthCheckEvent>().having((it) => it.createdAt, 'createdAt', isNotNull));
    expect(event.healthCheckInfo, const HealthCheckInfo(connectionId: 'test-connection-id'));
  });

  test('StreamChatWsCodec decodes a refusal as a ConnectionErrorEvent', () {
    final event = codec.decode(_frame({'type': EventType.connectionError, 'error': _tokenExpiredError}));

    expect(event, isA<ConnectionErrorEvent>());
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
    final event = codec.decode(jsonEncode({'type': EventType.connectionError, 'error': _tokenExpiredError}));

    expect(event, isA<ConnectionErrorEvent>().having((it) => it.error, 'error', isA<StreamApiError>()));
  });

  test('StreamChatWsCodec decodes any other frame as an Event', () {
    final event = codec.decode(_frame({'type': EventType.messageNew, 'cid': 'messaging:test-channel-id'}));

    expect(
      event,
      isA<Event>()
          .having((it) => it.type, 'type', EventType.messageNew)
          .having((it) => it.cid, 'cid', 'messaging:test-channel-id'),
    );

    // Neither, so the client publishes it rather than acting on it.
    expect(event.healthCheckInfo, isNull);
    expect(event.error, isNull);
  });

  test('StreamChatWsCodec throws on a frame it cannot parse', () {
    // The engine turns this into a dropped message rather than a failed connection, so throwing is
    // how the codec rejects a frame.
    expect(() => codec.decode('not json'), throwsA(anything));
  });

  test('StreamChatWsCodec encodes a ping as the health check the server expects', () {
    const ping = HealthCheckPingEvent(connectionId: 'test-connection-id');

    final encoded = codec.encode(ping);

    expect(jsonDecode(encoded as String), {'type': EventType.healthCheck, 'client_id': 'test-connection-id'});
  });
}

const _user = {'id': 'test-user-id', 'name': 'Test User'};

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
