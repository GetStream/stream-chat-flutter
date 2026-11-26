// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thread_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThreadUpdatedEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  Thread? get thread;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ThreadUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThreadUpdatedEventCopyWith<ThreadUpdatedEvent> get copyWith => _$ThreadUpdatedEventCopyWithImpl<ThreadUpdatedEvent>(
    this as ThreadUpdatedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThreadUpdatedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.thread, thread) || other.thread == thread) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    channelId,
    channelType,
    thread,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ThreadUpdatedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, thread: $thread, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ThreadUpdatedEventCopyWith<$Res> {
  factory $ThreadUpdatedEventCopyWith(
    ThreadUpdatedEvent value,
    $Res Function(ThreadUpdatedEvent) _then,
  ) = _$ThreadUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    Thread? thread,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ThreadUpdatedEventCopyWithImpl<$Res> implements $ThreadUpdatedEventCopyWith<$Res> {
  _$ThreadUpdatedEventCopyWithImpl(this._self, this._then);

  final ThreadUpdatedEvent _self;
  final $Res Function(ThreadUpdatedEvent) _then;

  /// Create a copy of ThreadUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? thread = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ThreadUpdatedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        thread: freezed == thread
            ? _self.thread
            : thread // ignore: cast_nullable_to_non_nullable
                  as Thread?,
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
