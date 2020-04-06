import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

class ChannelsBloc {
  final Client client;
  StreamSubscription _newMessagesSubscription;

  ChannelsBloc(this.client) {
    _newMessagesSubscription = client.on(EventType.messageNew).listen((e) {
      final newChannels = List<Channel>.from(channels ?? []);
      final index = newChannels.indexWhere((c) => c.cid == e.cid);
      if (index > 0) {
        final channel = newChannels.removeAt(index);
        newChannels.insert(0, channel);
        _channelsController.add(newChannels);
      }
    });
  }

  /// The current channel list
  List<Channel> get channels => _channelsController.value;

  /// The current channel list as a stream
  Stream<List<Channel>> get channelsStream => _channelsController.stream;

  final BehaviorSubject<bool> _queryChannelsLoadingController =
      BehaviorSubject.seeded(false);

  final BehaviorSubject<List<Channel>> _channelsController =
      BehaviorSubject.seeded([]);

  /// The stream notifying the state of queryChannel call
  Stream<bool> get queryChannelsLoading =>
      _queryChannelsLoadingController.stream;

  /// Calls [client.queryChannels] updating [queryChannelsLoading] stream
  Future<void> queryChannels({
    Map<String, dynamic> filter,
    List<SortOption> sortOptions,
    PaginationParams paginationParams,
    Map<String, dynamic> options,
    bool onlyOffline = false,
  }) async {
    if (_queryChannelsLoadingController.value == true) {
      return;
    }
    _queryChannelsLoadingController.sink.add(true);

    try {
      final clear = paginationParams == null ||
          paginationParams.offset == null ||
          paginationParams.offset == 0;
      final oldChannels = List<Channel>.from(channels);
      client
          .queryChannels(
        filter: filter,
        sort: sortOptions,
        options: options,
        paginationParams: paginationParams,
        onlyOffline: onlyOffline,
      )
          .listen((channels) {
        if (clear) {
          _channelsController.add(channels);
        } else {
          final l = oldChannels + channels;
          _channelsController.add(l);
        }
      }, onDone: () {
        _queryChannelsLoadingController.sink.add(false);
      }, onError: (err, stackTrace) {
        print(err);
        print(stackTrace);
        _queryChannelsLoadingController.addError(err, stackTrace);
      });
    } catch (err, stackTrace) {
      _queryChannelsLoadingController.addError(err, stackTrace);
    }
  }

  void dispose() {
    _channelsController.close();
    _queryChannelsLoadingController.close();
    _newMessagesSubscription.cancel();
  }
}
