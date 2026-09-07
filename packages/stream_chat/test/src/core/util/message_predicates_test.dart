import 'package:stream_chat/src/core/util/message_predicates.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

Message _message(
  String id, {
  String? parentId,
  bool? showInChannel,
  bool pinned = false,
  DateTime? pinExpires,
  String type = 'regular',
}) {
  return Message(
    id: id,
    parentId: parentId,
    showInChannel: showInChannel,
    pinned: pinned,
    pinExpires: pinExpires,
    type: type,
  );
}

void main() {
  group('MessagePredicates.isShownInChannel', () {
    test('is true for a non-thread message', () {
      expect(_message('m1').isShownInChannel, isTrue);
    });

    test('is true for a thread reply marked to show in the channel', () {
      final reply = _message('m1', parentId: 'p1', showInChannel: true);
      expect(reply.isShownInChannel, isTrue);
    });

    test('is false for a thread-only reply', () {
      final reply = _message('m1', parentId: 'p1');
      expect(reply.isShownInChannel, isFalse);
    });
  });

  group('MessagePredicates.hasValidPin', () {
    test('is false for a deleted message', () {
      final message = _message('m1', pinned: true, type: MessageType.deleted);
      expect(message.hasValidPin, isFalse);
    });

    test('is false for an unpinned message', () {
      final message = _message('m1');
      expect(message.hasValidPin, isFalse);
    });

    test('is true for a pinned message without expiration', () {
      final message = _message('m1', pinned: true);
      expect(message.hasValidPin, isTrue);
    });

    test('is true while the pin expiration is in the future', () {
      final message = _message('m1', pinned: true, pinExpires: DateTime.now().add(const Duration(hours: 1)));
      expect(message.hasValidPin, isTrue);
    });

    test('is false once the pin expiration has passed', () {
      final message = _message('m1', pinned: true, pinExpires: DateTime.now().subtract(const Duration(hours: 1)));
      expect(message.hasValidPin, isFalse);
    });
  });
}
