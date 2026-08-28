// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'truncate_channel_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TruncateChannelRequest {
  bool? get hardDelete;
  List<String>? get memberIds;
  MessageRequest? get message;
  bool? get skipPush;
  DateTime? get truncatedAt;

  /// Create a copy of TruncateChannelRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TruncateChannelRequestCopyWith<TruncateChannelRequest> get copyWith =>
      _$TruncateChannelRequestCopyWithImpl<TruncateChannelRequest>(
        this as TruncateChannelRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TruncateChannelRequest &&
            (identical(other.hardDelete, hardDelete) ||
                other.hardDelete == hardDelete) &&
            const DeepCollectionEquality().equals(other.memberIds, memberIds) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.skipPush, skipPush) ||
                other.skipPush == skipPush) &&
            (identical(other.truncatedAt, truncatedAt) ||
                other.truncatedAt == truncatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    hardDelete,
    const DeepCollectionEquality().hash(memberIds),
    message,
    skipPush,
    truncatedAt,
  );

  @override
  String toString() {
    return 'TruncateChannelRequest(hardDelete: $hardDelete, memberIds: $memberIds, message: $message, skipPush: $skipPush, truncatedAt: $truncatedAt)';
  }
}

/// @nodoc
abstract mixin class $TruncateChannelRequestCopyWith<$Res> {
  factory $TruncateChannelRequestCopyWith(
    TruncateChannelRequest value,
    $Res Function(TruncateChannelRequest) _then,
  ) = _$TruncateChannelRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? hardDelete,
    List<String>? memberIds,
    MessageRequest? message,
    bool? skipPush,
    DateTime? truncatedAt,
  });
}

/// @nodoc
class _$TruncateChannelRequestCopyWithImpl<$Res>
    implements $TruncateChannelRequestCopyWith<$Res> {
  _$TruncateChannelRequestCopyWithImpl(this._self, this._then);

  final TruncateChannelRequest _self;
  final $Res Function(TruncateChannelRequest) _then;

  /// Create a copy of TruncateChannelRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hardDelete = freezed,
    Object? memberIds = freezed,
    Object? message = freezed,
    Object? skipPush = freezed,
    Object? truncatedAt = freezed,
  }) {
    return _then(
      TruncateChannelRequest(
        hardDelete: freezed == hardDelete
            ? _self.hardDelete
            : hardDelete // ignore: cast_nullable_to_non_nullable
                  as bool?,
        memberIds: freezed == memberIds
            ? _self.memberIds
            : memberIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageRequest?,
        skipPush: freezed == skipPush
            ? _self.skipPush
            : skipPush // ignore: cast_nullable_to_non_nullable
                  as bool?,
        truncatedAt: freezed == truncatedAt
            ? _self.truncatedAt
            : truncatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
