import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/stream_member_list_controller.dart';

import 'mocks.dart';

void main() {
  final channel = MockChannel();

  tearDown(() {
    reset(channel);
  });

  QueryMembersResponse membersResponse(List<Member> members) {
    return QueryMembersResponse()..members = members;
  }

  group('search', () {
    test('queries members with the provided filter after debouncing', () async {
      final usedFilter = Completer<Filter?>();
      when(
        () => channel.queryMembers(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((invocation) async {
        final filter = invocation.namedArguments[#filter] as Filter?;
        if (!usedFilter.isCompleted) usedFilter.complete(filter);
        return membersResponse([Member(user: User(id: 'user-1'))]);
      });

      final controller = StreamMemberListController(
        channel: channel,
        debouncePolicy: const .constant(Duration.zero),
      );
      addTearDown(controller.dispose);

      controller.search('abc');

      // Waits for the debounced query to fire rather than a fixed timeout.
      expect(await usedFilter.future, Filter.autoComplete('name', 'abc'));
    });
  });

  group('superseded results', () {
    test('a slower earlier load does not overwrite a newer load', () async {
      final responses = <Completer<QueryMembersResponse>>[
        Completer<QueryMembersResponse>(),
        Completer<QueryMembersResponse>(),
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
