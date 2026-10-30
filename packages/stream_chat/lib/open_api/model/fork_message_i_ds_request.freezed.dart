// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fork_message_i_ds_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForkMessageIDsRequest {
  List<String> get sourceMessageIds;

  /// Create a copy of ForkMessageIDsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ForkMessageIDsRequestCopyWith<ForkMessageIDsRequest> get copyWith =>
      _$ForkMessageIDsRequestCopyWithImpl<ForkMessageIDsRequest>(
        this as ForkMessageIDsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ForkMessageIDsRequest &&
            const DeepCollectionEquality().equals(
              other.sourceMessageIds,
              sourceMessageIds,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(sourceMessageIds),
  );

  @override
  String toString() {
    return 'ForkMessageIDsRequest(sourceMessageIds: $sourceMessageIds)';
  }
}

/// @nodoc
abstract mixin class $ForkMessageIDsRequestCopyWith<$Res> {
  factory $ForkMessageIDsRequestCopyWith(
    ForkMessageIDsRequest value,
    $Res Function(ForkMessageIDsRequest) _then,
  ) = _$ForkMessageIDsRequestCopyWithImpl;
  @useResult
  $Res call({List<String> sourceMessageIds});
}

/// @nodoc
class _$ForkMessageIDsRequestCopyWithImpl<$Res> implements $ForkMessageIDsRequestCopyWith<$Res> {
  _$ForkMessageIDsRequestCopyWithImpl(this._self, this._then);

  final ForkMessageIDsRequest _self;
  final $Res Function(ForkMessageIDsRequest) _then;

  /// Create a copy of ForkMessageIDsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sourceMessageIds = null}) {
    return _then(
      ForkMessageIDsRequest(
        sourceMessageIds: null == sourceMessageIds
            ? _self.sourceMessageIds
            : sourceMessageIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}
