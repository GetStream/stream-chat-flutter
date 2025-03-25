import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets(
    'it should show the image in channel.extraData',
    (tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.name).thenReturn('test');
      when(() => channel.imageStream)
          .thenAnswer((i) => Stream.value('https://bit.ly/321RmWb'));
      when(() => channel.image).thenReturn('https://bit.ly/321RmWb');

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: StreamChannelAvatar(channel: channel),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      final image =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(image.imageUrl, 'https://bit.ly/321RmWb');
    },
  );

  testWidgets(
    'it should show the other member image',
    (tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.name).thenReturn('test');
      when(() => channel.imageStream).thenAnswer((i) => Stream.value(null));
      when(() => channel.image).thenReturn(null);
      when(() => channelState.membersStream).thenAnswer(
        (i) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          ),
          Member(
            userId: 'user-id2',
            user: User(
              id: 'user-id2',
              image: 'testimage',
            ),
          )
        ]),
      );
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id2',
          user: User(
            id: 'user-id2',
            image: 'testimage',
          ),
        ),
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        )
      ]);
      when(() => clientState.usersStream).thenAnswer(
        (i) => Stream.value({
          'user-id2': User(
            id: 'user-id2',
            image: 'testimage',
          ),
        }),
      );
      when(() => channel.extraData).thenReturn({
        'name': 'test',
      });

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: StreamChannelAvatar(channel: channel),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      final image =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(image.imageUrl, 'testimage');
    },
  );

  testWidgets(
    'it should use a groupimage if more than 2 members',
    (tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final currentUser = OwnUser(id: 'user-id');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(currentUser);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.name).thenReturn('test');
      when(() => channel.imageStream).thenAnswer((i) => Stream.value(null));
      final members = [
        Member(
          userId: 'user-id',
          user: User(
            id: 'user-id',
            image: 'testimage1',
          ),
        ),
        Member(
          userId: 'user-id2',
          user: User(
            id: 'user-id2',
            image: 'testimage2',
          ),
        ),
        Member(
          userId: 'user-id3',
          user: User(
            id: 'user-id3',
            image: 'testimage3',
          ),
        ),
      ];
      when(() => channelState.members).thenReturn(members);
      when(() => channelState.membersStream)
          .thenAnswer((_) => Stream.value(members));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: StreamChannelAvatar(channel: channel),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      final image =
          tester.widget<StreamGroupAvatar>(find.byType(StreamGroupAvatar));
      final otherMembers = members.where((it) => it.userId != currentUser.id);
      expect(
        image.members.map((it) => it.user?.id),
        otherMembers.map((it) => it.user?.id),
      );
    },
  );

  testWidgets(
    'using select: true should show a selection border',
    (tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.name).thenReturn('test');
      when(() => channel.imageStream)
          .thenAnswer((i) => Stream.value('https://bit.ly/321RmWb'));
      when(() => channel.image).thenReturn('https://bit.ly/321RmWb');

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: StreamChannelAvatar(
                  channel: channel,
                  selected: true,
                ),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('selectedImage')), findsOneWidget);
    },
  );
}
