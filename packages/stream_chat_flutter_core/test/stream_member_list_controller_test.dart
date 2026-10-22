import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/stream_member_list_controller.dart';

import 'mocks.dart';

void main() {
  final channel = MockChannel();

  tearDown(() {
    reset(channel);
  });

  Result<QueryMembersResponse> membersResponse(List<Member> members) {
    return Result.success(QueryMembersResponse(duration: '0.01ms', members: members));
  }

  test('an empty sort queries without a sort term', () async {
    final sorts = <Object?>[];
    when(
      () => channel.queryMembers(
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        pagination: any(named: 'pagination'),
      ),
    ).thenAnswer((invocation) async {
      sorts.add(invocation.namedArguments[#sort]);
      return membersResponse([Member(user: User(id: 'user-1'))]);
    });

    final controller = StreamMemberListController(
      channel: channel,
      sort: MemberSort.empty,
    );
    addTearDown(controller.dispose);

    await controller.doInitialLoad();

    expect(sorts.single, isEmpty);
  });

  void stubQueryMembers(Result<QueryMembersResponse> result) {
    when(
      () => channel.queryMembers(
        filter: any(named: 'filter'),
        sort: any(named: 'sort'),
        pagination: any(named: 'pagination'),
      ),
    ).thenAnswer((_) async => result);
  }

  test('doInitialLoad reports the failure of the query as it is', () async {
    const exception = StreamNetworkException(message: 'Network error');
    stubQueryMembers(const Result.failure(exception));
    final controller = StreamMemberListController(channel: channel);
    addTearDown(controller.dispose);

    await controller.doInitialLoad();

    expect(controller.value, isA<Error<int, Member>>().having((it) => it.error, 'error', same(exception)));
  });

  test('doInitialLoad reports any other failure as a client error', () async {
    final cause = Exception('boom');
    stubQueryMembers(Result.failure(cause));
    final controller = StreamMemberListController(channel: channel);
    addTearDown(controller.dispose);

    await controller.doInitialLoad();

    expect(
      controller.value,
      isA<Error<int, Member>>().having(
        (it) => it.error,
        'error',
        isA<StreamClientException>()
            .having((it) => it.message, 'message', 'Failed to load members')
            .having((it) => it.cause, 'cause', same(cause)),
      ),
    );
  });

  test('loadMore keeps the loaded members and reports the failure of the query as it is', () async {
    const exception = StreamNetworkException(message: 'Network error');
    stubQueryMembers(const Result.failure(exception));
    final loadedMembers = [Member(user: User(id: 'user-1'))];
    final controller = StreamMemberListController.fromValue(
      PagedValue(items: loadedMembers, nextPageKey: 1),
      channel: channel,
    );
    addTearDown(controller.dispose);

    await controller.loadMore(1);

    expect(controller.value.asSuccess.items, loadedMembers);
    expect(controller.value.asSuccess.error, same(exception));
  });

  test('loadMore keeps the loaded members and reports any other failure as a client error', () async {
    final cause = Exception('boom');
    stubQueryMembers(Result.failure(cause));
    final loadedMembers = [Member(user: User(id: 'user-1'))];
    final controller = StreamMemberListController.fromValue(
      PagedValue(items: loadedMembers, nextPageKey: 1),
      channel: channel,
    );
    addTearDown(controller.dispose);

    await controller.loadMore(1);

    expect(controller.value.asSuccess.items, loadedMembers);
    expect(
      controller.value.asSuccess.error,
      isA<StreamClientException>()
          .having((it) => it.message, 'message', 'Failed to load more members')
          .having((it) => it.cause, 'cause', same(cause)),
    );
  });

  group('search', () {
    test('queries members with the provided filter after debouncing', () {
      Filter? usedFilter;
      when(
        () => channel.queryMembers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((invocation) async {
        usedFilter ??= invocation.namedArguments[#filter] as Filter?;
        return membersResponse([Member(user: User(id: 'user-1'))]);
      });

      fakeAsync((async) {
        final controller = StreamMemberListController(channel: channel);
        addTearDown(controller.dispose);

        controller.search('abc');

        // 'abc' is longer than a short query, so the 300ms delay applies.
        async.elapse(const Duration(milliseconds: 299));
        expect(usedFilter, isNull);

        async.elapse(const Duration(milliseconds: 1));
        expect(usedFilter?.toJson(), MemberFilter.autoComplete(MemberFilterField.name, 'abc').toJson());
      });
    });

    test('replaces the base filter rather than narrowing it', () {
      Filter? usedFilter;
      when(
        () => channel.queryMembers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((invocation) async {
        usedFilter ??= invocation.namedArguments[#filter] as Filter?;
        return membersResponse([]);
      });

      fakeAsync((async) {
        final controller = StreamMemberListController(
          channel: channel,
          filter: MemberFilter.equal(MemberFilterField.banned, true),
        );
        addTearDown(controller.dispose);

        controller.search('abc');
        async.elapse(const Duration(milliseconds: 300));

        // The base filter is not merged in — combining it with the search text
        // would let it skew the debounce policy and contradict the search.
        expect(usedFilter?.toJson(), MemberFilter.autoComplete(MemberFilterField.name, 'abc').toJson());
      });
    });
  });

  group('superseded results', () {
    test('a slower earlier load does not overwrite a newer load', () async {
      final responses = <Completer<Result<QueryMembersResponse>>>[
        Completer<Result<QueryMembersResponse>>(),
        Completer<Result<QueryMembersResponse>>(),
      ];
      var call = 0;
      when(
        () => channel.queryMembers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) => responses[call++].future);

      final controller = StreamMemberListController(channel: channel);
      addTearDown(controller.dispose);

      final earlier = controller.doInitialLoad();
      final newer = controller.doInitialLoad();

      responses[1].complete(membersResponse([Member(user: User(id: 'newer'))]));
      await newer;
      responses[0].complete(membersResponse([Member(user: User(id: 'earlier'))]));
      await earlier;

      expect(controller.value.asSuccess.items.single.user!.id, 'newer');
    });
  });
}
