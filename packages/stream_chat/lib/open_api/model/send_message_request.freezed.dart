// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_message_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendMessageRequest {
  bool? get includeChannelContext;
  bool? get includeMentionedMembers;
  bool? get keepChannelHidden;
  MessageRequest get message;
  bool? get skipEnrichUrl;
  bool? get skipPush;

  /// Create a copy of SendMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SendMessageRequestCopyWith<SendMessageRequest> get copyWith =>
      _$SendMessageRequestCopyWithImpl<SendMessageRequest>(
        this as SendMessageRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendMessageRequest &&
            (identical(other.includeChannelContext, includeChannelContext) ||
                other.includeChannelContext == includeChannelContext) &&
            (identical(
                  other.includeMentionedMembers,
                  includeMentionedMembers,
                ) ||
                other.includeMentionedMembers == includeMentionedMembers) &&
            (identical(other.keepChannelHidden, keepChannelHidden) ||
                other.keepChannelHidden == keepChannelHidden) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.skipEnrichUrl, skipEnrichUrl) ||
                other.skipEnrichUrl == skipEnrichUrl) &&
            (identical(other.skipPush, skipPush) ||
                other.skipPush == skipPush));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    includeChannelContext,
    includeMentionedMembers,
    keepChannelHidden,
    message,
    skipEnrichUrl,
    skipPush,
  );

  @override
  String toString() {
    return 'SendMessageRequest(includeChannelContext: $includeChannelContext, includeMentionedMembers: $includeMentionedMembers, keepChannelHidden: $keepChannelHidden, message: $message, skipEnrichUrl: $skipEnrichUrl, skipPush: $skipPush)';
  }
}

/// @nodoc
abstract mixin class $SendMessageRequestCopyWith<$Res> {
  factory $SendMessageRequestCopyWith(
    SendMessageRequest value,
    $Res Function(SendMessageRequest) _then,
  ) = _$SendMessageRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? includeChannelContext,
    bool? includeMentionedMembers,
    bool? keepChannelHidden,
    MessageRequest message,
    bool? skipEnrichUrl,
    bool? skipPush,
  });
}

/// @nodoc
class _$SendMessageRequestCopyWithImpl<$Res>
    implements $SendMessageRequestCopyWith<$Res> {
  _$SendMessageRequestCopyWithImpl(this._self, this._then);

  final SendMessageRequest _self;
  final $Res Function(SendMessageRequest) _then;

  /// Create a copy of SendMessageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? includeChannelContext = freezed,
    Object? includeMentionedMembers = freezed,
    Object? keepChannelHidden = freezed,
    Object? message = null,
    Object? skipEnrichUrl = freezed,
    Object? skipPush = freezed,
  }) {
    return _then(
      SendMessageRequest(
        includeChannelContext: freezed == includeChannelContext
            ? _self.includeChannelContext
            : includeChannelContext // ignore: cast_nullable_to_non_nullable
                  as bool?,
        includeMentionedMembers: freezed == includeMentionedMembers
            ? _self.includeMentionedMembers
            : includeMentionedMembers // ignore: cast_nullable_to_non_nullable
                  as bool?,
        keepChannelHidden: freezed == keepChannelHidden
            ? _self.keepChannelHidden
            : keepChannelHidden // ignore: cast_nullable_to_non_nullable
                  as bool?,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageRequest,
        skipEnrichUrl: freezed == skipEnrichUrl
            ? _self.skipEnrichUrl
            : skipEnrichUrl // ignore: cast_nullable_to_non_nullable
                  as bool?,
        skipPush: freezed == skipPush
            ? _self.skipPush
            : skipPush // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
