import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  test('ScheduledMessagesQuery.copyWith replaces only the given fields', () {
    const query = ScheduledMessagesQuery(cid: 'messaging:general', limit: 25);

    final next = query.copyWith(next: 'cursor');

    expect(next, const ScheduledMessagesQuery(cid: 'messaging:general', limit: 25, next: 'cursor'));
  });

  test('queries with the same fields are equal', () {
    const a = ScheduledMessagesQuery(statuses: [ScheduledMessageStatus.failed], limit: 10);
    const b = ScheduledMessagesQuery(statuses: [ScheduledMessageStatus.failed], limit: 10);

    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });
}
