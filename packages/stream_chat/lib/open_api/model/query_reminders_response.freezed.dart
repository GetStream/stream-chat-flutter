// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_reminders_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryRemindersResponse {
  String get duration;
  String? get next;
  String? get prev;
  List<ReminderResponseData> get reminders;

  /// Create a copy of QueryRemindersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryRemindersResponseCopyWith<QueryRemindersResponse> get copyWith =>
      _$QueryRemindersResponseCopyWithImpl<QueryRemindersResponse>(
        this as QueryRemindersResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryRemindersResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev) &&
            const DeepCollectionEquality().equals(other.reminders, reminders));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    next,
    prev,
    const DeepCollectionEquality().hash(reminders),
  );

  @override
  String toString() {
    return 'QueryRemindersResponse(duration: $duration, next: $next, prev: $prev, reminders: $reminders)';
  }
}

/// @nodoc
abstract mixin class $QueryRemindersResponseCopyWith<$Res> {
  factory $QueryRemindersResponseCopyWith(
    QueryRemindersResponse value,
    $Res Function(QueryRemindersResponse) _then,
  ) = _$QueryRemindersResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    String? next,
    String? prev,
    List<ReminderResponseData> reminders,
  });
}

/// @nodoc
class _$QueryRemindersResponseCopyWithImpl<$Res>
    implements $QueryRemindersResponseCopyWith<$Res> {
  _$QueryRemindersResponseCopyWithImpl(this._self, this._then);

  final QueryRemindersResponse _self;
  final $Res Function(QueryRemindersResponse) _then;

  /// Create a copy of QueryRemindersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? next = freezed,
    Object? prev = freezed,
    Object? reminders = null,
  }) {
    return _then(
      QueryRemindersResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        prev: freezed == prev
            ? _self.prev
            : prev // ignore: cast_nullable_to_non_nullable
                  as String?,
        reminders: null == reminders
            ? _self.reminders
            : reminders // ignore: cast_nullable_to_non_nullable
                  as List<ReminderResponseData>,
      ),
    );
  }
}
