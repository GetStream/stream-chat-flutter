import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';

class StreamChannel extends InheritedWidget {
  final ChannelClient channelClient;

  ChannelState get channelState => channelClient.state.channelState;
  Stream<ChannelState> get channelStateStream =>
      channelClient.state.channelStateStream;

  StreamChannel({
    Key key,
    @required Widget child,
    @required this.channelClient,
  }) : super(
          key: key,
          child: child,
        );

  final BehaviorSubject<bool> _queryMessageController = BehaviorSubject();

  Stream<bool> get queryMessage => _queryMessageController.stream;

  void queryMessages() {
    _queryMessageController.add(true);

    String firstId;
    if (channelState.messages.isNotEmpty) {
      firstId = channelState.messages.first.id;
    }

    channelClient
        .query(
      messagesPagination: PaginationParams(
        lessThan: firstId,
        limit: 100,
      ),
    )
        .then((res) {
      _queryMessageController.add(false);
    }).catchError((e, stack) {
      _queryMessageController.addError(e, stack);
    });
  }

  Future<void> getReplies(String parentId) async {
    _queryMessageController.add(true);

    String firstId;
    if (channelClient.state.threads.containsKey(parentId)) {
      firstId = channelClient.state.threads[parentId].first.id;
    }

    return channelClient
        .getReplies(
      parentId,
      PaginationParams(
        lessThan: firstId,
        limit: 100,
      ),
    )
        .then((res) {
      _queryMessageController.add(false);
    }).catchError((e, stack) {
      _queryMessageController.addError(e, stack);
    });
  }

  void dispose() {
    _queryMessageController.close();
    channelClient.dispose();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static StreamChannel of(BuildContext context, [bool listen = false]) {
    StreamChannel streamChannel;

    if (listen) {
      streamChannel =
          context.dependOnInheritedWidgetOfExactType<StreamChannel>();
    } else {
      streamChannel = context.findAncestorWidgetOfExactType<StreamChannel>();
    }

    if (streamChannel == null) {
      throw Exception(
          'You must have a StreamChannel widget at the top of your widget tree');
    }

    return streamChannel;
  }
}
