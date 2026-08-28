// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_reminder_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateReminderRequest {
  DateTime? get remindAt;

  /// Create a copy of CreateReminderRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateReminderRequestCopyWith<CreateReminderRequest> get copyWith =>
      _$CreateReminderRequestCopyWithImpl<CreateReminderRequest>(
        this as CreateReminderRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateReminderRequest &&
            (identical(other.remindAt, remindAt) ||
                other.remindAt == remindAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, remindAt);

  @override
  String toString() {
    return 'CreateReminderRequest(remindAt: $remindAt)';
  }
}

/// @nodoc
abstract mixin class $CreateReminderRequestCopyWith<$Res> {
  factory $CreateReminderRequestCopyWith(
    CreateReminderRequest value,
    $Res Function(CreateReminderRequest) _then,
  ) = _$CreateReminderRequestCopyWithImpl;
  @useResult
  $Res call({DateTime? remindAt});
}

/// @nodoc
class _$CreateReminderRequestCopyWithImpl<$Res>
    implements $CreateReminderRequestCopyWith<$Res> {
  _$CreateReminderRequestCopyWithImpl(this._self, this._then);

  final CreateReminderRequest _self;
  final $Res Function(CreateReminderRequest) _then;

  /// Create a copy of CreateReminderRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? remindAt = freezed}) {
    return _then(
      CreateReminderRequest(
        remindAt: freezed == remindAt
            ? _self.remindAt
            : remindAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
