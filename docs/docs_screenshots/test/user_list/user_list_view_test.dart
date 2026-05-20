import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_client_stubs.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  docsGoldenTest(
    'user list view',
    fileName: 'user_list_view',
    constraints: const BoxConstraints.tightFor(width: 375, height: 500),
    builder: () {
      final client = MockClient();
      stubMockClientCurrentUser(client, OwnUser(id: 'user-1', image: 'https://docs.fixture/avatar/user-1.png'));

      final users = [
        User(id: 'user-2', image: 'https://docs.fixture/avatar/user-2.png', name: 'Alice Johnson', online: true),
        User(id: 'user-3', image: 'https://docs.fixture/avatar/user-3.png', name: 'Bob Smith', online: false),
        User(id: 'user-4', image: 'https://docs.fixture/avatar/user-4.png', name: 'Carol White', online: true),
        User(id: 'user-5', image: 'https://docs.fixture/avatar/user-5.png', name: 'David Brown', online: false),
        User(id: 'user-6', image: 'https://docs.fixture/avatar/user-6.png', name: 'Eve Davis', online: true),
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
