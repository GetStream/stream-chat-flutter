// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_member_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelMemberData {
  String get userId;
  String? get channelRole;
  Map<String, Object?> get custom;

  /// Create a copy of ChannelMemberData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelMemberDataCopyWith<ChannelMemberData> get copyWith =>
      _$ChannelMemberDataCopyWithImpl<ChannelMemberData>(this as ChannelMemberData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelMemberData &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.channelRole, channelRole) || other.channelRole == channelRole) &&
            const DeepCollectionEquality().equals(other.custom, custom));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, channelRole, const DeepCollectionEquality().hash(custom));

  @override
  String toString() {
    return 'ChannelMemberData(userId: $userId, channelRole: $channelRole, custom: $custom)';
  }
}

/// @nodoc
abstract mixin class $ChannelMemberDataCopyWith<$Res> {
  factory $ChannelMemberDataCopyWith(ChannelMemberData value, $Res Function(ChannelMemberData) _then) =
      _$ChannelMemberDataCopyWithImpl;
  @useResult
  $Res call({String userId, String? channelRole, Map<String, Object?> custom});
}

/// @nodoc
class _$ChannelMemberDataCopyWithImpl<$Res> implements $ChannelMemberDataCopyWith<$Res> {
  _$ChannelMemberDataCopyWithImpl(this._self, this._then);

  final ChannelMemberData _self;
  final $Res Function(ChannelMemberData) _then;

  /// Create a copy of ChannelMemberData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userId = null, Object? channelRole = freezed, Object? custom = null}) {
    return _then(
      ChannelMemberData(
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        channelRole: freezed == channelRole
            ? _self.channelRole
            : channelRole // ignore: cast_nullable_to_non_nullable
                  as String?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
      ),
    );
  }
}
