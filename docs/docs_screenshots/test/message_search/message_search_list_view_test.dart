import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../src/golden_client_stubs.dart';
import '../src/golden_theme.dart';
import '../src/mocks.dart';
import '../src/sample_users.dart';

GetMessageResponse _makeSearchResult({
  required String messageId,
  required String text,
  required String userName,
  required String channelName,
}) {
  final response = GetMessageResponse()
    ..message = Message(
      id: messageId,
      text: text,
      user: User(id: 'user-$messageId', image: 'https://docs.fixture/avatar/user-$messageId.png', name: userName),
      createdAt: DateTime(2024, 6, 1, 10, 0),
    )
    ..channel = ChannelModel(
      id: 'ch-$messageId',
      type: 'messaging',
      extraData: {'name': channelName},
    );
  return response;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  docsGoldenTest(
    'message search list view',
    fileName: 'message_search_list_view',
    constraints: const BoxConstraints.tightFor(width: 375, height: 500),
    builder: () {
      final client = MockClient();
      stubMockClientCurrentUser(client, asOwnUser(ameliaMoore));

      final results = [
        _makeSearchResult(
          messageId: '1',
          text: 'Flutter is an amazing UI toolkit!',
          userName: 'Alice',
          channelName: 'General',
        ),
        _makeSearchResult(
          messageId: '2',
          text: 'Flutter 3.0 has great performance improvements.',
          userName: 'Bob',
          channelName: 'Engineering',
        ),
        _makeSearchResult(
          messageId: '3',
          text: 'I love how Flutter handles animations.',
          userName: 'Carol',
          channelName: 'Design',
        ),
        _makeSearchResult(
          messageId: '4',
          text: 'Flutter Web support has come a long way.',
          userName: 'Dave',
          channelName: 'Random',
        ),
      ];

      final controller = StreamMessageSearchListController.fromValue(
        PagedValue(items: results),
        client: client,
        filter: Filter.equal('type', 'messaging'),
        searchQuery: 'flutter',
      );

      stubSearchMessagesForGoldens(client, results);

      return MaterialApp(
        theme: docsScreenshotsTheme(),
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: Scaffold(
            body: StreamMessageSearchListView(
              controller: controller,
              shrinkWrap: true,
            ),
          ),
        ),
      );
    },
  );
}
