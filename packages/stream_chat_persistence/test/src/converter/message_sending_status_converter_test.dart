import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/converter/message_sending_status_converter.dart';

void main() {
  group('mapToDart', () {
    final statusConverter = MessageSendingStatusConverter();

    test('should return null if nothing is provided', () {
      final res = statusConverter.mapToDart(null);
      expect(res, isNull);
    });

    test('should return expected status if status code is provided', () {
      final res = statusConverter.mapToDart(3);
      expect(res, MessageSendingStatus.updating);
    });
  });

  group('mapToSql', () {
    final statusConverter = MessageSendingStatusConverter();

    test('should return null if nothing is provided', () {
      final res = statusConverter.mapToSql(null);
      expect(res, isNull);
    });

    test('should return expected code if the status is provided', () {
      final res = statusConverter.mapToSql(MessageSendingStatus.updating);
      expect(res, 3);
    });
  });
}
