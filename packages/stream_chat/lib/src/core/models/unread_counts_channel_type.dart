import 'package:freezed_annotation/freezed_annotation.dart';

part 'unread_counts_channel_type.freezed.dart';

/// The current user's unread count across the channels of one channel type.
///
/// Listed in [GetUnreadCountResponse.channelType].
@freezed
class UnreadCountsChannelType with _$UnreadCountsChannelType {
  /// Creates a new [UnreadCountsChannelType].
  const UnreadCountsChannelType({
    required this.channelType,
    required this.channelCount,
    required this.unreadCount,
  });

  /// The channel type, such as `messaging` or `livestream`.
  @override
  final String channelType;

  /// The number of channels of this type that have unread messages.
  @override
  final int channelCount;

  /// The number of unread messages across all channels of this type.
  @override
  final int unreadCount;
}
