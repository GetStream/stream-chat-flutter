// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'predefined_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PredefinedFilter {
  String get name;
  ChannelFilter get filter;
  List<ChannelSort>? get sort;

  /// Create a copy of PredefinedFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PredefinedFilterCopyWith<PredefinedFilter> get copyWith =>
      _$PredefinedFilterCopyWithImpl<PredefinedFilter>(this as PredefinedFilter, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PredefinedFilter &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            const DeepCollectionEquality().equals(other.sort, sort));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, filter, const DeepCollectionEquality().hash(sort));

  @override
  String toString() {
    return 'PredefinedFilter(name: $name, filter: $filter, sort: $sort)';
  }
}

/// @nodoc
abstract mixin class $PredefinedFilterCopyWith<$Res> {
  factory $PredefinedFilterCopyWith(PredefinedFilter value, $Res Function(PredefinedFilter) _then) =
      _$PredefinedFilterCopyWithImpl;
  @useResult
  $Res call({String name, Filter<ChannelState> filter, List<ChannelSort>? sort});
}

/// @nodoc
class _$PredefinedFilterCopyWithImpl<$Res> implements $PredefinedFilterCopyWith<$Res> {
  _$PredefinedFilterCopyWithImpl(this._self, this._then);

  final PredefinedFilter _self;
  final $Res Function(PredefinedFilter) _then;

  /// Create a copy of PredefinedFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? filter = null, Object? sort = freezed}) {
    return _then(
      PredefinedFilter(
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        filter: null == filter
            ? _self.filter
            : filter // ignore: cast_nullable_to_non_nullable
                  as Filter<ChannelState>,
        sort: freezed == sort
            ? _self.sort
            : sort // ignore: cast_nullable_to_non_nullable
                  as List<ChannelSort>?,
      ),
    );
  }
}
