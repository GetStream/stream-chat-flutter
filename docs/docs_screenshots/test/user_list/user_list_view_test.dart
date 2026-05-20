import 'dart:math';

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

      // Every sample user, with online flipped pseudo-randomly. Seeded so
      // the same set of users light up across runs.
      final rng = Random(42);
      final users = [
        for (final user in sampleUsers) user.copyWith(online: rng.nextBool()),
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
