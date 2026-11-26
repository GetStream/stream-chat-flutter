// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_preference_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushPreferenceUpdatedEvent {
  PushPreference get pushPreference;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of PushPreferenceUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PushPreferenceUpdatedEventCopyWith<PushPreferenceUpdatedEvent> get copyWith =>
      _$PushPreferenceUpdatedEventCopyWithImpl<PushPreferenceUpdatedEvent>(
        this as PushPreferenceUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PushPreferenceUpdatedEvent &&
            (identical(other.pushPreference, pushPreference) || other.pushPreference == pushPreference) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    pushPreference,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'PushPreferenceUpdatedEvent(pushPreference: $pushPreference, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $PushPreferenceUpdatedEventCopyWith<$Res> {
  factory $PushPreferenceUpdatedEventCopyWith(
    PushPreferenceUpdatedEvent value,
    $Res Function(PushPreferenceUpdatedEvent) _then,
  ) = _$PushPreferenceUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    PushPreference pushPreference,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$PushPreferenceUpdatedEventCopyWithImpl<$Res> implements $PushPreferenceUpdatedEventCopyWith<$Res> {
  _$PushPreferenceUpdatedEventCopyWithImpl(this._self, this._then);

  final PushPreferenceUpdatedEvent _self;
  final $Res Function(PushPreferenceUpdatedEvent) _then;

  /// Create a copy of PushPreferenceUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pushPreference = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      PushPreferenceUpdatedEvent(
        pushPreference: null == pushPreference
            ? _self.pushPreference
            : pushPreference // ignore: cast_nullable_to_non_nullable
                  as PushPreference,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        isLocal: null == isLocal
            ? _self.isLocal
            : isLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
mixin _$ChannelPushPreferenceUpdatedEvent {
  String? get cid;
  ChannelPushPreference get channelPushPreference;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ChannelPushPreferenceUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelPushPreferenceUpdatedEventCopyWith<ChannelPushPreferenceUpdatedEvent> get copyWith =>
      _$ChannelPushPreferenceUpdatedEventCopyWithImpl<ChannelPushPreferenceUpdatedEvent>(
        this as ChannelPushPreferenceUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelPushPreferenceUpdatedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelPushPreference, channelPushPreference) ||
                other.channelPushPreference == channelPushPreference) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    channelPushPreference,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ChannelPushPreferenceUpdatedEvent(cid: $cid, channelPushPreference: $channelPushPreference, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ChannelPushPreferenceUpdatedEventCopyWith<$Res> {
  factory $ChannelPushPreferenceUpdatedEventCopyWith(
    ChannelPushPreferenceUpdatedEvent value,
    $Res Function(ChannelPushPreferenceUpdatedEvent) _then,
  ) = _$ChannelPushPreferenceUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    ChannelPushPreference channelPushPreference,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ChannelPushPreferenceUpdatedEventCopyWithImpl<$Res>
    implements $ChannelPushPreferenceUpdatedEventCopyWith<$Res> {
  _$ChannelPushPreferenceUpdatedEventCopyWithImpl(this._self, this._then);

  final ChannelPushPreferenceUpdatedEvent _self;
  final $Res Function(ChannelPushPreferenceUpdatedEvent) _then;

  /// Create a copy of ChannelPushPreferenceUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelPushPreference = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ChannelPushPreferenceUpdatedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelPushPreference: null == channelPushPreference
            ? _self.channelPushPreference
            : channelPushPreference // ignore: cast_nullable_to_non_nullable
                  as ChannelPushPreference,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        isLocal: null == isLocal
            ? _self.isLocal
            : isLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
