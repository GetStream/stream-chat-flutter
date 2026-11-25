import 'package:freezed_annotation/freezed_annotation.dart';

import '../user.dart';

part 'query_users_response.freezed.dart';

/// One page of the users matching a query.
///
/// See also:
///
///  * [StreamChatClient.queryUsers], which returns it.
@freezed
class QueryUsersResponse with _$QueryUsersResponse {
  /// Creates a new [QueryUsersResponse].
  const QueryUsersResponse({
    required this.duration,
    required this.users,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The users on this page.
  @override
  final List<User> users;
}
