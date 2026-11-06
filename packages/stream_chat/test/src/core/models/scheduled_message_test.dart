import 'package:collection/collection.dart';
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
          'text': 'Good morning @bob',
          'parent_id': 'parent-id',
          'show_in_channel': true,
          'mentioned_users': ['bob'],
          'mood': 'happy',
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
      expect(message.text, 'Good morning @bob');
      expect(message.parentId, 'parent-id');
      expect(message.showInChannel, isTrue);
    });

    test('dates the message by when it is sent and last changed', () {
      final message = ScheduledMessage.fromJson(scheduledMessageJson()).message;

      expect(message.createdAt, DateTime.utc(2026, 11, 2, 9));
      expect(message.updatedAt, DateTime.utc(2026, 10, 29, 10, 5));
    });

    test('turns mentioned user IDs into users', () {
      final message = ScheduledMessage.fromJson(scheduledMessageJson()).message;

      expect(message.mentionedUsers.map((user) => user.id), ['bob']);
    });

    test('reads custom data as extra data', () {
      final message = ScheduledMessage.fromJson(scheduledMessageJson()).message;

      expect(message.extraData, {'mood': 'happy'});
    });

    test('keeps a custom field named custom as it is', () {
      final json = scheduledMessageJson(
        message: {
          'text': 'Good morning',
          'custom': {'mood': 'happy'},
        },
      );

      final message = ScheduledMessage.fromJson(json).message;

      expect(message.extraData, {
        'custom': {'mood': 'happy'},
      });
    });

    test('keeps a status it does not name', () {
      final scheduledMessage = ScheduledMessage.fromJson(scheduledMessageJson(status: 'paused'));

      expect(scheduledMessage.status, const ScheduledMessageStatus('paused'));
    });
  });

  test('ScheduledMessage tells apart a renamed channel', () {
    final scheduledMessage = ScheduledMessage.fromJson(scheduledMessageJson());
    final renamed = ScheduledMessage.fromJson({
      ...scheduledMessageJson(),
      'channel': const {'cid': 'messaging:general', 'type': 'messaging', 'id': 'general', 'name': 'Renamed'},
    });

    expect(renamed, isNot(scheduledMessage));
  });

  test('ScheduledMessage reads the same JSON the same way twice', () {
    final first = ScheduledMessage.fromJson(scheduledMessageJson());
    final second = ScheduledMessage.fromJson(scheduledMessageJson());

    expect(second, first);
    expect(second.message, first.message);
  });

  test('ScheduledMessage takes the ID of its message by default', () {
    final scheduledMessage = ScheduledMessage(
      cid: 'messaging:general',
      user: User(id: 'alice'),
      message: Message(id: 'message-id', text: 'Good morning'),
      scheduledAt: DateTime.utc(2026, 11, 2, 9),
      status: ScheduledMessageStatus.scheduled,
      createdAt: DateTime.utc(2026, 10, 29, 10),
      updatedAt: DateTime.utc(2026, 10, 29, 10, 5),
    );

    expect(scheduledMessage.id, 'message-id');
  });

  group('ScheduledMessage.compareByListOrder', () {
    ScheduledMessage scheduled(
      String id, {
      required DateTime scheduledAt,
      DateTime? createdAt,
      ScheduledMessageStatus status = ScheduledMessageStatus.scheduled,
    }) => ScheduledMessage(
      id: id,
      cid: 'messaging:general',
      user: User(id: 'alice'),
      message: Message(id: id, text: 'Good morning'),
      scheduledAt: scheduledAt,
      status: status,
      createdAt: createdAt ?? DateTime.utc(2026, 10, 29),
      updatedAt: DateTime.utc(2026, 10, 29),
    );

    List<String> ordered(List<ScheduledMessage> messages) {
      return [for (final it in messages.sorted(ScheduledMessage.compareByListOrder)) it.id];
    }

    test('puts a failed message after a later scheduled one', () {
      final failed = scheduled(
        'failed',
        scheduledAt: DateTime.utc(2026, 11, 1),
        status: ScheduledMessageStatus.failed,
      );
      final later = scheduled('later', scheduledAt: DateTime.utc(2026, 11, 3));

      expect(ordered([failed, later]), ['later', 'failed']);
    });

    test('orders ones due at the same time by ID', () {
      final due = DateTime.utc(2026, 11, 2, 9);
      final b = scheduled('b', scheduledAt: due, createdAt: DateTime.utc(2026, 10, 28));
      final a = scheduled('a', scheduledAt: due, createdAt: DateTime.utc(2026, 10, 29));

      expect(ordered([b, a]), ['a', 'b']);
    });
  });
}
