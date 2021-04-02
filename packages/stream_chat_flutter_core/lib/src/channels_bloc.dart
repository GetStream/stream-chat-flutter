import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/channel_list_core.dart';
import 'package:stream_chat_flutter_core/src/stream_chat_core.dart';

/// Widget dedicated to the management of a channel list with pagination
/// [ChannelsBloc] is used together with [ChannelListCore] to manage a list of
/// [Channel]s with pagination, re-ordering, querying and other operations
/// associated with [Channel]s.
///
/// [ChannelsBloc] can be access at anytime by using the static [of] method
/// using Flutter's [BuildContext].
///
/// API docs: https://getstream.io/chat/docs/flutter-dart/query_channels/
class ChannelsBloc extends StatefulWidget {
  /// Creates a new [ChannelsBloc]. The parameter [child] must be supplied and
  /// not null.
  const ChannelsBloc({
    Key key,
    @required this.child,
    this.lockChannelsOrder = false,
    this.channelsComparator,
    this.shouldAddChannel,
  })  : assert(child != null, 'Parameter child should not be null.'),
        super(key: key);

  /// The widget child
  final Widget child;

  /// Set this to true to prevent channels to be brought to the top of the list
  /// when a new message arrives
  final bool lockChannelsOrder;

  /// Comparator used to sort the channels when a message.new event is received
  final Comparator<Channel> channelsComparator;

  /// Function used to evaluate if a channel should be added to the list when a
  /// message.new event is received
  final bool Function(Event) shouldAddChannel;

  @override
  ChannelsBlocState createState() => ChannelsBlocState();

  /// Use this method to get the current [ChannelsBlocState] instance
  static ChannelsBlocState of(BuildContext context) {
    ChannelsBlocState streamChatState;

    streamChatState = context.findAncestorStateOfType<ChannelsBlocState>();

    if (streamChatState == null) {
      throw Exception('You must have a ChannelsBloc widget as ancestor');
    }

    return streamChatState;
  }
}

/// The current state of the [ChannelsBloc].
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

  final _queryChannelsLoadingController = BehaviorSubject.seeded(false);

  final _channelsController = BehaviorSubject<List<Channel>>();

  /// The stream notifying the state of queryChannel call
  Stream<bool> get queryChannelsLoading =>
      _queryChannelsLoadingController.stream;

  final List<Channel> _hiddenChannels = [];

  bool _paginationEnded = false;

  /// Calls [client.queryChannels] updating [queryChannelsLoading] stream
  Future<void> queryChannels({
    Map<String, dynamic> filter,
    List<SortOption<ChannelModel>> sortOptions,
    PaginationParams paginationParams,
    Map<String, dynamic> options,
  }) async {
    final client = StreamChatCore.of(context).client;

    if (_paginationEnded || _queryChannelsLoadingController.value == true) {
      return;
    }

    if (_channelsController.hasValue) {
      _queryChannelsLoadingController.add(true);
    }

    try {
      final clear = paginationParams == null ||
          paginationParams.offset == null ||
          paginationParams.offset == 0;
      final oldChannels = List<Channel>.from(channels ?? []);
      var newChannels = <Channel>[];
      await for (final channels in client.queryChannels(
        filter: filter,
        sort: sortOptions,
        options: options,
        paginationParams: paginationParams,
      )) {
        newChannels = channels;
        if (clear) {
          _channelsController.add(channels);
        } else {
          final temp = oldChannels + channels;
          _channelsController.add(temp);
        }
        if (_channelsController.hasValue &&
            _queryChannelsLoadingController.value) {
          _queryChannelsLoadingController.sink.add(false);
        }
      }
      if (newChannels.isEmpty || newChannels.length < paginationParams.limit) {
        _paginationEnded = true;
      }
    } catch (e, stk) {
      if (_channelsController.hasValue) {
        _queryChannelsLoadingController.addError(e, stk);
      } else {
        _channelsController.addError(e, stk);
      }
    }
  }

  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();

    final client = StreamChatCore.of(context).client;

    if (!widget.lockChannelsOrder) {
      _subscriptions.add(client.on(EventType.messageNew).listen((e) {
        final newChannels = List<Channel>.from(channels ?? []);
        final index = newChannels.indexWhere((c) => c.cid == e.cid);
        if (index != -1) {
          if (index > 0) {
            final channel = newChannels.removeAt(index);
            newChannels.insert(0, channel);
          }
        } else if (widget.shouldAddChannel?.call(e) == true) {
          final hiddenIndex = _hiddenChannels.indexWhere((c) => c.cid == e.cid);
          if (hiddenIndex != -1) {
            newChannels.insert(0, _hiddenChannels[hiddenIndex]);
            _hiddenChannels.removeAt(hiddenIndex);
          } else {
            if (client.state?.channels != null &&
                client.state?.channels[e.cid] != null) {
              newChannels.insert(0, client.state.channels[e.cid]);
            }
          }
        }

        if (widget.channelsComparator != null) {
          newChannels.sort(widget.channelsComparator);
        }
        _channelsController.add(newChannels);
      }));
    }

    _subscriptions.add(client.on(EventType.channelHidden).listen((event) async {
      final newChannels = List<Channel>.from(channels ?? []);
      final channelIndex = newChannels.indexWhere((c) => c.cid == event.cid);
      if (channelIndex > -1) {
        final channel = newChannels.removeAt(channelIndex);
        _hiddenChannels.add(channel);
        _channelsController.add(newChannels);
      }
    }));
    // ignore: cascade_invocations
    _subscriptions.add(client
        .on(
      EventType.channelDeleted,
      EventType.notificationRemovedFromChannel,
    )
        .listen((e) {
      // ignore: cascade_invocations
      final channel = e.channel;
      _channelsController.add(List.from(
          (channels ?? [])..removeWhere((c) => c.cid == channel.cid)));
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
