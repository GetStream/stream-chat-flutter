// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventResponse {
  String get duration;
  WSEvent get event;

  /// Create a copy of EventResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EventResponseCopyWith<EventResponse> get copyWith => _$EventResponseCopyWithImpl<EventResponse>(
    this as EventResponse,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EventResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.event, event) || other.event == event));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, event);

  @override
  String toString() {
    return 'EventResponse(duration: $duration, event: $event)';
  }
}

/// @nodoc
abstract mixin class $EventResponseCopyWith<$Res> {
  factory $EventResponseCopyWith(
    EventResponse value,
    $Res Function(EventResponse) _then,
  ) = _$EventResponseCopyWithImpl;
  @useResult
  $Res call({String duration, WSEvent<WsEvent> event});
}

/// @nodoc
class _$EventResponseCopyWithImpl<$Res> implements $EventResponseCopyWith<$Res> {
  _$EventResponseCopyWithImpl(this._self, this._then);

  final EventResponse _self;
  final $Res Function(EventResponse) _then;

  /// Create a copy of EventResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? event = null}) {
    return _then(
      EventResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        event: null == event
            ? _self.event
            : event // ignore: cast_nullable_to_non_nullable
                  as WSEvent<WsEvent>,
      ),
    );
  }
}
