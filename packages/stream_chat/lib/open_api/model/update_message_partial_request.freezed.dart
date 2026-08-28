// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_message_partial_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateMessagePartialRequest {
  Map<String, Object?>? get set;
  bool? get skipEnrichUrl;
  bool? get skipPush;
  List<String>? get unset;

  /// Create a copy of UpdateMessagePartialRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateMessagePartialRequestCopyWith<UpdateMessagePartialRequest>
  get copyWith =>
      _$UpdateMessagePartialRequestCopyWithImpl<UpdateMessagePartialRequest>(
        this as UpdateMessagePartialRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateMessagePartialRequest &&
            const DeepCollectionEquality().equals(other.set, set) &&
            (identical(other.skipEnrichUrl, skipEnrichUrl) ||
                other.skipEnrichUrl == skipEnrichUrl) &&
            (identical(other.skipPush, skipPush) ||
                other.skipPush == skipPush) &&
            const DeepCollectionEquality().equals(other.unset, unset));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(set),
    skipEnrichUrl,
    skipPush,
    const DeepCollectionEquality().hash(unset),
  );

  @override
  String toString() {
    return 'UpdateMessagePartialRequest(set: $set, skipEnrichUrl: $skipEnrichUrl, skipPush: $skipPush, unset: $unset)';
  }
}

/// @nodoc
abstract mixin class $UpdateMessagePartialRequestCopyWith<$Res> {
  factory $UpdateMessagePartialRequestCopyWith(
    UpdateMessagePartialRequest value,
    $Res Function(UpdateMessagePartialRequest) _then,
  ) = _$UpdateMessagePartialRequestCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?>? set,
    bool? skipEnrichUrl,
    bool? skipPush,
    List<String>? unset,
  });
}

/// @nodoc
class _$UpdateMessagePartialRequestCopyWithImpl<$Res>
    implements $UpdateMessagePartialRequestCopyWith<$Res> {
  _$UpdateMessagePartialRequestCopyWithImpl(this._self, this._then);

  final UpdateMessagePartialRequest _self;
  final $Res Function(UpdateMessagePartialRequest) _then;

  /// Create a copy of UpdateMessagePartialRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? set = freezed,
    Object? skipEnrichUrl = freezed,
    Object? skipPush = freezed,
    Object? unset = freezed,
  }) {
    return _then(
      UpdateMessagePartialRequest(
        set: freezed == set
            ? _self.set
            : set // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        skipEnrichUrl: freezed == skipEnrichUrl
            ? _self.skipEnrichUrl
            : skipEnrichUrl // ignore: cast_nullable_to_non_nullable
                  as bool?,
        skipPush: freezed == skipPush
            ? _self.skipPush
            : skipPush // ignore: cast_nullable_to_non_nullable
                  as bool?,
        unset: freezed == unset
            ? _self.unset
            : unset // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}
