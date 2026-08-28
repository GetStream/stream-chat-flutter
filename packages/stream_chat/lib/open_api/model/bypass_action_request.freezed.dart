// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bypass_action_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BypassActionRequest {
  bool? get enabled;

  /// Create a copy of BypassActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BypassActionRequestCopyWith<BypassActionRequest> get copyWith =>
      _$BypassActionRequestCopyWithImpl<BypassActionRequest>(
        this as BypassActionRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BypassActionRequest &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enabled);

  @override
  String toString() {
    return 'BypassActionRequest(enabled: $enabled)';
  }
}

/// @nodoc
abstract mixin class $BypassActionRequestCopyWith<$Res> {
  factory $BypassActionRequestCopyWith(
    BypassActionRequest value,
    $Res Function(BypassActionRequest) _then,
  ) = _$BypassActionRequestCopyWithImpl;
  @useResult
  $Res call({bool? enabled});
}

/// @nodoc
class _$BypassActionRequestCopyWithImpl<$Res>
    implements $BypassActionRequestCopyWith<$Res> {
  _$BypassActionRequestCopyWithImpl(this._self, this._then);

  final BypassActionRequest _self;
  final $Res Function(BypassActionRequest) _then;

  /// Create a copy of BypassActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? enabled = freezed}) {
    return _then(
      BypassActionRequest(
        enabled: freezed == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
