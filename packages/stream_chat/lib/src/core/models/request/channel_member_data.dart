import 'package:freezed_annotation/freezed_annotation.dart';

part 'channel_member_data.freezed.dart';

/// A user to add to or invite into a channel.
@freezed
class ChannelMemberData with _$ChannelMemberData {
  /// Creates a request for the user with the id [userId].
  const ChannelMemberData({
    required this.userId,
    this.channelRole,
    this.custom = const {},
  });

  /// The id of the user.
  @override
  final String userId;

  /// The role the user gets in the channel, such as `channel_moderator`.
  @override
  final String? channelRole;

  /// Custom data stored on the membership.
  @override
  final Map<String, Object?> custom;
}
