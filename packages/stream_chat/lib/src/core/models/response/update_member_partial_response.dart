import 'package:freezed_annotation/freezed_annotation.dart';

import '../member.dart';

part 'update_member_partial_response.freezed.dart';

/// The current user's membership of a channel after some of its fields were set or unset.
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
