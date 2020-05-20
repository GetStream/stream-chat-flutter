import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';

/// Widget dedicated to the management of a channel list with pagination
class ChannelsBloc extends StatefulWidget {
  /// The widget child
  final Widget child;

  /// Instantiate a new ChannelsBloc
  const ChannelsBloc({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  ChannelsBlocState createState() => ChannelsBlocState();

  /// Use this method to get the current [ChannelsBlocState] instance
  static ChannelsBlocState of(BuildContext context) {
    ChannelsBlocState streamChatState;

    streamChatState = context.findAncestorStateOfType<ChannelsBlocState>();

    if (streamChatState == null) {
      throw Exception('You must have a ChannelsBloc widget as anchestor');
    }

    return streamChatState;
  }
}

/// The current state of the [ChannelsBloc]
class ChannelsBlocState extends State<ChannelsBloc>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
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
      StreamChat.of(context)
          .client
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

  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();

    final client = StreamChat.of(context).client;

    _subscriptions.add(client.on(EventType.messageNew).listen((e) {
      final newChannels = List<Channel>.from(channels ?? []);
      final index = newChannels.indexWhere((c) => c.cid == e.cid);
      if (index > 0) {
        final channel = newChannels.removeAt(index);
        newChannels.insert(0, channel);
        _channelsController.add(newChannels);
      }
    }));

    _subscriptions.add(client.on(EventType.channelDeleted).listen((e) {
      final channel = e.channel;
      _channelsController
          .add(List.from(channels..removeWhere((c) => c.cid == channel.cid)));
    }));

    _subscriptions
        .add(client.on(EventType.notificationAddedToChannel).listen((e) async {
      final channelModel = e.channel;
      final channel = Channel(
        client,
        channelModel.type,
        channelModel.id,
        channelModel.extraData,
      );
      await channel.watch();
      _channelsController.add(List.from(channels..insert(0, channel)));
    }));

    _subscriptions.add(
        client.on(EventType.notificationRemovedFromChannel).listen((e) async {
      final channelModel = e.channel;
      _channelsController.add(
          List.from(channels..removeWhere((c) => c.cid == channelModel.cid)));
    }));
  }

  @override
  void dispose() {
    _channelsController.close();
    _queryChannelsLoadingController.close();
    _subscriptions.forEach((s) => s.cancel());
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
