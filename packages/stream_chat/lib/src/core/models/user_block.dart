import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/user.dart';

part 'user_block.g.dart';

/// Contains information about a [User] that was blocked from a [Channel] or App.
@JsonSerializable()
class UserBlock extends Equatable {
  /// Creates a new instance of [UserBlock]
  const UserBlock({
    required this.user,
    this.blockedUser,
    this.userId,
    this.blockedUserId,
    this.createdAt,
  });

  /// Create a new instance from a json
  factory UserBlock.fromJson(Map<String, dynamic> json) =>
      _$UserBlockFromJson(json);

  /// User that blocked the [blockedUser].
  final User user;

  /// User that was blocked by the [user].
  final User? blockedUser;

  /// Reason for the block.
  final String? userId;

  /// Reason for the ban.
  final String? blockedUserId;

  /// Timestamp when the [user] was blocked.
  final DateTime? createdAt;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$UserBlockToJson(this);

  /// Returns a copy of this object with the given fields updated.
  UserBlock copyWith({
    User? user,
    User? blockedUser,
    String? userId,
    String? blockedUserId,
    DateTime? createdAt,
  }) =>
      UserBlock(
        user: user ?? this.user,
        blockedUser: blockedUser ?? this.blockedUser,
        userId: userId ?? this.userId,
        blockedUserId: blockedUserId ?? this.blockedUserId,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [
        user,
        blockedUser,
        userId,
        blockedUserId,
        createdAt,
      ];
}
