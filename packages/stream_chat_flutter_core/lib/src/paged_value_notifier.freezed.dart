// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paged_value_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PagedValue<Key, Value> implements DiagnosticableTreeMixin {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties..add(DiagnosticsProperty('type', 'PagedValue<$Key, $Value>'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PagedValue<Key, Value>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PagedValue<$Key, $Value>()';
  }
}

/// @nodoc
class $PagedValueCopyWith<Key, Value, $Res> {
  $PagedValueCopyWith(
      PagedValue<Key, Value> _, $Res Function(PagedValue<Key, Value>) __);
}

/// @nodoc

class Success<Key, Value> extends PagedValue<Key, Value>
    with DiagnosticableTreeMixin {
  const Success(
      {required final List<Value> items, this.nextPageKey, this.error})
      : _items = items,
        super._();

  /// List with all items loaded so far.
  final List<Value> _items;

  /// List with all items loaded so far.
  List<Value> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// The key for the next page to be fetched.
  final Key? nextPageKey;

  /// The current error, if any.
  final StreamChatError? error;

  /// Create a copy of PagedValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SuccessCopyWith<Key, Value, Success<Key, Value>> get copyWith =>
      _$SuccessCopyWithImpl<Key, Value, Success<Key, Value>>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'PagedValue<$Key, $Value>'))
      ..add(DiagnosticsProperty('items', items))
      ..add(DiagnosticsProperty('nextPageKey', nextPageKey))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Success<Key, Value> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other.nextPageKey, nextPageKey) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(nextPageKey),
      error);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PagedValue<$Key, $Value>(items: $items, nextPageKey: $nextPageKey, error: $error)';
  }
}

/// @nodoc
abstract mixin class $SuccessCopyWith<Key, Value, $Res>
    implements $PagedValueCopyWith<Key, Value, $Res> {
  factory $SuccessCopyWith(
          Success<Key, Value> value, $Res Function(Success<Key, Value>) _then) =
      _$SuccessCopyWithImpl;
  @useResult
  $Res call({List<Value> items, Key? nextPageKey, StreamChatError? error});
}

/// @nodoc
class _$SuccessCopyWithImpl<Key, Value, $Res>
    implements $SuccessCopyWith<Key, Value, $Res> {
  _$SuccessCopyWithImpl(this._self, this._then);

  final Success<Key, Value> _self;
  final $Res Function(Success<Key, Value>) _then;

  /// Create a copy of PagedValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextPageKey = freezed,
    Object? error = freezed,
  }) {
    return _then(Success<Key, Value>(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Value>,
      nextPageKey: freezed == nextPageKey
          ? _self.nextPageKey
          : nextPageKey // ignore: cast_nullable_to_non_nullable
              as Key?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as StreamChatError?,
    ));
  }
}

/// @nodoc

class Loading<Key, Value> extends PagedValue<Key, Value>
    with DiagnosticableTreeMixin {
  const Loading() : super._();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'PagedValue<$Key, $Value>.loading'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Loading<Key, Value>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PagedValue<$Key, $Value>.loading()';
  }
}

/// @nodoc

class Error<Key, Value> extends PagedValue<Key, Value>
    with DiagnosticableTreeMixin {
  const Error(this.error) : super._();

  final StreamChatError error;

  /// Create a copy of PagedValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ErrorCopyWith<Key, Value, Error<Key, Value>> get copyWith =>
      _$ErrorCopyWithImpl<Key, Value, Error<Key, Value>>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'PagedValue<$Key, $Value>.error'))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Error<Key, Value> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PagedValue<$Key, $Value>.error(error: $error)';
  }
}

/// @nodoc
abstract mixin class $ErrorCopyWith<Key, Value, $Res>
    implements $PagedValueCopyWith<Key, Value, $Res> {
  factory $ErrorCopyWith(
          Error<Key, Value> value, $Res Function(Error<Key, Value>) _then) =
      _$ErrorCopyWithImpl;
  @useResult
  $Res call({StreamChatError error});
}

/// @nodoc
class _$ErrorCopyWithImpl<Key, Value, $Res>
    implements $ErrorCopyWith<Key, Value, $Res> {
  _$ErrorCopyWithImpl(this._self, this._then);

  final Error<Key, Value> _self;
  final $Res Function(Error<Key, Value>) _then;

  /// Create a copy of PagedValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? error = null,
  }) {
    return _then(Error<Key, Value>(
      null == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as StreamChatError,
    ));
  }
}

// dart format on
