import 'dart:async';
import 'dart:math';

import 'package:stream_chat/stream_chat.dart' hide Success;
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';

import 'package:stream_chat_flutter_core/src/stream_channel_list_event_handler.dart';

/// The default channel page limit to load.
const defaultChannelPagedLimit = 10;

const _kDefaultBackendPaginationLimit = 30;

/// A controller for a Channel list.
///
/// This class lets you perform tasks such as:
/// * Load initial data.
/// * Use channel events handlers.
/// * Load more data using [loadMore].
/// * Replace the previously loaded channels.
/// * Return/Create a new channel and start watching it.
/// * Pause and Resume all subscriptions added to this composite.
class StreamChannelListController extends PagedValueNotifier<int, Channel> {
  /// Creates a Stream channel list controller.
  ///
  /// * `client` is the Stream chat client to use for the channels list.
  ///
  /// * `channelEventHandlers` is the channel events to use for the channels
  /// list. This class can be mixed in or extended to create custom overrides.
  /// See [StreamChannelListEventHandler] for advice.
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
    StreamChannelListEventHandler? eventHandler,
    this.filter,
    @Deprecated('''
    sort has been deprecated. 
    Please use channelStateSort instead.''') this.sort,
    this.channelStateSort,
    this.presence = true,
    this.limit = defaultChannelPagedLimit,
    this.messageLimit,
    this.memberLimit,
  })  : _eventHandler = eventHandler ?? StreamChannelListEventHandler(),
        super(const PagedValue.loading());

  /// Creates a [StreamChannelListController] from the passed [value].
  StreamChannelListController.fromValue(
    super.value, {
    required this.client,
    StreamChannelListEventHandler? eventHandler,
    this.filter,
    this.channelStateSort,
    @Deprecated('''
    sort has been deprecated. 
    Please use channelStateSort instead.''') this.sort,
    this.presence = true,
    this.limit = defaultChannelPagedLimit,
    this.messageLimit,
    this.memberLimit,
  }) : _eventHandler = eventHandler ?? StreamChannelListEventHandler();

  /// The client to use for the channels list.
  final StreamChatClient client;

  /// The channel event handlers to use for the channels list.
  final StreamChannelListEventHandler _eventHandler;

  /// The query filters to use.
  ///
  /// You can query on any of the custom fields you've defined on the [Channel].
  ///
  /// You can also filter other built-in channel fields.
  final Filter? filter;

  /// The sorting used for the channels matching the filters.
  ///
  /// Sorting is based on field and direction, multiple sorting options
  /// can be provided.
  ///
  /// You can sort based on last_updated, last_message_at, updated_at,
  /// created_at or member_count.
  ///
  /// Direction can be ascending or descending.
  @Deprecated('''
  sort has been deprecated. 
  Please use channelStateSort instead.''')
  final List<SortOption<ChannelModel>>? sort;

  /// The sorting used for the channels matching the filters.
  ///
  /// Sorting is based on field and direction, multiple sorting options
  /// can be provided.
  ///
  /// You can sort based on last_updated, last_message_at, updated_at,
  /// created_at or member_count.
  ///
  /// Direction can be ascending or descending.
  final List<SortOption<ChannelState>>? channelStateSort;

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
    final limit = min(
      this.limit * defaultInitialPagedLimitMultiplier,
      _kDefaultBackendPaginationLimit,
    );
    try {
      await for (final channels in client.queryChannels(
        filter: filter,
        channelStateSort: channelStateSort,
        // ignore: deprecated_member_use, deprecated_member_use_from_same_package
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
        // ignore: deprecated_member_use, deprecated_member_use_from_same_package
        sort: sort,
        channelStateSort: channelStateSort,
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

  /// Replaces the previously loaded channels with the passed [channels].
  set channels(List<Channel> channels) {
    if (value.isSuccess) {
      final currentValue = value.asSuccess;
      value = currentValue.copyWith(items: channels);
    } else {
      value = PagedValue(items: channels);
    }
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

  /// Leaves the [channel] and updates the list.
  Future<void> leaveChannel(Channel channel) async {
    final user = client.state.currentUser;
    assert(user != null, 'You must be logged in to leave a channel.');
    await channel.removeMembers([user!.id]);
  }

  /// Deletes the [channel] and updates the list.
  Future<void> deleteChannel(Channel channel) async {
    await channel.delete();
  }

  /// Mutes the [channel] and updates the list.
  Future<void> muteChannel(Channel channel) async {
    await channel.mute();
  }

  /// Un-mutes the [channel] and updates the list.
  Future<void> unmuteChannel(Channel channel) async {
    await channel.unmute();
  }

  /// Event listener, which can be set in order to listen
  /// [client] web-socket events.
  ///
  /// Return `true` if the event is handled. Return `false` to
  /// allow the event to be handled internally.
  bool Function(Event event)? eventListener;

  StreamSubscription<Event>? _channelEventSubscription;

  // Subscribes to the channel list events.
  void _subscribeToChannelListEvents() {
    if (_channelEventSubscription != null) {
      _unsubscribeFromChannelListEvents();
    }

    _channelEventSubscription = client
        .on()
        .skip(1) // Skipping the last emitted event.
        // We only need to handle the latest events.
        .listen((event) {
      // Only handle the event if the value is in success state.
      if (value.isNotSuccess) return;

      // Returns early if the event is already handled by the listener.
      if (eventListener?.call(event) ?? false) return;

      final eventType = event.type;
      if (eventType == EventType.channelDeleted) {
        _eventHandler.onChannelDeleted(event, this);
      } else if (eventType == EventType.channelHidden) {
        _eventHandler.onChannelHidden(event, this);
      } else if (eventType == EventType.channelTruncated) {
        _eventHandler.onChannelTruncated(event, this);
      } else if (eventType == EventType.channelUpdated) {
        _eventHandler.onChannelUpdated(event, this);
      } else if (eventType == EventType.channelVisible) {
        _eventHandler.onChannelVisible(event, this);
      } else if (eventType == EventType.connectionRecovered) {
        _eventHandler.onConnectionRecovered(event, this);
      } else if (eventType == EventType.messageNew) {
        _eventHandler.onMessageNew(event, this);
      } else if (eventType == EventType.notificationAddedToChannel) {
        _eventHandler.onNotificationAddedToChannel(event, this);
      } else if (eventType == EventType.notificationMessageNew) {
        _eventHandler.onNotificationMessageNew(event, this);
      } else if (eventType == EventType.notificationRemovedFromChannel) {
        _eventHandler.onNotificationRemovedFromChannel(event, this);
      } else if (eventType == 'user.presence.changed' ||
          eventType == EventType.userUpdated) {
        _eventHandler.onUserPresenceChanged(event, this);
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
