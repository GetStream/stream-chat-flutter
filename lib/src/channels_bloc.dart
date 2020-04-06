import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

class ChannelsBloc {
  final Client client;

  ChannelsBloc(this.client);

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
        _queryChannelsLoadingController.addError(err, stackTrace);
      });
    } catch (err, stackTrace) {
      _queryChannelsLoadingController.addError(err, stackTrace);
    }
  }

  void dispose() {
    _channelsController.close();
    _queryChannelsLoadingController.close();
  }
}
