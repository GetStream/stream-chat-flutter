import 'package:json_annotation/json_annotation.dart';

part 'unread_counts.g.dart';

/// {@template unreadCountsChannel}
/// A model class representing information for a specific channel.
/// {@endtemplate}
@JsonSerializable()
class UnreadCountsChannel {
  /// {@macro unreadCountsChannel}
  const UnreadCountsChannel({
    required this.channelId,
    required this.unreadCount,
    required this.lastRead,
  });

  /// Create a new instance from a json.
  factory UnreadCountsChannel.fromJson(Map<String, dynamic> json) => _$UnreadCountsChannelFromJson(json);

  /// The unique identifier of the channel (format: "type:id").
  final String channelId;

  /// Number of unread messages in this channel.
  final int unreadCount;

  /// Timestamp when the channel was last read by the user.
  final DateTime lastRead;

  /// Serializes this instance to a JSON map.
  Map<String, dynamic> toJson() => _$UnreadCountsChannelToJson(this);
}

/// {@template unreadCountsThread}
/// A model class representing unread count information for a specific thread.
/// {@endtemplate}
@JsonSerializable()
class UnreadCountsThread {
  /// {@macro unreadCountsThread}
  const UnreadCountsThread({
    required this.unreadCount,
    required this.lastRead,
    required this.lastReadMessageId,
    required this.parentMessageId,
  });

  /// Create a new instance from a json.
  factory UnreadCountsThread.fromJson(Map<String, dynamic> json) => _$UnreadCountsThreadFromJson(json);

  /// Number of unread messages in this thread.
  final int unreadCount;

  /// Timestamp when the thread was last read by the user.
  final DateTime lastRead;

  /// ID of the last message that was read in this thread.
  final String lastReadMessageId;

  /// ID of the parent message that started this thread.
  final String parentMessageId;

  /// Serializes this instance to a JSON map.
  Map<String, dynamic> toJson() => _$UnreadCountsThreadToJson(this);
}

/// {@template unreadCountsChannelType}
/// A model class representing aggregated unread count information for a
/// specific channel type.
/// {@endtemplate}
@JsonSerializable()
class UnreadCountsChannelType {
  /// {@macro unreadCountsChannelType}
  const UnreadCountsChannelType({
    required this.channelType,
    required this.channelCount,
    required this.unreadCount,
  });

  /// Create a new instance from a json.
  factory UnreadCountsChannelType.fromJson(Map<String, dynamic> json) => _$UnreadCountsChannelTypeFromJson(json);

  /// The type of channel (e.g., "messaging", "livestream", "team").
  final String channelType;

  /// Number of channels of this type that have unread messages.
  final int channelCount;

  /// Total number of unread messages across all channels of this type.
  final int unreadCount;

  /// Serializes this instance to a JSON map.
  Map<String, dynamic> toJson() => _$UnreadCountsChannelTypeToJson(this);
}
