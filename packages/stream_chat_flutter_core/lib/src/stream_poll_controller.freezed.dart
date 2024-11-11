// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stream_poll_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PollValidationError {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String message) $default, {
    required TResult Function(List<PollOption> options) duplicateOptions,
    required TResult Function(String name, ({int? max, int? min}) range)
        nameRange,
    required TResult Function(
            List<PollOption> options, ({int? max, int? min}) range)
        optionsRange,
    required TResult Function(int maxVotesAllowed, ({int? max, int? min}) range)
        maxVotesAllowed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String message)? $default, {
    TResult? Function(List<PollOption> options)? duplicateOptions,
    TResult? Function(String name, ({int? max, int? min}) range)? nameRange,
    TResult? Function(List<PollOption> options, ({int? max, int? min}) range)?
        optionsRange,
    TResult? Function(int maxVotesAllowed, ({int? max, int? min}) range)?
        maxVotesAllowed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String message)? $default, {
    TResult Function(List<PollOption> options)? duplicateOptions,
    TResult Function(String name, ({int? max, int? min}) range)? nameRange,
    TResult Function(List<PollOption> options, ({int? max, int? min}) range)?
        optionsRange,
    TResult Function(int maxVotesAllowed, ({int? max, int? min}) range)?
        maxVotesAllowed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PollValidationError value) $default, {
    required TResult Function(_PollValidationErrorDuplicateOptions value)
        duplicateOptions,
    required TResult Function(_PollValidationErrorNameRange value) nameRange,
    required TResult Function(_PollValidationErrorOptionsRange value)
        optionsRange,
    required TResult Function(_PollValidationErrorMaxVotesAllowed value)
        maxVotesAllowed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PollValidationError value)? $default, {
    TResult? Function(_PollValidationErrorDuplicateOptions value)?
        duplicateOptions,
    TResult? Function(_PollValidationErrorNameRange value)? nameRange,
    TResult? Function(_PollValidationErrorOptionsRange value)? optionsRange,
    TResult? Function(_PollValidationErrorMaxVotesAllowed value)?
        maxVotesAllowed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PollValidationError value)? $default, {
    TResult Function(_PollValidationErrorDuplicateOptions value)?
        duplicateOptions,
    TResult Function(_PollValidationErrorNameRange value)? nameRange,
    TResult Function(_PollValidationErrorOptionsRange value)? optionsRange,
    TResult Function(_PollValidationErrorMaxVotesAllowed value)?
        maxVotesAllowed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PollValidationErrorCopyWith<$Res> {
  factory $PollValidationErrorCopyWith(
          PollValidationError value, $Res Function(PollValidationError) then) =
      _$PollValidationErrorCopyWithImpl<$Res, PollValidationError>;
}

/// @nodoc
class _$PollValidationErrorCopyWithImpl<$Res, $Val extends PollValidationError>
    implements $PollValidationErrorCopyWith<$Res> {
  _$PollValidationErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PollValidationErrorImplCopyWith<$Res> {
  factory _$$PollValidationErrorImplCopyWith(_$PollValidationErrorImpl value,
          $Res Function(_$PollValidationErrorImpl) then) =
      __$$PollValidationErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PollValidationErrorImplCopyWithImpl<$Res>
    extends _$PollValidationErrorCopyWithImpl<$Res, _$PollValidationErrorImpl>
    implements _$$PollValidationErrorImplCopyWith<$Res> {
  __$$PollValidationErrorImplCopyWithImpl(_$PollValidationErrorImpl _value,
      $Res Function(_$PollValidationErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$PollValidationErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PollValidationErrorImpl implements _PollValidationError {
  const _$PollValidationErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'PollValidationError(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PollValidationErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PollValidationErrorImplCopyWith<_$PollValidationErrorImpl> get copyWith =>
      __$$PollValidationErrorImplCopyWithImpl<_$PollValidationErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String message) $default, {
    required TResult Function(List<PollOption> options) duplicateOptions,
    required TResult Function(String name, ({int? max, int? min}) range)
        nameRange,
    required TResult Function(
            List<PollOption> options, ({int? max, int? min}) range)
        optionsRange,
    required TResult Function(int maxVotesAllowed, ({int? max, int? min}) range)
        maxVotesAllowed,
  }) {
    return $default(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String message)? $default, {
    TResult? Function(List<PollOption> options)? duplicateOptions,
    TResult? Function(String name, ({int? max, int? min}) range)? nameRange,
    TResult? Function(List<PollOption> options, ({int? max, int? min}) range)?
        optionsRange,
    TResult? Function(int maxVotesAllowed, ({int? max, int? min}) range)?
        maxVotesAllowed,
  }) {
    return $default?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String message)? $default, {
    TResult Function(List<PollOption> options)? duplicateOptions,
    TResult Function(String name, ({int? max, int? min}) range)? nameRange,
    TResult Function(List<PollOption> options, ({int? max, int? min}) range)?
        optionsRange,
    TResult Function(int maxVotesAllowed, ({int? max, int? min}) range)?
        maxVotesAllowed,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PollValidationError value) $default, {
    required TResult Function(_PollValidationErrorDuplicateOptions value)
        duplicateOptions,
    required TResult Function(_PollValidationErrorNameRange value) nameRange,
    required TResult Function(_PollValidationErrorOptionsRange value)
        optionsRange,
    required TResult Function(_PollValidationErrorMaxVotesAllowed value)
        maxVotesAllowed,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PollValidationError value)? $default, {
    TResult? Function(_PollValidationErrorDuplicateOptions value)?
        duplicateOptions,
    TResult? Function(_PollValidationErrorNameRange value)? nameRange,
    TResult? Function(_PollValidationErrorOptionsRange value)? optionsRange,
    TResult? Function(_PollValidationErrorMaxVotesAllowed value)?
        maxVotesAllowed,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PollValidationError value)? $default, {
    TResult Function(_PollValidationErrorDuplicateOptions value)?
        duplicateOptions,
    TResult Function(_PollValidationErrorNameRange value)? nameRange,
    TResult Function(_PollValidationErrorOptionsRange value)? optionsRange,
    TResult Function(_PollValidationErrorMaxVotesAllowed value)?
        maxVotesAllowed,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _PollValidationError implements PollValidationError {
  const factory _PollValidationError(final String message) =
      _$PollValidationErrorImpl;

  String get message;

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PollValidationErrorImplCopyWith<_$PollValidationErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PollValidationErrorDuplicateOptionsImplCopyWith<$Res> {
  factory _$$PollValidationErrorDuplicateOptionsImplCopyWith(
          _$PollValidationErrorDuplicateOptionsImpl value,
          $Res Function(_$PollValidationErrorDuplicateOptionsImpl) then) =
      __$$PollValidationErrorDuplicateOptionsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<PollOption> options});
}

/// @nodoc
class __$$PollValidationErrorDuplicateOptionsImplCopyWithImpl<$Res>
    extends _$PollValidationErrorCopyWithImpl<$Res,
        _$PollValidationErrorDuplicateOptionsImpl>
    implements _$$PollValidationErrorDuplicateOptionsImplCopyWith<$Res> {
  __$$PollValidationErrorDuplicateOptionsImplCopyWithImpl(
      _$PollValidationErrorDuplicateOptionsImpl _value,
      $Res Function(_$PollValidationErrorDuplicateOptionsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? options = null,
  }) {
    return _then(_$PollValidationErrorDuplicateOptionsImpl(
      null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<PollOption>,
    ));
  }
}

/// @nodoc

class _$PollValidationErrorDuplicateOptionsImpl
    implements _PollValidationErrorDuplicateOptions {
  const _$PollValidationErrorDuplicateOptionsImpl(
      final List<PollOption> options)
      : _options = options;

  final List<PollOption> _options;
  @override
  List<PollOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  String toString() {
    return 'PollValidationError.duplicateOptions(options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PollValidationErrorDuplicateOptionsImpl &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_options));

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PollValidationErrorDuplicateOptionsImplCopyWith<
          _$PollValidationErrorDuplicateOptionsImpl>
      get copyWith => __$$PollValidationErrorDuplicateOptionsImplCopyWithImpl<
          _$PollValidationErrorDuplicateOptionsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String message) $default, {
    required TResult Function(List<PollOption> options) duplicateOptions,
    required TResult Function(String name, ({int? max, int? min}) range)
        nameRange,
    required TResult Function(
            List<PollOption> options, ({int? max, int? min}) range)
        optionsRange,
    required TResult Function(int maxVotesAllowed, ({int? max, int? min}) range)
        maxVotesAllowed,
  }) {
    return duplicateOptions(options);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String message)? $default, {
    TResult? Function(List<PollOption> options)? duplicateOptions,
    TResult? Function(String name, ({int? max, int? min}) range)? nameRange,
    TResult? Function(List<PollOption> options, ({int? max, int? min}) range)?
        optionsRange,
    TResult? Function(int maxVotesAllowed, ({int? max, int? min}) range)?
        maxVotesAllowed,
  }) {
    return duplicateOptions?.call(options);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String message)? $default, {
    TResult Function(List<PollOption> options)? duplicateOptions,
    TResult Function(String name, ({int? max, int? min}) range)? nameRange,
    TResult Function(List<PollOption> options, ({int? max, int? min}) range)?
        optionsRange,
    TResult Function(int maxVotesAllowed, ({int? max, int? min}) range)?
        maxVotesAllowed,
    required TResult orElse(),
  }) {
    if (duplicateOptions != null) {
      return duplicateOptions(options);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PollValidationError value) $default, {
    required TResult Function(_PollValidationErrorDuplicateOptions value)
        duplicateOptions,
    required TResult Function(_PollValidationErrorNameRange value) nameRange,
    required TResult Function(_PollValidationErrorOptionsRange value)
        optionsRange,
    required TResult Function(_PollValidationErrorMaxVotesAllowed value)
        maxVotesAllowed,
  }) {
    return duplicateOptions(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PollValidationError value)? $default, {
    TResult? Function(_PollValidationErrorDuplicateOptions value)?
        duplicateOptions,
    TResult? Function(_PollValidationErrorNameRange value)? nameRange,
    TResult? Function(_PollValidationErrorOptionsRange value)? optionsRange,
    TResult? Function(_PollValidationErrorMaxVotesAllowed value)?
        maxVotesAllowed,
  }) {
    return duplicateOptions?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PollValidationError value)? $default, {
    TResult Function(_PollValidationErrorDuplicateOptions value)?
        duplicateOptions,
    TResult Function(_PollValidationErrorNameRange value)? nameRange,
    TResult Function(_PollValidationErrorOptionsRange value)? optionsRange,
    TResult Function(_PollValidationErrorMaxVotesAllowed value)?
        maxVotesAllowed,
    required TResult orElse(),
  }) {
    if (duplicateOptions != null) {
      return duplicateOptions(this);
    }
    return orElse();
  }
}

abstract class _PollValidationErrorDuplicateOptions
    implements PollValidationError {
  const factory _PollValidationErrorDuplicateOptions(
          final List<PollOption> options) =
      _$PollValidationErrorDuplicateOptionsImpl;

  List<PollOption> get options;

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PollValidationErrorDuplicateOptionsImplCopyWith<
          _$PollValidationErrorDuplicateOptionsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PollValidationErrorNameRangeImplCopyWith<$Res> {
  factory _$$PollValidationErrorNameRangeImplCopyWith(
          _$PollValidationErrorNameRangeImpl value,
          $Res Function(_$PollValidationErrorNameRangeImpl) then) =
      __$$PollValidationErrorNameRangeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String name, ({int? max, int? min}) range});
}

