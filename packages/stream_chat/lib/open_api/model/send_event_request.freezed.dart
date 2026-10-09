// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_event_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendEventRequest {
  EventRequest get event;

  /// Create a copy of SendEventRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SendEventRequestCopyWith<SendEventRequest> get copyWith => _$SendEventRequestCopyWithImpl<SendEventRequest>(
    this as SendEventRequest,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendEventRequest &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, event);

  @override
  String toString() {
    return 'SendEventRequest(event: $event)';
  }
}

/// @nodoc
abstract mixin class $SendEventRequestCopyWith<$Res> {
  factory $SendEventRequestCopyWith(
    SendEventRequest value,
    $Res Function(SendEventRequest) _then,
  ) = _$SendEventRequestCopyWithImpl;
  @useResult
  $Res call({EventRequest event});
}

/// @nodoc
class _$SendEventRequestCopyWithImpl<$Res> implements $SendEventRequestCopyWith<$Res> {
  _$SendEventRequestCopyWithImpl(this._self, this._then);

  final SendEventRequest _self;
  final $Res Function(SendEventRequest) _then;

  /// Create a copy of SendEventRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? event = null}) {
    return _then(
      SendEventRequest(
        event: null == event
            ? _self.event
            : event // ignore: cast_nullable_to_non_nullable
                  as EventRequest,
      ),
    );
  }
}
