import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter/src/group_image.dart';
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

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(channel.state).thenReturn(channelState);
      when(channel.client).thenReturn(client);
      when(channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
            'image': 'imagetest',
          }));
      when(channel.extraData).thenReturn({
        'name': 'test',
        'image': 'imagetest',
      });

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: ChannelImage(),
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

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(channel.state).thenReturn(channelState);
      when(channel.client).thenReturn(client);
      when(channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
          }));
      when(channel.extraData).thenReturn({
        'name': 'test',
      });
      when(channelState.membersStream).thenAnswer((i) => Stream.value([
            Member(
              userId: 'user-id',
              user: User(id: 'user-id'),
            ),
            Member(
              userId: 'user-id2',
              user: User(
                id: 'user-id2',
                extraData: {
                  'image': 'testimage',
                },
              ),
            )
          ]));
      when(channelState.members).thenReturn([
        Member(
          userId: 'user-id2',
          user: User(
            id: 'user-id2',
            extraData: {
              'image': 'testimage',
            },
          ),
        ),
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        )
      ]);
      when(clientState.usersStream).thenAnswer((i) => Stream.value({
            'user-id2': User(
              id: 'user-id2',
              extraData: {
                'image': 'testimage',
              },
            ),
          }));
      when(channel.extraData).thenReturn({
        'name': 'test',
      });

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: ChannelImage(),
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

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(channel.state).thenReturn(channelState);
      when(channel.client).thenReturn(client);
      when(channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
          }));
      when(channel.extraData).thenReturn({
        'name': 'test',
      });
      when(channelState.membersStream).thenAnswer((i) => Stream.value([
            Member(
              userId: 'user-id',
              user: User(
                id: 'user-id',
                extraData: {
                  'image': 'testimage1',
                },
              ),
            ),
            Member(
              userId: 'user-id2',
              user: User(
                id: 'user-id2',
                extraData: {
                  'image': 'testimage2',
                },
              ),
            ),
            Member(
              userId: 'user-id3',
              user: User(
                id: 'user-id3',
                extraData: {
                  'image': 'testimage3',
                },
              ),
            ),
          ]));
      when(channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(
            id: 'user-id',
            extraData: {
              'image': 'testimage1',
            },
          ),
        ),
        Member(
          userId: 'user-id2',
          user: User(
            id: 'user-id2',
            extraData: {
              'image': 'testimage2',
            },
          ),
        ),
        Member(
          userId: 'user-id3',
          user: User(
            id: 'user-id3',
            extraData: {
              'image': 'testimage3',
            },
          ),
        ),
      ]);

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: ChannelImage(),
            ),
          ),
        ),
      ));

      final image = tester.widget<GroupImage>(find.byType(GroupImage));
      expect(image.images, [
        'testimage2',
        'testimage3',
      ]);
    },
  );

  testWidgets(
    'using select: true should show a selection border',
    (tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(channel.state).thenReturn(channelState);
      when(channel.client).thenReturn(client);
      when(channel.extraDataStream).thenAnswer((i) => Stream.value({
            'name': 'test',
            'image': 'imagetest',
          }));
      when(channel.extraData).thenReturn({
        'name': 'test',
        'image': 'imagetest',
      });

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: ChannelImage(
                selected: true,
              ),
            ),
          ),
        ),
      ));

      expect(find.byKey(Key('selectedImage')), findsOneWidget);
    },
  );
}
