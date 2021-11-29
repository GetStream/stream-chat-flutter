import 'dart:async';

import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter/src/v4/channel_list_view/stream_channel_list_event_handler.dart'
    as event_handler;

const defaultChannelPagedLimit = 10;

typedef ChannelListEventHandler = void Function(
  Event event,
  StreamChannelListController controller,
);

/// 
class StreamChannelListController extends PagedValueNotifier<int, Channel> {
  /// Creates a new instance of [StreamChannelListController].
  StreamChannelListController({
    required this.client,
    this.filter,
    this.sort,
    this.presence = true,
    this.limit = defaultChannelPagedLimit,
    this.messageLimit,
    this.memberLimit,
    this.onChannelDeleted = event_handler.onChannelDeleted,
    this.onChannelHidden = event_handler.onChannelHidden,
    this.onChannelTruncated = event_handler.onChannelTruncated,
    this.onChannelUpdated = event_handler.onChannelUpdated,
    this.onChannelVisible = event_handler.onChannelVisible,
    this.onConnectionRecovered = event_handler.onConnectionRecovered,
    this.onMessageNew = event_handler.onMessageNew,
    this.onNotificationAddedToChannel =
        event_handler.onNotificationAddedToChannel,
    this.onNotificationMessageNew = event_handler.onNotificationMessageNew,
    this.onNotificationRemovedFromChannel =
        event_handler.onNotificationRemovedFromChannel,
    this.onUserPresenceChanged = event_handler.onUserPresenceChanged,
  }) : super(const PagedValue.loading());

  /// Creates a [StreamChannelListController] from the passed [value].
  StreamChannelListController.fromValue(
    PagedValue<int, Channel> value, {
    required this.client,
    this.filter,
    this.sort,
    this.presence = true,
    this.limit = defaultChannelPagedLimit,
    this.messageLimit,
    this.memberLimit,
    this.onChannelDeleted = event_handler.onChannelDeleted,
    this.onChannelHidden = event_handler.onChannelHidden,
    this.onChannelTruncated = event_handler.onChannelTruncated,
    this.onChannelUpdated = event_handler.onChannelUpdated,
    this.onChannelVisible = event_handler.onChannelVisible,
    this.onConnectionRecovered = event_handler.onConnectionRecovered,
    this.onMessageNew = event_handler.onMessageNew,
    this.onNotificationAddedToChannel =
        event_handler.onNotificationAddedToChannel,
    this.onNotificationMessageNew = event_handler.onNotificationMessageNew,
    this.onNotificationRemovedFromChannel =
        event_handler.onNotificationRemovedFromChannel,
    this.onUserPresenceChanged = event_handler.onUserPresenceChanged,
  }) : super(value);

  /// The client to use for the channel list.
  final StreamChatClient client;

  /// The query filters to use.
  /// You can query on any of the custom fields you've defined on the [Channel].
  /// You can also filter other built-in channel fields.
  final Filter? filter;

  /// The sorting used for the channels matching the filters.
  /// Sorting is based on field and direction, multiple sorting options
  /// can be provided.
  /// You can sort based on last_updated, last_message_at, updated_at,
  /// created_at or member_count.
  /// Direction can be ascending or descending.
  final List<SortOption<ChannelModel>>? sort;

  /// If true you’ll receive user presence updates via the websocket events
  final bool presence;

  /// The limit to apply to the channel list.
  final int limit;

  /// Number of members to fetch in each channel
  final int? memberLimit;

  /// Number of messages to fetch in each channel
  final int? messageLimit;

  /// Callback function which gets called for the event
  /// [EventType.channelDeleted].
  ///
  /// By default, calls [event_handler.onChannelDeleted]
  /// with the [Event] and the [StreamChannelListController].
  final ChannelListEventHandler onChannelDeleted;

  /// Callback function which gets called for the event
  /// [EventType.channelHidden].
  ///
  /// By default, calls [event_handler.onChannelHidden]
  /// with the [Event] and the [StreamChannelListController].
  final ChannelListEventHandler onChannelHidden;

  /// Callback function which gets called for the event
  /// [EventType.channelTruncated].
  ///
  /// By default, calls [event_handler.onChannelTruncated]
  /// with the [Event] and the [StreamChannelListController].
  final ChannelListEventHandler onChannelTruncated;

  /// Callback function which gets called for the event
  /// [EventType.channelUpdated].
  ///
  /// By default, calls [event_handler.onChannelUpdated]
  /// with the [Event] and the [StreamChannelListController].
  final ChannelListEventHandler onChannelUpdated;

  /// Callback function which gets called for the event
  /// [EventType.channelVisible].
  ///
  /// By default, calls [event_handler.onChannelVisible]
  /// with the [Event] and the [StreamChannelListController].
  final ChannelListEventHandler onChannelVisible;

  /// Callback function which gets called for the event
  /// [EventType.connectionRecovered].
  ///
  /// By default, calls [event_handler.onConnectionRecovered]
  /// with the [Event] and the [StreamChannelListController].
  final ChannelListEventHandler onConnectionRecovered;

  /// Callback function which gets called for the event [EventType.messageNew].
  ///
  /// By default, calls [event_handler.onMessageNew]
  /// with the [Event] and the [StreamChannelListController].
  final ChannelListEventHandler onMessageNew;

