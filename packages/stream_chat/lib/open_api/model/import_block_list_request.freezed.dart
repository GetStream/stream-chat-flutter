// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import_block_list_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImportBlockListRequest {
  int? get chunkSize;
  List<String> get items;

  /// Create a copy of ImportBlockListRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImportBlockListRequestCopyWith<ImportBlockListRequest> get copyWith =>
      _$ImportBlockListRequestCopyWithImpl<ImportBlockListRequest>(
        this as ImportBlockListRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ImportBlockListRequest &&
            (identical(other.chunkSize, chunkSize) || other.chunkSize == chunkSize) &&
            const DeepCollectionEquality().equals(other.items, items));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    chunkSize,
    const DeepCollectionEquality().hash(items),
  );

  @override
  String toString() {
    return 'ImportBlockListRequest(chunkSize: $chunkSize, items: $items)';
  }
}

/// @nodoc
abstract mixin class $ImportBlockListRequestCopyWith<$Res> {
  factory $ImportBlockListRequestCopyWith(
    ImportBlockListRequest value,
    $Res Function(ImportBlockListRequest) _then,
  ) = _$ImportBlockListRequestCopyWithImpl;
  @useResult
  $Res call({int? chunkSize, List<String> items});
}

/// @nodoc
class _$ImportBlockListRequestCopyWithImpl<$Res> implements $ImportBlockListRequestCopyWith<$Res> {
  _$ImportBlockListRequestCopyWithImpl(this._self, this._then);

  final ImportBlockListRequest _self;
  final $Res Function(ImportBlockListRequest) _then;

  /// Create a copy of ImportBlockListRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? chunkSize = freezed, Object? items = null}) {
    return _then(
      ImportBlockListRequest(
        chunkSize: freezed == chunkSize
            ? _self.chunkSize
            : chunkSize // ignore: cast_nullable_to_non_nullable
                  as int?,
        items: null == items
            ? _self.items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}
