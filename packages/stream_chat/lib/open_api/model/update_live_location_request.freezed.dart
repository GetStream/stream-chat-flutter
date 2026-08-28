// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_live_location_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateLiveLocationRequest {
  DateTime? get endAt;
  double? get latitude;
  double? get longitude;
  String get messageId;

  /// Create a copy of UpdateLiveLocationRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateLiveLocationRequestCopyWith<UpdateLiveLocationRequest> get copyWith =>
      _$UpdateLiveLocationRequestCopyWithImpl<UpdateLiveLocationRequest>(
        this as UpdateLiveLocationRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateLiveLocationRequest &&
            (identical(other.endAt, endAt) || other.endAt == endAt) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, endAt, latitude, longitude, messageId);

  @override
  String toString() {
    return 'UpdateLiveLocationRequest(endAt: $endAt, latitude: $latitude, longitude: $longitude, messageId: $messageId)';
  }
}

/// @nodoc
abstract mixin class $UpdateLiveLocationRequestCopyWith<$Res> {
  factory $UpdateLiveLocationRequestCopyWith(
    UpdateLiveLocationRequest value,
    $Res Function(UpdateLiveLocationRequest) _then,
  ) = _$UpdateLiveLocationRequestCopyWithImpl;
  @useResult
  $Res call({
    DateTime? endAt,
    double? latitude,
    double? longitude,
    String messageId,
  });
}

/// @nodoc
class _$UpdateLiveLocationRequestCopyWithImpl<$Res>
    implements $UpdateLiveLocationRequestCopyWith<$Res> {
  _$UpdateLiveLocationRequestCopyWithImpl(this._self, this._then);

  final UpdateLiveLocationRequest _self;
  final $Res Function(UpdateLiveLocationRequest) _then;

  /// Create a copy of UpdateLiveLocationRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? endAt = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? messageId = null,
  }) {
    return _then(
      UpdateLiveLocationRequest(
        endAt: freezed == endAt
            ? _self.endAt
            : endAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        latitude: freezed == latitude
            ? _self.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _self.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
