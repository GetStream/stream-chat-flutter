import 'package:freezed_annotation/freezed_annotation.dart';

import '../member.dart';

part 'update_member_partial_response.freezed.dart';

/// The result of partially updating the current user's membership of a channel.
///
/// See also:
///
///  * [StreamChatClient.updateMemberPartial], which returns it.
///  * [Channel.pin] and [Channel.archive], which return it too.
@freezed
class UpdateMemberPartialResponse with _$UpdateMemberPartialResponse {
  /// Creates a new [UpdateMemberPartialResponse].
  const UpdateMemberPartialResponse({
    required this.duration,
    this.channelMember,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The updated membership.
  @override
  final Member? channelMember;
}
