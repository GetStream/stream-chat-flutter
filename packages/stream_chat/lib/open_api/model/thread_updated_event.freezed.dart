// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'thread_updated_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThreadUpdatedEvent {
  String? get channelId;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  ThreadResponse? get thread;
  String get type;

  /// Create a copy of ThreadUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThreadUpdatedEventCopyWith<ThreadUpdatedEvent> get copyWith =>
      _$ThreadUpdatedEventCopyWithImpl<ThreadUpdatedEvent>(
        this as ThreadUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThreadUpdatedEvent &&
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
            (identical(other.thread, thread) || other.thread == thread) &&
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
    thread,
    type,
  );

  @override
  String toString() {
    return 'ThreadUpdatedEvent(channelId: $channelId, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, thread: $thread, type: $type)';
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
    String? channelId,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    ThreadResponse? thread,
    String type,
  });
}

/// @nodoc
class _$ThreadUpdatedEventCopyWithImpl<$Res>
    implements $ThreadUpdatedEventCopyWith<$Res> {
  _$ThreadUpdatedEventCopyWithImpl(this._self, this._then);

  final ThreadUpdatedEvent _self;
  final $Res Function(ThreadUpdatedEvent) _then;

  /// Create a copy of ThreadUpdatedEvent
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
    Object? thread = freezed,
    Object? type = null,
  }) {
    return _then(
      ThreadUpdatedEvent(
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
        thread: freezed == thread
            ? _self.thread
            : thread // ignore: cast_nullable_to_non_nullable
                  as ThreadResponse?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
