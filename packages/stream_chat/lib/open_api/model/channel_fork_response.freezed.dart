// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_fork_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelForkResponse {
  String get channelCid;
  int get copiedMessageCount;
  DateTime get createdAt;
  String? get failedReason;
  Map<String, String> get messageIdMap;
  String? get oldestSourceMessageId;
  String get sourceChannelCid;
  String get sourceMessageId;
  String get status;
  String? get taskId;
  bool? get truncated;

  /// Create a copy of ChannelForkResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelForkResponseCopyWith<ChannelForkResponse> get copyWith =>
      _$ChannelForkResponseCopyWithImpl<ChannelForkResponse>(
        this as ChannelForkResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelForkResponse &&
            (identical(other.channelCid, channelCid) || other.channelCid == channelCid) &&
            (identical(other.copiedMessageCount, copiedMessageCount) ||
                other.copiedMessageCount == copiedMessageCount) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.failedReason, failedReason) || other.failedReason == failedReason) &&
            const DeepCollectionEquality().equals(
              other.messageIdMap,
              messageIdMap,
            ) &&
            (identical(other.oldestSourceMessageId, oldestSourceMessageId) ||
                other.oldestSourceMessageId == oldestSourceMessageId) &&
            (identical(other.sourceChannelCid, sourceChannelCid) || other.sourceChannelCid == sourceChannelCid) &&
            (identical(other.sourceMessageId, sourceMessageId) || other.sourceMessageId == sourceMessageId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.truncated, truncated) || other.truncated == truncated));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelCid,
    copiedMessageCount,
    createdAt,
    failedReason,
    const DeepCollectionEquality().hash(messageIdMap),
    oldestSourceMessageId,
    sourceChannelCid,
    sourceMessageId,
    status,
    taskId,
    truncated,
  );

  @override
  String toString() {
    return 'ChannelForkResponse(channelCid: $channelCid, copiedMessageCount: $copiedMessageCount, createdAt: $createdAt, failedReason: $failedReason, messageIdMap: $messageIdMap, oldestSourceMessageId: $oldestSourceMessageId, sourceChannelCid: $sourceChannelCid, sourceMessageId: $sourceMessageId, status: $status, taskId: $taskId, truncated: $truncated)';
  }
}

/// @nodoc
abstract mixin class $ChannelForkResponseCopyWith<$Res> {
  factory $ChannelForkResponseCopyWith(
    ChannelForkResponse value,
    $Res Function(ChannelForkResponse) _then,
  ) = _$ChannelForkResponseCopyWithImpl;
  @useResult
  $Res call({
    String channelCid,
    int copiedMessageCount,
    DateTime createdAt,
    String? failedReason,
    Map<String, String> messageIdMap,
    String? oldestSourceMessageId,
    String sourceChannelCid,
    String sourceMessageId,
    String status,
    String? taskId,
    bool? truncated,
  });
}

/// @nodoc
class _$ChannelForkResponseCopyWithImpl<$Res> implements $ChannelForkResponseCopyWith<$Res> {
  _$ChannelForkResponseCopyWithImpl(this._self, this._then);

  final ChannelForkResponse _self;
  final $Res Function(ChannelForkResponse) _then;

  /// Create a copy of ChannelForkResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelCid = null,
    Object? copiedMessageCount = null,
    Object? createdAt = null,
    Object? failedReason = freezed,
    Object? messageIdMap = null,
    Object? oldestSourceMessageId = freezed,
    Object? sourceChannelCid = null,
    Object? sourceMessageId = null,
    Object? status = null,
    Object? taskId = freezed,
    Object? truncated = freezed,
  }) {
    return _then(
      ChannelForkResponse(
        channelCid: null == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String,
        copiedMessageCount: null == copiedMessageCount
            ? _self.copiedMessageCount
            : copiedMessageCount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        failedReason: freezed == failedReason
            ? _self.failedReason
            : failedReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        messageIdMap: null == messageIdMap
            ? _self.messageIdMap
            : messageIdMap // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        oldestSourceMessageId: freezed == oldestSourceMessageId
            ? _self.oldestSourceMessageId
            : oldestSourceMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        sourceChannelCid: null == sourceChannelCid
            ? _self.sourceChannelCid
            : sourceChannelCid // ignore: cast_nullable_to_non_nullable
                  as String,
        sourceMessageId: null == sourceMessageId
            ? _self.sourceMessageId
            : sourceMessageId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        taskId: freezed == taskId
            ? _self.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as String?,
        truncated: freezed == truncated
            ? _self.truncated
            : truncated // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
