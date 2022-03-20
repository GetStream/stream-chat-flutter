import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Determines at which point in the [MessageListView] the initial index should
/// be.
int getInitialIndex(
  int? initialScrollIndex,
  StreamChannelState channelState,
  bool Function(Message)? messageFilter,
) {
  if (initialScrollIndex != null) {
    return initialScrollIndex;
  }
  if (channelState.initialMessageId != null) {
    final messages = channelState.channel.state!.messages
        .where(messageFilter ??
            defaultMessageFilter(
              channelState.channel.client.state.currentUser!.id,
            ))
        .toList(growable: false);
    final totalMessages = messages.length;
    final messageIndex =
        messages.indexWhere((e) => e.id == channelState.initialMessageId);
    final index = totalMessages - messageIndex;
    if (index != 0) return index + 1;
    return index;
  }
  return 0;
}

/// TODO: document me
int? getTopElementIndex(Iterable<ItemPosition> values) {
  final inView = values.where((position) => position.itemLeadingEdge < 1);
  if (inView.isEmpty) return null;
  return inView
      .reduce((max, position) =>
          position.itemLeadingEdge > max.itemLeadingEdge ? position : max)
      .index;
}

/// TODO: document me
int? getBottomElementIndex(Iterable<ItemPosition> values) {
  final inView = values.where((position) => position.itemLeadingEdge < 1);
  if (inView.isEmpty) return null;
  return inView
      .reduce((min, position) =>
          position.itemLeadingEdge < min.itemLeadingEdge ? position : min)
      .index;
}

/// TODO: document me
bool isInitialMessage(String id, StreamChannelState? channelState) {
  return channelState!.initialMessageId == id;
}

/// Converts a [ValueListenable] to a [Stream].
Stream<T> valueListenableToStreamAdapter<T>(ValueListenable<T> listenable) {
  // ignore: close_sinks
  late StreamController<T> _controller;

  void listener() {
    _controller.add(listenable.value);
  }

  void start() {
    listenable.addListener(listener);
  }

  void end() {
    listenable.removeListener(listener);
  }

  _controller = StreamController<T>(
    onListen: start,
    onPause: end,
    onResume: start,
    onCancel: end,
  );

  return _controller.stream;
}
