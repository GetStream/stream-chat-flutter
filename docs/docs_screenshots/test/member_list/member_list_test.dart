import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_client_stubs.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

List<Member> _sampleMembers() {
  final now = DateTime.now();
  return [
    Member(userId: charlotteAnderson.id, user: charlotteAnderson.copyWith(online: true)),
    Member(
      userId: noahSmith.id,
      user: noahSmith.copyWith(online: false, lastActive: now),
    ),
    Member(userId: elenaBarros.id, user: elenaBarros.copyWith(online: true)),
    Member(
      userId: liamJohnson.id,
      user: liamJohnson.copyWith(online: false, lastActive: now.subtract(const Duration(hours: 2))),
    ),
    Member(userId: mayaRoss.id, user: mayaRoss.copyWith(online: true)),
    Member(
      userId: ethanWilson.id,
      user: ethanWilson.copyWith(online: false, lastActive: now.subtract(const Duration(days: 3))),
    ),
  ];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  docsGoldenTest(
    'member list view',
    fileName: 'member_list_view',
    constraints: const BoxConstraints.tightFor(width: 375, height: 400),
    builder: () {
      final client = MockClient();
      stubMockClientCurrentUser(client, ownUser);
      final channel = MockChannel();
      final members = _sampleMembers();
      stubQueryMembersForGoldens(channel, members);
      final controller = StreamMemberListController.fromValue(
        PagedValue(items: members),
        channel: channel,
      );

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: Scaffold(
          body: StreamMemberListView(
            controller: controller,
            shrinkWrap: true,
          ),
        ),
      );
    },
  );

  docsGoldenTest(
    'member grid view',
    fileName: 'member_grid_view',
    constraints: const BoxConstraints.tightFor(width: 375, height: 400),
    builder: () {
      final client = MockClient();
      stubMockClientCurrentUser(client, ownUser);
      final channel = MockChannel();
      final members = _sampleMembers();
      stubQueryMembersForGoldens(channel, members);
      final controller = StreamMemberListController.fromValue(
        PagedValue(items: members),
        channel: channel,
      );

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: Scaffold(
          body: StreamMemberGridView(
            controller: controller,
            shrinkWrap: true,
          ),
        ),
      );
    },
  );
}
