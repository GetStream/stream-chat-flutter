// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stream_poll_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollValidationError {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PollValidationError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PollValidationError()';
  }
}

/// @nodoc
class $PollValidationErrorCopyWith<$Res> {
  $PollValidationErrorCopyWith(
      PollValidationError _, $Res Function(PollValidationError) __);
}

/// @nodoc

class _PollValidationErrorDuplicateOptions implements PollValidationError {
  const _PollValidationErrorDuplicateOptions(final List<PollOption> options)
      : _options = options;

  final List<PollOption> _options;
  List<PollOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PollValidationErrorDuplicateOptionsCopyWith<
          _PollValidationErrorDuplicateOptions>
      get copyWith => __$PollValidationErrorDuplicateOptionsCopyWithImpl<
          _PollValidationErrorDuplicateOptions>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PollValidationErrorDuplicateOptions &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_options));

  @override
  String toString() {
    return 'PollValidationError.duplicateOptions(options: $options)';
  }
}

/// @nodoc
abstract mixin class _$PollValidationErrorDuplicateOptionsCopyWith<$Res>
    implements $PollValidationErrorCopyWith<$Res> {
  factory _$PollValidationErrorDuplicateOptionsCopyWith(
          _PollValidationErrorDuplicateOptions value,
          $Res Function(_PollValidationErrorDuplicateOptions) _then) =
      __$PollValidationErrorDuplicateOptionsCopyWithImpl;
  @useResult
  $Res call({List<PollOption> options});
}

/// @nodoc
class __$PollValidationErrorDuplicateOptionsCopyWithImpl<$Res>
    implements _$PollValidationErrorDuplicateOptionsCopyWith<$Res> {
  __$PollValidationErrorDuplicateOptionsCopyWithImpl(this._self, this._then);

  final _PollValidationErrorDuplicateOptions _self;
  final $Res Function(_PollValidationErrorDuplicateOptions) _then;

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? options = null,
  }) {
    return _then(_PollValidationErrorDuplicateOptions(
      null == options
          ? _self._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<PollOption>,
    ));
  }
}

/// @nodoc

class _PollValidationErrorNameRange implements PollValidationError {
  const _PollValidationErrorNameRange(this.name, {required this.range});

  final String name;
  final Range<int> range;

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PollValidationErrorNameRangeCopyWith<_PollValidationErrorNameRange>
      get copyWith => __$PollValidationErrorNameRangeCopyWithImpl<
          _PollValidationErrorNameRange>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PollValidationErrorNameRange &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.range, range) || other.range == range));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, range);

  @override
  String toString() {
    return 'PollValidationError.nameRange(name: $name, range: $range)';
  }
}

/// @nodoc
abstract mixin class _$PollValidationErrorNameRangeCopyWith<$Res>
    implements $PollValidationErrorCopyWith<$Res> {
  factory _$PollValidationErrorNameRangeCopyWith(
          _PollValidationErrorNameRange value,
          $Res Function(_PollValidationErrorNameRange) _then) =
      __$PollValidationErrorNameRangeCopyWithImpl;
  @useResult
  $Res call({String name, Range<int> range});
}

/// @nodoc
class __$PollValidationErrorNameRangeCopyWithImpl<$Res>
    implements _$PollValidationErrorNameRangeCopyWith<$Res> {
  __$PollValidationErrorNameRangeCopyWithImpl(this._self, this._then);

  final _PollValidationErrorNameRange _self;
  final $Res Function(_PollValidationErrorNameRange) _then;

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? range = null,
  }) {
    return _then(_PollValidationErrorNameRange(
      null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      range: null == range
          ? _self.range
          : range // ignore: cast_nullable_to_non_nullable
              as Range<int>,
    ));
  }
}

/// @nodoc

class _PollValidationErrorOptionsRange implements PollValidationError {
  const _PollValidationErrorOptionsRange(final List<PollOption> options,
      {required this.range})
      : _options = options;

