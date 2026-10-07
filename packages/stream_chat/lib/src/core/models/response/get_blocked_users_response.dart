import 'package:freezed_annotation/freezed_annotation.dart';

import '../user_block.dart';

part 'get_blocked_users_response.freezed.dart';

/// The users the current user has blocked.
///
/// Returned by [StreamChatClient.getBlockedUsers].
@freezed
class GetBlockedUsersResponse with _$GetBlockedUsersResponse {
  /// Creates a new [GetBlockedUsersResponse].
  const GetBlockedUsersResponse({
    required this.duration,
    required this.blocks,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// One block for each user the current user has blocked.
  @override
  final List<UserBlock> blocks;
}
