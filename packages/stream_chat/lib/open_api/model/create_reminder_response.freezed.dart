// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_reminder_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateReminderResponse {
  String get duration;
  ReminderResponseData get reminder;

  /// Create a copy of CreateReminderResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateReminderResponseCopyWith<CreateReminderResponse> get copyWith =>
      _$CreateReminderResponseCopyWithImpl<CreateReminderResponse>(
        this as CreateReminderResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateReminderResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.reminder, reminder) || other.reminder == reminder));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, reminder);

  @override
  String toString() {
    return 'CreateReminderResponse(duration: $duration, reminder: $reminder)';
  }
}

/// @nodoc
abstract mixin class $CreateReminderResponseCopyWith<$Res> {
  factory $CreateReminderResponseCopyWith(
    CreateReminderResponse value,
    $Res Function(CreateReminderResponse) _then,
  ) = _$CreateReminderResponseCopyWithImpl;
  @useResult
  $Res call({String duration, ReminderResponseData reminder});
}

/// @nodoc
class _$CreateReminderResponseCopyWithImpl<$Res> implements $CreateReminderResponseCopyWith<$Res> {
  _$CreateReminderResponseCopyWithImpl(this._self, this._then);

  final CreateReminderResponse _self;
  final $Res Function(CreateReminderResponse) _then;

  /// Create a copy of CreateReminderResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? reminder = null}) {
    return _then(
      CreateReminderResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        reminder: null == reminder
            ? _self.reminder
            : reminder // ignore: cast_nullable_to_non_nullable
                  as ReminderResponseData,
      ),
    );
  }
}
