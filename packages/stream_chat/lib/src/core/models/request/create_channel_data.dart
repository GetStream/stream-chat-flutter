import 'package:freezed_annotation/freezed_annotation.dart';

import 'channel_member_data.dart';

part 'create_channel_data.freezed.dart';

/// The data a channel is created with.
///
/// See also:
///
///  * [UpdateChannelData], the data that replaces a channel's data.
@freezed
class CreateChannelData with _$CreateChannelData {
  /// Creates the data for a new channel.
  const CreateChannelData({
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
