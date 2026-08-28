// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_action_config_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModerationActionConfigResponse {
  String get action;
  Map<String, Object?>? get custom;
  String get description;
  String get entityType;
  String get icon;
  String? get id;
  int get order;
  String? get queueType;

  /// Create a copy of ModerationActionConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationActionConfigResponseCopyWith<ModerationActionConfigResponse>
  get copyWith =>
      _$ModerationActionConfigResponseCopyWithImpl<
        ModerationActionConfigResponse
      >(this as ModerationActionConfigResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationActionConfigResponse &&
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
    return 'ModerationActionConfigResponse(action: $action, custom: $custom, description: $description, entityType: $entityType, icon: $icon, id: $id, order: $order, queueType: $queueType)';
  }
}

/// @nodoc
abstract mixin class $ModerationActionConfigResponseCopyWith<$Res> {
  factory $ModerationActionConfigResponseCopyWith(
    ModerationActionConfigResponse value,
    $Res Function(ModerationActionConfigResponse) _then,
  ) = _$ModerationActionConfigResponseCopyWithImpl;
  @useResult
  $Res call({
    String action,
    Map<String, Object?>? custom,
    String description,
    String entityType,
    String icon,
    String? id,
    int order,
    String? queueType,
  });
}

/// @nodoc
class _$ModerationActionConfigResponseCopyWithImpl<$Res>
    implements $ModerationActionConfigResponseCopyWith<$Res> {
  _$ModerationActionConfigResponseCopyWithImpl(this._self, this._then);

  final ModerationActionConfigResponse _self;
  final $Res Function(ModerationActionConfigResponse) _then;

  /// Create a copy of ModerationActionConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? action = null,
    Object? custom = freezed,
    Object? description = null,
    Object? entityType = null,
    Object? icon = null,
    Object? id = freezed,
    Object? order = null,
    Object? queueType = freezed,
  }) {
    return _then(
      ModerationActionConfigResponse(
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        description: null == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _self.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: null == icon
            ? _self.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
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
