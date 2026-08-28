// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block_users_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockUsersRequest {
  String get blockedUserId;

  /// Create a copy of BlockUsersRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlockUsersRequestCopyWith<BlockUsersRequest> get copyWith =>
      _$BlockUsersRequestCopyWithImpl<BlockUsersRequest>(
        this as BlockUsersRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlockUsersRequest &&
            (identical(other.blockedUserId, blockedUserId) ||
                other.blockedUserId == blockedUserId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, blockedUserId);

  @override
  String toString() {
    return 'BlockUsersRequest(blockedUserId: $blockedUserId)';
  }
}

/// @nodoc
abstract mixin class $BlockUsersRequestCopyWith<$Res> {
  factory $BlockUsersRequestCopyWith(
    BlockUsersRequest value,
    $Res Function(BlockUsersRequest) _then,
  ) = _$BlockUsersRequestCopyWithImpl;
  @useResult
  $Res call({String blockedUserId});
}

/// @nodoc
class _$BlockUsersRequestCopyWithImpl<$Res>
    implements $BlockUsersRequestCopyWith<$Res> {
  _$BlockUsersRequestCopyWithImpl(this._self, this._then);

  final BlockUsersRequest _self;
  final $Res Function(BlockUsersRequest) _then;

  /// Create a copy of BlockUsersRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? blockedUserId = null}) {
    return _then(
      BlockUsersRequest(
        blockedUserId: null == blockedUserId
            ? _self.blockedUserId
            : blockedUserId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
