// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mark_unread_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarkUnreadRequest {
  String? get messageId;
  DateTime? get messageTimestamp;
  String? get threadId;

  /// Create a copy of MarkUnreadRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MarkUnreadRequestCopyWith<MarkUnreadRequest> get copyWith =>
      _$MarkUnreadRequestCopyWithImpl<MarkUnreadRequest>(
        this as MarkUnreadRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MarkUnreadRequest &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.messageTimestamp, messageTimestamp) ||
                other.messageTimestamp == messageTimestamp) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, messageId, messageTimestamp, threadId);

  @override
  String toString() {
    return 'MarkUnreadRequest(messageId: $messageId, messageTimestamp: $messageTimestamp, threadId: $threadId)';
  }
}

/// @nodoc
abstract mixin class $MarkUnreadRequestCopyWith<$Res> {
  factory $MarkUnreadRequestCopyWith(
    MarkUnreadRequest value,
    $Res Function(MarkUnreadRequest) _then,
  ) = _$MarkUnreadRequestCopyWithImpl;
  @useResult
  $Res call({String? messageId, DateTime? messageTimestamp, String? threadId});
}

/// @nodoc
class _$MarkUnreadRequestCopyWithImpl<$Res>
    implements $MarkUnreadRequestCopyWith<$Res> {
  _$MarkUnreadRequestCopyWithImpl(this._self, this._then);

  final MarkUnreadRequest _self;
  final $Res Function(MarkUnreadRequest) _then;

  /// Create a copy of MarkUnreadRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = freezed,
    Object? messageTimestamp = freezed,
    Object? threadId = freezed,
  }) {
    return _then(
      MarkUnreadRequest(
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        messageTimestamp: freezed == messageTimestamp
            ? _self.messageTimestamp
            : messageTimestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        threadId: freezed == threadId
            ? _self.threadId
            : threadId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
