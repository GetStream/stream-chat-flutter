// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rewind_channel_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RewindChannelRequest {
  String get expectedLastMessageId;
  bool? get inclusive;
  String get messageId;

  /// Create a copy of RewindChannelRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RewindChannelRequestCopyWith<RewindChannelRequest> get copyWith =>
      _$RewindChannelRequestCopyWithImpl<RewindChannelRequest>(
        this as RewindChannelRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RewindChannelRequest &&
            (identical(other.expectedLastMessageId, expectedLastMessageId) ||
                other.expectedLastMessageId == expectedLastMessageId) &&
            (identical(other.inclusive, inclusive) || other.inclusive == inclusive) &&
            (identical(other.messageId, messageId) || other.messageId == messageId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, expectedLastMessageId, inclusive, messageId);

  @override
  String toString() {
    return 'RewindChannelRequest(expectedLastMessageId: $expectedLastMessageId, inclusive: $inclusive, messageId: $messageId)';
  }
}

/// @nodoc
abstract mixin class $RewindChannelRequestCopyWith<$Res> {
  factory $RewindChannelRequestCopyWith(
    RewindChannelRequest value,
    $Res Function(RewindChannelRequest) _then,
  ) = _$RewindChannelRequestCopyWithImpl;
  @useResult
  $Res call({String expectedLastMessageId, bool? inclusive, String messageId});
}

/// @nodoc
class _$RewindChannelRequestCopyWithImpl<$Res> implements $RewindChannelRequestCopyWith<$Res> {
  _$RewindChannelRequestCopyWithImpl(this._self, this._then);

  final RewindChannelRequest _self;
  final $Res Function(RewindChannelRequest) _then;

  /// Create a copy of RewindChannelRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expectedLastMessageId = null,
    Object? inclusive = freezed,
    Object? messageId = null,
  }) {
    return _then(
      RewindChannelRequest(
        expectedLastMessageId: null == expectedLastMessageId
            ? _self.expectedLastMessageId
            : expectedLastMessageId // ignore: cast_nullable_to_non_nullable
                  as String,
        inclusive: freezed == inclusive
            ? _self.inclusive
            : inclusive // ignore: cast_nullable_to_non_nullable
                  as bool?,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
