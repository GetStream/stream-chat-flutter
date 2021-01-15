import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat/src/api/channel.dart';
import 'package:stream_chat/src/api/retry_policy.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:stream_chat/src/exceptions.dart';
import 'package:stream_chat/src/models/message.dart';
import 'package:stream_chat/stream_chat.dart';

/// The retry queue associated to a channel
class RetryQueue {
  /// The channel of this queue
  final Channel channel;

  /// The logger associated to this queue
  final Logger logger;

  /// Instantiate a new RetryQueue object
  RetryQueue({
    @required this.channel,
    this.logger,
  }) {
    _retryPolicy = channel.client.retryPolicy;

    _listenConnectionRecovered();

    _listenFailedEvents();
  }

  final _subscriptions = <StreamSubscription>[];

  void _listenConnectionRecovered() {
    _subscriptions
        .add(channel.client.on(EventType.connectionRecovered).listen((event) {
      if (!_isRetrying && event.online) {
        _startRetrying();
      }
    }));
  }

  final HeapPriorityQueue<Message> _messageQueue = HeapPriorityQueue(_byDate);
  bool _isRetrying = false;
  RetryPolicy _retryPolicy;

  /// Add a list of messages
  void add(List<Message> messages) {
    final messageList = _messageQueue.toList();
    _messageQueue.addAll(messages
        .where((element) => !messageList.any((m) => m.id == element.id)));

    if (_messageQueue.isNotEmpty && !_isRetrying) {
      _startRetrying();
    }
  }

  Future<void> _startRetrying() async {
    logger?.info('start retrying');
    _isRetrying = true;
    final retryPolicy = _retryPolicy.copyWith(attempt: 0);

    while (_messageQueue.isNotEmpty) {
      final message = _messageQueue.first;
      try {
        logger?.info('retry attempt ${retryPolicy.attempt}');
        await _sendMessage(message);
        logger?.info('message sent - removing it from the queue');
        _messageQueue.remove(message);
        logger?.info('now ${_messageQueue.length} messages in the queue');
        retryPolicy.attempt = 0;
      } catch (error) {
        ApiError apiError;
        if (error is DioError) {
          if (error.type == DioErrorType.RESPONSE) {
            _messageQueue.remove(message);
            return;
          }
          apiError = ApiError(
            error.response?.data,
            error.response?.statusCode,
          );
        } else if (error is ApiError) {
          apiError = error;
          if (apiError.status?.toString()?.startsWith('4') == true) {
            _messageQueue.remove(message);
            return;
          }
        }

        if (!retryPolicy.shouldRetry(
          channel.client,
          retryPolicy.attempt,
          apiError,
        )) {
          _messageQueue.toList().forEach(_sendFailedEvent);
          _isRetrying = false;
          return;
        }

        retryPolicy.attempt++;
        final timeout = retryPolicy.retryTimeout(
          channel.client,
          retryPolicy.attempt,
          apiError,
        );
        await Future.delayed(timeout);
      }
    }
    _isRetrying = false;
  }

  void _sendFailedEvent(Message message) {
    final newStatus = message.status == MessageSendingStatus.SENDING
        ? MessageSendingStatus.FAILED
        : (message.status == MessageSendingStatus.UPDATING
            ? MessageSendingStatus.FAILED_UPDATE
            : MessageSendingStatus.FAILED_DELETE);
    channel.state.addMessage(message.copyWith(
      status: newStatus,
    ));
  }

  Future<void> _sendMessage(Message message) async {
    if (message.status == MessageSendingStatus.FAILED_UPDATE ||
        message.status == MessageSendingStatus.UPDATING) {
      await channel.client.updateMessage(
        message,
        channel.cid,
      );
    } else if (message.status == MessageSendingStatus.FAILED ||
        message.status == MessageSendingStatus.SENDING) {
      await channel.sendMessage(
        message,
      );
    } else if (message.status == MessageSendingStatus.FAILED_DELETE ||
        message.status == MessageSendingStatus.DELETING) {
      await channel.client.deleteMessage(
        message,
        channel.cid,
      );
    }
  }

  void _listenFailedEvents() {
    _subscriptions.add(channel.on().listen((event) {
      final messageList = _messageQueue.toList();
      if (event.message != null) {
        final messageIndex =
            messageList.indexWhere((m) => m.id == event.message.id);
        if (messageIndex == -1 &&
            [
              MessageSendingStatus.FAILED_UPDATE,
              MessageSendingStatus.FAILED,
              MessageSendingStatus.FAILED_DELETE,
            ].contains(event.message.status)) {
          logger?.info('add message from events');
          add([event.message]);
        } else if (messageIndex != -1 &&
            [
              MessageSendingStatus.SENT,
              null,
            ].contains(event.message.status)) {
          _messageQueue.remove(messageList[messageIndex]);
        }
      }
    }));
  }

  /// Call this method to dispose this object
  void dispose() {
    _messageQueue.clear();
    _subscriptions.forEach((s) => s.cancel());
  }

  static int _byDate(Message m1, Message m2) {
    final date1 = _getMessageDate(m1);
    final date2 = _getMessageDate(m2);

    return date1.compareTo(date2);
  }

  static DateTime _getMessageDate(Message m1) {
    switch (m1.status) {
      case MessageSendingStatus.FAILED_DELETE:
      case MessageSendingStatus.DELETING:
        return m1.deletedAt;

      case MessageSendingStatus.FAILED:
      case MessageSendingStatus.SENDING:
        return m1.createdAt;

      case MessageSendingStatus.FAILED_UPDATE:
      case MessageSendingStatus.UPDATING:
        return m1.updatedAt;
      default:
        return null;
    }
  }
}
