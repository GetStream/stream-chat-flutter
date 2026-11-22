import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient();

  test('hasLoadedAll becomes false once the connection is lost', () async {
    harness.client.handleEvent(Event(type: EventType.connectionChanged, online: false));
    await settle();

    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isFalse);
  });

  test('a recovered connection loads them all again when they were all loaded', () async {
    final last = fakeScheduledMessage('last', scheduledAt: DateTime.utc(2026, 11, 3));
    harness
      ..stubPage(null, () async => fakePage([fakeScheduledMessage('missed')], next: 'page-2'))
      ..stubPage('page-2', () async => fakePage([last]));

    harness.client
      ..handleEvent(Event(type: EventType.connectionChanged, online: false))
      ..handleEvent(Event(type: EventType.connectionRecovered, online: true));
    await settle();

    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isTrue);
    expect(idsOf(harness.client.state.scheduledMessages), ['missed', 'last']);
  });

  test('a reload that failed is tried again on the next recovery', () async {
    harness.stubPage(null, () async => throw offline);
    harness.client
      ..handleEvent(Event(type: EventType.connectionChanged, online: false))
      ..handleEvent(Event(type: EventType.connectionRecovered, online: true));
    await settle();
    harness.stubPage(null, () async => fakePage([fakeScheduledMessage('missed')]));

    harness.client
      ..handleEvent(Event(type: EventType.connectionChanged, online: false))
      ..handleEvent(Event(type: EventType.connectionRecovered, online: true));
    await settle();

    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isTrue);
    expect(idsOf(harness.client.state.scheduledMessages), ['missed']);
  });

  test('a recovery without a lost connection loads nothing', () async {
    harness.client.handleEvent(Event(type: EventType.connectionRecovered, online: true));
    await settle();

    verifyNever(
      () => harness.api.scheduledMessages.queryScheduledMessages(any()),
    );
  });

  test('a load that finishes after the user switched is not applied', () async {
    final page = Completer<QueryScheduledMessagesResponse>();
    when(
      () => harness.api.scheduledMessages.queryScheduledMessages(any()),
    ).thenAnswer((_) => page.future);
    final load = harness.client.loadScheduledMessages();

    await harness.client.disconnectUser();
    await harness.client.connectUser(testUser, testToken);
    page.complete(fakePage([fakeScheduledMessage('old-user')]));
    await load;

    expect(harness.client.state.scheduledMessages, isEmpty);
    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isFalse);
  });

  test('a load asked for after the user switched makes its own request', () async {
    final first = Completer<QueryScheduledMessagesResponse>();
    harness.stubPage(null, () => first.future);
    final stale = harness.client.loadScheduledMessages();

    await harness.client.disconnectUser();
    await harness.client.connectUser(testUser, testToken);
    await settle();
    harness.stubPage(null, () async => fakePage([fakeScheduledMessage('new-user')]));
    await harness.client.loadScheduledMessages();
    first.complete(fakePage([fakeScheduledMessage('old-user')], next: 'page-2'));
    await stale;

    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isTrue);
    expect(idsOf(harness.client.state.scheduledMessages), ['new-user']);
    verifyNever(
      () => harness.api.scheduledMessages.queryScheduledMessages(any(that: pageAfter('page-2'))),
    );
  });

  test('queryScheduledMessages does not apply a page that arrives after the user switched', () async {
    final page = Completer<QueryScheduledMessagesResponse>();
    when(
      () => harness.api.scheduledMessages.queryScheduledMessages(any()),
    ).thenAnswer((_) => page.future);
    final query = harness.client.queryScheduledMessages();

    await harness.client.disconnectUser();
    await harness.client.connectUser(testUser, testToken);
    page.complete(fakePage([fakeScheduledMessage('old-user')]));
    await query;

    expect(harness.client.state.scheduledMessages, isEmpty);
  });

  test('disconnectUser unloads them', () async {
    await harness.hold([fakeScheduledMessage('a')]);

    await harness.client.disconnectUser();

    expect(harness.client.state.scheduledMessages, isEmpty);
    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isFalse);
  });

  test('scheduledMessagesStream listened to before a user switch keeps following them', () async {
    final emitted = <List<String>>[];
    final subscription = harness.client.state.scheduledMessagesStream.listen((it) => emitted.add(idsOf(it)));
    addTearDown(subscription.cancel);

    await harness.client.disconnectUser();
    await harness.client.connectUser(testUser, testToken);
    await settle();
    await harness.loadAllScheduledMessages();
    await harness.receive(EventType.scheduledMessageCreated, fakeScheduledMessage('after'));

    expect(emitted.last, ['after']);
  });
}