/// @nodoc
class __$$PollValidationErrorNameRangeImplCopyWithImpl<$Res>
    extends _$PollValidationErrorCopyWithImpl<$Res,
        _$PollValidationErrorNameRangeImpl>
    implements _$$PollValidationErrorNameRangeImplCopyWith<$Res> {
  __$$PollValidationErrorNameRangeImplCopyWithImpl(
      _$PollValidationErrorNameRangeImpl _value,
      $Res Function(_$PollValidationErrorNameRangeImpl) _then)
      : super(_value, _then);

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? range = null,
  }) {
    return _then(_$PollValidationErrorNameRangeImpl(
      null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      range: null == range
          ? _value.range
          : range // ignore: cast_nullable_to_non_nullable
              as ({int? max, int? min}),
    ));
  }
}

/// @nodoc

class _$PollValidationErrorNameRangeImpl
    implements _PollValidationErrorNameRange {
  const _$PollValidationErrorNameRangeImpl(this.name, {required this.range});

  @override
  final String name;
  @override
  final ({int? max, int? min}) range;

  @override
  String toString() {
    return 'PollValidationError.nameRange(name: $name, range: $range)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PollValidationErrorNameRangeImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.range, range) || other.range == range));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, range);

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PollValidationErrorNameRangeImplCopyWith<
          _$PollValidationErrorNameRangeImpl>
      get copyWith => __$$PollValidationErrorNameRangeImplCopyWithImpl<
          _$PollValidationErrorNameRangeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String message) $default, {
    required TResult Function(List<PollOption> options) duplicateOptions,
    required TResult Function(String name, ({int? max, int? min}) range)
        nameRange,
    required TResult Function(
            List<PollOption> options, ({int? max, int? min}) range)
        optionsRange,
    required TResult Function(int maxVotesAllowed, ({int? max, int? min}) range)
        maxVotesAllowed,
  }) {
    return nameRange(name, range);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String message)? $default, {
    TResult? Function(List<PollOption> options)? duplicateOptions,
    TResult? Function(String name, ({int? max, int? min}) range)? nameRange,
    TResult? Function(List<PollOption> options, ({int? max, int? min}) range)?
        optionsRange,
    TResult? Function(int maxVotesAllowed, ({int? max, int? min}) range)?
        maxVotesAllowed,
  }) {
    return nameRange?.call(name, range);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String message)? $default, {
    TResult Function(List<PollOption> options)? duplicateOptions,
    TResult Function(String name, ({int? max, int? min}) range)? nameRange,
    TResult Function(List<PollOption> options, ({int? max, int? min}) range)?
        optionsRange,
    TResult Function(int maxVotesAllowed, ({int? max, int? min}) range)?
        maxVotesAllowed,
    required TResult orElse(),
  }) {
    if (nameRange != null) {
      return nameRange(name, range);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PollValidationError value) $default, {
    required TResult Function(_PollValidationErrorDuplicateOptions value)
        duplicateOptions,
    required TResult Function(_PollValidationErrorNameRange value) nameRange,
    required TResult Function(_PollValidationErrorOptionsRange value)
        optionsRange,
    required TResult Function(_PollValidationErrorMaxVotesAllowed value)
        maxVotesAllowed,
  }) {
    return nameRange(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PollValidationError value)? $default, {
    TResult? Function(_PollValidationErrorDuplicateOptions value)?
        duplicateOptions,
    TResult? Function(_PollValidationErrorNameRange value)? nameRange,
    TResult? Function(_PollValidationErrorOptionsRange value)? optionsRange,
    TResult? Function(_PollValidationErrorMaxVotesAllowed value)?
        maxVotesAllowed,
  }) {
    return nameRange?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PollValidationError value)? $default, {
    TResult Function(_PollValidationErrorDuplicateOptions value)?
        duplicateOptions,
    TResult Function(_PollValidationErrorNameRange value)? nameRange,
    TResult Function(_PollValidationErrorOptionsRange value)? optionsRange,
    TResult Function(_PollValidationErrorMaxVotesAllowed value)?
        maxVotesAllowed,
    required TResult orElse(),
  }) {
    if (nameRange != null) {
      return nameRange(this);
    }
    return orElse();
  }
}

