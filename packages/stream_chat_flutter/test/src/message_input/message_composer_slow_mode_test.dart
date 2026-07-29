import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:record/record.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  final originalRecordPlatform = RecordPlatform.instance;
  setUp(() => RecordPlatform.instance = FakeRecordPlatform());
  tearDown(() => RecordPlatform.instance = originalRecordPlatform);

  goldenTest(
    'slow mode active',
    fileName: 'message_composer_slow_mode',
    constraints: const BoxConstraints.tightFor(width: 400, height: 120),
    builder: () {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => clientState.currentUserStream).thenAnswer((_) => Stream.value(OwnUser(id: 'user-id')));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.lastMessageAtStream).thenAnswer((_) => Stream.value(lastMessageAt));
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(channel.getRemainingCooldown).thenReturn(10);
      when(
        () => channel.getRemainingCooldown(lastMessageAt: any(named: 'lastMessageAt')),
      ).thenReturn(10);
      when(() => channel.currentUserLastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.currentUserLastMessageAtStream).thenAnswer((_) => Stream.value(lastMessageAt));
      when(() => channel.isMuted).thenReturn(false);
      when(() => channel.isMutedStream).thenAnswer((_) => Stream.value(false));
      when(() => channel.isPinned).thenReturn(false);
      when(() => channel.isPinnedStream).thenAnswer((_) => Stream.value(false));
      when(() => channel.isDistinct).thenReturn(false);
      when(() => channel.extraDataStream).thenAnswer((_) => Stream.value({'name': 'test'}));
      when(() => channel.extraData).thenReturn({'name': 'test'});
      when(() => channel.name).thenReturn('test');
      when(() => channel.nameStream).thenAnswer((_) => Stream.value('test'));
      when(() => channel.image).thenReturn(null);
      when(() => channel.imageStream).thenAnswer((_) => Stream.value(null));
      when(() => channelState.membersStream).thenAnswer(
        (_) => Stream.value([
          Member(
            userId: 'user-id',
            user: User(id: 'user-id'),
          ),
        ]),
      );
      when(() => channelState.members).thenReturn([
        Member(
          userId: 'user-id',
          user: User(id: 'user-id'),
        ),
      ]);
      when(() => channelState.messages).thenReturn([]);
      when(() => channelState.messagesStream).thenAnswer((_) => Stream.value([]));
      when(() => channelState.draft).thenReturn(null);
      when(() => channelState.draftStream).thenAnswer((_) => Stream.value(null));
      when(() => channelState.pinnedMessages).thenReturn([]);
      when(() => channelState.pinnedMessagesStream).thenAnswer((_) => Stream.value([]));
      when(() => channelState.read).thenReturn([]);
      when(() => channelState.readStream).thenAnswer((_) => Stream.value([]));
      when(() => channelState.currentUserReadStream).thenAnswer((_) => Stream.value(null));
      when(() => channelState.channelState).thenReturn(const ChannelState());
      when(() => channelState.channelStateStream).thenAnswer((_) => Stream.value(const ChannelState()));

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamChat(
          client: client,
          connectivityStream: Stream.value([ConnectivityResult.mobile]),
          child: StreamChannel(
            channel: channel,
            child: Scaffold(
              body: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  StreamMessageComposer(),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
