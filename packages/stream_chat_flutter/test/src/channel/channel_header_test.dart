import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
import '../mocks.dart';

void main() {
  testWidgets(
    'it should show basic channel information',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final user = OwnUser(id: 'user-id');
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream)
          .thenAnswer((_) => Stream.value(user));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.name).thenReturn('test');
      when(() => channel.imageStream)
          .thenAnswer((i) => Stream.value('https://bit.ly/321RmWb'));
      when(() => channel.image).thenReturn('https://bit.ly/321RmWb');
      when(() => channelState.unreadCount).thenReturn(1);
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connected));
      when(() => channelState.unreadCountStream)
          .thenAnswer((i) => Stream.value(1));
      when(() => clientState.totalUnreadCount).thenAnswer((i) => 1);
      when(() => clientState.totalUnreadCountStream)
          .thenAnswer((i) => Stream.value(1));
      when(() => channelState.membersStream).thenAnswer(
        (i) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          )
        ]),
      );
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: const Scaffold(
                body: StreamChannelHeader(),
              ),
            ),
          ),
        ),
      );

      expect(find.text('test'), findsOneWidget);
      expect(find.byType(StreamChannelAvatar), findsOneWidget);
      expect(find.byType(StreamBackButton), findsOneWidget);
      expect(find.byType(StreamChannelInfo), findsOneWidget);
    },
  );

  testWidgets(
    'it should show the InfoTile message if disconnected',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final user = OwnUser(id: 'user-id');
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream)
          .thenAnswer((_) => Stream.value(user));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.name).thenReturn('test');
      when(() => channel.imageStream)
          .thenAnswer((i) => Stream.value('https://bit.ly/321RmWb'));
      when(() => channel.image).thenReturn('https://bit.ly/321RmWb');
      when(() => channelState.unreadCount).thenReturn(1);
      when(() => channelState.unreadCountStream)
          .thenAnswer((i) => Stream.value(1));
      when(() => channelState.membersStream).thenAnswer(
        (i) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          )
        ]),
      );
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.disconnected));
      when(() => client.wsConnectionStatus)
          .thenReturn(ConnectionStatus.disconnected);
      when(() => clientState.totalUnreadCount).thenAnswer((i) => 1);
      when(() => clientState.totalUnreadCountStream)
          .thenAnswer((i) => Stream.value(1));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: const Scaffold(
                body: StreamChannelHeader(
                  showConnectionStateTile: true,
                ),
              ),
            ),
          ),
        ),
      );

      expect(
          tester
              .widget<StreamInfoTile>(find.byType(StreamInfoTile))
              .showMessage,
          true);
      expect(tester.widget<StreamInfoTile>(find.byType(StreamInfoTile)).message,
          'Disconnected');
    },
  );

  testWidgets(
    'it should show the InfoTile message if connecting',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final user = OwnUser(id: 'user-id');
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream)
          .thenAnswer((_) => Stream.value(user));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.name).thenReturn('test');
      when(() => channel.imageStream)
          .thenAnswer((i) => Stream.value('https://bit.ly/321RmWb'));
      when(() => channel.image).thenReturn('https://bit.ly/321RmWb');
      when(() => channelState.unreadCount).thenReturn(1);
      when(() => channelState.unreadCountStream)
          .thenAnswer((i) => Stream.value(1));
      when(() => channelState.membersStream).thenAnswer(
        (i) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          )
        ]),
      );
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connecting));
      when(() => clientState.totalUnreadCount).thenAnswer((i) => 1);
      when(() => clientState.totalUnreadCountStream)
          .thenAnswer((i) => Stream.value(1));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              showLoading: false,
              child: const Scaffold(
                body: StreamChannelHeader(
                  showConnectionStateTile: true,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(
          tester
              .widget<StreamInfoTile>(find.byType(StreamInfoTile))
              .showMessage,
          true);
      expect(tester.widget<StreamInfoTile>(find.byType(StreamInfoTile)).message,
          'Reconnecting...');
    },
  );

  testWidgets(
    'it should apply passed properties',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final user = OwnUser(id: 'user-id');
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream)
          .thenAnswer((_) => Stream.value(user));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(() => channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
          }));
      when(() => channel.extraData).thenReturn({
        'name': 'test',
      });
      when(() => channelState.unreadCount).thenReturn(1);
      when(() => channelState.unreadCountStream)
          .thenAnswer((i) => Stream.value(1));
      when(() => channelState.membersStream).thenAnswer(
        (i) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          )
        ]),
      );
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connecting));
      when(() => clientState.totalUnreadCountStream)
          .thenAnswer((i) => Stream.value(1));

      await tester.pumpWidget(
        MaterialAppWrapper(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: const Scaffold(
                body: StreamChannelHeader(
                  leading: Text('leading'),
                  subtitle: Text('subtitle'),
                  actions: [
                    Text('action'),
                  ],
                  title: Text('title'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('test'), findsNothing);
      expect(find.byType(StreamBackButton), findsNothing);
      expect(find.byType(StreamChannelAvatar), findsNothing);
      expect(find.byType(StreamChannelInfo), findsNothing);
      expect(find.text('leading'), findsOneWidget);
      expect(find.text('title'), findsOneWidget);
      expect(find.text('subtitle'), findsOneWidget);
      expect(find.text('action'), findsOneWidget);
    },
  );

  testWidgets(
    'showBackButton: false should hide the StreamBackButton and '
    'showTypingIndicator: false should hide the typing indicator and '
    'showConnectionStateTile: false should be passed to the infotile',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final user = OwnUser(id: 'user-id');
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream)
          .thenAnswer((_) => Stream.value(user));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.name).thenReturn('test');
      when(() => channel.imageStream)
          .thenAnswer((i) => Stream.value('https://bit.ly/321RmWb'));
      when(() => channel.image).thenReturn('https://bit.ly/321RmWb');
      when(() => channelState.unreadCount).thenReturn(1);
      when(() => channelState.unreadCountStream)
          .thenAnswer((i) => Stream.value(1));
      when(() => channelState.membersStream).thenAnswer(
        (i) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          )
        ]),
      );
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.disconnected));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: const Scaffold(
                body: StreamChannelHeader(
                  showTypingIndicator: false,
                  showBackButton: false,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(StreamBackButton), findsNothing);
      expect(
        tester
            .widget<StreamChannelInfo>(find.byType(StreamChannelInfo))
            .showTypingIndicator,
        false,
      );
      expect(
          tester
              .widget<StreamInfoTile>(find.byType(StreamInfoTile))
              .showMessage,
          false);
    },
  );

  testWidgets(
    'should apply passed callbacks',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final user = OwnUser(id: 'user-id');
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(user);
      when(() => clientState.currentUserStream)
          .thenAnswer((_) => Stream.value(user));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((i) => Stream.value(false));
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.name).thenReturn('test');
      when(() => channel.imageStream)
          .thenAnswer((i) => Stream.value('https://bit.ly/321RmWb'));
      when(() => channel.image).thenReturn('https://bit.ly/321RmWb');
      when(() => channelState.unreadCount).thenReturn(1);
      when(() => channelState.unreadCountStream)
          .thenAnswer((i) => Stream.value(1));
      when(() => channelState.membersStream).thenAnswer(
        (i) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          )
        ]),
      );
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connecting));
      when(() => clientState.totalUnreadCount).thenAnswer((i) => 1);
      when(() => clientState.totalUnreadCountStream)
          .thenAnswer((i) => Stream.value(1));

      var backPressed = false;
      var imageTapped = false;
      var titleTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: StreamChannelHeader(
                  onBackPressed: () => backPressed = true,
                  onImageTap: () => imageTapped = true,
                  onTitleTap: () => titleTapped = true,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(StreamBackButton));
      await tester.tap(find.byType(StreamChannelAvatar));
      await tester.tap(find.byType(StreamChannelName));

      expect(backPressed, true);
      expect(imageTapped, true);
      expect(titleTapped, true);
    },
  );
}
