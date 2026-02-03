import 'package:alchemist/alchemist.dart';
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../material_app_wrapper.dart';
import '../mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockClient client;
  late MockChannel channel;
  late MockChannelState channelState;

  late final user1 = User(id: 'alice', name: 'Alice');
  late final user2 = User(id: 'bob', name: 'Bob');

  setUpAll(() {
    client = MockClient();
    channel = MockChannel();
    channelState = MockChannelState();

    when(() => channel.state!).thenReturn(channelState);
    when(() => channelState.membersStream).thenAnswer(
      (_) => Stream<List<Member>>.value([
        Member(user: user1),
        Member(user: user2),
      ]),
    );
  });

  final originalConnectivityPlatform = ConnectivityPlatform.instance;
  setUp(() => ConnectivityPlatform.instance = FakeConnectivityPlatform());
  tearDown(() => ConnectivityPlatform.instance = originalConnectivityPlatform);

  testWidgets(
    'control test - verify different users are displayed',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            streamChatThemeData: StreamChatThemeData.light(),
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: Center(
                  child: StreamUserAvatarGroup(
                    users: [user1, user2],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.byType(StreamUserAvatar), findsNWidgets(2));
    },
  );

  goldenTest(
    'golden test for the group with "user123" and "user456"',
    fileName: 'group_avatar_0',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    builder: () {
      return MaterialAppWrapper(
        home: StreamChat(
          client: client,
          streamChatThemeData: StreamChatThemeData.light(),
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: StreamUserAvatarGroup(
                    users: [user1, user2],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
