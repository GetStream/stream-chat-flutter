import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/channel_state', () {
    test('should parse json correctly', () {
      final channelState =
          ChannelState.fromJson(jsonFixture('channel_state.json'));
      expect(channelState.channel?.cid, 'team:dev');
      expect(channelState.channel?.id, 'dev');
      expect(channelState.channel?.team, 'test');
      expect(channelState.channel?.type, 'team');
      expect(channelState.channel?.config, isA<ChannelConfig>());
      expect(channelState.channel?.config, isNotNull);
      expect(channelState.channel?.config.commands, hasLength(1));
      expect(channelState.channel?.config.commands[0], isA<Command>());
      expect(channelState.channel?.lastMessageAt,
          DateTime.parse('2020-01-30T13:43:41.062362Z'));
      expect(channelState.channel?.createdAt,
          DateTime.parse('2019-04-03T18:43:33.213373Z'));
      expect(channelState.channel?.updatedAt,
          DateTime.parse('2019-04-03T18:43:33.213374Z'));
      expect(channelState.channel?.createdBy, isA<User>());
      expect(channelState.channel?.frozen, true);
      expect(channelState.channel?.extraData['example'], 1);
      expect(channelState.channel?.extraData['name'], '#dev');
      expect(
        channelState.channel?.extraData['image'],
        'https://cdn.chrisshort.net/testing-certificate-chains-in-go/GOPHER_MIC_DROP.png',
      );
      expect(channelState.messages, isNotNull);
      expect(channelState.messages, isNotEmpty);
      expect(channelState.messages, hasLength(25));
      expect(channelState.messages![0], isA<Message>());
      expect(channelState.messages![0], isNotNull);
      expect(
        channelState.messages![0].createdAt,
        DateTime.parse('2020-01-29T03:23:02.843948Z'),
      );
      expect(channelState.messages![0].user, isA<User>());
      expect(channelState.watcherCount, 5);
    });

    test('should serialize to json correctly', () {
      final j = jsonFixture('channel_state.json');
      final channelState = ChannelState(
        channel: ChannelModel.fromJson(j['channel']),
        members: [],
        messages: (j['messages'] as List<Map<String, dynamic>>)
            .map(Message.fromJson)
            .toList(),
        read: [],
        watcherCount: 5,
        pinnedMessages: [],
        watchers: [],
      );

      expect(
        channelState.toJson(),
        jsonFixture('channel_state_to_json.json'),
      );
    });
  });
}
