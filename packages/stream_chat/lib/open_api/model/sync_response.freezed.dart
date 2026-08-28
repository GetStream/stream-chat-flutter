// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncResponse {
  String get duration;
  List<WSEvent> get events;
  List<String>? get inaccessibleCids;

  /// Create a copy of SyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SyncResponseCopyWith<SyncResponse> get copyWith =>
      _$SyncResponseCopyWithImpl<SyncResponse>(
        this as SyncResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SyncResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other.events, events) &&
            const DeepCollectionEquality().equals(
              other.inaccessibleCids,
              inaccessibleCids,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(events),
    const DeepCollectionEquality().hash(inaccessibleCids),
  );

  @override
  String toString() {
    return 'SyncResponse(duration: $duration, events: $events, inaccessibleCids: $inaccessibleCids)';
  }
}

/// @nodoc
abstract mixin class $SyncResponseCopyWith<$Res> {
  factory $SyncResponseCopyWith(
    SyncResponse value,
    $Res Function(SyncResponse) _then,
  ) = _$SyncResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    List<WSEvent<WsEvent>> events,
    List<String>? inaccessibleCids,
  });
}

/// @nodoc
class _$SyncResponseCopyWithImpl<$Res> implements $SyncResponseCopyWith<$Res> {
  _$SyncResponseCopyWithImpl(this._self, this._then);

  final SyncResponse _self;
  final $Res Function(SyncResponse) _then;

  /// Create a copy of SyncResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? events = null,
    Object? inaccessibleCids = freezed,
  }) {
    return _then(
      SyncResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        events: null == events
            ? _self.events
            : events // ignore: cast_nullable_to_non_nullable
                  as List<WSEvent<WsEvent>>,
        inaccessibleCids: freezed == inaccessibleCids
            ? _self.inaccessibleCids
            : inaccessibleCids // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}
