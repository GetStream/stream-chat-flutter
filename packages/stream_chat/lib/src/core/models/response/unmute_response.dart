import 'package:freezed_annotation/freezed_annotation.dart';

part 'unmute_response.freezed.dart';

/// The outcome of removing the current user's mute on one or more users.
@freezed
class UnmuteResponse with _$UnmuteResponse {
  /// Creates a new [UnmuteResponse].
  const UnmuteResponse({
    required this.duration,
    this.nonExistingUsers = const [],
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The ids that matched no user.
  ///
  /// Empty when every id resolved. An id repeated in the request appears here
  /// once per occurrence.
  @override
  final List<String> nonExistingUsers;
}
