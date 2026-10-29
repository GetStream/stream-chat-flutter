import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  Map<String, dynamic> scheduledMessageJson({
    String status = 'failed',
    Map<String, dynamic>? message,
  }) => {
    'id': 'scheduled-id',
    'cid': 'messaging:general',
    'channel': {'cid': 'messaging:general', 'type': 'messaging', 'id': 'general', 'name': 'General'},
    'user': {'id': 'alice', 'name': 'Alice'},
    'message':
        message ??
        {
          'text': 'Good morning @Bob',
          'parent_id': 'parent-id',
          'mentioned_users': ['bob'],
          'custom': {'mood': 'happy'},
        },
    'scheduled_at': '2026-11-02T09:00:00.000Z',
    'status': status,
    'failure_reason': 'channel_frozen',
    'created_at': '2026-10-29T10:00:00.000Z',
    'updated_at': '2026-10-29T10:05:00.000Z',
  };

  group('ScheduledMessage.fromJson', () {
    test('reads the schedule', () {
      final scheduledMessage = ScheduledMessage.fromJson(scheduledMessageJson());

      expect(scheduledMessage.id, 'scheduled-id');
      expect(scheduledMessage.cid, 'messaging:general');
      expect(scheduledMessage.channel?.name, 'General');
      expect(scheduledMessage.user.id, 'alice');
      expect(scheduledMessage.scheduledAt, DateTime.utc(2026, 11, 2, 9));
      expect(scheduledMessage.status, ScheduledMessageStatus.failed);
      expect(scheduledMessage.failureReason, ScheduledMessageFailureReason.channelFrozen);
      expect(scheduledMessage.createdAt, DateTime.utc(2026, 10, 29, 10));
      expect(scheduledMessage.updatedAt, DateTime.utc(2026, 10, 29, 10, 5));
    });

    test('builds the message with the scheduled ID and user', () {
      final message = ScheduledMessage.fromJson(scheduledMessageJson()).message;

      expect(message.id, 'scheduled-id');
      expect(message.user?.id, 'alice');
      expect(message.text, 'Good morning @Bob');
      expect(message.parentId, 'parent-id');
    });

    test('turns mentioned user IDs into users', () {
      final message = ScheduledMessage.fromJson(scheduledMessageJson()).message;

      expect(message.mentionedUsers.map((user) => user.id), ['bob']);
    });

    test('reads nested custom data as extra data', () {
      final message = ScheduledMessage.fromJson(scheduledMessageJson()).message;

      expect(message.extraData, {'mood': 'happy'});
    });

    test('keeps a status it does not name', () {
      final scheduledMessage = ScheduledMessage.fromJson(scheduledMessageJson(status: 'paused'));

      expect(scheduledMessage.status, const ScheduledMessageStatus('paused'));
    });
  });

  test('ScheduledMessage survives a JSON round trip', () {
    final scheduledMessage = ScheduledMessage.fromJson(scheduledMessageJson());

    final restored = ScheduledMessage.fromJson(scheduledMessage.toJson());

    expect(restored, scheduledMessage);
  });
}
