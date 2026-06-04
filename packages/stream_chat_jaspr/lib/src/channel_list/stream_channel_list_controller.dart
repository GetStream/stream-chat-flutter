import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:stream_chat/stream_chat.dart' hide Success;

/// The default channel page limit to load.
const defaultChannelPagedLimit = 10;

const _kDefaultBackendPaginationLimit = 30;
const _kInitialPagedLimitMultiplier = 3;

/// The default sort used for the channel list.
const defaultChannelListSort = [
  SortOption<ChannelState>.desc(ChannelSortKey.lastUpdated),
];

/// Represents the state of the channel list.
enum ChannelListState {
  /// Initial state, no data loaded yet.
  idle,

  /// Currently loading the initial data.
  loading,

  /// Data has been loaded successfully.
  loaded,

  /// An error occurred while loading.
  error,
}

/// A controller for a channel list that does not depend on Flutter.
///
/// Manages loading, pagination, and real-time event handling for a list of
/// [Channel] objects retrieved via [StreamChatClient.queryChannels].
///
/// Notify listeners of state changes by setting [onChanged]. Typically, a
/// Jaspr [StatefulComponent] sets this to `() => setState(() {})`.
class StreamChannelListController {
  /// Creates a [StreamChannelListController].
  ///
  /// * [client] is the Stream Chat client to use.
  /// * [filter] is the query filters.
  /// * [channelStateSort] is the sort order for channels.
  /// * [presence] whether to receive user presence updates.
  /// * [limit] page size for pagination.
  /// * [messageLimit] messages to fetch per channel.
  /// * [memberLimit] members to fetch per channel.
  StreamChannelListController({
    required this.client,
    this.filter,
    this.channelStateSort = defaultChannelListSort,
    this.presence = true,
    this.limit = defaultChannelPagedLimit,
    this.messageLimit,
    this.memberLimit,
  });

  /// The [StreamChatClient] used to fetch channels.
  final StreamChatClient client;

  /// Query filters for the channel list.
  final Filter? filter;

  /// Sort order for channels.
  final SortOrder<ChannelState>? channelStateSort;

  /// Whether to receive user presence updates via WebSocket events.
  final bool presence;

  /// Page size for each pagination request.
  final int limit;

  /// Number of messages to fetch per channel.
  final int? messageLimit;

  /// Number of members to fetch per channel.
  final int? memberLimit;

  /// The current list of loaded channels.
  List<Channel> channels = [];

  /// The current state of the controller.
  ChannelListState state = ChannelListState.idle;

  /// Whether more pages are available to load.
  bool hasMore = true;

  /// Whether a load-more request is currently in progress.
  bool isLoadingMore = false;

  /// The last error that occurred, if any.
  Object? error;

  /// Callback invoked whenever the controller's state changes.
  ///
  /// Set this from your component to trigger a rebuild:
  /// ```dart
  /// controller.onChanged = () => setState(() {});
  /// ```
  void Function()? onChanged;

  /// Event listener for [client] WebSocket events.
  ///
  /// Return `true` if the event is handled externally. Return `false` to
  /// allow the controller to handle it internally.
  bool Function(Event event)? eventListener;

  StreamSubscription<Event>? _channelEventSubscription;

  void _notifyChanged() {
    onChanged?.call();
  }

  /// Loads the initial page of channels.
  ///
  /// Automatically subscribes to real-time channel events on success.
  Future<void> doInitialLoad() async {
    if (state == ChannelListState.loading) return;

    state = ChannelListState.loading;
    error = null;
    _notifyChanged();

    final initialLimit = min(
      limit * _kInitialPagedLimitMultiplier,
      _kDefaultBackendPaginationLimit,
    );

    try {
      await for (final result in client.queryChannels(
        filter: filter,
        channelStateSort: channelStateSort,
        memberLimit: memberLimit,
        messageLimit: messageLimit,
        presence: presence,
        paginationParams: PaginationParams(limit: initialLimit),
      )) {
        channels = _sorted(result);
        hasMore = result.length >= initialLimit;
        state = ChannelListState.loaded;
        _notifyChanged();
      }
      _subscribeToChannelListEvents();
    } on StreamChatError catch (e) {
      error = e;
      state = ChannelListState.error;
      _notifyChanged();
    } catch (e) {
      error = e;
      state = ChannelListState.error;
      _notifyChanged();
    }
  }

  /// Loads the next page of channels.
  ///
  /// No-op if already loading or if there are no more pages.
  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    _notifyChanged();