  final List<PollOption> _options;
  List<PollOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  final Range<int> range;

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PollValidationErrorOptionsRangeCopyWith<_PollValidationErrorOptionsRange>
      get copyWith => __$PollValidationErrorOptionsRangeCopyWithImpl<
          _PollValidationErrorOptionsRange>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PollValidationErrorOptionsRange &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.range, range) || other.range == range));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_options), range);

  @override
  String toString() {
    return 'PollValidationError.optionsRange(options: $options, range: $range)';
  }
}

/// @nodoc
abstract mixin class _$PollValidationErrorOptionsRangeCopyWith<$Res>
    implements $PollValidationErrorCopyWith<$Res> {
  factory _$PollValidationErrorOptionsRangeCopyWith(
          _PollValidationErrorOptionsRange value,
          $Res Function(_PollValidationErrorOptionsRange) _then) =
      __$PollValidationErrorOptionsRangeCopyWithImpl;
  @useResult
  $Res call({List<PollOption> options, Range<int> range});
}

/// @nodoc
class __$PollValidationErrorOptionsRangeCopyWithImpl<$Res>
    implements _$PollValidationErrorOptionsRangeCopyWith<$Res> {
  __$PollValidationErrorOptionsRangeCopyWithImpl(this._self, this._then);

  final _PollValidationErrorOptionsRange _self;
  final $Res Function(_PollValidationErrorOptionsRange) _then;

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? options = null,
    Object? range = null,
  }) {
    return _then(_PollValidationErrorOptionsRange(
      null == options
          ? _self._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<PollOption>,
      range: null == range
          ? _self.range
          : range // ignore: cast_nullable_to_non_nullable
              as Range<int>,
    ));
  }
}

/// @nodoc

class _PollValidationErrorMaxVotesAllowed implements PollValidationError {
  const _PollValidationErrorMaxVotesAllowed(this.maxVotesAllowed,
      {required this.range});

  final int maxVotesAllowed;
  final Range<int> range;

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PollValidationErrorMaxVotesAllowedCopyWith<
          _PollValidationErrorMaxVotesAllowed>
      get copyWith => __$PollValidationErrorMaxVotesAllowedCopyWithImpl<
          _PollValidationErrorMaxVotesAllowed>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PollValidationErrorMaxVotesAllowed &&
            (identical(other.maxVotesAllowed, maxVotesAllowed) ||
                other.maxVotesAllowed == maxVotesAllowed) &&
            (identical(other.range, range) || other.range == range));
  }

  @override
  int get hashCode => Object.hash(runtimeType, maxVotesAllowed, range);

  @override
  String toString() {
    return 'PollValidationError.maxVotesAllowed(maxVotesAllowed: $maxVotesAllowed, range: $range)';
  }
}

/// @nodoc
abstract mixin class _$PollValidationErrorMaxVotesAllowedCopyWith<$Res>
    implements $PollValidationErrorCopyWith<$Res> {
  factory _$PollValidationErrorMaxVotesAllowedCopyWith(
          _PollValidationErrorMaxVotesAllowed value,
          $Res Function(_PollValidationErrorMaxVotesAllowed) _then) =
      __$PollValidationErrorMaxVotesAllowedCopyWithImpl;
  @useResult
  $Res call({int maxVotesAllowed, Range<int> range});
}

/// @nodoc
class __$PollValidationErrorMaxVotesAllowedCopyWithImpl<$Res>
    implements _$PollValidationErrorMaxVotesAllowedCopyWith<$Res> {
  __$PollValidationErrorMaxVotesAllowedCopyWithImpl(this._self, this._then);

  final _PollValidationErrorMaxVotesAllowed _self;
  final $Res Function(_PollValidationErrorMaxVotesAllowed) _then;

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? maxVotesAllowed = null,
    Object? range = null,
  }) {
    return _then(_PollValidationErrorMaxVotesAllowed(
      null == maxVotesAllowed
          ? _self.maxVotesAllowed
          : maxVotesAllowed // ignore: cast_nullable_to_non_nullable
              as int,
      range: null == range
          ? _self.range
          : range // ignore: cast_nullable_to_non_nullable
              as Range<int>,
    ));
  }
}

// dart format on
