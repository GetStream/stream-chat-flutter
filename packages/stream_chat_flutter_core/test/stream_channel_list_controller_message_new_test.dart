import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/stream_channel_list_controller.dart';

import 'mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const PaginationParams());
  });

  test('queries channels once for a burst of messages in a watched channel the filter excludes', () async {
    final client = MockClient();
    final events = StreamController<Event>.broadcast();
    addTearDown(events.close);
    when(client.on).thenAnswer((_) => events.stream);
    _stubQueryChannels(client, channels: [_mockChannel('messaging:listed')]);
    final controller = StreamChannelListController(client: client, channelStateSort: null);
    addTearDown(controller.dispose);
    await controller.doInitialLoad();
    clearInteractions(client);

    for (var i = 0; i < 50; i++) {
      events.add(Event(type: EventType.messageNew, cid: 'livestream:excluded'));
      await pumpEventQueue();
    }

    verify(
      () => client.queryChannelsWithResult(
        filter: any(named: 'filter'),
        channelStateSort: any(named: 'channelStateSort'),
        predefinedFilter: any(named: 'predefinedFilter'),
        filterValues: any(named: 'filterValues'),
        sortValues: any(named: 'sortValues'),
        memberLimit: any(named: 'memberLimit'),
        messageLimit: any(named: 'messageLimit'),
        presence: any(named: 'presence'),
        paginationParams: any(named: 'paginationParams'),
      ),
    ).called(1);
  });
}

MockChannel _mockChannel(String cid) {
  final channel = MockChannel();
  when(() => channel.cid).thenReturn(cid);
  return channel;
}

void _stubQueryChannels(MockClient client, {required List<Channel> channels}) {
  when(
    () => client.queryChannelsWithResult(
      filter: any(named: 'filter'),
      channelStateSort: any(named: 'channelStateSort'),
      predefinedFilter: any(named: 'predefinedFilter'),
      filterValues: any(named: 'filterValues'),
      sortValues: any(named: 'sortValues'),
      memberLimit: any(named: 'memberLimit'),
      messageLimit: any(named: 'messageLimit'),
      presence: any(named: 'presence'),
      paginationParams: any(named: 'paginationParams'),
    ),
  ).thenAnswer((_) => Stream.value(QueryChannelsResult(channels: channels)));
}
