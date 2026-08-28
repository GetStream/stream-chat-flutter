// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_indicator_update_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIIndicatorUpdateEvent {
  String? get aiMessage;
  String get aiState;
  String? get channelId;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get messageId;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of AIIndicatorUpdateEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIIndicatorUpdateEventCopyWith<AIIndicatorUpdateEvent> get copyWith =>
      _$AIIndicatorUpdateEventCopyWithImpl<AIIndicatorUpdateEvent>(
        this as AIIndicatorUpdateEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIIndicatorUpdateEvent &&
            (identical(other.aiMessage, aiMessage) ||
                other.aiMessage == aiMessage) &&
            (identical(other.aiState, aiState) || other.aiState == aiState) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.channelType, channelType) ||
                other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    aiMessage,
    aiState,
    channelId,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    messageId,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'AIIndicatorUpdateEvent(aiMessage: $aiMessage, aiState: $aiState, channelId: $channelId, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, messageId: $messageId, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $AIIndicatorUpdateEventCopyWith<$Res> {
  factory $AIIndicatorUpdateEventCopyWith(
    AIIndicatorUpdateEvent value,
    $Res Function(AIIndicatorUpdateEvent) _then,
  ) = _$AIIndicatorUpdateEventCopyWithImpl;
  @useResult
  $Res call({
    String? aiMessage,
    String aiState,
    String? channelId,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String messageId,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$AIIndicatorUpdateEventCopyWithImpl<$Res>
    implements $AIIndicatorUpdateEventCopyWith<$Res> {
  _$AIIndicatorUpdateEventCopyWithImpl(this._self, this._then);

  final AIIndicatorUpdateEvent _self;
  final $Res Function(AIIndicatorUpdateEvent) _then;

  /// Create a copy of AIIndicatorUpdateEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aiMessage = freezed,
    Object? aiState = null,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? messageId = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      AIIndicatorUpdateEvent(
        aiMessage: freezed == aiMessage
            ? _self.aiMessage
            : aiMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        aiState: null == aiState
            ? _self.aiState
            : aiState // ignore: cast_nullable_to_non_nullable
                  as String,
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
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
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
