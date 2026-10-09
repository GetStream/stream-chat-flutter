import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/stream_thread_list_controller.dart';

import 'mocks.dart';

void main() {
  test('StreamThreadListController.doInitialLoad queries the first page with its options and loads it', () async {
    final client = _client();
    final filter = ThreadFilter.equal(ThreadFilterField.channelCid, 'messaging:general');
    final sort = [ThreadSort.desc(ThreadSortField.lastMessageAt)];
    const options = ThreadOptions(watch: false, replyLimit: 5, participantLimit: 20, memberLimit: 30);
    final threads = [_thread('parent-1', lastMessageAt: DateTime.utc(2026, 2, 2)), _thread('parent-2')];
    when(
      () => client.queryThreads(filter: filter, sort: sort, options: options, limit: 30),
    ).thenAnswer((_) async => Result.success(QueryThreadsResponse(duration: '0.01ms', threads: threads, next: 'next')));

    final controller = StreamThreadListController(client: client, filter: filter, sort: sort, options: options);
    addTearDown(controller.dispose);
    await controller.doInitialLoad();

    expect(controller.value, PagedValue<String, Thread>(items: threads, nextPageKey: 'next'));
  });

  test('StreamThreadListController.loadMore sends the cursor and appends the last page', () async {
    final client = _client();
    final loaded = [_thread('parent-1')];
    final nextPage = [_thread('parent-2')];
    when(
      () => client.queryThreads(limit: 10, next: 'next'),
    ).thenAnswer((_) async => Result.success(QueryThreadsResponse(duration: '0.01ms', threads: nextPage, next: '')));

    final controller = StreamThreadListController.fromValue(
      PagedValue(items: loaded, nextPageKey: 'next'),
      client: client,
    );
    addTearDown(controller.dispose);
    await controller.loadMore('next');

    // An empty cursor marks the last page.
    expect(controller.value, PagedValue<String, Thread>(items: [...loaded, ...nextPage]));
  });

  test('StreamThreadListController.doInitialLoad reports the failure of the query as it is', () async {
    final client = _client();
    const error = StreamNetworkException(message: 'Network error');
    when(() => client.queryThreads(limit: 30)).thenAnswer((_) async => const Result.failure(error));

    final controller = StreamThreadListController(client: client);
    addTearDown(controller.dispose);
    await controller.doInitialLoad();

    expect(controller.value, const PagedValue<String, Thread>.error(error));
  });

  test('StreamThreadListController.loadMore keeps the loaded threads and reports any other failure as a client '
      'error', () async {
    final client = _client();
    final loaded = [_thread('parent-1')];
    final cause = Exception('boom');
    when(() => client.queryThreads(limit: 10, next: 'next')).thenAnswer((_) async => Result.failure(cause));

    final controller = StreamThreadListController.fromValue(
      PagedValue(items: loaded, nextPageKey: 'next'),
      client: client,
    );
    addTearDown(controller.dispose);
    await controller.loadMore('next');

    final value = controller.value.asSuccess;
    expect(value.items, loaded);
    expect(value.error, isA<StreamClientException>().having((it) => it.cause, 'cause', same(cause)));
  });
}

MockClient _client() {
  final client = MockClient();
  when(client.on).thenAnswer((_) => const Stream.empty());
  return client;
}

Thread _thread(String parentMessageId, {DateTime? lastMessageAt}) => Thread(
  channelCid: 'messaging:general',
  parentMessageId: parentMessageId,
  createdByUserId: 'creator',
  replyCount: 1,
  participantCount: 1,
  lastMessageAt: lastMessageAt ?? DateTime.utc(2026, 2, 1),
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);
