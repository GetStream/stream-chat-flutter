// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceResponse {
  DateTime get createdAt;
  bool? get disabled;
  String? get disabledReason;
  String? get hardwareId;
  String get id;
  String get pushProvider;
  String? get pushProviderName;
  String get userId;
  bool? get voip;

  /// Create a copy of DeviceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeviceResponseCopyWith<DeviceResponse> get copyWith =>
      _$DeviceResponseCopyWithImpl<DeviceResponse>(
        this as DeviceResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeviceResponse &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled) &&
            (identical(other.disabledReason, disabledReason) ||
                other.disabledReason == disabledReason) &&
            (identical(other.hardwareId, hardwareId) ||
                other.hardwareId == hardwareId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pushProvider, pushProvider) ||
                other.pushProvider == pushProvider) &&
            (identical(other.pushProviderName, pushProviderName) ||
                other.pushProviderName == pushProviderName) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.voip, voip) || other.voip == voip));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    disabled,
    disabledReason,
    hardwareId,
    id,
    pushProvider,
    pushProviderName,
    userId,
    voip,
  );

  @override
  String toString() {
    return 'DeviceResponse(createdAt: $createdAt, disabled: $disabled, disabledReason: $disabledReason, hardwareId: $hardwareId, id: $id, pushProvider: $pushProvider, pushProviderName: $pushProviderName, userId: $userId, voip: $voip)';
  }
}

/// @nodoc
abstract mixin class $DeviceResponseCopyWith<$Res> {
  factory $DeviceResponseCopyWith(
    DeviceResponse value,
    $Res Function(DeviceResponse) _then,
  ) = _$DeviceResponseCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    bool? disabled,
    String? disabledReason,
    String? hardwareId,
    String id,
    String pushProvider,
    String? pushProviderName,
    String userId,
    bool? voip,
  });
}

/// @nodoc
class _$DeviceResponseCopyWithImpl<$Res>
    implements $DeviceResponseCopyWith<$Res> {
  _$DeviceResponseCopyWithImpl(this._self, this._then);

  final DeviceResponse _self;
  final $Res Function(DeviceResponse) _then;

  /// Create a copy of DeviceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? disabled = freezed,
    Object? disabledReason = freezed,
    Object? hardwareId = freezed,
    Object? id = null,
    Object? pushProvider = null,
    Object? pushProviderName = freezed,
    Object? userId = null,
    Object? voip = freezed,
  }) {
    return _then(
      DeviceResponse(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        disabled: freezed == disabled
            ? _self.disabled
            : disabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        disabledReason: freezed == disabledReason
            ? _self.disabledReason
            : disabledReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        hardwareId: freezed == hardwareId
            ? _self.hardwareId
            : hardwareId // ignore: cast_nullable_to_non_nullable
                  as String?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        pushProvider: null == pushProvider
            ? _self.pushProvider
            : pushProvider // ignore: cast_nullable_to_non_nullable
                  as String,
        pushProviderName: freezed == pushProviderName
            ? _self.pushProviderName
            : pushProviderName // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        voip: freezed == voip
            ? _self.voip
            : voip // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
