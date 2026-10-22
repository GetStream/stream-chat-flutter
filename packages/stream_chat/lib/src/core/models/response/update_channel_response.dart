import 'package:freezed_annotation/freezed_annotation.dart';

import '../channel_model.dart';
import '../member.dart';
import '../message.dart';

part 'update_channel_response.freezed.dart';

/// The result of updating a channel, changing its members or answering an
/// invite to it.
///
/// See also:
///
///  * [StreamChatClient.updateChannel], [StreamChatClient.addChannelMembers],
///    [StreamChatClient.removeChannelMembers],
///    [StreamChatClient.inviteChannelMembers],
///    [StreamChatClient.acceptChannelInvite] and
///    [StreamChatClient.rejectChannelInvite], which return it, as do their
///    [Channel] counterparts.
@freezed
class UpdateChannelResponse with _$UpdateChannelResponse {
  /// Creates a new [UpdateChannelResponse].
  const UpdateChannelResponse({
    required this.duration,
    required this.members,
    this.channel,
    this.message,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The updated channel.
  @override
  final ChannelModel? channel;

  /// The channel's members after the update.
  @override
  final List<Member> members;

  /// The system message sent with the update, if one was given.
  @override
  final Message? message;
}
