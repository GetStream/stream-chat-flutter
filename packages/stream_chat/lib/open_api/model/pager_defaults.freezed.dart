// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pager_defaults.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PagerDefaults {
  int get limit;

  /// Create a copy of PagerDefaults
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PagerDefaultsCopyWith<PagerDefaults> get copyWith => _$PagerDefaultsCopyWithImpl<PagerDefaults>(
    this as PagerDefaults,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PagerDefaults &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, limit);

  @override
  String toString() {
    return 'PagerDefaults(limit: $limit)';
  }
}

/// @nodoc
abstract mixin class $PagerDefaultsCopyWith<$Res> {
  factory $PagerDefaultsCopyWith(
    PagerDefaults value,
    $Res Function(PagerDefaults) _then,
  ) = _$PagerDefaultsCopyWithImpl;
  @useResult
  $Res call({int limit});
}

/// @nodoc
class _$PagerDefaultsCopyWithImpl<$Res> implements $PagerDefaultsCopyWith<$Res> {
  _$PagerDefaultsCopyWithImpl(this._self, this._then);

  final PagerDefaults _self;
  final $Res Function(PagerDefaults) _then;

  /// Create a copy of PagerDefaults
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? limit = null}) {
    return _then(
      PagerDefaults(
        limit: null == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
