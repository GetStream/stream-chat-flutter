// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hide_channel_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HideChannelRequest {
  bool? get clearHistory;

  /// Create a copy of HideChannelRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HideChannelRequestCopyWith<HideChannelRequest> get copyWith =>
      _$HideChannelRequestCopyWithImpl<HideChannelRequest>(
        this as HideChannelRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HideChannelRequest &&
            (identical(other.clearHistory, clearHistory) ||
                other.clearHistory == clearHistory));
  }

  @override
  int get hashCode => Object.hash(runtimeType, clearHistory);

  @override
  String toString() {
    return 'HideChannelRequest(clearHistory: $clearHistory)';
  }
}

/// @nodoc
abstract mixin class $HideChannelRequestCopyWith<$Res> {
  factory $HideChannelRequestCopyWith(
    HideChannelRequest value,
    $Res Function(HideChannelRequest) _then,
  ) = _$HideChannelRequestCopyWithImpl;
  @useResult
  $Res call({bool? clearHistory});
}

/// @nodoc
class _$HideChannelRequestCopyWithImpl<$Res>
    implements $HideChannelRequestCopyWith<$Res> {
  _$HideChannelRequestCopyWithImpl(this._self, this._then);

  final HideChannelRequest _self;
  final $Res Function(HideChannelRequest) _then;

  /// Create a copy of HideChannelRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? clearHistory = freezed}) {
    return _then(
      HideChannelRequest(
        clearHistory: freezed == clearHistory
            ? _self.clearHistory
            : clearHistory // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
