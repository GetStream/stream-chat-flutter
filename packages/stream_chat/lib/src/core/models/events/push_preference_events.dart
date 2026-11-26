import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'push_preference_events.freezed.dart';

/// An event emitted when the current user changes their push notification
/// preferences.
@freezed
final class PushPreferenceUpdatedEvent extends ChatEvent with _$PushPreferenceUpdatedEvent {
  /// Creates a [PushPreferenceUpdatedEvent].
  PushPreferenceUpdatedEvent({
    required this.pushPreference,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.pushPreferenceUpdated;

  /// The current user's push notification preferences after the change.
  @override
  final PushPreference pushPreference;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event emitted when the current user changes their push notification
/// preferences for a channel.
@freezed
final class ChannelPushPreferenceUpdatedEvent extends ChatEvent with HasCid, _$ChannelPushPreferenceUpdatedEvent {
  /// Creates a [ChannelPushPreferenceUpdatedEvent].
  ChannelPushPreferenceUpdatedEvent({
    this.cid,
    required this.channelPushPreference,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.channelPushPreferenceUpdated;

  @override
  final String? cid;

  /// The current user's push notification preferences for the channel after the
  /// change.
  @override
  final ChannelPushPreference channelPushPreference;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}
