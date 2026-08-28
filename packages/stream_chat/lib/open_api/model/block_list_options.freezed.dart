// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block_list_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockListOptions {
  BlockListOptionsBehavior get behavior;
  String get blocklist;

  /// Create a copy of BlockListOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlockListOptionsCopyWith<BlockListOptions> get copyWith =>
      _$BlockListOptionsCopyWithImpl<BlockListOptions>(
        this as BlockListOptions,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlockListOptions &&
            (identical(other.behavior, behavior) ||
                other.behavior == behavior) &&
            (identical(other.blocklist, blocklist) ||
                other.blocklist == blocklist));
  }

  @override
  int get hashCode => Object.hash(runtimeType, behavior, blocklist);

  @override
  String toString() {
    return 'BlockListOptions(behavior: $behavior, blocklist: $blocklist)';
  }
}

/// @nodoc
abstract mixin class $BlockListOptionsCopyWith<$Res> {
  factory $BlockListOptionsCopyWith(
    BlockListOptions value,
    $Res Function(BlockListOptions) _then,
  ) = _$BlockListOptionsCopyWithImpl;
  @useResult
  $Res call({BlockListOptionsBehavior behavior, String blocklist});
}

/// @nodoc
class _$BlockListOptionsCopyWithImpl<$Res>
    implements $BlockListOptionsCopyWith<$Res> {
  _$BlockListOptionsCopyWithImpl(this._self, this._then);

  final BlockListOptions _self;
  final $Res Function(BlockListOptions) _then;

  /// Create a copy of BlockListOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? behavior = null, Object? blocklist = null}) {
    return _then(
      BlockListOptions(
        behavior: null == behavior
            ? _self.behavior
            : behavior // ignore: cast_nullable_to_non_nullable
                  as BlockListOptionsBehavior,
        blocklist: null == blocklist
            ? _self.blocklist
            : blocklist // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
