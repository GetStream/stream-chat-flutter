import 'package:freezed_annotation/freezed_annotation.dart';

part 'unmute_users_response.freezed.dart';

/// The outcome of removing the current user's mute on one or more users.
@freezed
class UnmuteUsersResponse with _$UnmuteUsersResponse {
  /// Creates a new [UnmuteUsersResponse].
  const UnmuteUsersResponse({
    required this.duration,
    this.nonExistingUsers = const [],
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The ids that matched no user, so nothing was unmuted for them.
  ///
  /// Never all of them: a call where no id matches fails instead.
  @override
  final List<String> nonExistingUsers;
}