abstract class _PollValidationErrorNameRange implements PollValidationError {
  const factory _PollValidationErrorNameRange(final String name,
          {required final ({int? max, int? min}) range}) =
      _$PollValidationErrorNameRangeImpl;

  String get name;
  ({int? max, int? min}) get range;

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PollValidationErrorNameRangeImplCopyWith<
          _$PollValidationErrorNameRangeImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PollValidationErrorOptionsRangeImplCopyWith<$Res> {
  factory _$$PollValidationErrorOptionsRangeImplCopyWith(
          _$PollValidationErrorOptionsRangeImpl value,
          $Res Function(_$PollValidationErrorOptionsRangeImpl) then) =
      __$$PollValidationErrorOptionsRangeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<PollOption> options, ({int? max, int? min}) range});
}

/// @nodoc
class __$$PollValidationErrorOptionsRangeImplCopyWithImpl<$Res>
    extends _$PollValidationErrorCopyWithImpl<$Res,
        _$PollValidationErrorOptionsRangeImpl>
    implements _$$PollValidationErrorOptionsRangeImplCopyWith<$Res> {
  __$$PollValidationErrorOptionsRangeImplCopyWithImpl(
      _$PollValidationErrorOptionsRangeImpl _value,
      $Res Function(_$PollValidationErrorOptionsRangeImpl) _then)
      : super(_value, _then);

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? options = null,
    Object? range = null,
  }) {
    return _then(_$PollValidationErrorOptionsRangeImpl(
      null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<PollOption>,
      range: null == range
          ? _value.range
          : range // ignore: cast_nullable_to_non_nullable
              as ({int? max, int? min}),
    ));
  }
}

