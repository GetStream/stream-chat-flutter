// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_appeal_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BulkAppealResult {
  String get appealId;
  AppealItemResponse? get appealItem;

  /// Create a copy of BulkAppealResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BulkAppealResultCopyWith<BulkAppealResult> get copyWith =>
      _$BulkAppealResultCopyWithImpl<BulkAppealResult>(
        this as BulkAppealResult,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BulkAppealResult &&
            (identical(other.appealId, appealId) ||
                other.appealId == appealId) &&
            (identical(other.appealItem, appealItem) ||
                other.appealItem == appealItem));
  }

  @override
  int get hashCode => Object.hash(runtimeType, appealId, appealItem);

  @override
  String toString() {
    return 'BulkAppealResult(appealId: $appealId, appealItem: $appealItem)';
  }
}

/// @nodoc
abstract mixin class $BulkAppealResultCopyWith<$Res> {
  factory $BulkAppealResultCopyWith(
    BulkAppealResult value,
    $Res Function(BulkAppealResult) _then,
  ) = _$BulkAppealResultCopyWithImpl;
  @useResult
  $Res call({String appealId, AppealItemResponse? appealItem});
}

/// @nodoc
class _$BulkAppealResultCopyWithImpl<$Res>
    implements $BulkAppealResultCopyWith<$Res> {
  _$BulkAppealResultCopyWithImpl(this._self, this._then);

  final BulkAppealResult _self;
  final $Res Function(BulkAppealResult) _then;

  /// Create a copy of BulkAppealResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? appealId = null, Object? appealItem = freezed}) {
    return _then(
      BulkAppealResult(
        appealId: null == appealId
            ? _self.appealId
            : appealId // ignore: cast_nullable_to_non_nullable
                  as String,
        appealItem: freezed == appealItem
            ? _self.appealItem
            : appealItem // ignore: cast_nullable_to_non_nullable
                  as AppealItemResponse?,
      ),
    );
  }
}