    try {
      await for (final result in client.queryChannels(
        filter: filter,
        channelStateSort: channelStateSort,
        memberLimit: memberLimit,
        messageLimit: messageLimit,
        presence: presence,
        paginationParams: PaginationParams(
          limit: limit,
          offset: channels.length,
        ),
      )) {
        channels = _sorted([...channels, ...result]);
        hasMore = result.length >= limit;
        isLoadingMore = false;
        _notifyChanged();
      }
    } on StreamChatError catch (e) {
      error = e;
      isLoadingMore = false;
      _notifyChanged();
    } catch (e) {
      error = e;
      isLoadingMore = false;
      _notifyChanged();
    }
  }

  /// Refreshes the channel list by re-running the initial load.
  Future<void> refresh() async {
    _unsubscribeFromChannelListEvents();
    channels = [];
    hasMore = true;
    error = null;
    state = ChannelListState.idle;
    _notifyChanged();
    await doInitialLoad();
  }

  /// Returns/creates a channel and starts watching it.
  Future<Channel> getChannel({
    required String id,
    required String type,
  }) async {
    final channel = client.channel(type, id: id);
    await channel.watch();
    return channel;
  }

  List<Channel> _sorted(List<Channel> items) {
    if (channelStateSort == null) return items;
    return items.sortedByCompare(
      (it) => it.state!.channelState,
      channelStateSort!.compare,
    );
  }

  // ---- Real-time event handling ----

  void _subscribeToChannelListEvents() {
    _unsubscribeFromChannelListEvents();

    _channelEventSubscription = client.on().listen((event) {
      if (state != ChannelListState.loaded) return;
      if (eventListener?.call(event) ?? false) return;

      final eventType = event.type;
      if (eventType == EventType.channelDeleted || eventType == EventType.channelHidden) {
        _onChannelRemoved(event);
      } else if (eventType == EventType.channelTruncated || eventType == EventType.connectionRecovered) {
        refresh();
      } else if (eventType == EventType.channelUpdated || eventType == EventType.memberUpdated) {
        _onChannelUpdated();
      } else if (eventType == EventType.channelVisible ||
          eventType == EventType.notificationAddedToChannel ||
          eventType == EventType.notificationMessageNew) {
        _onChannelVisible(event);
      } else if (eventType == EventType.messageNew) {
        _onMessageNew(event);
      } else if (eventType == EventType.notificationRemovedFromChannel) {
        _onNotificationRemovedFromChannel(event);
      } else if (eventType == 'user.presence.changed' || eventType == EventType.userUpdated) {
        _onUserPresenceChanged(event);
      }
    });
  }

  void _unsubscribeFromChannelListEvents() {
    _channelEventSubscription?.cancel();
    _channelEventSubscription = null;
  }

  void _onChannelRemoved(Event event) {
    channels.removeWhere(
      (it) => it.cid == (event.cid ?? event.channel?.cid),
    );
    _notifyChanged();
  }

  void _onChannelUpdated() {
    channels = _sorted([...channels]);
    _notifyChanged();
  }

  void _onChannelVisible(Event event) async {
    final channelId = event.channelId;
    final channelType = event.channelType;
    if (channelId == null || channelType == null) return;

    try {
      final channel = await getChannel(id: channelId, type: channelType);
      channels
        ..removeWhere((it) => it.cid == channel.cid)
        ..insert(0, channel);
      channels = _sorted(channels);
      _notifyChanged();
    } catch (e) {
      error = e;
      _notifyChanged();
    }
  }

  void _onMessageNew(Event event) {
    final channelCid = event.cid;
    if (channelCid == null) return;

    final index = channels.indexWhere((it) => it.cid == channelCid);
    if (index < 0) {
      refresh();
      return;
    }

    final channel = channels.removeAt(index);
    channels.insert(0, channel);
    channels = _sorted(channels);
    _notifyChanged();
  }

  void _onNotificationRemovedFromChannel(Event event) {
    final before = channels.length;
    channels.removeWhere((it) => it.cid == event.channel?.cid);
    if (channels.length != before) _notifyChanged();
  }

  void _onUserPresenceChanged(Event event) {
    final user = event.user;
    if (user == null) return;

    for (final channel in channels) {
      final members = channel.state?.members ?? [];
      if (!members.any((m) => m.userId == user.id)) continue;

      final updated = members.map((m) {
        if (m.userId == user.id) return m.copyWith(user: user);
        return m;
      }).toList();

      final membership = channel.membership;
      final updatedMembership = membership?.userId == user.id ? membership?.copyWith(user: user) : membership;

      channel.state!.updateChannelState(
        channel.state!.channelState.copyWith(
          membership: updatedMembership,
          members: updated,
        ),
      );
    }

    _notifyChanged();
  }

  /// Pauses event subscription processing.
  void pauseEventsSubscription([Future<void>? resumeSignal]) {
    _channelEventSubscription?.pause(resumeSignal);
  }

  /// Resumes event subscription processing.
  void resumeEventsSubscription() {
    _channelEventSubscription?.resume();
  }

  /// Disposes of resources held by this controller.
  ///
  /// Must be called when the controller is no longer needed.
  void dispose() {
    _unsubscribeFromChannelListEvents();
    onChanged = null;
  }
}
