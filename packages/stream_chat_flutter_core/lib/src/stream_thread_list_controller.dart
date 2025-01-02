import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/paged_value_notifier.dart';
import 'package:stream_chat_flutter_core/src/stream_thread_list_event_handler.dart';

/// The default thread list page limit to load.
const defaultThreadsPagedLimit = 10;

const _kDefaultBackendPaginationLimit = 30;

/// {@template streamThreadListController}
/// A controller for a thread list.
///
/// This class lets you perform tasks such as:
/// * Load initial data.
/// * Load more data using [loadMore].
/// * Replace the previously loaded threads.
/// {@endtemplate}
class StreamThreadListController extends PagedValueNotifier<String, Thread> {
  /// {@macro streamThreadListController}
  StreamThreadListController({
    required this.client,
    StreamThreadListEventHandler? eventHandler,
    this.options = const ThreadOptions(),
    this.limit = defaultThreadsPagedLimit,
  })  : _activeOptions = options,
        _eventHandler = eventHandler ?? StreamThreadListEventHandler(),
        super(const PagedValue.loading());

  /// Creates a [StreamThreadListController] from the passed [value].
  StreamThreadListController.fromValue(
    super.value, {
    required this.client,
    StreamThreadListEventHandler? eventHandler,
    this.options = const ThreadOptions(),
    this.limit = defaultThreadsPagedLimit,
  })  : _activeOptions = options,
        _eventHandler = eventHandler ?? StreamThreadListEventHandler();

  /// The Stream client used to perform the queries.
  final StreamChatClient client;

  /// The channel event handlers to use for the channels list.
  final StreamThreadListEventHandler _eventHandler;

  /// The limit to apply to the thread list.
  ///
  /// The default is set to [defaultUserPagedLimit].
  final int limit;

  /// The options used to filter the threads.
  ///
  /// The default is set to [ThreadOptions].
  final ThreadOptions options;
  ThreadOptions _activeOptions;

  /// Allows for the change of the [options] at runtime.
  ///
  /// Use this if you need to support runtime option changes,
  /// through custom filters UI.
  set options(ThreadOptions options) => _activeOptions = options;

  /// The ids of the threads that have unseen messages.
  ValueListenable<Set<String>> get unseenThreadIds => _unseenThreadIds;
  final _unseenThreadIds = ValueNotifier<Set<String>>(const {});

  /// Adds a new thread to the set of unseen thread IDs.
  void addUnseenThreadId(String? threadId) {
    if (threadId == null) return;

    final currentUnseenThreadIds = {..._unseenThreadIds.value};
    final updatedUnseenThreadIds = {...currentUnseenThreadIds, threadId};
    _unseenThreadIds.value = updatedUnseenThreadIds;
  }

  /// Clears the set of unseen thread IDs.
  void clearUnseenThreadIds() => _unseenThreadIds.value = const {};

  @override
  Future<void> doInitialLoad() async {
    final limit = min(
      this.limit * defaultInitialPagedLimitMultiplier,
      _kDefaultBackendPaginationLimit,
    );
    try {
      final response = await client.queryThreads(
        options: _activeOptions,
        pagination: PaginationParams(limit: limit),
      );

      final results = response.threads;
      final nextKey = response.next;
      value = PagedValue(
        items: results,
        nextPageKey: nextKey,
      );
      // Start listening to events
      _subscribeToThreadListEvents();
    } on StreamChatError catch (error) {
      value = PagedValue.error(error);
    } catch (error) {
      final chatError = StreamChatError(error.toString());
      value = PagedValue.error(chatError);
    }
  }

  @override
  Future<void> loadMore(String nextPageKey) async {
    final previousValue = value.asSuccess;

    try {
      final response = await client.queryThreads(
        options: _activeOptions,
        pagination: PaginationParams(limit: limit, next: nextPageKey),
      );

      final results = response.threads;
      final previousItems = previousValue.items;
      final newItems = previousItems + results;
      final next = response.next;
      final nextKey = next != null && next.isNotEmpty ? next : null;
      value = PagedValue(
        items: newItems,
        nextPageKey: nextKey,
      );
    } on StreamChatError catch (error) {
      value = previousValue.copyWith(error: error);
    } catch (error) {
      final chatError = StreamChatError(error.toString());
      value = previousValue.copyWith(error: chatError);
    }
  }

  @override
  Future<void> refresh({bool resetValue = true}) {
    if (resetValue) {
      _activeOptions = options;
    }
    return super.refresh(resetValue: resetValue);
  }

