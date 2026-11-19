// ignore_for_file: avoid_redundant_argument_values

import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient();

  test('a created event adds the scheduled message', () async {
    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('a'));

    expect(idsOf(harness.client.state.scheduledMessages), ['a']);
  });

  test('an updated event adds one that is not listed', () async {
    await harness.receive(EventType.scheduledMessageUpdated, fakeScheduledMessage('a'));

    expect(idsOf(harness.client.state.scheduledMessages), ['a']);
  });

  test('a failed event adds the failed one', () async {
    final failed = fakeScheduledMessage('a', status: ScheduledMessageStatus.failed);

    await harness.receive(EventType.scheduledMessageFailed, failed);

    expect(harness.client.state.scheduledMessages, [failed]);
  });

  test('a sent event removes it', () async {
    await harness.hold([fakeScheduledMessage('a')]);

    await harness.receive(EventType.scheduledMessageSent, fakeScheduledMessage('a'));

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('a deleted event removes it', () async {
    await harness.hold([fakeScheduledMessage('a')]);

    await harness.receive(EventType.scheduledMessageDeleted, fakeScheduledMessage('a'));

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('an older copy does not replace a newer one', () async {
    final newer = fakeScheduledMessage('a', text: 'Good evening', updatedAt: DateTime.utc(2026, 10, 30));
    await harness.hold([newer]);

    await harness.receive(EventType.scheduledMessageUpdated, fakeScheduledMessage('a'));

    expect(harness.client.state.scheduledMessages, [newer]);
  });

  test('an older copy that is scheduled earlier keeps them in order', () async {
    final newer = fakeScheduledMessage(
      'a',
      scheduledAt: DateTime.utc(2026, 11, 3),
      updatedAt: DateTime.utc(2026, 10, 30),
    );
    await harness.hold([newer, fakeScheduledMessage('b', scheduledAt: DateTime.utc(2026, 11, 2))]);

    await harness.receive(
      EventType.scheduledMessageUpdated,
      fakeScheduledMessage('a', scheduledAt: DateTime.utc(2026, 11, 1)),
    );

    expect(idsOf(harness.client.state.scheduledMessages), ['b', 'a']);
  });

  group('an event of the message a scheduled message quotes', () {
    final quoted = Message(id: 'quoted', text: 'See you there', createdAt: DateTime.utc(2026, 10, 28));
    final quoting = fakeScheduledMessage('a').copyWith(
      message: Message(id: 'a', text: 'Good morning', quotedMessageId: quoted.id, quotedMessage: quoted),
    );

    Future<void> receiveMessageEvent(String type, Message message) async {
      harness.client.handleEvent(Event(type: type, cid: testCid, message: message, isLocal: false));
      await settle();
    }

    test('updates the quote when the message is edited', () async {
      await harness.hold([quoting, fakeScheduledMessage('b')]);

      await receiveMessageEvent(EventType.messageUpdated, quoted.copyWith(text: 'See you at noon'));

      final [a, b] = harness.client.state.scheduledMessages;
      expect(a.message.quotedMessage?.text, 'See you at noon');
      expect(b.message.quotedMessage, isNull);
    });

    test('marks the quote deleted when the message is deleted', () async {
      await harness.hold([quoting]);

      final deleted = quoted.copyWith(type: MessageType.deleted, deletedAt: DateTime.utc(2026, 10, 30));
      await receiveMessageEvent(EventType.messageDeleted, deleted);

      final [a] = harness.client.state.scheduledMessages;
      expect(ScheduledMessageRules.quotesDeletedMessage(a.message, null), isTrue);
    });

    test('leaves the list as it was for a message no scheduled message quotes', () async {
      await harness.hold([quoting]);
      final before = harness.client.state.scheduledMessages;

      await receiveMessageEvent(EventType.messageUpdated, Message(id: 'other', text: 'Hi'));

      expect(identical(harness.client.state.scheduledMessages, before), isTrue);
    });
  });
}
