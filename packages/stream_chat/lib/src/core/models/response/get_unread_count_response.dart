import 'package:freezed_annotation/freezed_annotation.dart';

import '../unread_counts_channel.dart';
import '../unread_counts_channel_type.dart';
import '../unread_counts_thread.dart';

part 'get_unread_count_response.freezed.dart';

/// How many unread messages and threads the current user has, in total and by channel, channel type and thread.
///
/// Returned by [StreamChatClient.getUnreadCount].
@freezed
class GetUnreadCountResponse with _$GetUnreadCountResponse {
  /// Creates a new [GetUnreadCountResponse].
  const GetUnreadCountResponse({
    required this.duration,
    required this.totalUnreadCount,
    required this.totalUnreadThreadsCount,
    this.totalUnreadCountByTeam,
    required this.channels,
    required this.channelType,
    required this.threads,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The number of unread messages across all of the user's channels.
  @override
  final int totalUnreadCount;

  /// The number of threads with unread replies.
  @override
  final int totalUnreadThreadsCount;

  /// The number of unread messages in each of the user's teams, keyed by team.
  ///
  /// Null when unread messages are not counted per team, or the user belongs to no team. Otherwise each of the
  /// user's teams has an entry, `0` when nothing in it is unread.
  @override
  final Map<String, int>? totalUnreadCountByTeam;

  /// The channels that have unread messages.
  @override
  final List<UnreadCountsChannel> channels;

  /// The unread messages of each channel type that has any.
  @override
  final List<UnreadCountsChannelType> channelType;

  /// The threads that have unread replies.
  @override
  final List<UnreadCountsThread> threads;
}
