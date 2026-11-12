// Imports the internal counts: both the banner and the schedule sheet depend
// on them, so their scoping is checked once here.
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_input/schedule_message/scheduled_message_counts.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test("ScheduledMessageCounts.of counts a channel's messages without its thread replies", () {
    final counts = ScheduledMessageCounts.of(
      [_scheduled('a'), _scheduled('b'), _scheduled('reply', parentId: 'parent')],
      cid: _cid,
    );

    expect(counts.pending, 2);
  });

  test("ScheduledMessageCounts.of counts a thread's replies only", () {
    final counts = ScheduledMessageCounts.of(
      [_scheduled('a'), _scheduled('reply', parentId: 'parent'), _scheduled('other', parentId: 'other')],
      cid: _cid,
      parentId: 'parent',
    );

    expect(counts.pending, 1);
  });

  test('ScheduledMessageCounts.of leaves out messages in other channels', () {
    final counts = ScheduledMessageCounts.of(
      [_scheduled('a'), _scheduled('elsewhere', cid: 'messaging:other')],
      cid: _cid,
    );

    expect(counts, const ScheduledMessageCounts(failed: 0, pending: 1, channelPending: 1));
  });

  test("ScheduledMessageCounts.of counts the channel's pending thread replies toward channelPending", () {
    final counts = ScheduledMessageCounts.of(
      [_scheduled('a'), _scheduled('reply', parentId: 'parent')],
      cid: _cid,
    );

    expect(counts.channelPending, 2);
  });

  test('ScheduledMessageCounts.of counts failed messages apart from pending ones', () {
    final counts = ScheduledMessageCounts.of(
      [
        _scheduled('a'),
        _scheduled('b', status: ScheduledMessageStatus.sending),
        _scheduled('c', status: ScheduledMessageStatus.failed),
      ],
      cid: _cid,
    );

    expect(counts, const ScheduledMessageCounts(failed: 1, pending: 2, channelPending: 2));
  });

  test("ScheduledMessageCounts.of doesn't count sent messages", () {
    final counts = ScheduledMessageCounts.of(
      [_scheduled('a', status: ScheduledMessageStatus.sent)],
      cid: _cid,
    );

    expect(counts, const ScheduledMessageCounts(failed: 0, pending: 0, channelPending: 0));
  });
}

const _cid = 'messaging:general';

ScheduledMessage _scheduled(
  String id, {
  String cid = _cid,
  String? parentId,
  ScheduledMessageStatus status = ScheduledMessageStatus.scheduled,
}) {
  return ScheduledMessage(
    id: id,
    cid: cid,
    user: User(id: 'current-user'),
    message: Message(id: id, text: 'Hello', parentId: parentId),
    scheduledAt: DateTime(2026, 10, 23, 9),
    status: status,
  );
}
