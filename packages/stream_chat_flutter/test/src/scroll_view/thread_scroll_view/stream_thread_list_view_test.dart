import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

class MockStreamThreadListController extends Mock implements StreamThreadListController {
  @override
  PagedValue<String, Thread> value = const PagedValue.loading();

  final _unseenThreadIds = ValueNotifier<Set<String>>(const {});

  @override
  ValueListenable<Set<String>> get unseenThreadIds => _unseenThreadIds;
}

void main() {
  late StreamChatClient client;
  late ClientState clientState;
  late MockStreamThreadListController controller;
  late Thread thread;

  setUp(() {
    client = MockClient();
    clientState = MockClientState();
    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user-id'));

    thread = Thread(
      channelCid: 'messaging:general',
      parentMessageId: 'parent-message-id',
      parentMessage: Message(
        id: 'parent-message-id',
        text: 'Parent message from thread list',
        user: User(id: 'other-user-id'),
        createdAt: DateTime.now().toUtc(),
      ),
      createdByUserId: 'other-user-id',
      replyCount: 2,
      participantCount: 1,
    );

    controller = MockStreamThreadListController();
    when(controller.doInitialLoad).thenAnswer((_) async {
      controller.value = PagedValue(items: [thread]);
    });
  });

  tearDown(() {
    controller.dispose();
  });

  testWidgets('renders parent message row with thread indicator', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StreamThreadListView(controller: controller),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Parent message from thread list'), findsOneWidget);
    expect(find.text('2 replies'), findsOneWidget);
  });

  testWidgets('honors per-instance messageBuilder override', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        child: StreamThreadListView(
          controller: controller,
          itemBuilder: (_, __, ___, ____) => const Text('custom-thread-row'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('custom-thread-row'), findsOneWidget);
  });

  testWidgets('honors global threadListItem component builder override', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        client: client,
        componentBuilders: StreamComponentBuilders(
          extensions: streamChatComponentBuilders(
            threadListItem: (_, __) => const Text('global-thread-item'),
          ),
        ),
        child: StreamThreadListView(controller: controller),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('global-thread-item'), findsOneWidget);
  });
}

Widget _wrapWithMaterialApp({
  required StreamChatClient client,
  required Widget child,
  StreamComponentBuilders? componentBuilders,
}) {
  return MaterialApp(
    home: StreamChat(
      client: client,
      componentBuilders: componentBuilders,
      configData: StreamChatConfigurationData(),
      connectivityStream: Stream.value([ConnectivityResult.wifi]),
      child: Scaffold(body: child),
    ),
  );
}
