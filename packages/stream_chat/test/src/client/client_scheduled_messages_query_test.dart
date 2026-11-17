import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import 'scheduled_messages_harness.dart';

void main() {
  final harness = useScheduledMessageClient();

  test('queryScheduledMessages passes the channel, statuses, limit and cursor on', () async {
    harness.stubQuery(fakePage([]));
    const query = ScheduledMessagesQuery(
      cid: testCid,
      statuses: [ScheduledMessageStatus.failed],
      limit: 10,
      next: 'x',
    );

    await harness.client.queryScheduledMessages(query: query);

    verify(() => harness.api.scheduledMessages.queryScheduledMessages(query)).called(1);
  });

  test('loadScheduledMessages loads every page and replaces them all with the result', () async {
    await harness.hold([fakeScheduledMessage('gone')]);
    final later = fakeScheduledMessage('later', scheduledAt: DateTime.utc(2026, 11, 3));
    final sooner = fakeScheduledMessage('sooner', scheduledAt: DateTime.utc(2026, 11, 1));
    harness
      ..stubPage(null, () async => fakePage([later], next: 'page-2'))
      ..stubPage('page-2', () async => fakePage([sooner]));

    final loaded = await harness.client.loadScheduledMessages();

    expect(idsOf(loaded.scheduledMessages), ['sooner', 'later']);
    expect(loaded.hasLoadedAll, isTrue);
    expect(idsOf(harness.client.state.scheduledMessages), ['sooner', 'later']);
  });

  test('loadScheduledMessages after one that failed starts again from the first page', () async {
    await harness.hold([fakeScheduledMessage('gone')]);
    harness
      ..stubPage(null, () async => fakePage([fakeScheduledMessage('first')], next: 'page-2'))
      ..stubPage('page-2', () async => throw offline);
    await expectLater(harness.client.loadScheduledMessages(), throwsA(offline));
    harness.stubPage('page-2', () async => fakePage([]));

    await harness.client.loadScheduledMessages();

    expect(idsOf(harness.client.state.scheduledMessages), ['first']);
    expect(harness.client.state.scheduledMessageListState.hasLoadedAll, isTrue);
  });

  test('loadScheduledMessages asked for while it runs shares it', () async {
    final page = Completer<QueryScheduledMessagesResponse>();
    harness.stubPage(null, () => page.future);

    final first = harness.client.loadScheduledMessages();
    final second = harness.client.loadScheduledMessages();
    page.complete(fakePage([fakeScheduledMessage('a')]));

    expect(await second, same(await first));
    verify(
      () => harness.api.scheduledMessages.queryScheduledMessages(any()),
    ).called(1);
  });
}
