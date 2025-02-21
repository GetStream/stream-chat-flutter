import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
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
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      methodChannel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'listen') {
          try {
            await TestDefaultBinaryMessengerBinding
                .instance.defaultBinaryMessenger
                .handlePlatformMessage(
              methodChannel.name,
              methodChannel.codec.encodeSuccessEnvelope(['wifi']),
              (_) {},
            );
          } catch (e) {
            print(e);
          }
        }

        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
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
    },
  );
}
