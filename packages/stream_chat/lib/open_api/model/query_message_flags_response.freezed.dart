// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_message_flags_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryMessageFlagsResponse {
  String get duration;
  List<MessageFlagResponse> get flags;

  /// Create a copy of QueryMessageFlagsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryMessageFlagsResponseCopyWith<QueryMessageFlagsResponse> get copyWith =>
      _$QueryMessageFlagsResponseCopyWithImpl<QueryMessageFlagsResponse>(
        this as QueryMessageFlagsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryMessageFlagsResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            const DeepCollectionEquality().equals(other.flags, flags));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(flags),
  );

  @override
  String toString() {
    return 'QueryMessageFlagsResponse(duration: $duration, flags: $flags)';
  }
}

/// @nodoc
abstract mixin class $QueryMessageFlagsResponseCopyWith<$Res> {
  factory $QueryMessageFlagsResponseCopyWith(
    QueryMessageFlagsResponse value,
    $Res Function(QueryMessageFlagsResponse) _then,
  ) = _$QueryMessageFlagsResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<MessageFlagResponse> flags});
}

/// @nodoc
class _$QueryMessageFlagsResponseCopyWithImpl<$Res> implements $QueryMessageFlagsResponseCopyWith<$Res> {
  _$QueryMessageFlagsResponseCopyWithImpl(this._self, this._then);

  final QueryMessageFlagsResponse _self;
  final $Res Function(QueryMessageFlagsResponse) _then;

  /// Create a copy of QueryMessageFlagsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? flags = null}) {
    return _then(
      QueryMessageFlagsResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        flags: null == flags
            ? _self.flags
            : flags // ignore: cast_nullable_to_non_nullable
                  as List<MessageFlagResponse>,
      ),
    );
  }
}
