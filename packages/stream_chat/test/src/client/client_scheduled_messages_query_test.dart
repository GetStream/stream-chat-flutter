// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  useScheduledMessageClient();

  final offline = StreamChatNetworkError.raw(code: -1, message: 'No connection');

  test('passes the channel, statuses, limit and cursor on', () async {
    stubQuery(fakePage([]));
    const query = ScheduledMessagesQuery(
      cid: testCid,
      statuses: [ScheduledMessageStatus.failed],
      limit: 10,
      next: 'x',
    );

    await client.queryScheduledMessages(query: query);

    verify(() => api.scheduledMessages.queryScheduledMessages(query)).called(1);
  });

  test('loadScheduledMessages loads every page and replaces them all with the result', () async {
    await hold([fakeScheduledMessage('gone')]);
    final later = fakeScheduledMessage('later', scheduledAt: DateTime.utc(2026, 11, 3));
    final sooner = fakeScheduledMessage('sooner', scheduledAt: DateTime.utc(2026, 11, 1));
    stubPage(null, () async => fakePage([later], next: 'page-2'));
    stubPage('page-2', () async => fakePage([sooner]));

    final loaded = await client.loadScheduledMessages();

    expect(idsOf(loaded.scheduledMessages), ['sooner', 'later']);
    expect(loaded.hasLoadedAll, isTrue);
    expect(idsOf(client.state.scheduledMessages), ['sooner', 'later']);
  });

  test('loadScheduledMessages asked for again starts from the first page', () async {
    await hold([fakeScheduledMessage('gone')]);
    stubPage(null, () async => fakePage([fakeScheduledMessage('first')], next: 'page-2'));
    stubPage('page-2', () async => throw offline);
    await expectLater(client.loadScheduledMessages(), throwsA(offline));
    stubPage('page-2', () async => fakePage([]));

    await client.loadScheduledMessages();

    expect(idsOf(client.state.scheduledMessages), ['first']);
    expect(client.state.scheduledMessageListState.hasLoadedAll, isTrue);
  });

  test('loadScheduledMessages asked for while it runs shares it', () async {
    final page = Completer<QueryScheduledMessagesResponse>();
    stubPage(null, () => page.future);

    final first = client.loadScheduledMessages();
    final second = client.loadScheduledMessages();
    page.complete(fakePage([fakeScheduledMessage('a')]));

    expect(await second, same(await first));
    verify(
      () => api.scheduledMessages.queryScheduledMessages(any()),
    ).called(1);
  });

  test('they are no longer all loaded once the connection is lost', () async {
    client.handleEvent(Event(type: EventType.connectionChanged, online: false));
    await settle();

    expect(client.state.scheduledMessageListState.hasLoadedAll, isFalse);
  });

  test('loads them all again when the connection recovers', () async {
    stubPage(null, () async => fakePage([fakeScheduledMessage('missed')], next: 'page-2'));
    stubPage('page-2', () async => fakePage([fakeScheduledMessage('last', scheduledAt: DateTime.utc(2026, 11, 3))]));

    client
      ..handleEvent(Event(type: EventType.connectionChanged, online: false))
      ..handleEvent(Event(type: EventType.connectionRecovered, online: true));
    await settle();

    expect(client.state.scheduledMessageListState.hasLoadedAll, isTrue);
    expect(idsOf(client.state.scheduledMessages), ['missed', 'last']);
  });

  test('a reload that failed is tried again on the next recovery', () async {
    stubQuery(fakePage([fakeScheduledMessage('missed')]));
    stubPage(null, () async => throw offline);
    client
      ..handleEvent(Event(type: EventType.connectionChanged, online: false))
      ..handleEvent(Event(type: EventType.connectionRecovered, online: true));
    await settle();
    stubPage(null, () async => fakePage([fakeScheduledMessage('missed')]));

    client
      ..handleEvent(Event(type: EventType.connectionChanged, online: false))
      ..handleEvent(Event(type: EventType.connectionRecovered, online: true));
    await settle();

    expect(client.state.scheduledMessageListState.hasLoadedAll, isTrue);
    expect(idsOf(client.state.scheduledMessages), ['missed']);
  });

  test('a recovery without a lost connection loads nothing', () async {
    client.handleEvent(Event(type: EventType.connectionRecovered, online: true));
    await settle();

    verifyNever(
      () => api.scheduledMessages.queryScheduledMessages(any()),
    );
  });

  test('a load that finishes after the user switched is not applied', () async {
    final page = Completer<QueryScheduledMessagesResponse>();
    when(
      () => api.scheduledMessages.queryScheduledMessages(any()),
    ).thenAnswer((_) => page.future);
    final load = client.loadScheduledMessages();

    await client.disconnectUser();
    await client.connectUser(testUser, testToken);
    page.complete(fakePage([fakeScheduledMessage('old-user')]));
    await load;

    expect(client.state.scheduledMessages, isEmpty);
    expect(client.state.scheduledMessageListState.hasLoadedAll, isFalse);
  });

  test('a load asked for after the user switched makes its own request', () async {
    final first = Completer<QueryScheduledMessagesResponse>();
    stubPage(null, () => first.future);
    final stale = client.loadScheduledMessages();

    await client.disconnectUser();
    await client.connectUser(testUser, testToken);
    await settle();
    stubPage(null, () async => fakePage([fakeScheduledMessage('new-user')]));
    await client.loadScheduledMessages();
    first.complete(fakePage([fakeScheduledMessage('old-user')], next: 'page-2'));
    await stale;

    expect(client.state.scheduledMessageListState.hasLoadedAll, isTrue);
    expect(idsOf(client.state.scheduledMessages), ['new-user']);
    verifyNever(
      () => api.scheduledMessages.queryScheduledMessages(const ScheduledMessagesQuery(limit: 100, next: 'page-2')),
    );
  });

  test('a page that arrives after the user switched is not applied', () async {
    final page = Completer<QueryScheduledMessagesResponse>();
    when(
      () => api.scheduledMessages.queryScheduledMessages(any()),
    ).thenAnswer((_) => page.future);
    final query = client.queryScheduledMessages();

    await client.disconnectUser();
    await client.connectUser(testUser, testToken);
    page.complete(fakePage([fakeScheduledMessage('old-user')]));
    await query;

    expect(client.state.scheduledMessages, isEmpty);
  });

  test('lists the ones due at the same time by ID', () async {
    final due = DateTime.utc(2026, 11, 2, 9);

    await hold([
      fakeScheduledMessage('c', scheduledAt: due, updatedAt: DateTime.utc(2026, 10, 27)),
      fakeScheduledMessage('a', scheduledAt: due, updatedAt: DateTime.utc(2026, 10, 29)),
      fakeScheduledMessage('b', scheduledAt: due, updatedAt: DateTime.utc(2026, 10, 28)),
    ]);

    expect(idsOf(client.state.scheduledMessages), ['a', 'b', 'c']);
  });

  test('disconnecting unloads them', () async {
    await hold([fakeScheduledMessage('a')]);

    await client.disconnectUser();

    expect(client.state.scheduledMessages, isEmpty);
    expect(client.state.scheduledMessageListState.hasLoadedAll, isFalse);
  });

  test('a stream listened to before a user switch keeps following them', () async {
    final emitted = <List<String>>[];
    final subscription = client.state.scheduledMessagesStream.listen((it) => emitted.add(idsOf(it)));
    addTearDown(subscription.cancel);

    await client.disconnectUser();
    await client.connectUser(testUser, testToken);
    await settle();
    await loadAllScheduledMessages();
    await receive(EventType.scheduledMessageCreated, fakeScheduledMessage('after'));

    expect(emitted.last, ['after']);
  });
}
