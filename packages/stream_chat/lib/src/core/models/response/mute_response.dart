import 'package:freezed_annotation/freezed_annotation.dart';

part 'mute_response.freezed.dart';

/// The outcome of muting one or more users for the current user.
@freezed
class MuteResponse with _$MuteResponse {
  /// Creates a new [MuteResponse].
  const MuteResponse({
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
