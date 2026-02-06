import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_delete_scope.freezed.dart';
part 'message_delete_scope.g.dart';

/// Represents the scope of deletion for a message.
///
/// - [deleteForMe]: The message is deleted only for the current user.
/// - [deleteForAll]: The message is deleted for all users. The [hard]
///   parameter indicates whether the deletion is permanent (hard) or soft.
@freezed
sealed class MessageDeleteScope with _$MessageDeleteScope {
  /// The message is deleted only for the current user.
  ///
  /// Note: This does not permanently delete the message, it will remain
  /// visible to other channel members.
  const factory MessageDeleteScope.deleteForMe() = DeleteForMe;

  /// The message is deleted for all users.
  ///
  /// If [hard] is true, the message is permanently deleted and cannot be
  /// recovered. If false, the message is soft deleted and may be recoverable
  /// by channel members with the appropriate permissions.
  ///
  /// Defaults to soft deletion (hard = false).
  const factory MessageDeleteScope.deleteForAll({
    @Default(false) bool hard,
  }) = DeleteForAll;

  /// Creates a instance of [MessageDeleteScope] from a JSON map.
  factory MessageDeleteScope.fromJson(Map<String, dynamic> json) => _$MessageDeleteScopeFromJson(json);

  // region Predefined Scopes

  /// The message is soft deleted for all users.
  ///
  /// This is equivalent to `MessageDeleteScope.deleteForAll(hard: false)`.
  static const softDeleteForAll = MessageDeleteScope.deleteForAll();

  /// The message is permanently (hard) deleted for all users.
  ///
  /// This is equivalent to `MessageDeleteScope.deleteForAll(hard: true)`.
  static const hardDeleteForAll = MessageDeleteScope.deleteForAll(hard: true);

  // endregion
}

/// Extension methods for [MessageDeleteScope] to provide additional
/// functionality.
extension MessageDeleteScopeX on MessageDeleteScope {
  /// Indicates whether the deletion is permanent (hard) or soft.
  ///
  /// For [DeleteForMe], this is always false.
  bool get hard {
    return switch (this) {
      DeleteForMe() => false,
      DeleteForAll(hard: final hard) => hard,
    };
  }
}
