// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_queues_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListQueuesResponse {
  String get duration;
  List<ModerationQueueResponse> get queues;

  /// Create a copy of ListQueuesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ListQueuesResponseCopyWith<ListQueuesResponse> get copyWith =>
      _$ListQueuesResponseCopyWithImpl<ListQueuesResponse>(
        this as ListQueuesResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ListQueuesResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other.queues, queues));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(queues),
  );

  @override
  String toString() {
    return 'ListQueuesResponse(duration: $duration, queues: $queues)';
  }
}

/// @nodoc
abstract mixin class $ListQueuesResponseCopyWith<$Res> {
  factory $ListQueuesResponseCopyWith(
    ListQueuesResponse value,
    $Res Function(ListQueuesResponse) _then,
  ) = _$ListQueuesResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<ModerationQueueResponse> queues});
}

/// @nodoc
class _$ListQueuesResponseCopyWithImpl<$Res>
    implements $ListQueuesResponseCopyWith<$Res> {
  _$ListQueuesResponseCopyWithImpl(this._self, this._then);

  final ListQueuesResponse _self;
  final $Res Function(ListQueuesResponse) _then;

  /// Create a copy of ListQueuesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? queues = null}) {
    return _then(
      ListQueuesResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        queues: null == queues
            ? _self.queues
            : queues // ignore: cast_nullable_to_non_nullable
                  as List<ModerationQueueResponse>,
      ),
    );
  }
}
