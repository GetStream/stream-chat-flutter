import 'dart:async';

import 'package:stream_chat/stream_chat.dart';

/// The default page size for message pagination.
const defaultMessagePageLimit = 20;

/// Represents the loading state of the message list.
enum MessageListState {
  /// Initial state, no data loaded yet.
  idle,

  /// Currently loading the initial data.
  loading,

  /// Data has been loaded successfully.
  loaded,

  /// An error occurred while loading.
  error,
}

/// A controller for a message list within a single [Channel].
///
/// Manages loading, pagination, and real-time event handling for a list of
/// [Message] objects. Mirrors the pattern used by [StreamChannelListController].
///
/// Set [onChanged] to `() => setState(() {})` from your Jaspr component to
/// trigger a rebuild whenever the state changes.
class StreamMessageListController {
  /// Creates a [StreamMessageListController] for the given [channel].
  StreamMessageListController({
    required this.channel,
    this.limit = defaultMessagePageLimit,
  });

  /// The channel whose messages are managed by this controller.
  final Channel channel;

  /// Number of messages to fetch per pagination request.
  final int limit;

  /// The current list of visible messages in chronological order (oldest first).
  List<Message> messages = [];

  /// The current loading state.
  MessageListState state = MessageListState.idle;

  /// Whether more (older) messages are available to load.
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

  StreamSubscription<List<Message>>? _messagesSubscription;

  void _notifyChanged() => onChanged?.call();

  /// Starts watching the channel and loads the initial set of messages.
  Future<void> doInitialLoad() async {
    if (state == MessageListState.loading) return;

    state = MessageListState.loading;
    error = null;
    _notifyChanged();

    try {
      await channel.watch();

      // Subscribe to real-time message updates.
      _subscribeToMessages();

      // Seed initial messages from local state.
      _updateMessages();

      // Fetch the latest messages from the server.
      await channel.query(
        messagesPagination: PaginationParams(limit: limit),
      );

      _updateMessages();

      state = MessageListState.loaded;
      _notifyChanged();
    } catch (e) {
      error = e;
      state = MessageListState.error;
      _notifyChanged();
    }
  }

  /// Loads older messages (pagination going back in time).
  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;
    if (messages.isEmpty) return;

    isLoadingMore = true;
    _notifyChanged();

    try {
      final oldest = messages.first;
      final result = await channel.query(
        messagesPagination: PaginationParams(
          limit: limit,
          lessThan: oldest.id,
        ),
      );

      _updateMessages();

      // If fewer messages than requested were returned, there are no more.
      final fetched = result.messages ?? [];
      if (fetched.length < limit) hasMore = false;

      isLoadingMore = false;
      _notifyChanged();
    } catch (e) {
      error = e;
      isLoadingMore = false;
      _notifyChanged();
    }
  }

  void _subscribeToMessages() {
    _messagesSubscription?.cancel();
    _messagesSubscription =
        channel.state!.messagesStream.listen((_) => _updateMessages());
  }

  void _updateMessages() {
    final all = channel.state?.messages ?? [];
    messages = all.where(_isVisibleMessage).toList();
  }

  /// Disposes of resources held by this controller.
  void dispose() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
    onChanged = null;
  }
}

bool _isVisibleMessage(Message message) {
  if (message.isShadowed) return false;
  if (message.isDeleted) return false;
  if (message.isError) return false;
  if (message.isEphemeral) return false;
  return true;
}
