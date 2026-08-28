// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_blocked_users_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetBlockedUsersResponse {
  List<BlockedUserResponse> get blocks;
  String get duration;

  /// Create a copy of GetBlockedUsersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GetBlockedUsersResponseCopyWith<GetBlockedUsersResponse> get copyWith =>
      _$GetBlockedUsersResponseCopyWithImpl<GetBlockedUsersResponse>(
        this as GetBlockedUsersResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GetBlockedUsersResponse &&
            const DeepCollectionEquality().equals(other.blocks, blocks) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(blocks),
    duration,
  );

  @override
  String toString() {
    return 'GetBlockedUsersResponse(blocks: $blocks, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $GetBlockedUsersResponseCopyWith<$Res> {
  factory $GetBlockedUsersResponseCopyWith(
    GetBlockedUsersResponse value,
    $Res Function(GetBlockedUsersResponse) _then,
  ) = _$GetBlockedUsersResponseCopyWithImpl;
  @useResult
  $Res call({List<BlockedUserResponse> blocks, String duration});
}

/// @nodoc
class _$GetBlockedUsersResponseCopyWithImpl<$Res>
    implements $GetBlockedUsersResponseCopyWith<$Res> {
  _$GetBlockedUsersResponseCopyWithImpl(this._self, this._then);

  final GetBlockedUsersResponse _self;
  final $Res Function(GetBlockedUsersResponse) _then;

  /// Create a copy of GetBlockedUsersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? blocks = null, Object? duration = null}) {
    return _then(
      GetBlockedUsersResponse(
        blocks: null == blocks
            ? _self.blocks
            : blocks // ignore: cast_nullable_to_non_nullable
                  as List<BlockedUserResponse>,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
