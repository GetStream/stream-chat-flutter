import 'package:freezed_annotation/freezed_annotation.dart';

import 'channel_member_data.dart';

part 'update_channel_data.freezed.dart';

/// The data that replaces all of a channel's data.
///
/// See also:
///
///  * [CreateChannelData], the data a channel is created with.
@freezed
class UpdateChannelData with _$UpdateChannelData {
  /// Creates the data that replaces a channel's data.
  const UpdateChannelData({
    this.members,
    this.invites,
    this.team,
    this.frozen,
    this.disabled,
    this.custom = const {},
  });

  /// The channel's members.
  @override
  final List<ChannelMemberData>? members;

  /// The users invited into the channel.
  @override
  final List<ChannelMemberData>? invites;

  /// The team the channel belongs to.
  @override
  final String? team;

  /// Whether the channel is frozen, so no new messages can be sent.
  @override
  final bool? frozen;

  /// Whether the channel is disabled.
  @override
  final bool? disabled;

  /// Custom data stored on the channel, such as its `name` and `image`.
  @override
  final Map<String, Object?> custom;
}
