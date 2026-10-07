import 'package:freezed_annotation/freezed_annotation.dart';

part 'block_users_response.freezed.dart';

/// The block the current user placed on another user.
///
/// Returned by [StreamChatClient.blockUser].
@freezed
class BlockUsersResponse with _$BlockUsersResponse {
  /// Creates a new [BlockUsersResponse].
  const BlockUsersResponse({
    required this.duration,
    required this.blockedByUserId,
    required this.blockedUserId,
    required this.createdAt,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The id of the user who placed the block.
  @override
  final String blockedByUserId;

  /// The id of the blocked user.
  @override
  final String blockedUserId;

  /// The time the block was placed.
  @override
  final DateTime createdAt;
}