/// @nodoc

class _$PollValidationErrorOptionsRangeImpl
    implements _PollValidationErrorOptionsRange {
  const _$PollValidationErrorOptionsRangeImpl(final List<PollOption> options,
      {required this.range})
      : _options = options;

  final List<PollOption> _options;
  @override
  List<PollOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  final ({int? max, int? min}) range;

  @override
  String toString() {
    return 'PollValidationError.optionsRange(options: $options, range: $range)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PollValidationErrorOptionsRangeImpl &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.range, range) || other.range == range));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_options), range);

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PollValidationErrorOptionsRangeImplCopyWith<
          _$PollValidationErrorOptionsRangeImpl>
      get copyWith => __$$PollValidationErrorOptionsRangeImplCopyWithImpl<
          _$PollValidationErrorOptionsRangeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String message) $default, {
    required TResult Function(List<PollOption> options) duplicateOptions,
    required TResult Function(String name, ({int? max, int? min}) range)
        nameRange,
    required TResult Function(
            List<PollOption> options, ({int? max, int? min}) range)
        optionsRange,
    required TResult Function(int maxVotesAllowed, ({int? max, int? min}) range)
        maxVotesAllowed,
  }) {
    return optionsRange(options, range);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String message)? $default, {
    TResult? Function(List<PollOption> options)? duplicateOptions,
    TResult? Function(String name, ({int? max, int? min}) range)? nameRange,
    TResult? Function(List<PollOption> options, ({int? max, int? min}) range)?
        optionsRange,
    TResult? Function(int maxVotesAllowed, ({int? max, int? min}) range)?
        maxVotesAllowed,
  }) {
    return optionsRange?.call(options, range);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String message)? $default, {
    TResult Function(List<PollOption> options)? duplicateOptions,
    TResult Function(String name, ({int? max, int? min}) range)? nameRange,
    TResult Function(List<PollOption> options, ({int? max, int? min}) range)?
        optionsRange,
    TResult Function(int maxVotesAllowed, ({int? max, int? min}) range)?
        maxVotesAllowed,
    required TResult orElse(),
  }) {
    if (optionsRange != null) {
      return optionsRange(options, range);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PollValidationError value) $default, {
    required TResult Function(_PollValidationErrorDuplicateOptions value)
        duplicateOptions,
    required TResult Function(_PollValidationErrorNameRange value) nameRange,
    required TResult Function(_PollValidationErrorOptionsRange value)
        optionsRange,
    required TResult Function(_PollValidationErrorMaxVotesAllowed value)
        maxVotesAllowed,
  }) {
    return optionsRange(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PollValidationError value)? $default, {
    TResult? Function(_PollValidationErrorDuplicateOptions value)?
        duplicateOptions,
    TResult? Function(_PollValidationErrorNameRange value)? nameRange,
    TResult? Function(_PollValidationErrorOptionsRange value)? optionsRange,
    TResult? Function(_PollValidationErrorMaxVotesAllowed value)?
        maxVotesAllowed,
  }) {
    return optionsRange?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PollValidationError value)? $default, {
    TResult Function(_PollValidationErrorDuplicateOptions value)?
        duplicateOptions,
    TResult Function(_PollValidationErrorNameRange value)? nameRange,
    TResult Function(_PollValidationErrorOptionsRange value)? optionsRange,
    TResult Function(_PollValidationErrorMaxVotesAllowed value)?
        maxVotesAllowed,
    required TResult orElse(),
  }) {
    if (optionsRange != null) {
      return optionsRange(this);
    }
    return orElse();
  }
}

