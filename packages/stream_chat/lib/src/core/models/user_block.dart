import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'user_block.freezed.dart';

/// A block one [User] placed on another.
///
/// See also:
///
///  * [GetBlockedUsersResponse.blocks], which lists them.
@freezed
class UserBlock with _$UserBlock {
  /// Creates a new [UserBlock].
  const UserBlock({
    required this.user,
    required this.blockedUser,
    required this.userId,
    required this.blockedUserId,
    required this.createdAt,
  });

  /// The user who placed the block.
  @override
  final User user;

  /// The user [user] blocked.
  ///
  /// A placeholder named `Deleted User` when that user no longer exists; then
  /// only [blockedUserId] carries their id.
  @override
  final User blockedUser;

  /// The id of [user].
  @override
  final String userId;

  /// The id of [blockedUser].
  @override
  final String blockedUserId;

  /// The time [user] blocked [blockedUser].
  @override
  final DateTime createdAt;
}
