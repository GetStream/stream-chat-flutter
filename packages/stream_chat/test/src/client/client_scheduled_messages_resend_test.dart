import 'dart:async';

import 'package:clock/clock.dart' show Clock, withClock;
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient();

  group('a change to one whose request failed', () {
    final message = Message(id: 'a', text: 'Good morning');
    final later = scheduledAt.add(const Duration(days: 1));

    final changes = <String, Future<Object?> Function(StreamChatClient client, String id)>{
      'updateScheduledMessage': (client, id) => client.updateScheduledMessage(
        id,
        Message(id: id, text: 'Good evening'),
      ),
      'rescheduleMessage': (client, id) => client.rescheduleMessage(id, scheduledAt: later),
      'sendScheduledMessageNow': (client, id) => client.sendScheduledMessageNow(id),
    };

    // Answers the update and the send-now that follow scheduling it again.
    void stubFollowUps(ScheduledMessage answer) {
      when(
        () => harness.api.scheduledMessages.updateScheduledMessage(
          'a',
          message: any(named: 'message'),
          scheduledAt: any(named: 'scheduledAt'),
        ),
      ).thenAnswer((_) async => fakeUpdate(answer));
      when(
        () => harness.api.scheduledMessages.sendScheduledMessageNow('a'),
      ).thenAnswer((_) async => fakeSendNow(answer));
    }

    void stubScheduleAgain(Future<ScheduleMessageResponse> Function() answer) {
      when(
        () => harness.api.scheduledMessages.scheduleMessage(
          'general',
          'messaging',
          any(),
          any(),
          skipPush: any(named: 'skipPush'),
          skipEnrichUrl: any(named: 'skipEnrichUrl'),
        ),
      ).thenAnswer((_) => answer());
    }

    // The copy the server stored on an earlier attempt, with the old text and
    // time, which scheduling it again answers with.
    final stored = fakeScheduledMessage('a', scheduledAt: scheduledAt);

    test('updateScheduledMessage saves the edit over the copy an earlier attempt stored', () async {
      final failed = await harness.scheduleUnreachable(message);
      final edited = Message(id: 'a', text: 'Good evening');
      final saved = fakeScheduledMessage('a', text: 'Good evening', scheduledAt: later, updatedAt: now);
      stubScheduleAgain(() async => scheduled(message, stored));
      stubFollowUps(saved);

      await withClock(
        Clock.fixed(now),
        () => harness.client.updateScheduledMessage(failed.id, edited, scheduledAt: later),
      );
      await settle();

      verify(
        () => harness.api.scheduledMessages.updateScheduledMessage('a', message: edited, scheduledAt: later),
      ).called(1);
      expect(harness.client.state.scheduledMessages, [saved]);
    });

    test('rescheduleMessage saves the move over the copy an earlier attempt stored', () async {
      final failed = await harness.scheduleUnreachable(message);
      final moved = fakeScheduledMessage('a', scheduledAt: later, updatedAt: now);
      stubScheduleAgain(() async => scheduled(message, stored));
      stubFollowUps(moved);

      await withClock(Clock.fixed(now), () => harness.client.rescheduleMessage(failed.id, scheduledAt: later));
      await settle();

      verify(() => harness.api.scheduledMessages.updateScheduledMessage('a', scheduledAt: later)).called(1);
      expect(harness.client.state.scheduledMessages, [moved]);
    });

    test('updateScheduledMessage lists the edit as failed when saving it after scheduling it again fails', () async {
      final failed = await harness.scheduleUnreachable(message);
      final edited = Message(id: 'a', text: 'Good evening');
      stubScheduleAgain(() async => scheduled(message, stored));
      when(
        () => harness.api.scheduledMessages.updateScheduledMessage(
          'a',
          message: any(named: 'message'),
          scheduledAt: any(named: 'scheduledAt'),
        ),
      ).thenAnswer((_) async => throw offline);

      await expectLater(
        withClock(Clock.fixed(now), () => harness.client.updateScheduledMessage(failed.id, edited)),
        throwsA(offline),
      );
      await settle();

      final [listed] = harness.client.state.scheduledMessages;
      expect(listed.failure, const ScheduledMessageUpdatingFailed(isRetriable: true));
      expect(listed.message.text, 'Good evening');
    });

    test('sendScheduledMessageNow schedules it again as it was, then sends it right away', () async {
      final failed = await harness.scheduleUnreachable(message);
      clearInteractions(harness.api.scheduledMessages);
      final sending = fakeScheduledMessage('a', scheduledAt: scheduledAt, status: ScheduledMessageStatus.sending);
      stubScheduleAgain(() async => scheduled(message, stored));
      stubFollowUps(sending);

      await withClock(Clock.fixed(now), () => harness.client.sendScheduledMessageNow(failed.id));
      await settle();

      final [scheduledAt_] = verify(
        () => harness.api.scheduledMessages.scheduleMessage(
          'general',
          'messaging',
          any(),
          captureAny(),
          skipPush: any(named: 'skipPush'),
          skipEnrichUrl: any(named: 'skipEnrichUrl'),
        ),
      ).captured;
      expect(scheduledAt_, failed.scheduledAt);
      verify(() => harness.api.scheduledMessages.sendScheduledMessageNow('a')).called(1);
      expect(harness.client.state.scheduledMessages.single.status, ScheduledMessageStatus.sending);
    });

    test(
      'sendScheduledMessageNow schedules one due within the minimum lead time again at its time, then sends it',
      () async {
        final soon = now.add(const Duration(seconds: 30));
        stubScheduleAgain(() async => throw offline);
        await expectLater(
          withClock(
            Clock.fixed(now),
            () => harness.client.scheduleMessage(message, 'general', 'messaging', scheduledAt: soon),
          ),
          throwsA(offline),
        );
        await settle();
        final [failed] = harness.client.state.scheduledMessages;
        clearInteractions(harness.api.scheduledMessages);
        stubScheduleAgain(() async => scheduled(message, fakeScheduledMessage('a', scheduledAt: soon)));
        stubFollowUps(fakeScheduledMessage('a', scheduledAt: soon, status: ScheduledMessageStatus.sending));

        await withClock(Clock.fixed(now), () => harness.client.sendScheduledMessageNow(failed.id));

        final [scheduledAgainAt] = verify(
          () => harness.api.scheduledMessages.scheduleMessage(
            'general',
            'messaging',
            any(),
            captureAny(),
            skipPush: any(named: 'skipPush'),
            skipEnrichUrl: any(named: 'skipEnrichUrl'),
          ),
        ).captured;
        expect(scheduledAgainAt, soon);
        verify(() => harness.api.scheduledMessages.sendScheduledMessageNow('a')).called(1);
      },
    );

    test('sendScheduledMessageNow lists it as scheduled when sending it after scheduling it again fails', () async {
      final failed = await harness.scheduleUnreachable(message);
      stubScheduleAgain(() async => scheduled(message, stored));
      when(() => harness.api.scheduledMessages.sendScheduledMessageNow('a')).thenAnswer((_) async => throw offline);

      await expectLater(
        withClock(Clock.fixed(now), () => harness.client.sendScheduledMessageNow(failed.id)),
        throwsA(offline),
      );
      await settle();

      final [listed] = harness.client.state.scheduledMessages;
      expect(listed.status, ScheduledMessageStatus.scheduled);
      expect(listed.failure, isNull);
    });

    for (final (name, moveTo) in [
      (
        'updateScheduledMessage',
        (StreamChatClient client, String id, DateTime at) {
          return client.updateScheduledMessage(
            id,
            Message(id: id, text: 'Good evening'),
            scheduledAt: at,
          );
        },
      ),
      (
        'rescheduleMessage',
        (StreamChatClient client, String id, DateTime at) {
          return client.rescheduleMessage(id, scheduledAt: at);
        },
      ),
    ]) {
      test('$name refuses a time that has passed without scheduling it again', () async {
        final failed = await harness.scheduleUnreachable(message);
        clearInteractions(harness.api.scheduledMessages);
        final passed = now.subtract(const Duration(minutes: 1));

        await expectLater(
          withClock(Clock.fixed(now), () => moveTo(harness.client, failed.id, passed)),
          throwsA(
            isA<ScheduledMessageRefusedError>().having(
              (it) => it.reason,
              'reason',
              ScheduledMessageErrorReason.scheduledAtTooSoon,
            ),
          ),
        );

        verifyNoMoreInteractions(harness.api.scheduledMessages);
        expect(harness.client.state.scheduledMessages, [failed]);
      });
    }

    test('rescheduleMessage that the server refuses leaves the failed copy as it was', () async {
      final failed = await harness.scheduleUnreachable(message);
      stubScheduleAgain(() async => throw rejected);

      await expectLater(
        withClock(Clock.fixed(now), () => harness.client.rescheduleMessage(failed.id, scheduledAt: later)),
        throwsA(rejected),
      );
      await settle();

      final [listed] = harness.client.state.scheduledMessages;
      expect(listed.failure, const ScheduledMessageSchedulingFailed());
      expect(listed.message.text, failed.message.text);
      expect(listed.scheduledAt, failed.scheduledAt);
    });

    test('resendScheduledMessage that the server refuses leaves the failed copy as it was', () async {
      final failed = await harness.scheduleUnreachable(message);
      stubScheduleAgain(() async => throw rejected);

      await expectLater(
        withClock(Clock.fixed(now), () => harness.client.resendScheduledMessage(failed.id)),
        throwsA(rejected),
      );
      await settle();

      final [listed] = harness.client.state.scheduledMessages;
      expect(listed.failure, const ScheduledMessageSchedulingFailed());
      expect(listed.message.text, failed.message.text);
    });

    test('sendScheduledMessageNow stops listing one deleted meanwhile on another device', () async {
      final failed = await harness.scheduleUnreachable(message);
      final canceled = refusedWith(scheduledMessageCanceledCode);
      stubScheduleAgain(() async => throw canceled);

      final events = await harness.eventsDuring(
        () => expectRequest(
          withClock(Clock.fixed(now), () => harness.client.sendScheduledMessageNow(failed.id)),
          canceled,
        ),
      );

      expect(events.last, (EventType.scheduledMessageDeleted, ScheduledMessageStatus.canceled));
      expect(harness.client.state.scheduledMessages, isEmpty);
    });

    for (final MapEntry(key: name, value: change) in changes.entries) {
      test('$name schedules it again with its ID', () async {
        final failed = await harness.scheduleUnreachable(message);
        clearInteractions(harness.api.scheduledMessages);
        stubScheduleAgain(
          () async => scheduled(message, fakeScheduledMessage('a', scheduledAt: later)),
        );
        stubFollowUps(fakeScheduledMessage('a', scheduledAt: later));

        await withClock(Clock.fixed(now), () => change(harness.client, failed.id));

        final [scheduledAgain] = verify(
          () => harness.api.scheduledMessages.scheduleMessage(
            'general',
            'messaging',
            captureAny(),
            any(),
            skipPush: any(named: 'skipPush'),
            skipEnrichUrl: any(named: 'skipEnrichUrl'),
          ),
        ).captured;
        expect((scheduledAgain as Message).id, 'a');
      });

      test('$name refuses while it is still being scheduled for the first time', () async {
        final answer = Completer<ScheduleMessageResponse>();
        harness.stubSchedule(message, () => answer.future);
        final scheduling = harness.schedule(message);
        await settle();
        clearInteractions(harness.api.scheduledMessages);

        await expectLater(
          withClock(Clock.fixed(now), () => change(harness.client, 'a')),
          throwsStateError,
        );

        verifyNoMoreInteractions(harness.api.scheduledMessages);
        answer.complete(scheduled(message, fakeScheduledMessage('a', scheduledAt: scheduledAt)));
        await scheduling;
      });

      test('$name then deleteScheduledMessage deletes it on the server once it is scheduled', () async {
        final failed = await harness.scheduleUnreachable(message);
        final answer = Completer<ScheduleMessageResponse>();
        stubScheduleAgain(() => answer.future);
        when(
          () => harness.api.scheduledMessages.deleteScheduledMessage('a'),
        ).thenAnswer((_) async => fakeDelete(fakeScheduledMessage('a', status: ScheduledMessageStatus.canceled)));

        final changed = withClock(Clock.fixed(now), () => change(harness.client, failed.id));
        await settle();
        await harness.client.deleteScheduledMessage(failed.id);
        verifyNever(() => harness.api.scheduledMessages.deleteScheduledMessage(any()));

        answer.complete(scheduled(message, fakeScheduledMessage('a', scheduledAt: later)));
        await changed;
        await settle();

        verify(() => harness.api.scheduledMessages.deleteScheduledMessage('a')).called(1);
        expect(harness.client.state.scheduledMessages, isEmpty);
      });
    }
  });

  test('resendScheduledMessage resolves to null when its time has passed and it is sent right away', () async {
    final message = Message(id: 'a', text: 'Good morning');
    final failed = await harness.scheduleUnreachable(message);
    harness.stubSchedule(message, () async => sentRightAway(message));
    final passed = scheduledAt.add(const Duration(minutes: 1));

    final resent = await withClock(Clock.fixed(passed), () => harness.client.resendScheduledMessage(failed.id));
    await settle();

    expect(resent, isNull);
    expect(harness.client.state.scheduledMessages, isEmpty);
  });
}
