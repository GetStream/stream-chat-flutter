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

    expect((counts.pending, counts.channelPending), (1, 1));
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

    expect((counts.failed, counts.pending, counts.channelPending), (1, 2, 2));
  });

  test('ScheduledMessageCounts.of counts a failed edit as failed and still pending', () {
    final counts = ScheduledMessageCounts.of(
      [
        _scheduled(
          'a',
          status: ScheduledMessageStatus.failed,
          failureReason: ScheduledMessageFailureReason.updateFailed,
        ),
      ],
      cid: _cid,
    );

    expect((counts.failed, counts.pending, counts.channelPending, counts.userPending), (1, 1, 1, 1));
  });

  test("ScheduledMessageCounts.of doesn't count sent messages", () {
    final counts = ScheduledMessageCounts.of(
      [_scheduled('a', status: ScheduledMessageStatus.sent)],
      cid: _cid,
    );

    expect((counts.failed, counts.pending, counts.channelPending, counts.userPending), (0, 0, 0, 0));
  });

  test('ScheduledMessageCounts.of counts the pending messages of every channel toward userPending', () {
    final counts = ScheduledMessageCounts.of(
      [
        _scheduled('a'),
        _scheduled('elsewhere', cid: 'messaging:other'),
        _scheduled('failed', cid: 'messaging:other', status: ScheduledMessageStatus.failed),
      ],
      cid: _cid,
    );

    expect(counts.userPending, 2);
  });

  test('ScheduledMessageCounts.of gives when the first pending message in scope is sent', () {
    final counts = ScheduledMessageCounts.of(
      [
        _scheduled('later', scheduledAt: DateTime(2026, 10, 24, 9)),
        _scheduled('next', scheduledAt: DateTime(2026, 10, 23, 9)),
        _scheduled('failed', scheduledAt: DateTime(2026, 10, 22, 9), status: ScheduledMessageStatus.failed),
        _scheduled('reply', scheduledAt: DateTime(2026, 10, 21, 9), parentId: 'parent'),
      ],
      cid: _cid,
    );

    expect(counts.nextScheduledAt, DateTime(2026, 10, 23, 9));
  });

  test('ScheduledMessageCounts.of gives no next time when nothing is pending', () {
    final counts = ScheduledMessageCounts.of(
      [_scheduled('a', status: ScheduledMessageStatus.failed)],
      cid: _cid,
    );

    expect(counts.nextScheduledAt, isNull);
  });
}

const _cid = 'messaging:general';

ScheduledMessage _scheduled(
  String id, {
  String cid = _cid,
  String? parentId,
  DateTime? scheduledAt,
  ScheduledMessageStatus status = ScheduledMessageStatus.scheduled,
  ScheduledMessageFailureReason? failureReason,
}) {
  return ScheduledMessage(
    id: id,
    cid: cid,
    user: User(id: 'current-user'),
    message: Message(id: id, text: 'Hello', parentId: parentId),
    scheduledAt: scheduledAt ?? DateTime(2026, 10, 23, 9),
    status: status,
    failureReason: failureReason,
  );
}
