import 'package:test/test.dart';
import 'package:stream_chat/src/api/web_socket_channel_stub.dart';

void main() {
  test('src/api/web_socket_stub_test', () {
    expect(
      () => connectWebSocket('fakeurl'),
      throwsA(isA<UnimplementedError>()),
    );
  });
}
