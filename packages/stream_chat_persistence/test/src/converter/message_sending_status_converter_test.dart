import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/converter/message_sending_status_converter.dart';

void main() {
  group('fromSql', () {
    final statusConverter = MessageSendingStatusConverter();

    test('should return expected status if status code is provided', () {
      final res = statusConverter.fromSql(3);
      expect(res, MessageSendingStatus.updating);
    });
  });

  group('toSql', () {
    final statusConverter = MessageSendingStatusConverter();

    test('should return expected code if the status is provided', () {
      final res = statusConverter.toSql(MessageSendingStatus.updating);
      expect(res, 3);
    });
  });
}
