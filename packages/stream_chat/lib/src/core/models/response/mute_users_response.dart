import 'package:freezed_annotation/freezed_annotation.dart';

part 'mute_users_response.freezed.dart';

/// The outcome of muting one or more users for the current user.
@freezed
class MuteUsersResponse with _$MuteUsersResponse {
  /// Creates a new [MuteUsersResponse].
  const MuteUsersResponse({
    required this.duration,
    this.nonExistingUsers = const [],
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The ids that matched no user, so nothing was muted for them.
  ///
  /// Only ever some of the ids given: a call where none of them match a user
  /// fails instead. It is therefore always empty when one id was given, and an
  /// id repeated in the call appears here once per occurrence.
  @override
  final List<String> nonExistingUsers;
}
