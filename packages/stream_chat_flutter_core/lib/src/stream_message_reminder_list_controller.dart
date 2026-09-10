// ignore_for_file: join_return_with_assignment

import 'dart:async';
import 'dart:math';

import 'package:stream_chat/stream_chat.dart';
import 'package:stream_core/stream_core.dart' show SortedListExtensions;
import 'paged_value_notifier.dart';
import 'stream_message_reminder_list_event_handler.dart';

/// The default message reminder page limit to load.
const defaultMessageReminderPagedLimit = 10;

const _kDefaultBackendPaginationLimit = 30;

/// {@template streamMessageReminderListController}
/// A controller for managing and displaying a paginated list of message
/// reminders.
///
/// The `StreamMessageReminderListController` extends [PagedValueNotifier] to
/// handle paginated data for message reminders. It provides functionality for
/// querying reminders, handling events, and managing filters and sorting.
///
/// This controller is typically used in conjunction with UI components
/// to display and interact with a list of message reminders.
/// {@endtemplate}
class StreamMessageReminderListController extends PagedValueNotifier<String, MessageReminder> {
  /// {@macro streamMessageReminderListController}
  StreamMessageReminderListController({
    required this.client,
    StreamMessageReminderListEventHandler? eventHandler,
    this.filter,
    List<MessageReminderSort>? sort,
    this.limit = defaultMessageReminderPagedLimit,
  }) : _activeFilter = filter,
       sort = sort ?? MessageReminderSort.defaultSort,
       _eventHandler = eventHandler ?? StreamMessageReminderListEventHandler(),
       super(const PagedValue.loading());

  /// Creates a [StreamMessageReminderListController] from the passed [value].
  StreamMessageReminderListController.fromValue(
    super.value, {
    required this.client,
    StreamMessageReminderListEventHandler? eventHandler,
    this.filter,
    List<MessageReminderSort>? sort,
    this.limit = defaultMessageReminderPagedLimit,
  }) : _activeFilter = filter,
       sort = sort ?? MessageReminderSort.defaultSort,
       _eventHandler = eventHandler ?? StreamMessageReminderListEventHandler();

  /// The Stream client used to perform the queries.
  final StreamChatClient client;

  /// The channel event handlers to use for the message reminder list.
  final StreamMessageReminderListEventHandler _eventHandler;

  /// The query filters to use.
  ///
  /// You can query on any of the custom fields you've defined on the
  /// [MessageReminder].
  final MessageReminderFilter? filter;
  MessageReminderFilter? _activeFilter;

  /// The sorting used for the message reminders matching the filters.
  ///
  /// Sorting is based on field and direction, multiple sorting options
  /// can be provided.
  ///
  /// Direction can be ascending or descending.
  ///
  /// Defaults to [MessageReminderSort.defaultSort]; pass [MessageReminderSort.empty] to leave the ordering
  /// to the API.
  final List<MessageReminderSort> sort;
  late List<MessageReminderSort> _activeSort = sort;

  /// The limit to apply to the message reminder list. The default is set to
  /// [defaultMessageReminderPagedLimit].
  final int limit;

  /// Allows for the change of filters used for message reminder queries.
  ///
  /// Use this if you need to support runtime filter changes,
  /// through custom filters UI.
  set filter(MessageReminderFilter? value) => _activeFilter = value;

  /// Allows for the change of the query sort used for message reminder queries.
  ///
  /// Use this if you need to support runtime sort changes,
  /// through custom sort UI.
  set sort(List<MessageReminderSort> value) => _activeSort = value;

  @override
  set value(PagedValue<String, MessageReminder> newValue) {
    super.value = newValue.maybeMap(
      orElse: () => newValue,
      (success) => success.copyWith(
        items: success.items.sortedWith(_activeSort.compare),
      ),
    );
  }

  @override
  Future<void> doInitialLoad() async {
    final limit = min(
      this.limit * defaultInitialPagedLimitMultiplier,
      _kDefaultBackendPaginationLimit,
    );
    try {
      final response = await client.queryReminders(
        sort: _activeSort,
        filter: _activeFilter,
        pagination: PaginationParams(limit: limit),
      );

      final results = response.reminders;
      final nextKey = response.next;
      value = PagedValue(
        items: results,
        nextPageKey: nextKey,
      );
      // Start listening to events
      if (disposed) return;
      _subscribeToReminderListEvents();
    } on StreamChatException catch (error) {
      value = PagedValue.error(error);
    } catch (error) {
      final chatError = StreamClientException(message: 'Failed to load message reminders', cause: error);
      value = PagedValue.error(chatError);
    }
  }

