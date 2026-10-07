import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api;
import '../core/models/response/block_user_response.dart';
import '../core/models/response/get_blocked_users_response.dart';
import '../core/models/response/get_unread_count_response.dart';
import '../core/models/response/unblock_user_response.dart';
import 'mapper/user_mapper.dart';

/// Repository dedicated to user operations.
class UsersRepository {
  /// Creates a new users repository.
  const UsersRepository(this._api);

  final api.DefaultApi _api;

  /// Gets how many unread messages and threads the current user has.
  Future<Result<GetUnreadCountResponse>> getUnreadCount() async {
    final result = await _api.unreadCounts();
    return result.map((response) => response.toModel());
  }

  /// Blocks the user with the given [userId] for the current user.
  Future<Result<BlockUserResponse>> blockUser(String userId) async {
    final result = await _api.blockUsers(blockUsersRequest: api.BlockUsersRequest(blockedUserId: userId));
    return result.map((response) => response.toModel());
  }

  /// Unblocks the user with the given [userId] for the current user.
  Future<Result<UnblockUserResponse>> unblockUser(String userId) async {
    final result = await _api.unblockUsers(unblockUsersRequest: api.UnblockUsersRequest(blockedUserId: userId));
    return result.map((response) => response.toModel());
  }

  /// Gets the users the current user has blocked.
  Future<Result<GetBlockedUsersResponse>> getBlockedUsers() async {
    final result = await _api.getBlockedUsers();
    return result.map((response) => response.toModel());
  }
}
