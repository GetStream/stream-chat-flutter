import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_partial_request.freezed.dart';

/// A partial update of one user: the fields in [set] are set and the fields named in [unset] are removed, leaving
/// every other field as it is.
///
/// Passed to [StreamChatClient.updateUsersPartial].
@freezed
class UpdateUserPartialRequest with _$UpdateUserPartialRequest {
  /// Creates a partial update of the user with [id].
  const UpdateUserPartialRequest({
    required this.id,
    this.set,
    this.unset,
  });

  /// The id of the user to update.
  @override
  final String id;

  /// The fields to set, keyed by name.
  @override
  final Map<String, Object?>? set;

  /// The names of the fields to remove.
  @override
  final List<String>? unset;
}
