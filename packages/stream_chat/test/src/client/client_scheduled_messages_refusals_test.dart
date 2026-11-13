import 'package:clock/clock.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient();

  final now = DateTime.utc(2026, 10, 30, 12);
  final scheduledAt = now.add(const Duration(days: 1));

  Future<ScheduleMessageResponse> schedule(Message message) {
    return withClock(
      Clock.fixed(now),
      () => harness.client.scheduleMessage(message, 'general', 'messaging', scheduledAt: scheduledAt),
    );
  }

  // Loads the channel [testCid], with [commands] and [messages].
  void loadChannel({List<Command> commands = const [], List<Message> messages = const []}) {
    final model = ChannelModel(
      cid: testCid,
      config: ChannelConfig(commands: commands),
    );
    Channel.fromState(harness.client, ChannelState(channel: model, messages: messages));
  }

  void stubSchedule() {
    when(
      () => harness.api.scheduledMessages.scheduleMessage(
        any(),
        any(),
        any(),
        any(),
        skipPush: any(named: 'skipPush'),
        skipEnrichUrl: any(named: 'skipEnrichUrl'),
      ),
    ).thenAnswer(
      (invocation) async => ScheduleMessageResponse()
        ..message = invocation.positionalArguments[2] as Message
        ..scheduledMessage = fakeScheduledMessage('b', scheduledAt: scheduledAt),
    );
  }

  void verifyNotScheduled() {
    verifyNever(
      () => harness.api.scheduledMessages.scheduleMessage(
        any(),
        any(),
        any(),
        any(),
        skipPush: any(named: 'skipPush'),
        skipEnrichUrl: any(named: 'skipEnrichUrl'),
      ),
    );
  }

  void verifyNotUpdated() {
    verifyNever(
      () => harness.api.scheduledMessages.updateScheduledMessage(
        any(),
        message: any(named: 'message'),
        scheduledAt: any(named: 'scheduledAt'),
      ),
    );
  }

  Matcher refusedFor(ScheduledMessageErrorReason reason) {
    return isA<ScheduledMessageRefusedError>().having((it) => it.reason, 'reason', reason);
  }

  final giphy = Command(name: 'giphy');
  final deleted = Message(id: 'quoted', text: 'Gone', type: MessageType.deleted);

  test('scheduleMessage refuses a command in a channel that has commands, without a request', () async {
    loadChannel(commands: [giphy]);

    await expectLater(schedule(Message(id: 'b', text: '/giphy cats')), throwsA(refusedFor(.slashCommand)));

    verifyNotScheduled();
  });

  test('scheduleMessage lists nothing for a command it refuses', () async {
    loadChannel(commands: [giphy]);

    await expectLater(schedule(Message(id: 'b', text: '/unknown')), throwsA(refusedFor(.slashCommand)));
    await settle();

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('scheduleMessage schedules a command in a channel without commands', () async {
    loadChannel();
    stubSchedule();

    await schedule(Message(id: 'b', text: '/giphy cats'));

    verify(
      () => harness.api.scheduledMessages.scheduleMessage('general', 'messaging', any(), scheduledAt),
    ).called(1);
  });

  test('scheduleMessage schedules text that only contains a command after a space', () async {
    loadChannel(commands: [giphy]);
    stubSchedule();

    await schedule(Message(id: 'b', text: ' /giphy cats'));

    verify(
      () => harness.api.scheduledMessages.scheduleMessage('general', 'messaging', any(), scheduledAt),
    ).called(1);
  });

  test('updateScheduledMessage refuses editing the text into a command, without a request', () async {
    loadChannel(commands: [giphy]);
    final a = fakeScheduledMessage('a');
    await harness.hold([a]);

    await expectLater(
      harness.client.updateScheduledMessage(a, a.message.copyWith(text: '/giphy cats')),
      throwsA(refusedFor(.slashCommand)),
    );

    verifyNotUpdated();
  });

  test('scheduleMessage refuses a quote of a deleted message, without a request', () async {
    final message = Message(id: 'b', text: 'About that', quotedMessageId: 'quoted', quotedMessage: deleted);

    await expectLater(schedule(message), throwsA(refusedFor(.quotedMessageDeleted)));

    verifyNotScheduled();
  });

  test('scheduleMessage refuses a quote the loaded channel knows was deleted', () async {
    loadChannel(messages: [deleted]);
    final message = Message(id: 'b', text: 'About that', quotedMessageId: 'quoted');

    await expectLater(schedule(message), throwsA(refusedFor(.quotedMessageDeleted)));

    verifyNotScheduled();
  });

  test('updateScheduledMessage refuses a quote of a deleted message, without a request', () async {
    final a = fakeScheduledMessage('a');
    await harness.hold([a]);
    final edited = a.message.copyWith(quotedMessageId: 'quoted', quotedMessage: deleted);

    await expectLater(harness.client.updateScheduledMessage(a, edited), throwsA(refusedFor(.quotedMessageDeleted)));

    verifyNotUpdated();
  });

  test('rescheduleMessage refuses moving one that quotes a deleted message, without a request', () async {
    loadChannel(messages: [deleted]);
    final a = fakeScheduledMessage('a');
    final quoting = a.copyWith(message: a.message.copyWith(quotedMessageId: 'quoted'));
    await harness.hold([quoting]);

    await expectLater(
      harness.client.rescheduleMessage(quoting, scheduledAt: DateTime.utc(2026, 11, 3)),
      throwsA(refusedFor(.quotedMessageDeleted)),
    );

    verifyNotUpdated();
  });

  test("rescheduleMessage doesn't refuse keeping one that quotes a deleted message at its time", () async {
    loadChannel(messages: [deleted]);
    final a = fakeScheduledMessage('a');
    final quoting = a.copyWith(message: a.message.copyWith(quotedMessageId: 'quoted'));
    await harness.hold([quoting]);
    when(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', scheduledAt: quoting.scheduledAt),
    ).thenAnswer((_) async => fakeUpdate(quoting));

    await harness.client.rescheduleMessage(quoting, scheduledAt: quoting.scheduledAt);

    verify(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', scheduledAt: quoting.scheduledAt),
    ).called(1);
  });

  test('sendScheduledMessageNow refuses one that quotes a deleted message, without a request', () async {
    loadChannel(messages: [deleted]);
    final a = fakeScheduledMessage('a');
    final quoting = a.copyWith(message: a.message.copyWith(quotedMessageId: 'quoted'));
    await harness.hold([quoting]);

    await expectLater(
      harness.client.sendScheduledMessageNow(quoting),
      throwsA(refusedFor(.quotedMessageDeleted)),
    );

    verifyNever(() => harness.api.scheduledMessages.sendScheduledMessageNow(any()));
  });
}
