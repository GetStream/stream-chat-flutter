import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/group_avatar.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'it should show the image in channel.extraData',
    (tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
            'image': 'imagetest',
          }));
      when(() => channel.extraData).thenReturn({
        'name': 'test',
        'image': 'imagetest',
      });

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: const Scaffold(
              body: ChannelAvatar(),
            ),
          ),
        ),
      ));

      final image =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(image.imageUrl, 'imagetest');
    },
  );

  testWidgets(
    'it should show the the other member image',
    (tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
          }));
      when(() => channel.extraData).thenReturn({
        'name': 'test',
      });
      when(() => channelState.membersStream).thenAnswer((i) => Stream.value([
            Member(
              userId: 'user-id',
              user: User(id: 'user-id'),
            ),
            Member(
              userId: 'user-id2',
              user: User(
                id: 'user-id2',
                extraData: const {
                  'image': 'testimage',
                },
              ),
            )
          ]));
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id2',
          user: User(
            id: 'user-id2',
            extraData: const {
              'image': 'testimage',
            },
          ),
        ),
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        )
      ]);
      when(() => clientState.usersStream).thenAnswer((i) => Stream.value({
            'user-id2': User(
              id: 'user-id2',
              extraData: const {
                'image': 'testimage',
              },
            ),
          }));
      when(() => channel.extraData).thenReturn({
        'name': 'test',
      });

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: const Scaffold(
              body: ChannelAvatar(),
            ),
          ),
        ),
      ));

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
      when(() => clientState.user).thenReturn(currentUser);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
          }));
      when(() => channel.extraData).thenReturn({
        'name': 'test',
      });
      final members = [
        Member(
          userId: 'user-id',
          user: User(
            id: 'user-id',
            extraData: const {
              'image': 'testimage1',
            },
          ),
        ),
        Member(
          userId: 'user-id2',
          user: User(
            id: 'user-id2',
            extraData: const {
              'image': 'testimage2',
            },
          ),
        ),
        Member(
          userId: 'user-id3',
          user: User(
            id: 'user-id3',
            extraData: const {
              'image': 'testimage3',
            },
          ),
        ),
      ];
      when(() => channelState.members).thenReturn(members);
      when(() => channelState.membersStream)
          .thenAnswer((_) => Stream.value(members));

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: const Scaffold(
              body: ChannelAvatar(),
            ),
          ),
        ),
      ));

      final image = tester.widget<GroupAvatar>(find.byType(GroupAvatar));
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
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
            'image': 'imagetest',
          }));
      when(() => channel.extraData).thenReturn({
        'name': 'test',
        'image': 'imagetest',
      });

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: const Scaffold(
              body: ChannelAvatar(
                selected: true,
              ),
            ),
          ),
        ),
      ));

      expect(find.byKey(const Key('selectedImage')), findsOneWidget);
    },
  );
}
