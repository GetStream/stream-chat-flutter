import 'package:stream_chat/src/core/util/message_merging.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'message_merging_fixtures.dart';

void main() {
  test('mergeActiveLocations replaces the existing location sharing the same key', () {
    final endAt = DateTime.now().add(const Duration(hours: 1));
    final existing = [sharedLocation(messageId: 'm1', endAt: endAt, latitude: 1)];
    final incoming = message(
      'm1',
      sharedLocation: sharedLocation(messageId: 'm1', endAt: endAt, latitude: 2),
    );

    final result = MessageMerging.mergeActiveLocations(existing: existing, toMerge: [incoming]);

    expect(result, hasLength(1));
    expect(result.first.latitude, 2);
  });

  test('mergeActiveLocations drops expired locations and ignores messages without a live location', () {
    final expired = sharedLocation(
      messageId: 'm1',
      endAt: DateTime.now().subtract(const Duration(hours: 1)),
    );
    final incoming = message('m2');

    final result = MessageMerging.mergeActiveLocations(existing: [expired], toMerge: [incoming]);

    expect(result, isEmpty);
  });

  test('mergeActiveLocations drops the location when its attached message is deleted', () {
    final active = sharedLocation(messageId: 'm1', endAt: DateTime.now().add(const Duration(hours: 1)));
    final incoming = message('m1', type: MessageType.deleted);

    final result = MessageMerging.mergeActiveLocations(existing: [active], toMerge: [incoming]);

    expect(result, isEmpty);
  });

  test('removeActiveLocations returns the existing locations untouched when there is nothing to remove', () {
    final existing = [sharedLocation(messageId: 'm1')];

    final result = MessageMerging.removeActiveLocations(existing: existing, toRemove: const []);

    expect(result, same(existing));
  });

  test('removeActiveLocations removes the locations attached to the removed messages', () {
    final existing = [
      sharedLocation(messageId: 'm1'),
      sharedLocation(messageId: 'm2'),
    ];

    final result = MessageMerging.removeActiveLocations(existing: existing, toRemove: [message('m1')]);

    expect(result, hasLength(1));
    expect(result.first.messageId, 'm2');
  });
}
