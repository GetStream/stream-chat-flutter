// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_reminder_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateReminderRequest {
  DateTime? get remindAt;

  /// Create a copy of UpdateReminderRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateReminderRequestCopyWith<UpdateReminderRequest> get copyWith =>
      _$UpdateReminderRequestCopyWithImpl<UpdateReminderRequest>(
        this as UpdateReminderRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateReminderRequest &&
            (identical(other.remindAt, remindAt) || other.remindAt == remindAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, remindAt);

  @override
  String toString() {
    return 'UpdateReminderRequest(remindAt: $remindAt)';
  }
}

/// @nodoc
abstract mixin class $UpdateReminderRequestCopyWith<$Res> {
  factory $UpdateReminderRequestCopyWith(
    UpdateReminderRequest value,
    $Res Function(UpdateReminderRequest) _then,
  ) = _$UpdateReminderRequestCopyWithImpl;
  @useResult
  $Res call({DateTime? remindAt});
}

/// @nodoc
class _$UpdateReminderRequestCopyWithImpl<$Res> implements $UpdateReminderRequestCopyWith<$Res> {
  _$UpdateReminderRequestCopyWithImpl(this._self, this._then);

  final UpdateReminderRequest _self;
  final $Res Function(UpdateReminderRequest) _then;

  /// Create a copy of UpdateReminderRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? remindAt = freezed}) {
    return _then(
      UpdateReminderRequest(
        remindAt: freezed == remindAt
            ? _self.remindAt
            : remindAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
