// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parsed_predefined_filter_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParsedPredefinedFilterResponse {
  Map<String, Object?> get filter;
  String get name;
  List<SortParamRequest>? get sort;

  /// Create a copy of ParsedPredefinedFilterResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParsedPredefinedFilterResponseCopyWith<ParsedPredefinedFilterResponse> get copyWith =>
      _$ParsedPredefinedFilterResponseCopyWithImpl<ParsedPredefinedFilterResponse>(
        this as ParsedPredefinedFilterResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParsedPredefinedFilterResponse &&
            const DeepCollectionEquality().equals(other.filter, filter) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.sort, sort));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(filter),
    name,
    const DeepCollectionEquality().hash(sort),
  );

  @override
  String toString() {
    return 'ParsedPredefinedFilterResponse(filter: $filter, name: $name, sort: $sort)';
  }
}

/// @nodoc
abstract mixin class $ParsedPredefinedFilterResponseCopyWith<$Res> {
  factory $ParsedPredefinedFilterResponseCopyWith(
    ParsedPredefinedFilterResponse value,
    $Res Function(ParsedPredefinedFilterResponse) _then,
  ) = _$ParsedPredefinedFilterResponseCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?> filter,
    String name,
    List<SortParamRequest>? sort,
  });
}

/// @nodoc
class _$ParsedPredefinedFilterResponseCopyWithImpl<$Res> implements $ParsedPredefinedFilterResponseCopyWith<$Res> {
  _$ParsedPredefinedFilterResponseCopyWithImpl(this._self, this._then);

  final ParsedPredefinedFilterResponse _self;
  final $Res Function(ParsedPredefinedFilterResponse) _then;

  /// Create a copy of ParsedPredefinedFilterResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filter = null,
    Object? name = null,
    Object? sort = freezed,
  }) {
    return _then(
      ParsedPredefinedFilterResponse(
        filter: null == filter
            ? _self.filter
            : filter // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        sort: freezed == sort
            ? _self.sort
            : sort // ignore: cast_nullable_to_non_nullable
                  as List<SortParamRequest>?,
      ),
    );
  }
}