  /// Callback function which gets called for the event
  /// [EventType.notificationAddedToChannel].
  ///
  /// By default, calls [event_handler.onNotificationAddedToChannel]
  /// with the [Event] and the [StreamChannelListController].
  final ChannelListEventHandler onNotificationAddedToChannel;

  /// Callback function which gets called for the event
  /// [EventType.notificationMessageNew].
  ///
  /// By default, calls [event_handler.onNotificationMessageNew]
  /// with the [Event] and the [StreamChannelListController].
  final ChannelListEventHandler onNotificationMessageNew;

  /// Callback function which gets called for the event
  /// [EventType.notificationRemovedFromChannel].
  ///
  /// By default, calls [event_handler.onNotificationRemovedFromChannel]
  /// with the [Event] and the [StreamChannelListController].
  final ChannelListEventHandler onNotificationRemovedFromChannel;

  /// Callback function which gets called for the event
  /// 'user.presence.changed' and [EventType.userUpdated].
  ///
  /// By default, calls [event_handler.onUserPresenceChanged]
  /// with the [Event] and the [StreamChannelListController].
  final ChannelListEventHandler onUserPresenceChanged;

  @override
  Future<void> doInitialLoad() async {
    final limit = this.limit * defaultInitialPagedLimitMultiplier;
    try {
      await for (final channels in client.queryChannels(
        filter: filter,
        sort: sort,
        memberLimit: memberLimit,
        messageLimit: messageLimit,
        presence: presence,
        paginationParams: PaginationParams(limit: limit),
      )) {
        final nextKey = channels.length < limit ? null : channels.length;
        value = PagedValue(
          items: channels,
          nextPageKey: nextKey,
        );
      }
      // start listening events
      _subscribeToChannelListEvents();
    } on StreamChatError catch (error) {
      value = PagedValue.error(error);
    } catch (error) {
      final chatError = StreamChatError(error.toString());
      value = PagedValue.error(chatError);
    }
  }

  @override
  Future<void> loadMore(int nextPageKey) async {
    final previousValue = value.asSuccess;

    try {
      await for (final channels in client.queryChannels(
        filter: filter,
        sort: sort,
        memberLimit: memberLimit,
        messageLimit: messageLimit,
        presence: presence,
        paginationParams: PaginationParams(limit: limit, offset: nextPageKey),
      )) {
        final previousItems = previousValue.items;
        final newItems = previousItems + channels;
        final nextKey = channels.length < limit ? null : newItems.length;
        value = PagedValue(
          items: newItems,
          nextPageKey: nextKey,
        );
      }
    } on StreamChatError catch (error) {
      value = previousValue.copyWith(error: error);
    } catch (error) {
      final chatError = StreamChatError(error.toString());
      value = previousValue.copyWith(error: chatError);
    }
  }

  /// Replaces the previously loaded channels with [channels] and updates
  /// the nextPageKey.
  set channels(List<Channel> channels) {
    value = PagedValue(
      items: channels,
      nextPageKey: channels.length,
    );
  }

  /// Returns/Creates a new Channel and starts watching it.
  Future<Channel> getChannel({
    required String id,
    required String type,
  }) async {
    final channel = client.channel(type, id: id);
    await channel.watch();
    return channel;
  }

  StreamSubscription<Event>? _channelEventSubscription;

  // Subscribes to the channel list events.
  void _subscribeToChannelListEvents() {
    if (_channelEventSubscription != null) {
      _unsubscribeFromChannelListEvents();
    }

    _channelEventSubscription = client.on().listen((event) {
      final eventType = event.type;
      if (eventType == EventType.channelDeleted) {
        onChannelDeleted(event, this);
      } else if (eventType == EventType.channelHidden) {
        onChannelHidden(event, this);
      } else if (eventType == EventType.channelTruncated) {
        onChannelTruncated(event, this);
      } else if (eventType == EventType.channelUpdated) {
        onChannelUpdated(event, this);
      } else if (eventType == EventType.channelVisible) {
        onChannelVisible(event, this);
      } else if (eventType == EventType.connectionRecovered) {
        onConnectionRecovered(event, this);
      } else if (eventType == EventType.connectionChanged) {
        if (event.online != null) onConnectionRecovered(event, this);
      } else if (eventType == EventType.messageNew) {
        onMessageNew(event, this);
      } else if (eventType == EventType.notificationAddedToChannel) {
        onNotificationAddedToChannel(event, this);
      } else if (eventType == EventType.notificationMessageNew) {
        onNotificationMessageNew(event, this);
      } else if (eventType == EventType.notificationRemovedFromChannel) {
        onNotificationRemovedFromChannel(event, this);
      } else if (eventType == 'user.presence.changed' ||
          eventType == EventType.userUpdated) {
        onUserPresenceChanged(event, this);
      }
    });
  }

  // Unsubscribes from all channel list events.
  void _unsubscribeFromChannelListEvents() {
    if (_channelEventSubscription != null) {
      _channelEventSubscription!.cancel();
      _channelEventSubscription = null;
    }
  }

  /// Pauses all subscriptions added to this composite.
  void pauseEventsSubscription([Future<void>? resumeSignal]) {
    _channelEventSubscription?.pause(resumeSignal);
  }

  /// Resumes all subscriptions added to this composite.
  void resumeEventsSubscription() {
    _channelEventSubscription?.resume();
  }

  @override
  void dispose() {
    _unsubscribeFromChannelListEvents();
    super.dispose();
  }
}
