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
  /// Never all of them: a call where no id matches fails instead.
  @override
  final List<String> nonExistingUsers;
}
