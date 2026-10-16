import 'package:freezed_annotation/freezed_annotation.dart';

import '../unread_counts_channel.dart';
import '../unread_counts_channel_type.dart';
import '../unread_counts_thread.dart';

part 'get_unread_count_response.freezed.dart';

/// The result of counting the current user's unread messages and threads, in
/// total and by channel, channel type and thread, returned by
/// [StreamChatClient.getUnreadCount].
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
  /// Null when the counts are not broken down by team. Otherwise each of the
  /// user's teams has an entry, `0` when nothing in it is unread.
  @override
  final Map<String, int>? totalUnreadCountByTeam;

  /// The channels that have unread messages.
  @override
  final List<UnreadCountsChannel> channels;

  /// The channel types that have unread messages.
  @override
  final List<UnreadCountsChannelType> channelType;

  /// The threads that have unread replies.
  @override
  final List<UnreadCountsThread> threads;
}
