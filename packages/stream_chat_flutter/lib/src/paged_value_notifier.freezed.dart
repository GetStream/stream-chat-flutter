// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'paged_value_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$PagedValueTearOff {
  const _$PagedValueTearOff();

  Success<Key, Value> call<Key, Value>(
      {required List<Value> items, Key? nextPageKey, StreamChatError? error}) {
    return Success<Key, Value>(
      items: items,
      nextPageKey: nextPageKey,
      error: error,
    );
  }

  Loading<Key, Value> loading<Key, Value>() {
    return Loading<Key, Value>();
  }

  Error<Key, Value> error<Key, Value>(StreamChatError error) {
    return Error<Key, Value>(
      error,
    );
  }
}

/// @nodoc
const $PagedValue = _$PagedValueTearOff();

/// @nodoc
mixin _$PagedValue<Key, Value> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Value> items, Key? nextPageKey, StreamChatError? error)
        $default, {
    required TResult Function() loading,
    required TResult Function(StreamChatError error) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(
            List<Value> items, Key? nextPageKey, StreamChatError? error)?
        $default, {
    TResult Function()? loading,
    TResult Function(StreamChatError error)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Value> items, Key? nextPageKey, StreamChatError? error)?
        $default, {
    TResult Function()? loading,
    TResult Function(StreamChatError error)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Success<Key, Value> value) $default, {
    required TResult Function(Loading<Key, Value> value) loading,
    required TResult Function(Error<Key, Value> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Success<Key, Value> value)? $default, {
    TResult Function(Loading<Key, Value> value)? loading,
    TResult Function(Error<Key, Value> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Success<Key, Value> value)? $default, {
    TResult Function(Loading<Key, Value> value)? loading,
    TResult Function(Error<Key, Value> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PagedValueCopyWith<Key, Value, $Res> {
  factory $PagedValueCopyWith(PagedValue<Key, Value> value,
          $Res Function(PagedValue<Key, Value>) then) =
      _$PagedValueCopyWithImpl<Key, Value, $Res>;
}

/// @nodoc
class _$PagedValueCopyWithImpl<Key, Value, $Res>
    implements $PagedValueCopyWith<Key, Value, $Res> {
  _$PagedValueCopyWithImpl(this._value, this._then);

  final PagedValue<Key, Value> _value;
  // ignore: unused_field
  final $Res Function(PagedValue<Key, Value>) _then;
}

/// @nodoc
abstract class $SuccessCopyWith<Key, Value, $Res> {
  factory $SuccessCopyWith(
          Success<Key, Value> value, $Res Function(Success<Key, Value>) then) =
      _$SuccessCopyWithImpl<Key, Value, $Res>;
  $Res call({List<Value> items, Key? nextPageKey, StreamChatError? error});
}

/// @nodoc
class _$SuccessCopyWithImpl<Key, Value, $Res>
    extends _$PagedValueCopyWithImpl<Key, Value, $Res>
    implements $SuccessCopyWith<Key, Value, $Res> {
  _$SuccessCopyWithImpl(
      Success<Key, Value> _value, $Res Function(Success<Key, Value>) _then)
      : super(_value, (v) => _then(v as Success<Key, Value>));

  @override
  Success<Key, Value> get _value => super._value as Success<Key, Value>;

  @override
  $Res call({
    Object? items = freezed,
    Object? nextPageKey = freezed,
    Object? error = freezed,
  }) {
    return _then(Success<Key, Value>(
      items: items == freezed
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Value>,
      nextPageKey: nextPageKey == freezed
          ? _value.nextPageKey
          : nextPageKey // ignore: cast_nullable_to_non_nullable
              as Key?,
      error: error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as StreamChatError?,
    ));
  }
}

/// @nodoc

class _$Success<Key, Value> extends Success<Key, Value>
    with DiagnosticableTreeMixin {
  const _$Success({required this.items, this.nextPageKey, this.error})
      : super._();

  @override

  /// List with all items loaded so far.
  final List<Value> items;
  @override

  /// The key for the next page to be fetched.
  final Key? nextPageKey;
  @override

  /// The current error, if any.
  final StreamChatError? error;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PagedValue<$Key, $Value>(items: $items, nextPageKey: $nextPageKey, error: $error)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PagedValue<$Key, $Value>'))
      ..add(DiagnosticsProperty('items', items))
      ..add(DiagnosticsProperty('nextPageKey', nextPageKey))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Success<Key, Value> &&
            (identical(other.items, items) ||
                const DeepCollectionEquality().equals(other.items, items)) &&
            (identical(other.nextPageKey, nextPageKey) ||
                const DeepCollectionEquality()
                    .equals(other.nextPageKey, nextPageKey)) &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(items) ^
      const DeepCollectionEquality().hash(nextPageKey) ^
      const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  $SuccessCopyWith<Key, Value, Success<Key, Value>> get copyWith =>
      _$SuccessCopyWithImpl<Key, Value, Success<Key, Value>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Value> items, Key? nextPageKey, StreamChatError? error)
        $default, {
    required TResult Function() loading,
    required TResult Function(StreamChatError error) error,
  }) {
    return $default(items, nextPageKey, this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(
            List<Value> items, Key? nextPageKey, StreamChatError? error)?
        $default, {
    TResult Function()? loading,
    TResult Function(StreamChatError error)? error,
  }) {
    return $default?.call(items, nextPageKey, this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Value> items, Key? nextPageKey, StreamChatError? error)?
        $default, {
    TResult Function()? loading,
    TResult Function(StreamChatError error)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(items, nextPageKey, this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Success<Key, Value> value) $default, {
    required TResult Function(Loading<Key, Value> value) loading,
    required TResult Function(Error<Key, Value> value) error,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Success<Key, Value> value)? $default, {
    TResult Function(Loading<Key, Value> value)? loading,
    TResult Function(Error<Key, Value> value)? error,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Success<Key, Value> value)? $default, {
    TResult Function(Loading<Key, Value> value)? loading,
    TResult Function(Error<Key, Value> value)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class Success<Key, Value> extends PagedValue<Key, Value> {
  const factory Success(
      {required List<Value> items,
      Key? nextPageKey,
      StreamChatError? error}) = _$Success<Key, Value>;
  const Success._() : super._();

  /// List with all items loaded so far.
  List<Value> get items => throw _privateConstructorUsedError;

  /// The key for the next page to be fetched.
  Key? get nextPageKey => throw _privateConstructorUsedError;

  /// The current error, if any.
  StreamChatError? get error => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SuccessCopyWith<Key, Value, Success<Key, Value>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoadingCopyWith<Key, Value, $Res> {
  factory $LoadingCopyWith(
          Loading<Key, Value> value, $Res Function(Loading<Key, Value>) then) =
      _$LoadingCopyWithImpl<Key, Value, $Res>;
}

/// @nodoc
class _$LoadingCopyWithImpl<Key, Value, $Res>
    extends _$PagedValueCopyWithImpl<Key, Value, $Res>
    implements $LoadingCopyWith<Key, Value, $Res> {
  _$LoadingCopyWithImpl(
      Loading<Key, Value> _value, $Res Function(Loading<Key, Value>) _then)
      : super(_value, (v) => _then(v as Loading<Key, Value>));

  @override
  Loading<Key, Value> get _value => super._value as Loading<Key, Value>;
}

/// @nodoc

class _$Loading<Key, Value> extends Loading<Key, Value>
    with DiagnosticableTreeMixin {
  const _$Loading() : super._();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PagedValue<$Key, $Value>.loading()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PagedValue<$Key, $Value>.loading'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Loading<Key, Value>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Value> items, Key? nextPageKey, StreamChatError? error)
        $default, {
    required TResult Function() loading,
    required TResult Function(StreamChatError error) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(
            List<Value> items, Key? nextPageKey, StreamChatError? error)?
        $default, {
    TResult Function()? loading,
    TResult Function(StreamChatError error)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Value> items, Key? nextPageKey, StreamChatError? error)?
        $default, {
    TResult Function()? loading,
    TResult Function(StreamChatError error)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Success<Key, Value> value) $default, {
    required TResult Function(Loading<Key, Value> value) loading,
    required TResult Function(Error<Key, Value> value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Success<Key, Value> value)? $default, {
    TResult Function(Loading<Key, Value> value)? loading,
    TResult Function(Error<Key, Value> value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Success<Key, Value> value)? $default, {
    TResult Function(Loading<Key, Value> value)? loading,
    TResult Function(Error<Key, Value> value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading<Key, Value> extends PagedValue<Key, Value> {
  const factory Loading() = _$Loading<Key, Value>;
  const Loading._() : super._();
}

/// @nodoc
abstract class $ErrorCopyWith<Key, Value, $Res> {
  factory $ErrorCopyWith(
          Error<Key, Value> value, $Res Function(Error<Key, Value>) then) =
      _$ErrorCopyWithImpl<Key, Value, $Res>;
  $Res call({StreamChatError error});
}

/// @nodoc
class _$ErrorCopyWithImpl<Key, Value, $Res>
    extends _$PagedValueCopyWithImpl<Key, Value, $Res>
    implements $ErrorCopyWith<Key, Value, $Res> {
  _$ErrorCopyWithImpl(
      Error<Key, Value> _value, $Res Function(Error<Key, Value>) _then)
      : super(_value, (v) => _then(v as Error<Key, Value>));

  @override
  Error<Key, Value> get _value => super._value as Error<Key, Value>;

  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(Error<Key, Value>(
      error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as StreamChatError,
    ));
  }
}

/// @nodoc

class _$Error<Key, Value> extends Error<Key, Value>
    with DiagnosticableTreeMixin {
  const _$Error(this.error) : super._();

  @override
  final StreamChatError error;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PagedValue<$Key, $Value>.error(error: $error)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PagedValue<$Key, $Value>.error'))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Error<Key, Value> &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  $ErrorCopyWith<Key, Value, Error<Key, Value>> get copyWith =>
      _$ErrorCopyWithImpl<Key, Value, Error<Key, Value>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            List<Value> items, Key? nextPageKey, StreamChatError? error)
        $default, {
    required TResult Function() loading,
    required TResult Function(StreamChatError error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(
            List<Value> items, Key? nextPageKey, StreamChatError? error)?
        $default, {
    TResult Function()? loading,
    TResult Function(StreamChatError error)? error,
  }) {
    return error?.call(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            List<Value> items, Key? nextPageKey, StreamChatError? error)?
        $default, {
    TResult Function()? loading,
    TResult Function(StreamChatError error)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(Success<Key, Value> value) $default, {
    required TResult Function(Loading<Key, Value> value) loading,
    required TResult Function(Error<Key, Value> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(Success<Key, Value> value)? $default, {
    TResult Function(Loading<Key, Value> value)? loading,
    TResult Function(Error<Key, Value> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(Success<Key, Value> value)? $default, {
    TResult Function(Loading<Key, Value> value)? loading,
    TResult Function(Error<Key, Value> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error<Key, Value> extends PagedValue<Key, Value> {
  const factory Error(StreamChatError error) = _$Error<Key, Value>;
  const Error._() : super._();

  StreamChatError get error => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ErrorCopyWith<Key, Value, Error<Key, Value>> get copyWith =>
      throw _privateConstructorUsedError;
}
