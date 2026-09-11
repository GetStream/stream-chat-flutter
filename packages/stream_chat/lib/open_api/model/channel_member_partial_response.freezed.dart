// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_member_partial_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelMemberPartialResponse {
  String get channelRole;
  Map<String, Object?>? get custom;
  bool get notificationsMuted;

  /// Create a copy of ChannelMemberPartialResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelMemberPartialResponseCopyWith<ChannelMemberPartialResponse> get copyWith =>
      _$ChannelMemberPartialResponseCopyWithImpl<ChannelMemberPartialResponse>(
        this as ChannelMemberPartialResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelMemberPartialResponse &&
            (identical(other.channelRole, channelRole) || other.channelRole == channelRole) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.notificationsMuted, notificationsMuted) ||
                other.notificationsMuted == notificationsMuted));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelRole,
    const DeepCollectionEquality().hash(custom),
    notificationsMuted,
  );

  @override
  String toString() {
    return 'ChannelMemberPartialResponse(channelRole: $channelRole, custom: $custom, notificationsMuted: $notificationsMuted)';
  }
}

/// @nodoc
abstract mixin class $ChannelMemberPartialResponseCopyWith<$Res> {
  factory $ChannelMemberPartialResponseCopyWith(
    ChannelMemberPartialResponse value,
    $Res Function(ChannelMemberPartialResponse) _then,
  ) = _$ChannelMemberPartialResponseCopyWithImpl;
  @useResult
  $Res call({
    String channelRole,
    Map<String, Object?>? custom,
    bool notificationsMuted,
  });
}

/// @nodoc
class _$ChannelMemberPartialResponseCopyWithImpl<$Res> implements $ChannelMemberPartialResponseCopyWith<$Res> {
  _$ChannelMemberPartialResponseCopyWithImpl(this._self, this._then);

  final ChannelMemberPartialResponse _self;
  final $Res Function(ChannelMemberPartialResponse) _then;

  /// Create a copy of ChannelMemberPartialResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelRole = null,
    Object? custom = freezed,
    Object? notificationsMuted = null,
  }) {
    return _then(
      ChannelMemberPartialResponse(
        channelRole: null == channelRole
            ? _self.channelRole
            : channelRole // ignore: cast_nullable_to_non_nullable
                  as String,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        notificationsMuted: null == notificationsMuted
            ? _self.notificationsMuted
            : notificationsMuted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