  /// Replaces the previously loaded threads with the passed [threads].
  set threads(List<Thread> threads) {
    if (value.isSuccess) {
      final currentValue = value.asSuccess;
      value = currentValue.copyWith(items: threads);
    } else {
      value = PagedValue(items: threads);
    }
  }

  /// Returns the thread with the given [parentMessageId] from the list.
  ///
  /// Returns `null` if no thread is found.
  Thread? getThread({required String? parentMessageId}) {
    final currentThreads = [...currentItems];
    final thread = currentThreads.firstWhereOrNull(
      (it) => it.parentMessageId == parentMessageId,
    );

    return thread;
  }

  /// Updates the given [thread] in the list.
  void updateThread(Thread thread) {
    final currentThreads = [...currentItems];
    final updateIndex = currentThreads.indexWhere(
      (it) => it.parentMessageId == thread.parentMessageId,
    );

    if (updateIndex < 0) return;
    currentThreads[updateIndex] = thread;

    threads = currentThreads;
  }

  /// Deletes the thread with the given [parentMessageId] from the list.
  ///
  /// Returns `true` if the thread is deleted successfully. Otherwise, `false`.
  void deleteThread({required String? parentMessageId}) {
    final currentThreads = [...currentItems];
    final removeIndex = currentThreads.indexWhere(
      (it) => it.parentMessageId == parentMessageId,
    );

    if (removeIndex < 0) return;
    currentThreads.removeAt(removeIndex);

    threads = currentThreads;
  }

  /// Removes all the threads with the given [channelCid] from the list.
  ///
  /// This is useful when you want to remove all the threads from a channel
  /// when the channel is deleted.
  void deleteThreadByChannelCid({required String channelCid}) {
    final oldThreads = [...currentItems];
    final newThreads = [
      ...oldThreads.where((it) => it.channelCid != channelCid),
    ];

    threads = newThreads;
  }

  /// Event listener, which can be set in order to listen
  /// [client] web-socket events.
  ///
  /// Return `true` if the event is handled. Return `false` to
  /// allow the event to be handled internally.
  bool Function(Event event)? eventListener;

  StreamSubscription<Event>? _threadEventSubscription;

  // Subscribes to the thread list events.
  void _subscribeToThreadListEvents() {
    if (_threadEventSubscription != null) {
      _unsubscribeFromThreadListEvents();
    }

    _threadEventSubscription = client.on().listen((event) {
      // Only handle the event if the value is in success state.
      if (value.isNotSuccess) return;

      // Returns early if the event is already handled by the listener.
      if (eventListener?.call(event) ?? false) return;

      final handlerFunc = switch (event.type) {
        EventType.threadUpdated => _eventHandler.onThreadUpdated,
        EventType.connectionRecovered => _eventHandler.onConnectionRecovered,
        EventType.notificationThreadMessageNew =>
          _eventHandler.onNotificationThreadMessageNew,
        EventType.messageRead => _eventHandler.onMessageRead,
        EventType.notificationMarkUnread =>
          _eventHandler.onNotificationMarkUnread,
        EventType.channelDeleted => _eventHandler.onChannelDeleted,
        EventType.channelTruncated => _eventHandler.onChannelTruncated,
        EventType.messageNew => _eventHandler.onMessageNew,
        EventType.messageUpdated => _eventHandler.onMessageUpdated,
        EventType.messageDeleted => _eventHandler.onMessageDeleted,
        EventType.reactionNew => _eventHandler.onReactionNew,
        EventType.reactionUpdated => _eventHandler.onReactionUpdated,
        EventType.reactionDeleted => _eventHandler.onReactionDeleted,
        _ => null,
      };

      return handlerFunc?.call(event, this);
    });
  }

  // Unsubscribes from all channel list events.
  void _unsubscribeFromThreadListEvents() {
    if (_threadEventSubscription != null) {
      _threadEventSubscription!.cancel();
      _threadEventSubscription = null;
    }
  }

  /// Pauses all subscriptions added to this composite.
  void pauseEventsSubscription([Future<void>? resumeSignal]) {
    _threadEventSubscription?.pause(resumeSignal);
  }

  /// Resumes all subscriptions added to this composite.
  void resumeEventsSubscription() {
    _threadEventSubscription?.resume();
  }

  @override
  void dispose() {
    _unsubscribeFromThreadListEvents();
    super.dispose();
  }
}
