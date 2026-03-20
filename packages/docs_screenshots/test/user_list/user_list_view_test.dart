import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_client_stubs.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  goldenTest(
    'user list view',
    fileName: 'user_list_view',
    constraints: const BoxConstraints.tightFor(width: 375, height: 500),
    builder: () {
      final client = MockClient();
      stubMockClientCurrentUser(client, OwnUser(id: 'user-1'));

      final users = [
        User(id: 'user-2', name: 'Alice Johnson', online: true),
        User(id: 'user-3', name: 'Bob Smith', online: false),
        User(id: 'user-4', name: 'Carol White', online: true),
        User(id: 'user-5', name: 'David Brown', online: false),
        User(id: 'user-6', name: 'Eve Davis', online: true),
      ];

      final controller = StreamUserListController.fromValue(
        PagedValue(items: users),
        client: client,
      );

      stubQueryUsersForGoldens(client, users);

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: StreamUserListView(
              controller: controller,
              shrinkWrap: true,
            ),
          ),
        ),
      );
    },
  );
}