abstract class _PollValidationErrorOptionsRange implements PollValidationError {
  const factory _PollValidationErrorOptionsRange(final List<PollOption> options,
          {required final ({int? max, int? min}) range}) =
      _$PollValidationErrorOptionsRangeImpl;

  List<PollOption> get options;
  ({int? max, int? min}) get range;

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PollValidationErrorOptionsRangeImplCopyWith<
          _$PollValidationErrorOptionsRangeImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PollValidationErrorMaxVotesAllowedImplCopyWith<$Res> {
  factory _$$PollValidationErrorMaxVotesAllowedImplCopyWith(
          _$PollValidationErrorMaxVotesAllowedImpl value,
          $Res Function(_$PollValidationErrorMaxVotesAllowedImpl) then) =
      __$$PollValidationErrorMaxVotesAllowedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int maxVotesAllowed, ({int? max, int? min}) range});
}

/// @nodoc
class __$$PollValidationErrorMaxVotesAllowedImplCopyWithImpl<$Res>
    extends _$PollValidationErrorCopyWithImpl<$Res,
        _$PollValidationErrorMaxVotesAllowedImpl>
    implements _$$PollValidationErrorMaxVotesAllowedImplCopyWith<$Res> {
  __$$PollValidationErrorMaxVotesAllowedImplCopyWithImpl(
      _$PollValidationErrorMaxVotesAllowedImpl _value,
      $Res Function(_$PollValidationErrorMaxVotesAllowedImpl) _then)
      : super(_value, _then);

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxVotesAllowed = null,
    Object? range = null,
  }) {
    return _then(_$PollValidationErrorMaxVotesAllowedImpl(
      null == maxVotesAllowed
          ? _value.maxVotesAllowed
          : maxVotesAllowed // ignore: cast_nullable_to_non_nullable
              as int,
      range: null == range
          ? _value.range
          : range // ignore: cast_nullable_to_non_nullable
              as ({int? max, int? min}),
    ));
  }
}

