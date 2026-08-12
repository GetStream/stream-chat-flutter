import 'dart:async';

import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final originalConnectivityPlatform = ConnectivityPlatform.instance;
  setUp(() => ConnectivityPlatform.instance = FakeConnectivityPlatform());
  tearDown(() => ConnectivityPlatform.instance = originalConnectivityPlatform);

  testWidgets(
    'does not throw when the channel is disposed while the avatar is still '
    'mounted and gets rebuilt',
    (tester) async {
      final client = MockClient();
      final clientState = client.state; // stable MockClientState instance
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'alice'));

      final channel = MockChannel();
      final channelState = MockChannelState();

      final members = [
        Member(
          userId: 'alice',
          user: User(id: 'alice'),
        ),
        Member(
          userId: 'bob',
          user: User(id: 'bob'),
        ),
      ];

      // The avatar's inner builder can be re-run by the framework (an inherited
      // dependency changing on logout) after the channel is disposed — not only
      // by a member-stream event. We model both: a mutable state ref that flips
      // to null on "dispose", plus a members controller we can push to.
      final membersController = StreamController<List<Member>>.broadcast();
      addTearDown(membersController.close);

      ChannelClientState? liveState = channelState;

      when(() => channel.client).thenReturn(client);
      when(() => channel.state).thenAnswer((_) => liveState);
      when(() => channel.image).thenReturn(null);
      when(() => channel.imageStream).thenAnswer((_) => Stream<String?>.value(null));
      when(() => channel.isGroup).thenReturn(false);
      when(() => channel.isOneToOne).thenReturn(true);

      when(() => channelState.membersStream).thenAnswer((_) => membersController.stream);
      when(() => channelState.members).thenReturn(members);

      // A key we can use to force a rebuild of the avatar's subtree, simulating
      // the framework rebuilding it after the channel is disposed.
      final rebuildNotifier = ValueNotifier<int>(0);
      addTearDown(rebuildNotifier.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            themeData: StreamChatThemeData(),
            child: Scaffold(
              body: Center(
                child: ValueListenableBuilder<int>(
                  valueListenable: rebuildNotifier,
                  builder: (context, _, __) => StreamChannelAvatar(
                    channel: channel,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // The avatar renders fine while the channel is alive.
      expect(tester.takeException(), isNull);
      expect(find.byType(StreamUserAvatar), findsOneWidget);

      // Simulate logout: the channel's state is disposed and nulled...
      liveState = null;

      // ...then a members emission arrives while the nested BetterStreamBuilder
      // is still mounted, exercising the member-stream disposal path against the
      // now-disposed channel.
      membersController.add(List.of(members));
      await tester.pump();
      expect(tester.takeException(), isNull);

      // ...and separately, the framework rebuilds the avatar (as an inherited-
      // dependency change would) against the now-disposed channel.
      rebuildNotifier.value++;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      // Rebuilding against a disposed channel must not throw.
      expect(tester.takeException(), isNull);
    },
  );
}
