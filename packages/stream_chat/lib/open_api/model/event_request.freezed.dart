// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventRequest {
  Map<String, Object?>? get custom;
  String? get parentId;
  String get type;

  /// Create a copy of EventRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EventRequestCopyWith<EventRequest> get copyWith =>
      _$EventRequestCopyWithImpl<EventRequest>(
        this as EventRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EventRequest &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(custom),
    parentId,
    type,
  );

  @override
  String toString() {
    return 'EventRequest(custom: $custom, parentId: $parentId, type: $type)';
  }
}

/// @nodoc
abstract mixin class $EventRequestCopyWith<$Res> {
  factory $EventRequestCopyWith(
    EventRequest value,
    $Res Function(EventRequest) _then,
  ) = _$EventRequestCopyWithImpl;
  @useResult
  $Res call({Map<String, Object?>? custom, String? parentId, String type});
}

/// @nodoc
class _$EventRequestCopyWithImpl<$Res> implements $EventRequestCopyWith<$Res> {
  _$EventRequestCopyWithImpl(this._self, this._then);

  final EventRequest _self;
  final $Res Function(EventRequest) _then;

  /// Create a copy of EventRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? custom = freezed,
    Object? parentId = freezed,
    Object? type = null,
  }) {
    return _then(
      EventRequest(
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
