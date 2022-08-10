import 'dart:convert';

import 'package:stream_chat/src/core/models/call_payload.dart';
import 'package:test/test.dart';

void main() {
  test('CallPayload', () {
    const jsonExample = '''
      {"id":"test",
      "provider": "test",
      "agora": {"channel":"test"},
      "hms":{"room_id":"test", "room_name":"test"}
      }
      ''';
    final response = CallPayload.fromJson(json.decode(jsonExample));
    expect(response.agora, isA<AgoraPayload>());
    expect(response.hms, isA<HMSPayload>());
    expect(response.id, isA<String>());
    expect(response.provider, isA<String>());
  });

  test('AgoraPayload', () {
    const jsonExample = '''
      {"channel":"test"}
      ''';
    final response = AgoraPayload.fromJson(json.decode(jsonExample));
    expect(response.channel, isA<String>());
  });

  test('HMSPayload', () {
    const jsonExample = '''
      {"room_id":"test", "room_name":"test"}
      ''';
    final response = HMSPayload.fromJson(json.decode(jsonExample));
    expect(response.roomId, isA<String>());
    expect(response.roomName, isA<String>());
  });
}
