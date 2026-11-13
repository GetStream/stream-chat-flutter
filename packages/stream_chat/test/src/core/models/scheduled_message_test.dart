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

  test('ScheduledMessage.fromJson reads the schedule', () {
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

  test('ScheduledMessage.fromJson builds the message with the scheduled ID and user', () {
    final message = ScheduledMessage.fromJson(scheduledMessageJson()).message;

    expect(message.id, 'scheduled-id');
    expect(message.user?.id, 'alice');
  });

  test('ScheduledMessage.fromJson reads the message', () {
    final message = ScheduledMessage.fromJson(scheduledMessageJson()).message;

    expect(message.text, 'Good morning @bob');
    expect(message.parentId, 'parent-id');
    expect(message.showInChannel, isTrue);
  });

  test('ScheduledMessage.fromJson dates the message by when it is sent and last changed', () {
    final message = ScheduledMessage.fromJson(scheduledMessageJson()).message;

    expect(message.createdAt, DateTime.utc(2026, 11, 2, 9));
    expect(message.updatedAt, DateTime.utc(2026, 10, 29, 10, 5));
  });

  test('ScheduledMessage.fromJson turns mentioned user IDs into users', () {
    final message = ScheduledMessage.fromJson(scheduledMessageJson()).message;

    expect(message.mentionedUsers.map((user) => user.id), ['bob']);
  });

  test('ScheduledMessage.fromJson reads custom data as extra data', () {
    final message = ScheduledMessage.fromJson(scheduledMessageJson()).message;

    expect(message.extraData, {'mood': 'happy'});
  });

  test('ScheduledMessage.fromJson keeps a custom field named custom as it is', () {
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

  test('ScheduledMessage.fromJson keeps a status it does not name', () {
    final scheduledMessage = ScheduledMessage.fromJson(scheduledMessageJson(status: 'paused'));

    expect(scheduledMessage.status, const ScheduledMessageStatus('paused'));
  });

  test('ScheduledMessage tells apart a renamed channel', () {
    ScheduledMessage inChannel(String name) => ScheduledMessage(
      cid: 'messaging:general',
      channel: ChannelModel(cid: 'messaging:general', extraData: {'name': name}),
      user: User(id: 'alice'),
      message: Message(id: 'scheduled-id', text: 'Good morning'),
      scheduledAt: DateTime.utc(2026, 11, 2, 9),
      status: ScheduledMessageStatus.scheduled,
    );

    final scheduledMessage = inChannel('General');
    final renamed = inChannel('Renamed');

    expect(renamed, isNot(scheduledMessage));
  });

  test('ScheduledMessage reads the same JSON the same way twice', () {
    final first = ScheduledMessage.fromJson(scheduledMessageJson());
    final second = ScheduledMessage.fromJson(scheduledMessageJson());

    expect(second, first);
    expect(second.message, first.message);
  });

  test('ScheduledMessage takes its dates from the server', () {
    final scheduledMessage = ScheduledMessage.fromJson(scheduledMessageJson());

    expect(scheduledMessage.remoteCreatedAt, DateTime.utc(2026, 10, 29, 10));
    expect(scheduledMessage.remoteUpdatedAt, DateTime.utc(2026, 10, 29, 10, 5));
    expect(scheduledMessage.localCreatedAt, isNull);
    expect(scheduledMessage.localUpdatedAt, isNull);
  });

  test('ScheduledMessage takes the ID of its message when given none', () {
    final scheduledMessage = ScheduledMessage(
      cid: 'messaging:general',
      user: User(id: 'alice'),
      message: Message(id: 'message-id', text: 'Good morning'),
      scheduledAt: DateTime.utc(2026, 11, 2, 9),
      status: ScheduledMessageStatus.preparingToSchedule,
    );

    expect(scheduledMessage.id, 'message-id');
  });

  test('ScheduledMessage not on the server yet is dated on this device', () {
    final scheduledMessage = ScheduledMessage(
      cid: 'messaging:general',
      user: User(id: 'alice'),
      message: Message(id: 'message-id', text: 'Good morning'),
      scheduledAt: DateTime.utc(2026, 11, 2, 9),
      status: ScheduledMessageStatus.preparingToSchedule,
      localCreatedAt: DateTime.utc(2026, 10, 29, 10),
      localUpdatedAt: DateTime.utc(2026, 10, 29, 10, 5),
    );

    expect(scheduledMessage.createdAt, DateTime.utc(2026, 10, 29, 10));
    expect(scheduledMessage.updatedAt, DateTime.utc(2026, 10, 29, 10, 5));
  });

  test('ScheduledMessageStatus.isPending is true until the message is sent or fails', () {
    expect(ScheduledMessageStatus.preparingToSchedule.isPending, isTrue);
    expect(ScheduledMessageStatus.scheduled.isPending, isTrue);
    expect(ScheduledMessageStatus.sending.isPending, isTrue);
    expect(ScheduledMessageStatus.failed.isPending, isFalse);
    expect(ScheduledMessageStatus.canceled.isPending, isFalse);
    expect(ScheduledMessageStatus.sent.isPending, isFalse);
  });

  test('ScheduledMessage.toMessage carries the content to edit', () {
    final scheduledMessage = ScheduledMessage(
      id: 'scheduled-id',
      cid: 'messaging:general',
      user: User(id: 'alice'),
      message: Message(
        id: 'message-id',
        text: 'Good morning @bob',
        attachments: [Attachment(type: 'image', imageUrl: 'https://example.com/a.png')],
        mentionedUsers: [User(id: 'bob')],
        quotedMessageId: 'quoted-id',
        parentId: 'parent-id',
        showInChannel: true,
        extraData: const {'mood': 'happy'},
        state: MessageState.sent,
      ),
      scheduledAt: DateTime.utc(2026, 11, 2, 9),
      status: ScheduledMessageStatus.scheduled,
    );

    final message = scheduledMessage.toMessage();

    expect(message.id, 'scheduled-id');
    expect(message.text, 'Good morning @bob');
    expect(message.attachments, scheduledMessage.message.attachments);
    expect(message.mentionedUsers, [User(id: 'bob')]);
    expect(message.quotedMessageId, 'quoted-id');
    expect(message.parentId, 'parent-id');
    expect(message.showInChannel, isTrue);
    expect(message.extraData, {'mood': 'happy'});
    expect(message.state, const MessageState.initial());
  });

  test('ScheduledMessage.copyWith clears the failure reason only when told to', () {
    final failed = ScheduledMessage(
      cid: 'messaging:general',
      user: User(id: 'alice'),
      message: Message(id: 'message-id', text: 'Good morning'),
      scheduledAt: DateTime.utc(2026, 11, 2, 9),
      status: ScheduledMessageStatus.failed,
      failureReason: ScheduledMessageFailureReason.updateFailed,
    );

    expect(failed.copyWith().failureReason, ScheduledMessageFailureReason.updateFailed);
    expect(failed.copyWith(failureReason: null).failureReason, isNull);
  });

  test('ScheduledMessage.toMessage keeps whether it is silent, its poll, its mentions and who can see it', () {
    final poll = Poll(
      id: 'poll-id',
      name: 'Lunch?',
      options: const [PollOption(text: 'Pizza')],
    );
    final scheduledMessage = ScheduledMessage(
      id: 'scheduled-id',
      cid: 'messaging:general',
      user: User(id: 'alice'),
      message: Message(
        id: 'message-id',
        text: 'Good morning',
        silent: true,
        poll: poll,
        restrictedVisibility: const ['bob'],
        mentionedChannel: true,
        mentionedHere: true,
        mentionedRoles: const ['admin'],
        mentionedGroupIds: const ['design'],
      ),
      scheduledAt: DateTime.utc(2026, 11, 2, 9),
      status: ScheduledMessageStatus.scheduled,
    );

    final message = scheduledMessage.toMessage();

    expect(message.silent, isTrue);
    expect(message.poll, poll);
    expect(message.pollId, 'poll-id');
    expect(message.restrictedVisibility, ['bob']);
    expect(message.mentionedChannel, isTrue);
    expect(message.mentionedHere, isTrue);
    expect(message.mentionedRoles, ['admin']);
    expect(message.mentionedGroupIds, ['design']);
  });
}
