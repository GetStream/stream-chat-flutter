// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_context_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelContextResponse {
  String get cid;
  UserResponse? get createdBy;
  String get id;
  String get type;

  /// Create a copy of ChannelContextResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelContextResponseCopyWith<ChannelContextResponse> get copyWith =>
      _$ChannelContextResponseCopyWithImpl<ChannelContextResponse>(
        this as ChannelContextResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelContextResponse &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cid, createdBy, id, type);

  @override
  String toString() {
    return 'ChannelContextResponse(cid: $cid, createdBy: $createdBy, id: $id, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ChannelContextResponseCopyWith<$Res> {
  factory $ChannelContextResponseCopyWith(
    ChannelContextResponse value,
    $Res Function(ChannelContextResponse) _then,
  ) = _$ChannelContextResponseCopyWithImpl;
  @useResult
  $Res call({String cid, UserResponse? createdBy, String id, String type});
}

/// @nodoc
class _$ChannelContextResponseCopyWithImpl<$Res> implements $ChannelContextResponseCopyWith<$Res> {
  _$ChannelContextResponseCopyWithImpl(this._self, this._then);

  final ChannelContextResponse _self;
  final $Res Function(ChannelContextResponse) _then;

  /// Create a copy of ChannelContextResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = null,
    Object? createdBy = freezed,
    Object? id = null,
    Object? type = null,
  }) {
    return _then(
      ChannelContextResponse(
        cid: null == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
