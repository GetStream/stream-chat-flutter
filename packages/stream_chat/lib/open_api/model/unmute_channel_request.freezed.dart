// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unmute_channel_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnmuteChannelRequest {
  List<String>? get channelCids;
  int? get expiration;

  /// Create a copy of UnmuteChannelRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnmuteChannelRequestCopyWith<UnmuteChannelRequest> get copyWith =>
      _$UnmuteChannelRequestCopyWithImpl<UnmuteChannelRequest>(
        this as UnmuteChannelRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnmuteChannelRequest &&
            const DeepCollectionEquality().equals(
              other.channelCids,
              channelCids,
            ) &&
            (identical(other.expiration, expiration) || other.expiration == expiration));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelCids),
    expiration,
  );

  @override
  String toString() {
    return 'UnmuteChannelRequest(channelCids: $channelCids, expiration: $expiration)';
  }
}

/// @nodoc
abstract mixin class $UnmuteChannelRequestCopyWith<$Res> {
  factory $UnmuteChannelRequestCopyWith(
    UnmuteChannelRequest value,
    $Res Function(UnmuteChannelRequest) _then,
  ) = _$UnmuteChannelRequestCopyWithImpl;
  @useResult
  $Res call({List<String>? channelCids, int? expiration});
}

/// @nodoc
class _$UnmuteChannelRequestCopyWithImpl<$Res> implements $UnmuteChannelRequestCopyWith<$Res> {
  _$UnmuteChannelRequestCopyWithImpl(this._self, this._then);

  final UnmuteChannelRequest _self;
  final $Res Function(UnmuteChannelRequest) _then;

  /// Create a copy of UnmuteChannelRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? channelCids = freezed, Object? expiration = freezed}) {
    return _then(
      UnmuteChannelRequest(
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
