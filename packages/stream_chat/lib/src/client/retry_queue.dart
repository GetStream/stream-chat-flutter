import 'dart:async';

import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/client/channel.dart';
import 'package:stream_chat/src/client/retry_policy.dart';
import 'package:stream_chat/src/core/error/error.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/stream_chat.dart';

/// The retry queue associated to a channel
class RetryQueue {
  /// Instantiate a new RetryQueue object
  RetryQueue({
    required this.channel,
    this.logger,
  }) : client = channel.client {
    _retryPolicy = client.retryPolicy;
    _listenConnectionRecovered();
    _listenFailedEvents();
  }

  /// The channel of this queue
  final Channel channel;

  /// The client associated with this [channel]
  final StreamChatClient client;

  /// The logger associated to this queue
  final Logger? logger;

  late final RetryPolicy _retryPolicy;

  final _compositeSubscription = CompositeSubscription();

  final _messageQueue = HeapPriorityQueue(_byDate);
  bool _isRetrying = false;

  void _listenConnectionRecovered() {
    client.on(EventType.connectionRecovered).listen((event) {
      if (event.online == true) {
        _startRetrying();
      }
    }).addTo(_compositeSubscription);
  }

  void _listenFailedEvents() {
    channel.on().where((event) => event.message != null).listen((event) {
      final message = event.message!;
      final containsMessage = _messageQueue.containsMessage(message);
      if (!containsMessage) return;
      if (message.status == MessageSendingStatus.sent) {
        logger?.info('Removing sent message from queue : ${message.id}');
        _messageQueue.removeMessage(message);
        return;
      } else {
        if ([
          MessageSendingStatus.failed_update,
          MessageSendingStatus.failed,
          MessageSendingStatus.failed_delete,
        ].contains(message.status)) {
          logger?.info('Adding failed message from event : ${event.type}');
          add([message]);
        }
      }
    }).addTo(_compositeSubscription);
  }

  /// Add a list of messages
  void add(List<Message> messages) {
    if (messages.isEmpty) return;
    if (_messageQueue.containsAllMessage(messages)) return;

    logger?.info('Adding ${messages.length} messages');
    final messageList = _messageQueue.toList();
    // we should not add message if already available in the queue
    _messageQueue.addAll(messages.where(
      (it) => !messageList.any((m) => m.id == it.id),
    ));
    _startRetrying();
  }

  Future<void> _startRetrying() async {
    if (_isRetrying) return;
    _isRetrying = true;

    logger?.info('Started retrying failed messages');
    while (_messageQueue.isNotEmpty) {
      logger?.info('${_messageQueue.length} messages remaining in the queue');
      final message = _messageQueue.first;
      await _runAndRetry(message);
    }
    _isRetrying = false;
  }

  Future<void> _runAndRetry(Message message) async {
    var attempt = 1;

    final maxAttempt = _retryPolicy.maxRetryAttempts;
    // early return in case maxAttempt is less than 0
    if (attempt > maxAttempt) return;

    // ignore: literal_only_boolean_expressions
    while (true) {
      try {
        logger?.info('Message (${message.id}) retry attempt $attempt');
        await _retryMessage(message);
        logger?.info('Message (${message.id}) sent successfully');
        _messageQueue.removeMessage(message);
        break;
      } on StreamChatError catch (e) {
        // retry logic
        final maxAttempt = _retryPolicy.maxRetryAttempts;
        if (attempt < maxAttempt) {
          final shouldRetry = _retryPolicy.shouldRetry(client, attempt, e);
          if (shouldRetry) {
            final timeout = _retryPolicy.retryTimeout(client, attempt, e);
            // temporary failure, continue
            logger?.info(
              'API call failed (attempt $attempt), '
              'retrying in ${timeout.inSeconds} seconds. Error was $e',
            );
            await Future.delayed(timeout);
            attempt += 1;
          } else {
            logger?.info(
              'API call failed (attempt $attempt). '
              'Giving up for now, will retry when connection recovers. '
              'Error was $e',
            );
            _sendFailedEvent(message);
            break;
          }
        } else {
          logger?.info(
            'API call failed (attempt $attempt). '
            'Exceeds maxRetryAttempt : $maxAttempt '
            'Giving up for now, will retry when connection recovers. '
            'Error was $e',
          );
          _sendFailedEvent(message);
          break;
        }
      } catch (e) {
        logger?.info(
          'API call failed due to unknown error (attempt $attempt). '
          'Giving up for now, will retry when connection recovers. '
          'Error was $e',
        );
        _sendFailedEvent(message);
        break;
      }
    }
  }

  void _sendFailedEvent(Message message) {
    final newStatus = message.status == MessageSendingStatus.sending
        ? MessageSendingStatus.failed
        : message.status == MessageSendingStatus.updating
            ? MessageSendingStatus.failed_update
            : MessageSendingStatus.failed_delete;
    channel.state?.addMessage(message.copyWith(status: newStatus));
  }

  Future<void> _retryMessage(Message message) async {
    if (message.status == MessageSendingStatus.failed_update ||
        message.status == MessageSendingStatus.updating) {
      await channel.updateMessage(message);
    } else if (message.status == MessageSendingStatus.failed ||
        message.status == MessageSendingStatus.sending) {
      await channel.sendMessage(message);
    } else if (message.status == MessageSendingStatus.failed_delete ||
        message.status == MessageSendingStatus.deleting) {
      await channel.deleteMessage(message);
    }
  }

  /// Whether our [_messageQueue] has messages or not
  bool get hasMessages => _messageQueue.isNotEmpty;

  /// Call this method to dispose this object
  void dispose() {
    _messageQueue.clear();
    _compositeSubscription.dispose();
  }

  static int _byDate(Message m1, Message m2) {
    final date1 = _getMessageDate(m1);
    final date2 = _getMessageDate(m2);

    if (date1 == null || date2 == null) {
      return 0;
    }

    return date1.compareTo(date2);
  }

  static DateTime? _getMessageDate(Message m1) {
    switch (m1.status) {
      case MessageSendingStatus.failed_delete:
      case MessageSendingStatus.deleting:
        return m1.deletedAt;

      case MessageSendingStatus.failed:
      case MessageSendingStatus.sending:
        return m1.createdAt;

      case MessageSendingStatus.failed_update:
      case MessageSendingStatus.updating:
        return m1.updatedAt;
      default:
        return null;
    }
  }
}

extension _MessageHeapPriorityQueue on HeapPriorityQueue<Message> {
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

  bool containsAllMessage(List<Message> messages) {
    if (isEmpty) return false;
    final list = toUnorderedList();
    final messageIds = messages.map((it) => it.id);
    return list.every((it) => messageIds.contains(it.id));
  }
}