/// @nodoc

class _$PollValidationErrorMaxVotesAllowedImpl
    implements _PollValidationErrorMaxVotesAllowed {
  const _$PollValidationErrorMaxVotesAllowedImpl(this.maxVotesAllowed,
      {required this.range});

  @override
  final int maxVotesAllowed;
  @override
  final ({int? max, int? min}) range;

  @override
  String toString() {
    return 'PollValidationError.maxVotesAllowed(maxVotesAllowed: $maxVotesAllowed, range: $range)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PollValidationErrorMaxVotesAllowedImpl &&
            (identical(other.maxVotesAllowed, maxVotesAllowed) ||
                other.maxVotesAllowed == maxVotesAllowed) &&
            (identical(other.range, range) || other.range == range));
  }

  @override
  int get hashCode => Object.hash(runtimeType, maxVotesAllowed, range);

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PollValidationErrorMaxVotesAllowedImplCopyWith<
          _$PollValidationErrorMaxVotesAllowedImpl>
      get copyWith => __$$PollValidationErrorMaxVotesAllowedImplCopyWithImpl<
          _$PollValidationErrorMaxVotesAllowedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String message) $default, {
    required TResult Function(List<PollOption> options) duplicateOptions,
    required TResult Function(String name, ({int? max, int? min}) range)
        nameRange,
    required TResult Function(
            List<PollOption> options, ({int? max, int? min}) range)
        optionsRange,
    required TResult Function(int maxVotesAllowed, ({int? max, int? min}) range)
        maxVotesAllowed,
  }) {
    return maxVotesAllowed(this.maxVotesAllowed, range);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String message)? $default, {
    TResult? Function(List<PollOption> options)? duplicateOptions,
    TResult? Function(String name, ({int? max, int? min}) range)? nameRange,
    TResult? Function(List<PollOption> options, ({int? max, int? min}) range)?
        optionsRange,
    TResult? Function(int maxVotesAllowed, ({int? max, int? min}) range)?
        maxVotesAllowed,
  }) {
    return maxVotesAllowed?.call(this.maxVotesAllowed, range);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String message)? $default, {
    TResult Function(List<PollOption> options)? duplicateOptions,
    TResult Function(String name, ({int? max, int? min}) range)? nameRange,
    TResult Function(List<PollOption> options, ({int? max, int? min}) range)?
        optionsRange,
    TResult Function(int maxVotesAllowed, ({int? max, int? min}) range)?
        maxVotesAllowed,
    required TResult orElse(),
  }) {
    if (maxVotesAllowed != null) {
      return maxVotesAllowed(this.maxVotesAllowed, range);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PollValidationError value) $default, {
    required TResult Function(_PollValidationErrorDuplicateOptions value)
        duplicateOptions,
    required TResult Function(_PollValidationErrorNameRange value) nameRange,
    required TResult Function(_PollValidationErrorOptionsRange value)
        optionsRange,
    required TResult Function(_PollValidationErrorMaxVotesAllowed value)
        maxVotesAllowed,
  }) {
    return maxVotesAllowed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PollValidationError value)? $default, {
    TResult? Function(_PollValidationErrorDuplicateOptions value)?
        duplicateOptions,
    TResult? Function(_PollValidationErrorNameRange value)? nameRange,
    TResult? Function(_PollValidationErrorOptionsRange value)? optionsRange,
    TResult? Function(_PollValidationErrorMaxVotesAllowed value)?
        maxVotesAllowed,
  }) {
    return maxVotesAllowed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PollValidationError value)? $default, {
    TResult Function(_PollValidationErrorDuplicateOptions value)?
        duplicateOptions,
    TResult Function(_PollValidationErrorNameRange value)? nameRange,
    TResult Function(_PollValidationErrorOptionsRange value)? optionsRange,
    TResult Function(_PollValidationErrorMaxVotesAllowed value)?
        maxVotesAllowed,
    required TResult orElse(),
  }) {
    if (maxVotesAllowed != null) {
      return maxVotesAllowed(this);
    }
    return orElse();
  }
}

abstract class _PollValidationErrorMaxVotesAllowed
    implements PollValidationError {
  const factory _PollValidationErrorMaxVotesAllowed(final int maxVotesAllowed,
          {required final ({int? max, int? min}) range}) =
      _$PollValidationErrorMaxVotesAllowedImpl;

  int get maxVotesAllowed;
  ({int? max, int? min}) get range;

  /// Create a copy of PollValidationError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PollValidationErrorMaxVotesAllowedImplCopyWith<
          _$PollValidationErrorMaxVotesAllowedImpl>
      get copyWith => throw _privateConstructorUsedError;
}
