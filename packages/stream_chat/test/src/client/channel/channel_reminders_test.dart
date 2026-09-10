import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

Future<ChannelState> _seedChannel(ChannelTester tester) => tester.watch(
  modifyResponse: (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: const [ChannelCapability.readEvents],
    ),
  ),
);

void main() {
  group('`.createReminder`', () {
    const messageId = 'test-message-id';
    final reminderRemindAt = DateTime.utc(2024, 6, 15, 14, 30);

    channelTest(
      'should call client.createReminder',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannel,
      body: (tester) async {
        tester.mockApi(
          (api) => api.reminders.createReminder(messageId),
          result: createDefaultCreateReminderResponse(
            reminder: createDefaultMessageReminder(
              messageId: messageId,
              channelCid: _channelCid,
              remindAt: reminderRemindAt,
            ),
          ),
        );

        final res = await tester.channel.createReminder(messageId);

        expect(res, isNotNull);
        expect(res.reminder.messageId, messageId);

        tester.verifyApi(
          (api) => api.reminders.createReminder(messageId),
        );
      },
    );

    channelTest(
      'with remindAt should pass remindAt to client',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannel,
      body: (tester) async {
        final remindAt = DateTime.utc(2024, 6, 15, 14, 30);
        tester.mockApi(
          (api) => api.reminders.createReminder(messageId, remindAt: remindAt),
          result: createDefaultCreateReminderResponse(
            reminder: createDefaultMessageReminder(
              messageId: messageId,
              channelCid: _channelCid,
              remindAt: reminderRemindAt,
            ),
          ),
        );

        final res = await tester.channel.createReminder(messageId, remindAt: remindAt);

        expect(res, isNotNull);
        expect(res.reminder.messageId, messageId);
        expect(res.reminder.remindAt, remindAt);

        tester.verifyApi(
          (api) => api.reminders.createReminder(messageId, remindAt: remindAt),
        );
      },
    );
  });

  group('`.updateReminder`', () {
    const messageId = 'test-message-id';
    final reminderRemindAt = DateTime.utc(2024, 8, 20, 16, 45);

    channelTest(
      'should call client.updateReminder',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannel,
      body: (tester) async {
        tester.mockApi(
          (api) => api.reminders.updateReminder(messageId),
          result: createDefaultUpdateReminderResponse(
            reminder: createDefaultMessageReminder(
              messageId: messageId,
              channelCid: _channelCid,
              remindAt: reminderRemindAt,
            ),
          ),
        );

        final res = await tester.channel.updateReminder(messageId);

        expect(res, isNotNull);
        expect(res.reminder.messageId, messageId);

        tester.verifyApi(
          (api) => api.reminders.updateReminder(messageId),
        );
      },
    );

    channelTest(
      'with remindAt should pass remindAt to client',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannel,
      body: (tester) async {
        final remindAt = DateTime.utc(2024, 8, 20, 16, 45);
        tester.mockApi(
          (api) => api.reminders.updateReminder(messageId, remindAt: remindAt),
          result: createDefaultUpdateReminderResponse(
            reminder: createDefaultMessageReminder(
              messageId: messageId,
              channelCid: _channelCid,
              remindAt: reminderRemindAt,
            ),
          ),
        );

        final res = await tester.channel.updateReminder(messageId, remindAt: remindAt);

        expect(res, isNotNull);
        expect(res.reminder.messageId, messageId);
        expect(res.reminder.remindAt, remindAt);

        tester.verifyApi(
          (api) => api.reminders.updateReminder(messageId, remindAt: remindAt),
        );
      },
    );
  });

  group('`.deleteReminder`', () {
    const messageId = 'test-message-id';

    channelTest(
      'should call client.deleteReminder',
      channelType: _channelType,
      channelId: _channelId,
      setUp: _seedChannel,
      body: (tester) async {
        tester.mockApi(
          (api) => api.reminders.deleteReminder(messageId),
          result: createDefaultEmptyResponse(),
        );

        final res = await tester.channel.deleteReminder(messageId);

        expect(res, isNotNull);

        tester.verifyApi(
          (api) => api.reminders.deleteReminder(messageId),
        );
      },
    );
  });
}
