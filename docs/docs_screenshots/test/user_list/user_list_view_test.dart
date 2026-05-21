import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_client_stubs.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  docsGoldenTest(
    'user list view',
    fileName: 'user_list_view',
    constraints: const BoxConstraints.tightFor(width: 375, height: 500),
    builder: () {
      final client = MockClient();
      stubMockClientCurrentUser(client, ownUser);

      final users = [
        charlotteAnderson.copyWith(online: true),
        noahSmith.copyWith(online: false),
        elenaBarros.copyWith(online: true),
        liamJohnson.copyWith(online: false),
        mayaRoss.copyWith(online: true),
      ];

      final controller = StreamUserListController.fromValue(
        PagedValue(items: users),
        client: client,
      );

      stubQueryUsersForGoldens(client, users);

      return StreamChat(
        client: client,
        connectivityStream: Stream.value([ConnectivityResult.mobile]),
        child: Scaffold(
          body: StreamUserListView(
            controller: controller,
            shrinkWrap: true,
          ),
        ),
      );
    },
  );
}
