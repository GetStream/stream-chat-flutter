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
  /// Only ever some of the ids given: a call where none of them match a user
  /// fails instead. It is therefore always empty when one id was given, and an
  /// id repeated in the call appears here once per occurrence.
  @override
  final List<String> nonExistingUsers;
}
