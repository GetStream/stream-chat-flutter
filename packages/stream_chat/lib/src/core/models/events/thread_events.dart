import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'thread_events.freezed.dart';

/// An event sent when a thread is updated.
@freezed
final class ThreadUpdatedEvent extends ChatEvent with HasCid, _$ThreadUpdatedEvent {
  /// Creates a [ThreadUpdatedEvent].
  ThreadUpdatedEvent({
    this.cid,
    this.channelId,
    this.channelType,
    this.thread,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.threadUpdated;

  @override
  final String? cid;

  /// The id of the channel the event belongs to, without its type.
  @override
  final String? channelId;

  /// The type of the channel the event belongs to, such as `messaging`.
  @override
  final String? channelType;

  /// The thread as it is after the update.
  @override
  final Thread? thread;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}
