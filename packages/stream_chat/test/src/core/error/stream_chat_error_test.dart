import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/error/error.dart';
import 'package:test/test.dart';

void main() {
  group('StreamChatError', () {
    test('should match if message is same', () {
      const message = 'test-error-message';
      const error = StreamChatError(message);
      const error2 = StreamChatError(message);

      expect(error, error2);
    });

    test('`.toString`', () {
      const message = 'test-error-message';
      const error = StreamChatError(message);

      expect(error.toString(), 'StreamChatError(message: $message)');
    });
  });

  group('StreamWebSocketError', () {
    test('.fromStreamError', () {
      final data = ErrorResponse()..code = 333;
      final error = StreamWebSocketError.fromStreamError(data.toJson());
      expect(error, isNotNull);
      expect(error.code, data.code);
    });

    test('should match if message and data.code is same', () {
      const message = 'test-error-message';
      final data = ErrorResponse()..code = 333;
      final error = StreamWebSocketError(message, data: data);
      final error2 = StreamWebSocketError(message, data: data);

      expect(error, error2);
    });

    test('`.toString`', () {
      const message = 'test-error-message';
      final data = ErrorResponse()..code = 333;
      final error = StreamWebSocketError(message, data: data);

      expect(
        error.toString(),
        'StreamWebSocketError(code: ${data.code}, message: $message, data: $data)',
      );
    });

    test('`.toString` omits code when absent', () {
      const error = StreamWebSocketError('boom');
      expect(error.toString(), 'StreamWebSocketError(message: boom)');
    });
  });
}
