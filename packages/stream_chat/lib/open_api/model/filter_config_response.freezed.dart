// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_config_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FilterConfigResponse {
  List<String>? get aiImageLabels;
  Map<String, List<String>>? get aiImageTaxonomy;
  List<String>? get aiTextLabels;
  List<String>? get configKeys;
  List<String>? get filterableCustomKeys;
  List<String> get llmLabels;

  /// Create a copy of FilterConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FilterConfigResponseCopyWith<FilterConfigResponse> get copyWith =>
      _$FilterConfigResponseCopyWithImpl<FilterConfigResponse>(
        this as FilterConfigResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FilterConfigResponse &&
            const DeepCollectionEquality().equals(
              other.aiImageLabels,
              aiImageLabels,
            ) &&
            const DeepCollectionEquality().equals(
              other.aiImageTaxonomy,
              aiImageTaxonomy,
            ) &&
            const DeepCollectionEquality().equals(
              other.aiTextLabels,
              aiTextLabels,
            ) &&
            const DeepCollectionEquality().equals(
              other.configKeys,
              configKeys,
            ) &&
            const DeepCollectionEquality().equals(
              other.filterableCustomKeys,
              filterableCustomKeys,
            ) &&
            const DeepCollectionEquality().equals(other.llmLabels, llmLabels));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(aiImageLabels),
    const DeepCollectionEquality().hash(aiImageTaxonomy),
    const DeepCollectionEquality().hash(aiTextLabels),
    const DeepCollectionEquality().hash(configKeys),
    const DeepCollectionEquality().hash(filterableCustomKeys),
    const DeepCollectionEquality().hash(llmLabels),
  );

  @override
  String toString() {
    return 'FilterConfigResponse(aiImageLabels: $aiImageLabels, aiImageTaxonomy: $aiImageTaxonomy, aiTextLabels: $aiTextLabels, configKeys: $configKeys, filterableCustomKeys: $filterableCustomKeys, llmLabels: $llmLabels)';
  }
}

/// @nodoc
abstract mixin class $FilterConfigResponseCopyWith<$Res> {
  factory $FilterConfigResponseCopyWith(
    FilterConfigResponse value,
    $Res Function(FilterConfigResponse) _then,
  ) = _$FilterConfigResponseCopyWithImpl;
  @useResult
  $Res call({
    List<String>? aiImageLabels,
    Map<String, List<String>>? aiImageTaxonomy,
    List<String>? aiTextLabels,
    List<String>? configKeys,
    List<String>? filterableCustomKeys,
    List<String> llmLabels,
  });
}

/// @nodoc
class _$FilterConfigResponseCopyWithImpl<$Res> implements $FilterConfigResponseCopyWith<$Res> {
  _$FilterConfigResponseCopyWithImpl(this._self, this._then);

  final FilterConfigResponse _self;
  final $Res Function(FilterConfigResponse) _then;

  /// Create a copy of FilterConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aiImageLabels = freezed,
    Object? aiImageTaxonomy = freezed,
    Object? aiTextLabels = freezed,
    Object? configKeys = freezed,
    Object? filterableCustomKeys = freezed,
    Object? llmLabels = null,
  }) {
    return _then(
      FilterConfigResponse(
        aiImageLabels: freezed == aiImageLabels
            ? _self.aiImageLabels
            : aiImageLabels // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        aiImageTaxonomy: freezed == aiImageTaxonomy
            ? _self.aiImageTaxonomy
            : aiImageTaxonomy // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<String>>?,
        aiTextLabels: freezed == aiTextLabels
            ? _self.aiTextLabels
            : aiTextLabels // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        configKeys: freezed == configKeys
            ? _self.configKeys
            : configKeys // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        filterableCustomKeys: freezed == filterableCustomKeys
            ? _self.filterableCustomKeys
            : filterableCustomKeys // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        llmLabels: null == llmLabels
            ? _self.llmLabels
            : llmLabels // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}
