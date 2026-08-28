// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_delete_action_config_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BulkDeleteActionConfigRequest {
  List<String> get ids;

  /// Create a copy of BulkDeleteActionConfigRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BulkDeleteActionConfigRequestCopyWith<BulkDeleteActionConfigRequest>
  get copyWith =>
      _$BulkDeleteActionConfigRequestCopyWithImpl<
        BulkDeleteActionConfigRequest
      >(this as BulkDeleteActionConfigRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BulkDeleteActionConfigRequest &&
            const DeepCollectionEquality().equals(other.ids, ids));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(ids));

  @override
  String toString() {
    return 'BulkDeleteActionConfigRequest(ids: $ids)';
  }
}

/// @nodoc
abstract mixin class $BulkDeleteActionConfigRequestCopyWith<$Res> {
  factory $BulkDeleteActionConfigRequestCopyWith(
    BulkDeleteActionConfigRequest value,
    $Res Function(BulkDeleteActionConfigRequest) _then,
  ) = _$BulkDeleteActionConfigRequestCopyWithImpl;
  @useResult
  $Res call({List<String> ids});
}

/// @nodoc
class _$BulkDeleteActionConfigRequestCopyWithImpl<$Res>
    implements $BulkDeleteActionConfigRequestCopyWith<$Res> {
  _$BulkDeleteActionConfigRequestCopyWithImpl(this._self, this._then);

  final BulkDeleteActionConfigRequest _self;
  final $Res Function(BulkDeleteActionConfigRequest) _then;

  /// Create a copy of BulkDeleteActionConfigRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? ids = null}) {
    return _then(
      BulkDeleteActionConfigRequest(
        ids: null == ids
            ? _self.ids
            : ids // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}
