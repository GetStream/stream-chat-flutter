import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

class StreamChat extends InheritedWidget {
  final Client client;
  final List<StreamSubscription> _subscriptions = [];

  StreamChat({
    Key key,
    @required this.client,
    @required Widget child,
  }) : super(
          key: key,
          child: child,
        ) {
    _subscriptions.add(client.on('message.new').listen((Event e) {
      final index = channels.indexWhere((c) => c.channel.cid == e.cid);
      if (index > 0) {
        final channel = channels.removeAt(index);
        channels.insert(0, channel);
        _channelsController.add(channels);
      }
    }));
  }

  User get user => _userController.value;

  Stream<User> get userStream => _userController.stream;
  final BehaviorSubject<User> _userController = BehaviorSubject();

  Future<void> setUser(User newUser, [String token]) async {
    _userController.sink.add(null);

    try {
      if (token != null) {
        await client.setUser(newUser, token);
      } else {
        await client.setUserWithProvider(newUser);
      }
      _userController.sink.add(newUser);
    } catch (e, stack) {
      _userController.sink.addError(e, stack);
    }
  }

  Stream<List<ChannelState>> get channelsStream => _channelsController.stream;
  final BehaviorSubject<List<ChannelState>> _channelsController =
      BehaviorSubject();
  final List<ChannelState> channels = [];

  final BehaviorSubject<bool> _queryChannelsLoadingController =
      BehaviorSubject.seeded(false);

  Stream<bool> get queryChannelsLoading =>
      _queryChannelsLoadingController.stream;

  Future<void> queryChannels({
    Map<String, dynamic> filter,
    List<SortOption> sortOptions,
    PaginationParams paginationParams,
    Map<String, dynamic> options,
  }) async {
    if (_queryChannelsLoadingController.value) {
      return;
    }
    _queryChannelsLoadingController.sink.add(true);

    try {
      final res = await client.queryChannels(
        filter: filter,
        sort: sortOptions,
        options: options,
        paginationParams: paginationParams,
      );
      channels.addAll(res.map((c) => c.state.channelState));
      _channelsController.sink.add(channels);
      _queryChannelsLoadingController.sink.add(false);
    } catch (e) {
      _channelsController.sink.addError(e);
    }
  }

  void clearChannels() {
    channels.clear();
  }

  void dispose() {
    client.dispose();
    _subscriptions.forEach((s) => s.cancel());
    _userController.close();
    _queryChannelsLoadingController.close();
    _channelsController.close();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static StreamChat of(BuildContext context, [bool listen = false]) {
    StreamChat streamChat;

    if (listen) {
      streamChat = context.dependOnInheritedWidgetOfExactType<StreamChat>();
    } else {
      streamChat = context.findAncestorWidgetOfExactType<StreamChat>();
    }

    if (streamChat == null) {
      throw Exception(
          'You must have a StreamChat widget at the top of your widget tree');
    }

    return streamChat;
  }
}
