// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upsert_action_config_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpsertActionConfigRequest {
  String get action;
  Map<String, Object?>? get custom;
  String? get description;
  String get entityType;
  String? get icon;
  String? get id;
  int get order;
  String? get queueType;

  /// Create a copy of UpsertActionConfigRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpsertActionConfigRequestCopyWith<UpsertActionConfigRequest> get copyWith =>
      _$UpsertActionConfigRequestCopyWithImpl<UpsertActionConfigRequest>(
        this as UpsertActionConfigRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpsertActionConfigRequest &&
            (identical(other.action, action) || other.action == action) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.queueType, queueType) ||
                other.queueType == queueType));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    action,
    const DeepCollectionEquality().hash(custom),
    description,
    entityType,
    icon,
    id,
    order,
    queueType,
  );

  @override
  String toString() {
    return 'UpsertActionConfigRequest(action: $action, custom: $custom, description: $description, entityType: $entityType, icon: $icon, id: $id, order: $order, queueType: $queueType)';
  }
}

/// @nodoc
abstract mixin class $UpsertActionConfigRequestCopyWith<$Res> {
  factory $UpsertActionConfigRequestCopyWith(
    UpsertActionConfigRequest value,
    $Res Function(UpsertActionConfigRequest) _then,
  ) = _$UpsertActionConfigRequestCopyWithImpl;
  @useResult
  $Res call({
    String action,
    Map<String, Object?>? custom,
    String? description,
    String entityType,
    String? icon,
    String? id,
    int order,
    String? queueType,
  });
}

/// @nodoc
class _$UpsertActionConfigRequestCopyWithImpl<$Res>
    implements $UpsertActionConfigRequestCopyWith<$Res> {
  _$UpsertActionConfigRequestCopyWithImpl(this._self, this._then);

  final UpsertActionConfigRequest _self;
  final $Res Function(UpsertActionConfigRequest) _then;

  /// Create a copy of UpsertActionConfigRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? custom = freezed,
    Object? description = freezed,
    Object? entityType = null,
    Object? icon = freezed,
    Object? id = freezed,
    Object? order = null,
    Object? queueType = freezed,
  }) {
    return _then(
      UpsertActionConfigRequest(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        description: freezed == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        entityType: null == entityType
            ? _self.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: freezed == icon
            ? _self.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        id: freezed == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        order: null == order
            ? _self.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        queueType: freezed == queueType
            ? _self.queueType
            : queueType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
