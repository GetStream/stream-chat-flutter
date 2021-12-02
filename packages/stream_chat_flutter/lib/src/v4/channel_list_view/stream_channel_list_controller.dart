import 'dart:async';

import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter/src/v4/channel_list_view/channel_event_handlers.dart';

/// The default channel page limit to load.
const defaultChannelPagedLimit = 10;

/// A controller for a Channel list.
///
/// This class lets you perform tasks such as:
/// * Load initial data.
/// * Use channel events handlers.
/// * Load more data using [loadMore].
/// * Replace the previously loaded channels.
/// * Return/Create a new channel and start watching it.
/// * Unsubscribe from all channel list events.
/// * Pause and Resume all subscriptions added to this composite.
class StreamChannelListController extends PagedValueNotifier<int, Channel> {
  /// Creates a Stream channel list controller.
  ///
  /// * `client` is the Stream chat client to use for the channels list.
  ///
  /// * `channelEventHandlers` is the channel events to use for the channels
  /// list. This class can be mixed in or extended to create custom overrides.
  /// See [ChannelEventHandlers] for advice.
  ///
  /// * `filter` is the query filters to use.
  ///
  /// * `sort` is the sorting used for the channels matching the filters.
  ///
  /// * `presence` sets whether you'll receive user presence updates via the
  /// websocket events.
  ///
  /// * `limit` is the limit to apply to the channel list.
  ///
  /// * `messageLimit` is the number of messages to fetch in each channel.
  ///
  /// * `memberLimit` is the number of members to fetch in each channel.
  StreamChannelListController({
    required this.client,
    ChannelEventHandlers? channelEventHandlers,
    this.filter,
    this.sort,
    this.presence = true,
    this.limit = defaultChannelPagedLimit,
    this.messageLimit,
    this.memberLimit,
  })  : _channelEventHandlers = channelEventHandlers ?? ChannelEventHandlers(),
        super(const PagedValue.loading());

  /// Creates a [StreamChannelListController] from the passed [value].
  StreamChannelListController.fromValue(
    PagedValue<int, Channel> value, {
    required this.client,
    ChannelEventHandlers? channelEventHandlers,
    this.filter,
    this.sort,
    this.presence = true,
    this.limit = defaultChannelPagedLimit,
    this.messageLimit,
    this.memberLimit,
  })  : _channelEventHandlers = channelEventHandlers ?? ChannelEventHandlers(),
        super(value);

  /// The channel events to use for the channels list.
  final ChannelEventHandlers _channelEventHandlers;

  /// The client to use for the channels list.
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

  /// The limit to apply to the channel list. The default is set to
  /// [defaultChannelPagedLimit].
  final int limit;

  /// Number of messages to fetch in each channel.
  final int? messageLimit;

  /// Number of members to fetch in each channel.
  final int? memberLimit;

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
      // start listening to events
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
        _channelEventHandlers.onChannelDeleted(event, this);
      } else if (eventType == EventType.channelHidden) {
        _channelEventHandlers.onChannelHidden(event, this);
      } else if (eventType == EventType.channelTruncated) {
        _channelEventHandlers.onChannelTruncated(event, this);
      } else if (eventType == EventType.channelUpdated) {
        _channelEventHandlers.onChannelUpdated(event, this);
      } else if (eventType == EventType.channelVisible) {
        _channelEventHandlers.onChannelVisible(event, this);
      } else if (eventType == EventType.connectionRecovered) {
        _channelEventHandlers.onConnectionRecovered(event, this);
      } else if (eventType == EventType.connectionChanged) {
        if (event.online != null) {
          _channelEventHandlers.onConnectionRecovered(event, this);
        }
      } else if (eventType == EventType.messageNew) {
        _channelEventHandlers.onMessageNew(event, this);
      } else if (eventType == EventType.notificationAddedToChannel) {
        _channelEventHandlers.onNotificationAddedToChannel(event, this);
      } else if (eventType == EventType.notificationMessageNew) {
        _channelEventHandlers.onNotificationMessageNew(event, this);
      } else if (eventType == EventType.notificationRemovedFromChannel) {
        _channelEventHandlers.onNotificationRemovedFromChannel(event, this);
      } else if (eventType == 'user.presence.changed' ||
          eventType == EventType.userUpdated) {
        _channelEventHandlers.onUserPresenceChanged(event, this);
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
