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
      harness.client.updateScheduledMessage(a.id, a.message.copyWith(text: '/giphy cats')),
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

    await expectLater(harness.client.updateScheduledMessage(a.id, edited), throwsA(refusedFor(.quotedMessageDeleted)));

    verifyNotUpdated();
  });

  test('rescheduleMessage refuses moving one that quotes a deleted message, without a request', () async {
    loadChannel(messages: [deleted]);
    final a = fakeScheduledMessage('a');
    final quoting = a.copyWith(message: a.message.copyWith(quotedMessageId: 'quoted'));
    await harness.hold([quoting]);

    await expectLater(
      harness.client.rescheduleMessage(quoting.id, scheduledAt: DateTime.utc(2026, 11, 3)),
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

    await harness.client.rescheduleMessage(quoting.id, scheduledAt: quoting.scheduledAt);

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
      harness.client.sendScheduledMessageNow(quoting.id),
      throwsA(refusedFor(.quotedMessageDeleted)),
    );

    verifyNever(() => harness.api.scheduledMessages.sendScheduledMessageNow(any()));
  });

  test(
    'rescheduleMessage refuses moving one that is a command in a channel that has commands, without a request',
    () async {
      loadChannel(commands: [giphy]);
      final a = fakeScheduledMessage('a');
      final command = a.copyWith(message: a.message.copyWith(text: '/giphy cats'));
      await harness.hold([command]);

      await expectLater(
        harness.client.rescheduleMessage(command.id, scheduledAt: DateTime.utc(2026, 11, 3)),
        throwsA(refusedFor(.slashCommand)),
      );

      verifyNotUpdated();
    },
  );

  test("rescheduleMessage doesn't refuse keeping a command at its time", () async {
    loadChannel(commands: [giphy]);
    final a = fakeScheduledMessage('a');
    final command = a.copyWith(message: a.message.copyWith(text: '/giphy cats'));
    await harness.hold([command]);
    when(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', scheduledAt: command.scheduledAt),
    ).thenAnswer((_) async => fakeUpdate(command));

    await harness.client.rescheduleMessage(command.id, scheduledAt: command.scheduledAt);

    verify(
      () => harness.api.scheduledMessages.updateScheduledMessage('a', scheduledAt: command.scheduledAt),
    ).called(1);
  });

  group('a scheduled message that is not listed', () {
    final missing = fakeScheduledMessage('missing');
    final saved = fakeScheduledMessage('missing', text: 'Good evening', updatedAt: DateTime.utc(2026, 10, 30));

    // The events [run] emits, and the list just before its request answers.
    Future<(List<(String, ScheduledMessageStatus?)>, List<ScheduledMessage>)> requestWith(
      Future<void> Function() run,
      void Function(Future<void> Function() answered) stub,
    ) async {
      late List<ScheduledMessage> listedBeforeAnswer;
      stub(() async => listedBeforeAnswer = harness.client.state.scheduledMessages);
      final events = await harness.eventsDuring(run);
      return (events, listedBeforeAnswer);
    }

    test('updateScheduledMessage makes the request, then lists the server copy', () async {
      final edited = Message(id: 'missing', text: 'Good evening');
      final (events, listedBeforeAnswer) = await requestWith(
        () => harness.client.updateScheduledMessage(missing.id, edited),
        (answered) =>
            when(
              () => harness.api.scheduledMessages.updateScheduledMessage('missing', message: edited),
            ).thenAnswer((_) async {
              await answered();
              return fakeUpdate(saved);
            }),
      );

      expect(listedBeforeAnswer, isEmpty);
      expect(events, [(EventType.scheduledMessageUpdated, ScheduledMessageStatus.scheduled)]);
      expect(harness.client.state.scheduledMessages, [saved]);
    });

    test('rescheduleMessage makes the request, then lists the server copy', () async {
      final later = DateTime.utc(2026, 11, 3, 9);
      final moved = fakeScheduledMessage('missing', scheduledAt: later, updatedAt: DateTime.utc(2026, 10, 30));
      final (events, listedBeforeAnswer) = await requestWith(
        () => harness.client.rescheduleMessage(missing.id, scheduledAt: later),
        (answered) =>
            when(
              () => harness.api.scheduledMessages.updateScheduledMessage('missing', scheduledAt: later),
            ).thenAnswer((_) async {
              await answered();
              return fakeUpdate(moved);
            }),
      );

      expect(listedBeforeAnswer, isEmpty);
      expect(events, [(EventType.scheduledMessageUpdated, ScheduledMessageStatus.scheduled)]);
      expect(harness.client.state.scheduledMessages, [moved]);
    });

    test('sendScheduledMessageNow makes the request without changing the list', () async {
      when(
        () => harness.api.scheduledMessages.sendScheduledMessageNow('missing'),
      ).thenAnswer((_) async => fakeSendNow(missing));

      final events = await harness.eventsDuring(() => harness.client.sendScheduledMessageNow(missing.id));

      expect(events, isEmpty);
      expect(harness.client.state.scheduledMessages, isEmpty);
      verify(() => harness.api.scheduledMessages.sendScheduledMessageNow('missing')).called(1);
    });

    test('resendScheduledMessage has nothing to resend, so it throws without a request', () async {
      await expectLater(harness.client.resendScheduledMessage(missing.id), throwsStateError);

      verifyNotScheduled();
      verifyNotUpdated();
    });

    test('deleteScheduledMessage asks the server to delete it, without an event', () async {
      final deleted = fakeDelete(missing);
      when(() => harness.api.scheduledMessages.deleteScheduledMessage('missing')).thenAnswer((_) async => deleted);

      late DeleteScheduledMessageResponse response;
      final events = await harness.eventsDuring(() async {
        response = await harness.client.deleteScheduledMessage(missing.id);
      });

      expect(response, same(deleted));
      expect(events, isEmpty);
      verify(() => harness.api.scheduledMessages.deleteScheduledMessage('missing')).called(1);
    });

    test('deleteScheduledMessage rethrows when the server no longer has it either', () async {
      when(
        () => harness.api.scheduledMessages.deleteScheduledMessage('missing'),
      ).thenAnswer((_) async => throw missingError);

      await expectLater(harness.client.deleteScheduledMessage(missing.id), throwsA(missingError));
    });
  });
}
