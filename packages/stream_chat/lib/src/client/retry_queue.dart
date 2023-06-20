import 'dart:async';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/client/retry_policy.dart';
import 'package:stream_chat/stream_chat.dart';

/// The retry queue associated to a channel.
class RetryQueue {
  /// Instantiate a new RetryQueue object.
  RetryQueue({
    required this.channel,
    this.logger,
  }) : client = channel.client {
    _retryPolicy = client.retryPolicy;
    _listenConnectionRecovered();
    _listenMessageEvents();
  }

  /// The channel of this queue.
  final Channel channel;

  /// The client associated with this [channel].
  final StreamChatClient client;

  /// The logger associated to this queue.
  final Logger? logger;

  late final RetryPolicy _retryPolicy;

  final _compositeSubscription = CompositeSubscription();

  final _messageQueue = HeapPriorityQueue(_byDate);

  void _listenConnectionRecovered() {
    client.on(EventType.connectionRecovered).distinct().listen((event) {
      if (event.online == true) {
        logger?.info('Connection recovered, retrying failed messages');
        channel.state?.retryFailedMessages();
      }
    }).addTo(_compositeSubscription);
  }

  void _listenMessageEvents() {
    channel.on().where((event) => event.message != null).listen((event) {
      final message = event.message!;
      final containsMessage = _messageQueue.containsMessage(message);
      if (!containsMessage) return;

      if (message.state.isCompleted) {
        logger?.info('Removing sent message from queue : ${message.id}');
        return _messageQueue.removeMessage(message);
      }
    }).addTo(_compositeSubscription);
  }

  /// Add a list of messages.
  void add(Iterable<Message> messages) {
    assert(
      messages.every((it) => it.state.isFailed),
      'Only failed messages can be added to the queue',
    );

    // Filter out messages that are already in the queue.
    final messagesToAdd = messages.where((it) {
      return !_messageQueue.containsMessage(it);
    });

    // If there are no messages to add, return.
    if (messagesToAdd.isEmpty) return;

    logger?.info('Adding ${messagesToAdd.length} messages to the queue');
    _messageQueue.addAll(messagesToAdd);

    _processQueue();
  }

  bool _isProcessing = false;

  Future<void> _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    logger?.info('Started retrying failed messages');
    while (_messageQueue.isNotEmpty) {
      logger?.info('${_messageQueue.length} messages remaining in the queue');

      final message = _messageQueue.first;
      final retryPolicy = _retryPolicy;
      try {
        await backOff(
          () => channel.retryMessage(message),
          delayFactor: retryPolicy.delayFactor,
          randomizationFactor: retryPolicy.randomizationFactor,
          maxDelay: retryPolicy.maxDelay,
          maxAttempts: retryPolicy.maxRetryAttempts,
          retryIf: (error, attempt) {
            if (error is! StreamChatError) return false;
            return retryPolicy.shouldRetry(client, attempt, error);
          },
        );
      } catch (error) {
        logger?.severe('Error while retrying message ${message.id}', error);
        // If we are unable to successfully retry the message, update the state
        // with the failed state.
        channel.state?.updateMessage(message);
      } finally {
        // remove the message from the queue after it's handled.
        _messageQueue.removeFirst();
      }
    }

    _isProcessing = false;
  }

  /// Whether our [_messageQueue] has messages or not.
  bool get hasMessages => _messageQueue.isNotEmpty;

  /// Returns true if the queue contains the given [message].
  bool contains(Message message) => _messageQueue.containsMessage(message);

  /// Call this method to dispose this object.
  void dispose() {
    _messageQueue.clear();
    _compositeSubscription.dispose();
  }

  static int _byDate(Message m1, Message m2) {
    final date1 = _getMessageDate(m1);
    final date2 = _getMessageDate(m2);

    if (date1 == null && date2 == null) return 0;
    if (date1 == null) return -1;
    if (date2 == null) return 1;
    return date1.compareTo(date2);
  }

  static DateTime? _getMessageDate(Message message) {
    return message.state.maybeWhen(
      failed: (state, _) => state.when(
        sendingFailed: () => message.createdAt,
        updatingFailed: () => message.updatedAt,
        deletingFailed: (_) => message.deletedAt,
      ),
      orElse: () => null,
    );
  }
}

extension on HeapPriorityQueue<Message> {
  void removeMessage(Message message) {
    final list = toUnorderedList();
    final index = list.indexWhere((it) => it.id == message.id);
    if (index == -1) return;
    final element = list[index];
    remove(element);
  }

  bool containsMessage(Message message) {
    final list = toUnorderedList();
    final index = list.indexWhere((it) => it.id == message.id);
    if (index == -1) return false;
    return true;
  }
}
