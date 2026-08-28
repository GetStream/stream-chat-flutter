// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mark_read_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MarkReadRequest {
  String? get messageId;
  String? get threadId;

  /// Create a copy of MarkReadRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MarkReadRequestCopyWith<MarkReadRequest> get copyWith =>
      _$MarkReadRequestCopyWithImpl<MarkReadRequest>(
        this as MarkReadRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MarkReadRequest &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, messageId, threadId);

  @override
  String toString() {
    return 'MarkReadRequest(messageId: $messageId, threadId: $threadId)';
  }
}

/// @nodoc
abstract mixin class $MarkReadRequestCopyWith<$Res> {
  factory $MarkReadRequestCopyWith(
    MarkReadRequest value,
    $Res Function(MarkReadRequest) _then,
  ) = _$MarkReadRequestCopyWithImpl;
  @useResult
  $Res call({String? messageId, String? threadId});
}

/// @nodoc
class _$MarkReadRequestCopyWithImpl<$Res>
    implements $MarkReadRequestCopyWith<$Res> {
  _$MarkReadRequestCopyWithImpl(this._self, this._then);

  final MarkReadRequest _self;
  final $Res Function(MarkReadRequest) _then;

  /// Create a copy of MarkReadRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? messageId = freezed, Object? threadId = freezed}) {
    return _then(
      MarkReadRequest(
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        threadId: freezed == threadId
            ? _self.threadId
            : threadId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
