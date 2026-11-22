// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_scheduled_messages_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryScheduledMessagesResponse {
  String get duration;
  String? get next;
  List<ScheduledMessageResponse> get scheduledMessages;

  /// Create a copy of QueryScheduledMessagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryScheduledMessagesResponseCopyWith<QueryScheduledMessagesResponse> get copyWith =>
      _$QueryScheduledMessagesResponseCopyWithImpl<QueryScheduledMessagesResponse>(
        this as QueryScheduledMessagesResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryScheduledMessagesResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.next, next) || other.next == next) &&
            const DeepCollectionEquality().equals(
              other.scheduledMessages,
              scheduledMessages,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    next,
    const DeepCollectionEquality().hash(scheduledMessages),
  );

  @override
  String toString() {
    return 'QueryScheduledMessagesResponse(duration: $duration, next: $next, scheduledMessages: $scheduledMessages)';
  }
}

/// @nodoc
abstract mixin class $QueryScheduledMessagesResponseCopyWith<$Res> {
  factory $QueryScheduledMessagesResponseCopyWith(
    QueryScheduledMessagesResponse value,
    $Res Function(QueryScheduledMessagesResponse) _then,
  ) = _$QueryScheduledMessagesResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    String? next,
    List<ScheduledMessageResponse> scheduledMessages,
  });
}

/// @nodoc
class _$QueryScheduledMessagesResponseCopyWithImpl<$Res> implements $QueryScheduledMessagesResponseCopyWith<$Res> {
  _$QueryScheduledMessagesResponseCopyWithImpl(this._self, this._then);

  final QueryScheduledMessagesResponse _self;
  final $Res Function(QueryScheduledMessagesResponse) _then;

  /// Create a copy of QueryScheduledMessagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? next = freezed,
    Object? scheduledMessages = null,
  }) {
    return _then(
      QueryScheduledMessagesResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        scheduledMessages: null == scheduledMessages
            ? _self.scheduledMessages
            : scheduledMessages // ignore: cast_nullable_to_non_nullable
                  as List<ScheduledMessageResponse>,
      ),
    );
  }
}
