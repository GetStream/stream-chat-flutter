import 'package:freezed_annotation/freezed_annotation.dart';

import '../user.dart';

part 'update_users_response.freezed.dart';

/// The result of creating, updating or partially updating users.
///
/// See also:
///
///  * [StreamChatClient.updateUser], [StreamChatClient.updateUsers],
///    [StreamChatClient.updateUserPartial] and
///    [StreamChatClient.updateUsersPartial], which return it.
@freezed
class UpdateUsersResponse with _$UpdateUsersResponse {
  /// Creates a new [UpdateUsersResponse].
  const UpdateUsersResponse({
    required this.duration,
    required this.users,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The updated users, keyed by id.
  @override
  final Map<String, User> users;
}
