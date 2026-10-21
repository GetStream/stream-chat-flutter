import 'package:stream_chat/src/core/util/message_merging.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'message_merging_fixtures.dart';

void main() {
  test('mergePinnedMessages keeps only messages that are still valid pins', () {
    final existing = [message('m1', createdAt: DateTime(2024), pinned: true)];
    final incoming = [
      message('m2', createdAt: DateTime(2024, 2), pinned: true),
      message('m3', createdAt: DateTime(2024, 3)),
      message(
        'm4',
        createdAt: DateTime(2024, 4),
        pinned: true,
        pinExpires: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      message('m5', createdAt: DateTime(2024, 5), pinned: true, type: MessageType.deleted),
    ];

    final result = MessageMerging.mergePinnedMessages(existing: existing, toMerge: incoming);

    expect(ids(result), ['m1', 'm2']);
  });

  test('mergePinnedMessages drops an existing pin that the incoming message unpins', () {
    final existing = [message('m1', pinned: true)];
    final incoming = [message('m1')];

    final result = MessageMerging.mergePinnedMessages(existing: existing, toMerge: incoming);

    expect(result, isEmpty);
  });

  test('mergePinnedMessages forwards a custom update strategy', () {
    final existing = [message('m1', pinned: true, text: 'old')];
    final incoming = [message('m1', pinned: true, text: 'new')];

    final result = MessageMerging.mergePinnedMessages(
      existing: existing,
      toMerge: incoming,
      update: (original, updated) => updated.copyWith(text: 'custom'),
    );

    expect(result.single.text, 'custom');
  });

  test('removePinnedMessages removes the given messages and filters out pins that are no longer valid', () {
    final existing = [
      message('m1', pinned: true),
      message(
        'm2',
        pinned: true,
        pinExpires: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      message('m3', pinned: true),
    ];

    final result = MessageMerging.removePinnedMessages(existing: existing, toRemove: [message('m1')]);

    expect(ids(result), ['m3']);
  });

  test('mergePinnedMessages merges a batch of pins by pin time', () {
    final existing = [
      message('t3', pinned: true, pinnedAt: DateTime(2024, 1, 3)),
      message('t1', pinned: true, pinnedAt: DateTime(2024, 1, 1)),
    ];
    final incoming = [
      message('t4', pinned: true, pinnedAt: DateTime(2024, 1, 4)),
      message('t2', pinned: true, pinnedAt: DateTime(2024, 1, 2)),
    ];

    final result = MessageMerging.mergePinnedMessages(existing: existing, toMerge: incoming);

    expect(ids(result), ['t4', 't3', 't2', 't1']);
  });

  test('sortPinnedMessages orders the pinned messages newest pin first', () {
    final pinnedMessages = [
      message('m1', pinned: true, pinnedAt: DateTime(2024, 1, 1)),
      message('m2', pinned: true, pinnedAt: DateTime(2024, 1, 2)),
    ];

    final result = MessageMerging.sortPinnedMessages(pinnedMessages);

    expect(ids(result!), ['m2', 'm1']);
  });

  test('sortPinnedMessages returns pinned messages already newest pin first as the same list', () {
    final pinnedMessages = [
      message('m1', pinned: true, pinnedAt: DateTime(2024, 1, 2)),
      message('m2', pinned: true, pinnedAt: DateTime(2024, 1, 1)),
    ];

    final result = MessageMerging.sortPinnedMessages(pinnedMessages);

    expect(result, same(pinnedMessages));
  });

  group('sortByPinnedAt', () {
    for (final (description, a, b, matcher) in [
      (
        'orders a later pin before an earlier one',
        message('later', pinned: true, pinnedAt: DateTime(2024, 1, 2)),
        message('earlier', pinned: true, pinnedAt: DateTime(2024, 1, 1)),
        isNegative,
      ),
      (
        'orders a pinned message before one without a pin date',
        message('pinned', pinned: true, pinnedAt: DateTime(2024, 1, 1)),
        message('unpinned'),
        isNegative,
      ),
      (
        'orders a message without a pin date after a pinned one',
        message('unpinned'),
        message('pinned', pinned: true, pinnedAt: DateTime(2024, 1, 1)),
        isPositive,
      ),
      (
        'treats two messages without a pin date as equal',
        message('unpinned-a'),
        message('unpinned-b'),
        isZero,
      ),
    ]) {
      test(description, () {
        expect(MessageMerging.sortByPinnedAt(a, b), matcher);
      });
    }
  });
}
