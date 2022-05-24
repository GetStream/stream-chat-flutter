import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  late MockClient client;
  late MockChannel channel;
  late MockChannelState channelState;
  late MockMember member;
  late MockUser user;
  late MockMember member2;
  late MockUser user2;
  const methodChannel =
      MethodChannel('dev.fluttercommunity.plus/connectivity_status');

  setUpAll(() {
    client = MockClient();
    channel = MockChannel();
    channelState = MockChannelState();
    member = MockMember();
    user = MockUser();
    member2 = MockMember();
    user2 = MockUser();

    when(() => channel.state!).thenReturn(channelState);
    when(() => channelState.membersStream)
        .thenAnswer((_) => Stream<List<Member>>.value([member, member2]));
    when(() => member.user).thenReturn(user);
    when(() => user.name).thenReturn('user123');
    when(() => user.id).thenReturn('123');
    when(() => member2.user).thenReturn(user2);
    when(() => user2.name).thenReturn('user456');
    when(() => user2.id).thenReturn('456');
  });

  setUp(() {
    methodChannel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'listen') {
        try {
          await ServicesBinding.instance.defaultBinaryMessenger
              .handlePlatformMessage(
            methodChannel.name,
            methodChannel.codec.encodeSuccessEnvelope('wifi'),
            (_) {},
          );
        } catch (e) {
          print(e);
        }
      }
    });
  });

  testWidgets(
    'control test',
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
                  child: StreamGroupAvatar(
                    members: [
                      member,
                      member2,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(StreamUserAvatar), findsNWidgets(2));
    },
  );

  testGoldens(
    'golden test for the group with "user123" and "user456"',
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
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: StreamGroupAvatar(
                      members: [
                        member,
                        member2,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'group_avatar_0');
    },
  );

  tearDown(() {
    methodChannel.setMockMethodCallHandler(null);
  });

  /*testGoldens(
    'golden test for the name "demo user"',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: GroupAvatar(
                  members: [
                    Member(userId: 'user123'),
                    Member(userId: 'user456'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'group_avatar_0');
    },
  );

  testGoldens(
    'golden test for the name "demo"',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: GroupAvatar(
                  members: [
                    Member(userId: 'user123'),
                    Member(userId: 'user456'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'group_avatar_1');
    },
  );

  testGoldens(
    'control special character test',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: GroupAvatar(
                  members: [
                    Member(userId: 'user123'),
                    Member(userId: 'user456'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'group_avatar_3');
    },
  );

  testGoldens(
    'control special character test 2',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: GroupAvatar(
                  members: [
                    Member(userId: 'user123'),
                    Member(userId: 'user456'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'group_avatar_3');
    },
  );*/
}