  @override
  Future<void> loadMore(String nextPageKey) async {
    final previousValue = value.asSuccess;

    try {
      final response = await client.queryReminders(
        sort: _activeSort,
        filter: _activeFilter,
        pagination: PaginationParams(limit: limit, next: nextPageKey),
      );

      final results = response.reminders;
      final previousItems = previousValue.items;
      final newItems = previousItems + results;
      final next = response.next;
      final nextKey = next != null && next.isNotEmpty ? next : null;
      value = PagedValue(
        items: newItems,
        nextPageKey: nextKey,
      );
    } on StreamChatException catch (error) {
      value = previousValue.copyWith(error: error);
    } catch (error) {
      final chatError = StreamClientException(message: 'Failed to load more message reminders', cause: error);
      value = previousValue.copyWith(error: chatError);
    }
  }

  /// Event listener, which can be set in order to listen
  /// [client] web-socket events.
  ///
  /// Return `true` if the event is handled. Return `false` to
  /// allow the event to be handled internally.
  bool Function(Event event)? eventListener;

  StreamSubscription<Event>? _reminderEventSubscription;

  // Subscribes to the message reminder list events.
  void _subscribeToReminderListEvents() {
    if (_reminderEventSubscription != null) {
      _unsubscribeFromReminderListEvents();
    }

    _reminderEventSubscription = client.on().listen((event) {
      // Only handle the event if the value is in success state.
      if (value.isNotSuccess) return;

      // Returns early if the event is already handled by the listener.
      if (eventListener?.call(event) ?? false) return;

      final handlerFunc = switch (event.type) {
        EventType.reminderCreated => _eventHandler.onMessageReminderCreated,
        EventType.reminderUpdated => _eventHandler.onMessageReminderUpdated,
        EventType.reminderDeleted => _eventHandler.onMessageReminderDeleted,
        EventType.notificationReminderDue => _eventHandler.onMessageReminderDue,
        EventType.connectionRecovered => _eventHandler.onConnectionRecovered,
        _ => null,
      };

      return handlerFunc?.call(event, this);
    });
  }

  @override
  Future<void> refresh({bool resetValue = true}) {
    if (resetValue) {
      _activeFilter = filter;
      _activeSort = sort;
    }
    return super.refresh(resetValue: resetValue);
  }

  /// Replaces the previously loaded message reminders with the passed
  /// [reminders].
  set reminders(List<MessageReminder> reminders) {
    if (value.isSuccess) {
      final currentValue = value.asSuccess;
      value = currentValue.copyWith(items: reminders);
    } else {
      value = PagedValue(items: reminders);
    }
  }

  /// Add/Updates the given [reminder] in the list.
  ///
  /// Returns `true` if the reminder is added or updated successfully.
  bool updateReminder(MessageReminder reminder) {
    final currentReminders = [
      ...currentItems.merge(
        [reminder],
        key: (reminder) => (reminder.messageId, reminder.userId),
        update: (original, updated) => original.merge(updated),
      ),
    ];

    reminders = currentReminders;
    return true;
  }

  /// Deletes the reminder with the given parameters from the list.
  ///
  /// Returns `true` if the reminder is deleted successfully.
  bool deleteReminder(MessageReminder reminder) {
    final currentReminders = [...currentItems];
    final removeIndex = currentReminders.indexWhere(
      (it) {
        var predicate = it.userId == reminder.userId;
        predicate &= it.messageId == reminder.messageId;
        return predicate;
      },
    );

    if (removeIndex < 0) return false;
    currentReminders.removeAt(removeIndex);

    reminders = currentReminders;
    return true;
  }

  // Unsubscribes from all message reminder list events.
  void _unsubscribeFromReminderListEvents() {
    if (_reminderEventSubscription != null) {
      _reminderEventSubscription!.cancel();
      _reminderEventSubscription = null;
    }
  }

  /// Pauses all subscriptions added to this composite.
  void pauseEventsSubscription([Future<void>? resumeSignal]) {
    _reminderEventSubscription?.pause(resumeSignal);
  }

  /// Resumes all subscriptions added to this composite.
  void resumeEventsSubscription() {
    _reminderEventSubscription?.resume();
  }

  @override
  void dispose() {
    _unsubscribeFromReminderListEvents();
    super.dispose();
  }
}
