// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_indicator_stop_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIIndicatorStopEvent {
  String? get channelId;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of AIIndicatorStopEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIIndicatorStopEventCopyWith<AIIndicatorStopEvent> get copyWith =>
      _$AIIndicatorStopEventCopyWithImpl<AIIndicatorStopEvent>(
        this as AIIndicatorStopEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIIndicatorStopEvent &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.channelType, channelType) ||
                other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelId,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'AIIndicatorStopEvent(channelId: $channelId, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $AIIndicatorStopEventCopyWith<$Res> {
  factory $AIIndicatorStopEventCopyWith(
    AIIndicatorStopEvent value,
    $Res Function(AIIndicatorStopEvent) _then,
  ) = _$AIIndicatorStopEventCopyWithImpl;
  @useResult
  $Res call({
    String? channelId,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$AIIndicatorStopEventCopyWithImpl<$Res>
    implements $AIIndicatorStopEventCopyWith<$Res> {
  _$AIIndicatorStopEventCopyWithImpl(this._self, this._then);

  final AIIndicatorStopEvent _self;
  final $Res Function(AIIndicatorStopEvent) _then;

  /// Create a copy of AIIndicatorStopEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      AIIndicatorStopEvent(
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
