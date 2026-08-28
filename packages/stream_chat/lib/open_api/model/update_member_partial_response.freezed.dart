// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_member_partial_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateMemberPartialResponse {
  ChannelMemberResponse? get channelMember;
  String get duration;

  /// Create a copy of UpdateMemberPartialResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateMemberPartialResponseCopyWith<UpdateMemberPartialResponse>
  get copyWith =>
      _$UpdateMemberPartialResponseCopyWithImpl<UpdateMemberPartialResponse>(
        this as UpdateMemberPartialResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateMemberPartialResponse &&
            (identical(other.channelMember, channelMember) ||
                other.channelMember == channelMember) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, channelMember, duration);

  @override
  String toString() {
    return 'UpdateMemberPartialResponse(channelMember: $channelMember, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $UpdateMemberPartialResponseCopyWith<$Res> {
  factory $UpdateMemberPartialResponseCopyWith(
    UpdateMemberPartialResponse value,
    $Res Function(UpdateMemberPartialResponse) _then,
  ) = _$UpdateMemberPartialResponseCopyWithImpl;
  @useResult
  $Res call({ChannelMemberResponse? channelMember, String duration});
}

/// @nodoc
class _$UpdateMemberPartialResponseCopyWithImpl<$Res>
    implements $UpdateMemberPartialResponseCopyWith<$Res> {
  _$UpdateMemberPartialResponseCopyWithImpl(this._self, this._then);

  final UpdateMemberPartialResponse _self;
  final $Res Function(UpdateMemberPartialResponse) _then;

  /// Create a copy of UpdateMemberPartialResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? channelMember = freezed, Object? duration = null}) {
    return _then(
      UpdateMemberPartialResponse(
        channelMember: freezed == channelMember
            ? _self.channelMember
            : channelMember // ignore: cast_nullable_to_non_nullable
                  as ChannelMemberResponse?,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
