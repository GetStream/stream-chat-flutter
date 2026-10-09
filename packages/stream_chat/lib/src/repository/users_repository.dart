import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api;
import '../core/models/request/update_user_partial_request.dart';
import '../core/models/response/block_users_response.dart';
import '../core/models/response/get_blocked_users_response.dart';
import '../core/models/response/get_unread_count_response.dart';
import '../core/models/response/unblock_users_response.dart';
import '../core/models/response/update_users_response.dart';
import '../core/models/user.dart';
import 'mapper/users_mapper.dart';

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
  Future<Result<BlockUsersResponse>> blockUser(String userId) async {
    final result = await _api.blockUsers(blockUsersRequest: api.BlockUsersRequest(blockedUserId: userId));
    return result.map((response) => response.toModel());
  }

  /// Unblocks the user with the given [userId] for the current user.
  Future<Result<UnblockUsersResponse>> unblockUser(String userId) async {
    final result = await _api.unblockUsers(unblockUsersRequest: api.UnblockUsersRequest(blockedUserId: userId));
    return result.map((response) => response.toModel());
  }

  /// Gets the users the current user has blocked.
  Future<Result<GetBlockedUsersResponse>> getBlockedUsers() async {
    final result = await _api.getBlockedUsers();
    return result.map((response) => response.toModel());
  }

  /// Creates or replaces each of [users], as [StreamChatClient.updateUser] does for one.
  Future<Result<UpdateUsersResponse>> updateUsers(List<User> users) async {
    final result = await _api.updateUsers(
      updateUsersRequest: api.UpdateUsersRequest(users: {for (final user in users) user.id: user.toRequest()}),
    );

    return result.map((response) => response.toModel());
  }

  /// Partially updates several users at once, applying each of [updates] to the user it names.
  Future<Result<UpdateUsersResponse>> updateUsersPartial(List<UpdateUserPartialRequest> updates) async {
    final result = await _api.updateUsersPartial(
      updateUsersPartialRequest: api.UpdateUsersPartialRequest(users: [for (final it in updates) it.toRequest()]),
    );

    return result.map((response) => response.toModel());
  }
}
