import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/stream_channel_list_event_handler.dart';

import 'mocks.dart';

void main() {
  group('when the message is in a channel the refreshed list leaves out', () {
    test('refreshes the list once for many messages', () {
      fakeAsync((async) {
        final list = _FakeChannelList([_mockChannel('messaging:listed')]);
        final handler = StreamChannelListEventHandler();

        for (var i = 0; i < 20; i++) {
          _receiveMessage(async, handler, list, 'livestream:excluded');
        }

        expect(list.refreshCount, 1);
      });
    });

    test('refreshes the list again once the backoff has passed', () {
      fakeAsync((async) {
        final list = _FakeChannelList([_mockChannel('messaging:listed')]);
        final handler = StreamChannelListEventHandler();

        _receiveMessage(async, handler, list, 'livestream:excluded');
        async.elapse(const Duration(seconds: 30));
        _receiveMessage(async, handler, list, 'livestream:excluded');

        expect(list.refreshCount, 2);
      });
    });

    test('doubles the backoff after each refresh that still leaves the channel out', () {
      fakeAsync((async) {
        final list = _FakeChannelList([_mockChannel('messaging:listed')]);
        final handler = StreamChannelListEventHandler();

        _receiveMessage(async, handler, list, 'livestream:excluded');
        async.elapse(const Duration(seconds: 30));
        _receiveMessage(async, handler, list, 'livestream:excluded');
        async.elapse(const Duration(seconds: 59));
        _receiveMessage(async, handler, list, 'livestream:excluded');
        final refreshCountWithinBackoff = list.refreshCount;
        async.elapse(const Duration(seconds: 1));
        _receiveMessage(async, handler, list, 'livestream:excluded');

        expect(refreshCountWithinBackoff, 2);
        expect(list.refreshCount, 3);
      });
    });

    test('caps the backoff at 10 minutes', () {
      fakeAsync((async) {
        final list = _FakeChannelList([_mockChannel('messaging:listed')]);
        final handler = StreamChannelListEventHandler();

        // The backoff grows 30 s → 1 → 2 → 4 → 8 min; without the cap the sixth
        // refresh would back off 16 minutes and skip the seventh message.
        for (var i = 0; i < 7; i++) {
          _receiveMessage(async, handler, list, 'livestream:excluded');
          async.elapse(const Duration(minutes: 10));
        }

        expect(list.refreshCount, 7);
      });
    });

    test('still refreshes the list for a message in another missing channel', () {
      fakeAsync((async) {
        final list = _FakeChannelList([_mockChannel('messaging:listed')]);
        final handler = StreamChannelListEventHandler();

        _receiveMessage(async, handler, list, 'livestream:excluded');
        _receiveMessage(async, handler, list, 'messaging:other');

        expect(list.refreshCount, 2);
      });
    });

    test('refreshes the list again after the connection recovers', () {
      fakeAsync((async) {
        final list = _FakeChannelList([_mockChannel('messaging:listed')]);
        final handler = StreamChannelListEventHandler();

        _receiveMessage(async, handler, list, 'livestream:excluded');
        handler.onConnectionRecovered(Event(type: EventType.connectionRecovered), list.controller);
        _receiveMessage(async, handler, list, 'livestream:excluded');

        expect(list.refreshCount, 2);
      });
    });
  });

  test('refreshes the list for a channel that was listed and then removed', () {
    fakeAsync((async) {
      final listed = _mockChannel('messaging:listed');
      final hidden = _mockChannel('messaging:hidden');
      final list = _FakeChannelList([listed], channelsAfterRefresh: [hidden, listed]);
      final handler = StreamChannelListEventHandler();

      _receiveMessage(async, handler, list, 'messaging:hidden');
      list.items = [listed];
      _receiveMessage(async, handler, list, 'messaging:hidden');

      expect(list.refreshCount, 2);
    });
  });

  test('refreshes the list for a backed-off channel that was listed in the meantime and then removed', () {
    fakeAsync((async) {
      final listed = _mockChannel('messaging:listed');
      final hidden = _mockChannel('messaging:hidden');
      final list = _FakeChannelList([listed]);
      final handler = StreamChannelListEventHandler();

      _receiveMessage(async, handler, list, 'messaging:hidden');
      list.items = [hidden, listed];
      _receiveMessage(async, handler, list, 'messaging:hidden');
      list.items = [listed];
      _receiveMessage(async, handler, list, 'messaging:hidden');

      expect(list.refreshCount, 2);
    });
  });

  test('shares one trailing refresh between messages arriving while a refresh runs', () async {
    final list = _FakeChannelList([_mockChannel('messaging:listed')], completeRefreshesManually: true);
    final handler = StreamChannelListEventHandler();

    for (final cid in ['messaging:first', 'messaging:second', 'messaging:third']) {
      handler.onMessageNew(_messageNew(cid), list.controller);
    }
    await pumpEventQueue();
    list.completeRefresh();
    await pumpEventQueue();
    list.completeRefresh();
    await pumpEventQueue();

    expect(list.refreshCount, 2);
  });
}

// Delivers a `message.new` event for [cid] and lets the handler finish with it.
void _receiveMessage(
  FakeAsync async,
  StreamChannelListEventHandler handler,
  _FakeChannelList list,
  String cid,
) {
  handler.onMessageNew(_messageNew(cid), list.controller);
  async.flushMicrotasks();
}

Event _messageNew(String cid) => Event(type: EventType.messageNew, cid: cid);

MockChannel _mockChannel(String cid) {
  final channel = MockChannel();
  when(() => channel.cid).thenReturn(cid);
  return channel;
}

// A mocked channel list whose items change only when the test says so, and
// which counts the refreshes it is asked for.
class _FakeChannelList {
  _FakeChannelList(
    this.items, {
    List<Channel>? channelsAfterRefresh,
    bool completeRefreshesManually = false,
  }) {
    when(() => controller.currentItems).thenAnswer((_) => items);
    when(controller.refresh).thenAnswer((_) async {});
    when(() => controller.refresh(resetValue: false)).thenAnswer((_) {
      refreshCount += 1;
      if (completeRefreshesManually) {
        final completer = Completer<void>();
        _pendingRefreshes.add(completer);
        return completer.future;
      }
      if (channelsAfterRefresh != null) items = channelsAfterRefresh;
      return Future.value();
    });
  }

  final controller = MockStreamChannelListController();
  final _pendingRefreshes = <Completer<void>>[];
  List<Channel> items;
  int refreshCount = 0;

  void completeRefresh() => _pendingRefreshes.removeAt(0).complete();
}
