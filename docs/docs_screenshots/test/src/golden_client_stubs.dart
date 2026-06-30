import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

bool _registeredFallbacks = false;

void _ensureGoldenMocktailFallbacks() {
  if (_registeredFallbacks) return;
  registerFallbackValue(const Filter.empty());
  registerFallbackValue(const ThreadOptions());
  registerFallbackValue(const PaginationParams());
  registerFallbackValue(<SortOption<User>>[]);
  registerFallbackValue(<SortOption<Thread>>[]);
  registerFallbackValue(<SortOption<ChannelState>>[]);
  registerFallbackValue(<SortOption<Draft>>[]);
  registerFallbackValue(<SortOption<Member>>[]);
  _registeredFallbacks = true;
}

/// Subscriptions after a successful paged load call [StreamChatClient.on]. Mocks must return a stream.
void stubStreamClientEventStream(MockClient client) {
  when(() => client.on()).thenAnswer((_) => const Stream<Event>.empty());
}

/// Stubs channel queries for [StreamChannelListController] goldens using [StreamChannelListController.fromValue].
void stubQueryChannelsForGoldens(MockClient client, List<Channel> channels) {
  _ensureGoldenMocktailFallbacks();
  stubStreamClientEventStream(client);
  when(
    () => client.queryChannelsWithResult(
      filter: any(named: 'filter'),
      channelStateSort: any(named: 'channelStateSort'),
      predefinedFilter: any(named: 'predefinedFilter'),
      filterValues: any(named: 'filterValues'),
      sortValues: any(named: 'sortValues'),
      state: any(named: 'state'),
      watch: any(named: 'watch'),
      presence: any(named: 'presence'),
      memberLimit: any(named: 'memberLimit'),
      messageLimit: any(named: 'messageLimit'),
      paginationParams: any(named: 'paginationParams'),
      waitForConnect: any(named: 'waitForConnect'),
    ),
  ).thenAnswer((_) => Stream.value(QueryChannelsResult(channels: channels)));
}

/// Stubs thread queries for [StreamThreadListController] goldens using [StreamThreadListController.fromValue].
void stubQueryThreadsForGoldens(MockClient client, List<Thread> threads) {
  _ensureGoldenMocktailFallbacks();
  stubStreamClientEventStream(client);
  when(
    () => client.queryThreads(
      filter: any(named: 'filter'),
      sort: any(named: 'sort'),
      options: any(named: 'options'),
      pagination: any(named: 'pagination'),
    ),
  ).thenAnswer(
    (_) async => QueryThreadsResponse()
      ..threads = threads
      ..next = null,
  );
}

/// Stubs user queries for [StreamUserListController] goldens using [StreamUserListController.fromValue].
void stubQueryUsersForGoldens(MockClient client, List<User> users) {
  _ensureGoldenMocktailFallbacks();
  when(
    () => client.queryUsers(
      presence: any(named: 'presence'),
      filter: any(named: 'filter'),
      sort: any(named: 'sort'),
      pagination: any(named: 'pagination'),
    ),
  ).thenAnswer((_) async => QueryUsersResponse()..users = users);
}

/// Stubs draft queries for [StreamDraftListController] goldens using [StreamDraftListController.fromValue].
void stubQueryDraftsForGoldens(MockClient client, List<Draft> drafts) {
  _ensureGoldenMocktailFallbacks();
  stubStreamClientEventStream(client);
  when(
    () => client.queryDrafts(
      filter: any(named: 'filter'),
      sort: any(named: 'sort'),
      pagination: any(named: 'pagination'),
    ),
  ).thenAnswer(
    (_) async => QueryDraftsResponse()
      ..drafts = drafts
      ..next = null,
  );
}

/// Stubs member queries for [StreamMemberListController] goldens using [StreamMemberListController.fromValue].
void stubQueryMembersForGoldens(MockChannel channel, List<Member> members) {
  _ensureGoldenMocktailFallbacks();
  when(
    () => channel.queryMembers(
      filter: any(named: 'filter'),
      sort: any(named: 'sort'),
      pagination: any(named: 'pagination'),
    ),
  ).thenAnswer((_) async => QueryMembersResponse()..members = members);
}

/// Stubs search for [StreamMessageSearchListController] goldens using [StreamMessageSearchListController.fromValue].
void stubSearchMessagesForGoldens(MockClient client, List<GetMessageResponse> results) {
  _ensureGoldenMocktailFallbacks();
  when(
    () => client.search(
      any(),
      query: any(named: 'query'),
      sort: any(named: 'sort'),
      paginationParams: any(named: 'paginationParams'),
      messageFilters: any(named: 'messageFilters'),
    ),
  ).thenAnswer(
    (_) async => SearchMessagesResponse()
      ..results = results
      ..next = null,
  );
}
