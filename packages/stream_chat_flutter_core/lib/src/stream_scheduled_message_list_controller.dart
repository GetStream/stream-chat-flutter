import 'dart:async';

import 'package:stream_chat/stream_chat.dart';

import 'paged_value_notifier.dart';
import 'stream_scheduled_message_list_event_handler.dart';

/// The default number of scheduled messages to load per page.
const defaultScheduledMessagePagedLimit = 100;

/// A controller for a paged list of the current user's scheduled messages
/// that are not sent yet, earliest first.
///
/// Once loaded, the list stays current as messages are scheduled, edited,
/// sent or deleted anywhere in the app, and it is loaded again when the
/// connection recovers.
class StreamScheduledMessageListController extends PagedValueNotifier<String, ScheduledMessage> {
  /// Creates a controller for the scheduled messages in the channel [cid], or
  /// in every channel when it is null.
  ///
  /// When [statuses] is given, only messages with one of them are listed.
  StreamScheduledMessageListController({
    required this.client,
    StreamScheduledMessageListEventHandler? eventHandler,
    this.cid,
    this.statuses,
    this.limit = defaultScheduledMessagePagedLimit,
  }) : _eventHandler = eventHandler ?? StreamScheduledMessageListEventHandler(),
       super(const PagedValue.loading());

  /// Creates a controller that starts from [value].
  StreamScheduledMessageListController.fromValue(
    super.value, {
    required this.client,
    StreamScheduledMessageListEventHandler? eventHandler,
    this.cid,
    this.statuses,
    this.limit = defaultScheduledMessagePagedLimit,
  }) : _eventHandler = eventHandler ?? StreamScheduledMessageListEventHandler();

  /// The client used to load the scheduled messages.
  final StreamChatClient client;

  // The handlers that keep the list current as events arrive.
  final StreamScheduledMessageListEventHandler _eventHandler;

  /// The channel the listed messages are in, or null for every channel.
  final String? cid;

  /// The statuses the listed messages have, or null for every pending one.
  final List<ScheduledMessageStatus>? statuses;

  /// The number of scheduled messages to load per page.
  final int limit;

  StreamSubscription<Event>? _eventSubscription;

  @override
  Future<void> doInitialLoad() async {
    try {
      final response = await client.queryScheduledMessages(
        cid: cid,
        statuses: statuses,
        limit: limit,
      );

      value = PagedValue(
        items: _sorted(response.scheduledMessages),
        nextPageKey: response.next,
      );

      if (disposed) return;
      _subscribe();
    } on StreamChatError catch (error) {
      value = PagedValue.error(error);
    } catch (error) {
      value = PagedValue.error(StreamChatError(error.toString()));
    }
  }

  @override
  Future<void> loadMore(String nextPageKey) async {
    final previousValue = value.asSuccess;

    try {
      final response = await client.queryScheduledMessages(
        cid: cid,
        statuses: statuses,
        limit: limit,
        next: nextPageKey,
      );

      final loadedIds = {for (final it in response.scheduledMessages) it.id};
      value = PagedValue(
        items: _sorted([
          ...previousValue.items.where((it) => !loadedIds.contains(it.id)),
          ...response.scheduledMessages,
        ]),
        nextPageKey: response.next,
      );
    } on StreamChatError catch (error) {
      value = previousValue.copyWith(error: error);
    } catch (error) {
      value = previousValue.copyWith(error: StreamChatError(error.toString()));
    }
  }

  /// Event listener, which can be set in order to listen to [client]
  /// web-socket events.
  ///
  /// Return `true` if the event is handled. Return `false` to allow the event
  /// to be handled internally.
  bool Function(Event event)? eventListener;

  void _subscribe() {
    unawaited(_eventSubscription?.cancel());
    _eventSubscription = client.on().listen((event) {
      // Only handle the event if the value is in success state.
      if (value.isNotSuccess) return;

      // Returns early if the event is already handled by the listener.
      if (eventListener?.call(event) ?? false) return;

      final handlerFunc = switch (event.type) {
        EventType.scheduledMessageCreated => _eventHandler.onScheduledMessageCreated,
        EventType.scheduledMessageUpdated => _eventHandler.onScheduledMessageUpdated,
        EventType.scheduledMessageFailed => _eventHandler.onScheduledMessageFailed,
        EventType.scheduledMessageSent => _eventHandler.onScheduledMessageSent,
        EventType.scheduledMessageDeleted => _eventHandler.onScheduledMessageDeleted,
        EventType.connectionRecovered => _eventHandler.onConnectionRecovered,
        _ => null,
      };

      return handlerFunc?.call(event, this);
    });
  }

  /// Adds [scheduledMessage] to the list, or replaces the one with its ID
  /// unless that one is newer.
  ///
  /// A scheduled message outside the channel or statuses this controller
  /// lists is removed instead. Returns `true` if the list changed.
  bool updateScheduledMessage(ScheduledMessage scheduledMessage) {
    if (!_matches(scheduledMessage)) return deleteScheduledMessage(scheduledMessage);

    final items = currentItems;
    final existing = items.where((it) => it.id == scheduledMessage.id).firstOrNull;
    if (existing != null && existing.updatedAt.isAfter(scheduledMessage.updatedAt)) return false;

    value = value.asSuccess.copyWith(
      items: _sorted([...items.where((it) => it.id != scheduledMessage.id), scheduledMessage]),
    );
    return true;
  }

  /// Removes [scheduledMessage] from the list.
  ///
  /// Returns `true` if it was listed.
  bool deleteScheduledMessage(ScheduledMessage scheduledMessage) {
    final items = currentItems;
    if (!items.any((it) => it.id == scheduledMessage.id)) return false;

    value = value.asSuccess.copyWith(
      items: [...items.where((it) => it.id != scheduledMessage.id)],
    );
    return true;
  }

  bool _matches(ScheduledMessage scheduledMessage) {
    if (cid != null && scheduledMessage.cid != cid) return false;
    return statuses?.contains(scheduledMessage.status) ?? true;
  }

  static List<ScheduledMessage> _sorted(List<ScheduledMessage> scheduledMessages) {
    return [...scheduledMessages]..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  @override
  void dispose() {
    unawaited(_eventSubscription?.cancel());
    super.dispose();
  }
}
