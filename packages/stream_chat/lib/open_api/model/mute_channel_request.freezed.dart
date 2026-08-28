// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mute_channel_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MuteChannelRequest {
  List<String>? get channelCids;
  int? get expiration;

  /// Create a copy of MuteChannelRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MuteChannelRequestCopyWith<MuteChannelRequest> get copyWith =>
      _$MuteChannelRequestCopyWithImpl<MuteChannelRequest>(
        this as MuteChannelRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MuteChannelRequest &&
            const DeepCollectionEquality().equals(
              other.channelCids,
              channelCids,
            ) &&
            (identical(other.expiration, expiration) ||
                other.expiration == expiration));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelCids),
    expiration,
  );

  @override
  String toString() {
    return 'MuteChannelRequest(channelCids: $channelCids, expiration: $expiration)';
  }
}

/// @nodoc
abstract mixin class $MuteChannelRequestCopyWith<$Res> {
  factory $MuteChannelRequestCopyWith(
    MuteChannelRequest value,
    $Res Function(MuteChannelRequest) _then,
  ) = _$MuteChannelRequestCopyWithImpl;
  @useResult
  $Res call({List<String>? channelCids, int? expiration});
}

/// @nodoc
class _$MuteChannelRequestCopyWithImpl<$Res>
    implements $MuteChannelRequestCopyWith<$Res> {
  _$MuteChannelRequestCopyWithImpl(this._self, this._then);

  final MuteChannelRequest _self;
  final $Res Function(MuteChannelRequest) _then;

  /// Create a copy of MuteChannelRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? channelCids = freezed, Object? expiration = freezed}) {
    return _then(
      MuteChannelRequest(
        channelCids: freezed == channelCids
            ? _self.channelCids
            : channelCids // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        expiration: freezed == expiration
            ? _self.expiration
            : expiration // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
