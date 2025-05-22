// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageState _$MessageStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'initial':
      return MessageInitial.fromJson(json);
    case 'outgoing':
      return MessageOutgoing.fromJson(json);
    case 'completed':
      return MessageCompleted.fromJson(json);
    case 'failed':
      return MessageFailed.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'MessageState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$MessageState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(OutgoingState state) outgoing,
    required TResult Function(CompletedState state) completed,
    required TResult Function(FailedState state, Object? reason) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(OutgoingState state)? outgoing,
    TResult? Function(CompletedState state)? completed,
    TResult? Function(FailedState state, Object? reason)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(OutgoingState state)? outgoing,
    TResult Function(CompletedState state)? completed,
    TResult Function(FailedState state, Object? reason)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageInitial value) initial,
    required TResult Function(MessageOutgoing value) outgoing,
    required TResult Function(MessageCompleted value) completed,
    required TResult Function(MessageFailed value) failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageInitial value)? initial,
    TResult? Function(MessageOutgoing value)? outgoing,
    TResult? Function(MessageCompleted value)? completed,
    TResult? Function(MessageFailed value)? failed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageInitial value)? initial,
    TResult Function(MessageOutgoing value)? outgoing,
    TResult Function(MessageCompleted value)? completed,
    TResult Function(MessageFailed value)? failed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this MessageState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageStateCopyWith<$Res> {
  factory $MessageStateCopyWith(
          MessageState value, $Res Function(MessageState) then) =
      _$MessageStateCopyWithImpl<$Res, MessageState>;
}

/// @nodoc
class _$MessageStateCopyWithImpl<$Res, $Val extends MessageState>
    implements $MessageStateCopyWith<$Res> {
  _$MessageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$MessageInitialImplCopyWith<$Res> {
  factory _$$MessageInitialImplCopyWith(_$MessageInitialImpl value,
          $Res Function(_$MessageInitialImpl) then) =
      __$$MessageInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MessageInitialImplCopyWithImpl<$Res>
    extends _$MessageStateCopyWithImpl<$Res, _$MessageInitialImpl>
    implements _$$MessageInitialImplCopyWith<$Res> {
  __$$MessageInitialImplCopyWithImpl(
      _$MessageInitialImpl _value, $Res Function(_$MessageInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$MessageInitialImpl implements MessageInitial {
  const _$MessageInitialImpl({final String? $type})
      : $type = $type ?? 'initial';

  factory _$MessageInitialImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageInitialImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MessageState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$MessageInitialImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(OutgoingState state) outgoing,
    required TResult Function(CompletedState state) completed,
    required TResult Function(FailedState state, Object? reason) failed,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(OutgoingState state)? outgoing,
    TResult? Function(CompletedState state)? completed,
    TResult? Function(FailedState state, Object? reason)? failed,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(OutgoingState state)? outgoing,
    TResult Function(CompletedState state)? completed,
    TResult Function(FailedState state, Object? reason)? failed,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageInitial value) initial,
    required TResult Function(MessageOutgoing value) outgoing,
    required TResult Function(MessageCompleted value) completed,
    required TResult Function(MessageFailed value) failed,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageInitial value)? initial,
    TResult? Function(MessageOutgoing value)? outgoing,
    TResult? Function(MessageCompleted value)? completed,
    TResult? Function(MessageFailed value)? failed,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageInitial value)? initial,
    TResult Function(MessageOutgoing value)? outgoing,
    TResult Function(MessageCompleted value)? completed,
    TResult Function(MessageFailed value)? failed,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageInitialImplToJson(
      this,
    );
  }
}

abstract class MessageInitial implements MessageState {
  const factory MessageInitial() = _$MessageInitialImpl;

  factory MessageInitial.fromJson(Map<String, dynamic> json) =
      _$MessageInitialImpl.fromJson;
}

/// @nodoc
abstract class _$$MessageOutgoingImplCopyWith<$Res> {
  factory _$$MessageOutgoingImplCopyWith(_$MessageOutgoingImpl value,
          $Res Function(_$MessageOutgoingImpl) then) =
      __$$MessageOutgoingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({OutgoingState state});

  $OutgoingStateCopyWith<$Res> get state;
}

/// @nodoc
class __$$MessageOutgoingImplCopyWithImpl<$Res>
    extends _$MessageStateCopyWithImpl<$Res, _$MessageOutgoingImpl>
    implements _$$MessageOutgoingImplCopyWith<$Res> {
  __$$MessageOutgoingImplCopyWithImpl(
      _$MessageOutgoingImpl _value, $Res Function(_$MessageOutgoingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
  }) {
    return _then(_$MessageOutgoingImpl(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as OutgoingState,
    ));
  }

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OutgoingStateCopyWith<$Res> get state {
    return $OutgoingStateCopyWith<$Res>(_value.state, (value) {
      return _then(_value.copyWith(state: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageOutgoingImpl implements MessageOutgoing {
  const _$MessageOutgoingImpl({required this.state, final String? $type})
      : $type = $type ?? 'outgoing';

  factory _$MessageOutgoingImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageOutgoingImplFromJson(json);

  @override
  final OutgoingState state;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MessageState.outgoing(state: $state)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageOutgoingImpl &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, state);

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageOutgoingImplCopyWith<_$MessageOutgoingImpl> get copyWith =>
      __$$MessageOutgoingImplCopyWithImpl<_$MessageOutgoingImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(OutgoingState state) outgoing,
    required TResult Function(CompletedState state) completed,
    required TResult Function(FailedState state, Object? reason) failed,
  }) {
    return outgoing(state);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(OutgoingState state)? outgoing,
    TResult? Function(CompletedState state)? completed,
    TResult? Function(FailedState state, Object? reason)? failed,
  }) {
    return outgoing?.call(state);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(OutgoingState state)? outgoing,
    TResult Function(CompletedState state)? completed,
    TResult Function(FailedState state, Object? reason)? failed,
    required TResult orElse(),
  }) {
    if (outgoing != null) {
      return outgoing(state);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageInitial value) initial,
    required TResult Function(MessageOutgoing value) outgoing,
    required TResult Function(MessageCompleted value) completed,
    required TResult Function(MessageFailed value) failed,
  }) {
    return outgoing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageInitial value)? initial,
    TResult? Function(MessageOutgoing value)? outgoing,
    TResult? Function(MessageCompleted value)? completed,
    TResult? Function(MessageFailed value)? failed,
  }) {
    return outgoing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageInitial value)? initial,
    TResult Function(MessageOutgoing value)? outgoing,
    TResult Function(MessageCompleted value)? completed,
    TResult Function(MessageFailed value)? failed,
    required TResult orElse(),
  }) {
    if (outgoing != null) {
      return outgoing(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageOutgoingImplToJson(
      this,
    );
  }
}

abstract class MessageOutgoing implements MessageState {
  const factory MessageOutgoing({required final OutgoingState state}) =
      _$MessageOutgoingImpl;

  factory MessageOutgoing.fromJson(Map<String, dynamic> json) =
      _$MessageOutgoingImpl.fromJson;

  OutgoingState get state;

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageOutgoingImplCopyWith<_$MessageOutgoingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MessageCompletedImplCopyWith<$Res> {
  factory _$$MessageCompletedImplCopyWith(_$MessageCompletedImpl value,
          $Res Function(_$MessageCompletedImpl) then) =
      __$$MessageCompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({CompletedState state});

  $CompletedStateCopyWith<$Res> get state;
}

/// @nodoc
class __$$MessageCompletedImplCopyWithImpl<$Res>
    extends _$MessageStateCopyWithImpl<$Res, _$MessageCompletedImpl>
    implements _$$MessageCompletedImplCopyWith<$Res> {
  __$$MessageCompletedImplCopyWithImpl(_$MessageCompletedImpl _value,
      $Res Function(_$MessageCompletedImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
  }) {
    return _then(_$MessageCompletedImpl(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as CompletedState,
    ));
  }

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompletedStateCopyWith<$Res> get state {
    return $CompletedStateCopyWith<$Res>(_value.state, (value) {
      return _then(_value.copyWith(state: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageCompletedImpl implements MessageCompleted {
  const _$MessageCompletedImpl({required this.state, final String? $type})
      : $type = $type ?? 'completed';

  factory _$MessageCompletedImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageCompletedImplFromJson(json);

  @override
  final CompletedState state;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MessageState.completed(state: $state)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageCompletedImpl &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, state);

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageCompletedImplCopyWith<_$MessageCompletedImpl> get copyWith =>
      __$$MessageCompletedImplCopyWithImpl<_$MessageCompletedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(OutgoingState state) outgoing,
    required TResult Function(CompletedState state) completed,
    required TResult Function(FailedState state, Object? reason) failed,
  }) {
    return completed(state);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(OutgoingState state)? outgoing,
    TResult? Function(CompletedState state)? completed,
    TResult? Function(FailedState state, Object? reason)? failed,
  }) {
    return completed?.call(state);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(OutgoingState state)? outgoing,
    TResult Function(CompletedState state)? completed,
    TResult Function(FailedState state, Object? reason)? failed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(state);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageInitial value) initial,
    required TResult Function(MessageOutgoing value) outgoing,
    required TResult Function(MessageCompleted value) completed,
    required TResult Function(MessageFailed value) failed,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageInitial value)? initial,
    TResult? Function(MessageOutgoing value)? outgoing,
    TResult? Function(MessageCompleted value)? completed,
    TResult? Function(MessageFailed value)? failed,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageInitial value)? initial,
    TResult Function(MessageOutgoing value)? outgoing,
    TResult Function(MessageCompleted value)? completed,
    TResult Function(MessageFailed value)? failed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageCompletedImplToJson(
      this,
    );
  }
}

abstract class MessageCompleted implements MessageState {
  const factory MessageCompleted({required final CompletedState state}) =
      _$MessageCompletedImpl;

  factory MessageCompleted.fromJson(Map<String, dynamic> json) =
      _$MessageCompletedImpl.fromJson;

  CompletedState get state;

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageCompletedImplCopyWith<_$MessageCompletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MessageFailedImplCopyWith<$Res> {
  factory _$$MessageFailedImplCopyWith(
          _$MessageFailedImpl value, $Res Function(_$MessageFailedImpl) then) =
      __$$MessageFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({FailedState state, Object? reason});

  $FailedStateCopyWith<$Res> get state;
}

/// @nodoc
class __$$MessageFailedImplCopyWithImpl<$Res>
    extends _$MessageStateCopyWithImpl<$Res, _$MessageFailedImpl>
    implements _$$MessageFailedImplCopyWith<$Res> {
  __$$MessageFailedImplCopyWithImpl(
      _$MessageFailedImpl _value, $Res Function(_$MessageFailedImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? reason = freezed,
  }) {
    return _then(_$MessageFailedImpl(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as FailedState,
      reason: freezed == reason ? _value.reason : reason,
    ));
  }

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FailedStateCopyWith<$Res> get state {
    return $FailedStateCopyWith<$Res>(_value.state, (value) {
      return _then(_value.copyWith(state: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageFailedImpl implements MessageFailed {
  const _$MessageFailedImpl(
      {required this.state, this.reason, final String? $type})
      : $type = $type ?? 'failed';

  factory _$MessageFailedImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageFailedImplFromJson(json);

  @override
  final FailedState state;
  @override
  final Object? reason;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MessageState.failed(state: $state, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageFailedImpl &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other.reason, reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, state, const DeepCollectionEquality().hash(reason));

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageFailedImplCopyWith<_$MessageFailedImpl> get copyWith =>
      __$$MessageFailedImplCopyWithImpl<_$MessageFailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(OutgoingState state) outgoing,
    required TResult Function(CompletedState state) completed,
    required TResult Function(FailedState state, Object? reason) failed,
  }) {
    return failed(state, reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(OutgoingState state)? outgoing,
    TResult? Function(CompletedState state)? completed,
    TResult? Function(FailedState state, Object? reason)? failed,
  }) {
    return failed?.call(state, reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(OutgoingState state)? outgoing,
    TResult Function(CompletedState state)? completed,
    TResult Function(FailedState state, Object? reason)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(state, reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageInitial value) initial,
    required TResult Function(MessageOutgoing value) outgoing,
    required TResult Function(MessageCompleted value) completed,
    required TResult Function(MessageFailed value) failed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageInitial value)? initial,
    TResult? Function(MessageOutgoing value)? outgoing,
    TResult? Function(MessageCompleted value)? completed,
    TResult? Function(MessageFailed value)? failed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageInitial value)? initial,
    TResult Function(MessageOutgoing value)? outgoing,
    TResult Function(MessageCompleted value)? completed,
    TResult Function(MessageFailed value)? failed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageFailedImplToJson(
      this,
    );
  }
}

abstract class MessageFailed implements MessageState {
  const factory MessageFailed(
      {required final FailedState state,
      final Object? reason}) = _$MessageFailedImpl;

  factory MessageFailed.fromJson(Map<String, dynamic> json) =
      _$MessageFailedImpl.fromJson;

  FailedState get state;
  Object? get reason;

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageFailedImplCopyWith<_$MessageFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OutgoingState _$OutgoingStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'sending':
      return Sending.fromJson(json);
    case 'updating':
      return Updating.fromJson(json);
    case 'deleting':
      return Deleting.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'OutgoingState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$OutgoingState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sending,
    required TResult Function() updating,
    required TResult Function(bool hard) deleting,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sending,
    TResult? Function()? updating,
    TResult? Function(bool hard)? deleting,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sending,
    TResult Function()? updating,
    TResult Function(bool hard)? deleting,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Sending value) sending,
    required TResult Function(Updating value) updating,
    required TResult Function(Deleting value) deleting,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Sending value)? sending,
    TResult? Function(Updating value)? updating,
    TResult? Function(Deleting value)? deleting,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Sending value)? sending,
    TResult Function(Updating value)? updating,
    TResult Function(Deleting value)? deleting,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this OutgoingState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OutgoingStateCopyWith<$Res> {
  factory $OutgoingStateCopyWith(
          OutgoingState value, $Res Function(OutgoingState) then) =
      _$OutgoingStateCopyWithImpl<$Res, OutgoingState>;
}

/// @nodoc
class _$OutgoingStateCopyWithImpl<$Res, $Val extends OutgoingState>
    implements $OutgoingStateCopyWith<$Res> {
  _$OutgoingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OutgoingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SendingImplCopyWith<$Res> {
  factory _$$SendingImplCopyWith(
          _$SendingImpl value, $Res Function(_$SendingImpl) then) =
      __$$SendingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SendingImplCopyWithImpl<$Res>
    extends _$OutgoingStateCopyWithImpl<$Res, _$SendingImpl>
    implements _$$SendingImplCopyWith<$Res> {
  __$$SendingImplCopyWithImpl(
      _$SendingImpl _value, $Res Function(_$SendingImpl) _then)
      : super(_value, _then);

  /// Create a copy of OutgoingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$SendingImpl implements Sending {
  const _$SendingImpl({final String? $type}) : $type = $type ?? 'sending';

  factory _$SendingImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendingImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'OutgoingState.sending()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SendingImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sending,
    required TResult Function() updating,
    required TResult Function(bool hard) deleting,
  }) {
    return sending();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sending,
    TResult? Function()? updating,
    TResult? Function(bool hard)? deleting,
  }) {
    return sending?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sending,
    TResult Function()? updating,
    TResult Function(bool hard)? deleting,
    required TResult orElse(),
  }) {
    if (sending != null) {
      return sending();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Sending value) sending,
    required TResult Function(Updating value) updating,
    required TResult Function(Deleting value) deleting,
  }) {
    return sending(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Sending value)? sending,
    TResult? Function(Updating value)? updating,
    TResult? Function(Deleting value)? deleting,
  }) {
    return sending?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Sending value)? sending,
    TResult Function(Updating value)? updating,
    TResult Function(Deleting value)? deleting,
    required TResult orElse(),
  }) {
    if (sending != null) {
      return sending(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SendingImplToJson(
      this,
    );
  }
}

abstract class Sending implements OutgoingState {
  const factory Sending() = _$SendingImpl;

  factory Sending.fromJson(Map<String, dynamic> json) = _$SendingImpl.fromJson;
}

/// @nodoc
abstract class _$$UpdatingImplCopyWith<$Res> {
  factory _$$UpdatingImplCopyWith(
          _$UpdatingImpl value, $Res Function(_$UpdatingImpl) then) =
      __$$UpdatingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UpdatingImplCopyWithImpl<$Res>
    extends _$OutgoingStateCopyWithImpl<$Res, _$UpdatingImpl>
    implements _$$UpdatingImplCopyWith<$Res> {
  __$$UpdatingImplCopyWithImpl(
      _$UpdatingImpl _value, $Res Function(_$UpdatingImpl) _then)
      : super(_value, _then);

  /// Create a copy of OutgoingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$UpdatingImpl implements Updating {
  const _$UpdatingImpl({final String? $type}) : $type = $type ?? 'updating';

  factory _$UpdatingImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdatingImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'OutgoingState.updating()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UpdatingImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sending,
    required TResult Function() updating,
    required TResult Function(bool hard) deleting,
  }) {
    return updating();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sending,
    TResult? Function()? updating,
    TResult? Function(bool hard)? deleting,
  }) {
    return updating?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sending,
    TResult Function()? updating,
    TResult Function(bool hard)? deleting,
    required TResult orElse(),
  }) {
    if (updating != null) {
      return updating();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Sending value) sending,
    required TResult Function(Updating value) updating,
    required TResult Function(Deleting value) deleting,
  }) {
    return updating(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Sending value)? sending,
    TResult? Function(Updating value)? updating,
    TResult? Function(Deleting value)? deleting,
  }) {
    return updating?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Sending value)? sending,
    TResult Function(Updating value)? updating,
    TResult Function(Deleting value)? deleting,
    required TResult orElse(),
  }) {
    if (updating != null) {
      return updating(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdatingImplToJson(
      this,
    );
  }
}

abstract class Updating implements OutgoingState {
  const factory Updating() = _$UpdatingImpl;

  factory Updating.fromJson(Map<String, dynamic> json) =
      _$UpdatingImpl.fromJson;
}

/// @nodoc
abstract class _$$DeletingImplCopyWith<$Res> {
  factory _$$DeletingImplCopyWith(
          _$DeletingImpl value, $Res Function(_$DeletingImpl) then) =
      __$$DeletingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool hard});
}

/// @nodoc
class __$$DeletingImplCopyWithImpl<$Res>
    extends _$OutgoingStateCopyWithImpl<$Res, _$DeletingImpl>
    implements _$$DeletingImplCopyWith<$Res> {
  __$$DeletingImplCopyWithImpl(
      _$DeletingImpl _value, $Res Function(_$DeletingImpl) _then)
      : super(_value, _then);

  /// Create a copy of OutgoingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hard = null,
  }) {
    return _then(_$DeletingImpl(
      hard: null == hard
          ? _value.hard
          : hard // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeletingImpl implements Deleting {
  const _$DeletingImpl({this.hard = false, final String? $type})
      : $type = $type ?? 'deleting';

  factory _$DeletingImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeletingImplFromJson(json);

  @override
  @JsonKey()
  final bool hard;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'OutgoingState.deleting(hard: $hard)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeletingImpl &&
            (identical(other.hard, hard) || other.hard == hard));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hard);

  /// Create a copy of OutgoingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeletingImplCopyWith<_$DeletingImpl> get copyWith =>
      __$$DeletingImplCopyWithImpl<_$DeletingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sending,
    required TResult Function() updating,
    required TResult Function(bool hard) deleting,
  }) {
    return deleting(hard);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sending,
    TResult? Function()? updating,
    TResult? Function(bool hard)? deleting,
  }) {
    return deleting?.call(hard);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sending,
    TResult Function()? updating,
    TResult Function(bool hard)? deleting,
    required TResult orElse(),
  }) {
    if (deleting != null) {
      return deleting(hard);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Sending value) sending,
    required TResult Function(Updating value) updating,
    required TResult Function(Deleting value) deleting,
  }) {
    return deleting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Sending value)? sending,
    TResult? Function(Updating value)? updating,
    TResult? Function(Deleting value)? deleting,
  }) {
    return deleting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Sending value)? sending,
    TResult Function(Updating value)? updating,
    TResult Function(Deleting value)? deleting,
    required TResult orElse(),
  }) {
    if (deleting != null) {
      return deleting(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DeletingImplToJson(
      this,
    );
  }
}

abstract class Deleting implements OutgoingState {
  const factory Deleting({final bool hard}) = _$DeletingImpl;

  factory Deleting.fromJson(Map<String, dynamic> json) =
      _$DeletingImpl.fromJson;

  bool get hard;

  /// Create a copy of OutgoingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeletingImplCopyWith<_$DeletingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompletedState _$CompletedStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'sent':
      return Sent.fromJson(json);
    case 'updated':
      return Updated.fromJson(json);
    case 'deleted':
      return Deleted.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'CompletedState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$CompletedState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sent,
    required TResult Function() updated,
    required TResult Function(bool hard) deleted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sent,
    TResult? Function()? updated,
    TResult? Function(bool hard)? deleted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sent,
    TResult Function()? updated,
    TResult Function(bool hard)? deleted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Sent value) sent,
    required TResult Function(Updated value) updated,
    required TResult Function(Deleted value) deleted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Sent value)? sent,
    TResult? Function(Updated value)? updated,
    TResult? Function(Deleted value)? deleted,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Sent value)? sent,
    TResult Function(Updated value)? updated,
    TResult Function(Deleted value)? deleted,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this CompletedState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompletedStateCopyWith<$Res> {
  factory $CompletedStateCopyWith(
          CompletedState value, $Res Function(CompletedState) then) =
      _$CompletedStateCopyWithImpl<$Res, CompletedState>;
}

/// @nodoc
class _$CompletedStateCopyWithImpl<$Res, $Val extends CompletedState>
    implements $CompletedStateCopyWith<$Res> {
  _$CompletedStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompletedState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SentImplCopyWith<$Res> {
  factory _$$SentImplCopyWith(
          _$SentImpl value, $Res Function(_$SentImpl) then) =
      __$$SentImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SentImplCopyWithImpl<$Res>
    extends _$CompletedStateCopyWithImpl<$Res, _$SentImpl>
    implements _$$SentImplCopyWith<$Res> {
  __$$SentImplCopyWithImpl(_$SentImpl _value, $Res Function(_$SentImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompletedState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$SentImpl implements Sent {
  const _$SentImpl({final String? $type}) : $type = $type ?? 'sent';

  factory _$SentImpl.fromJson(Map<String, dynamic> json) =>
      _$$SentImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'CompletedState.sent()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SentImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sent,
    required TResult Function() updated,
    required TResult Function(bool hard) deleted,
  }) {
    return sent();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sent,
    TResult? Function()? updated,
    TResult? Function(bool hard)? deleted,
  }) {
    return sent?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sent,
    TResult Function()? updated,
    TResult Function(bool hard)? deleted,
    required TResult orElse(),
  }) {
    if (sent != null) {
      return sent();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Sent value) sent,
    required TResult Function(Updated value) updated,
    required TResult Function(Deleted value) deleted,
  }) {
    return sent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Sent value)? sent,
    TResult? Function(Updated value)? updated,
    TResult? Function(Deleted value)? deleted,
  }) {
    return sent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Sent value)? sent,
    TResult Function(Updated value)? updated,
    TResult Function(Deleted value)? deleted,
    required TResult orElse(),
  }) {
    if (sent != null) {
      return sent(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SentImplToJson(
      this,
    );
  }
}

abstract class Sent implements CompletedState {
  const factory Sent() = _$SentImpl;

  factory Sent.fromJson(Map<String, dynamic> json) = _$SentImpl.fromJson;
}

/// @nodoc
abstract class _$$UpdatedImplCopyWith<$Res> {
  factory _$$UpdatedImplCopyWith(
          _$UpdatedImpl value, $Res Function(_$UpdatedImpl) then) =
      __$$UpdatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UpdatedImplCopyWithImpl<$Res>
    extends _$CompletedStateCopyWithImpl<$Res, _$UpdatedImpl>
    implements _$$UpdatedImplCopyWith<$Res> {
  __$$UpdatedImplCopyWithImpl(
      _$UpdatedImpl _value, $Res Function(_$UpdatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompletedState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$UpdatedImpl implements Updated {
  const _$UpdatedImpl({final String? $type}) : $type = $type ?? 'updated';

  factory _$UpdatedImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdatedImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'CompletedState.updated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UpdatedImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sent,
    required TResult Function() updated,
    required TResult Function(bool hard) deleted,
  }) {
    return updated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sent,
    TResult? Function()? updated,
    TResult? Function(bool hard)? deleted,
  }) {
    return updated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sent,
    TResult Function()? updated,
    TResult Function(bool hard)? deleted,
    required TResult orElse(),
  }) {
    if (updated != null) {
      return updated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Sent value) sent,
    required TResult Function(Updated value) updated,
    required TResult Function(Deleted value) deleted,
  }) {
    return updated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Sent value)? sent,
    TResult? Function(Updated value)? updated,
    TResult? Function(Deleted value)? deleted,
  }) {
    return updated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Sent value)? sent,
    TResult Function(Updated value)? updated,
    TResult Function(Deleted value)? deleted,
    required TResult orElse(),
  }) {
    if (updated != null) {
      return updated(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdatedImplToJson(
      this,
    );
  }
}

abstract class Updated implements CompletedState {
  const factory Updated() = _$UpdatedImpl;

  factory Updated.fromJson(Map<String, dynamic> json) = _$UpdatedImpl.fromJson;
}

/// @nodoc
abstract class _$$DeletedImplCopyWith<$Res> {
  factory _$$DeletedImplCopyWith(
          _$DeletedImpl value, $Res Function(_$DeletedImpl) then) =
      __$$DeletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool hard});
}

/// @nodoc
class __$$DeletedImplCopyWithImpl<$Res>
    extends _$CompletedStateCopyWithImpl<$Res, _$DeletedImpl>
    implements _$$DeletedImplCopyWith<$Res> {
  __$$DeletedImplCopyWithImpl(
      _$DeletedImpl _value, $Res Function(_$DeletedImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompletedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hard = null,
  }) {
    return _then(_$DeletedImpl(
      hard: null == hard
          ? _value.hard
          : hard // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeletedImpl implements Deleted {
  const _$DeletedImpl({this.hard = false, final String? $type})
      : $type = $type ?? 'deleted';

  factory _$DeletedImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeletedImplFromJson(json);

  @override
  @JsonKey()
  final bool hard;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'CompletedState.deleted(hard: $hard)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeletedImpl &&
            (identical(other.hard, hard) || other.hard == hard));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hard);

  /// Create a copy of CompletedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeletedImplCopyWith<_$DeletedImpl> get copyWith =>
      __$$DeletedImplCopyWithImpl<_$DeletedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sent,
    required TResult Function() updated,
    required TResult Function(bool hard) deleted,
  }) {
    return deleted(hard);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sent,
    TResult? Function()? updated,
    TResult? Function(bool hard)? deleted,
  }) {
    return deleted?.call(hard);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sent,
    TResult Function()? updated,
    TResult Function(bool hard)? deleted,
    required TResult orElse(),
  }) {
    if (deleted != null) {
      return deleted(hard);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Sent value) sent,
    required TResult Function(Updated value) updated,
    required TResult Function(Deleted value) deleted,
  }) {
    return deleted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Sent value)? sent,
    TResult? Function(Updated value)? updated,
    TResult? Function(Deleted value)? deleted,
  }) {
    return deleted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Sent value)? sent,
    TResult Function(Updated value)? updated,
    TResult Function(Deleted value)? deleted,
    required TResult orElse(),
  }) {
    if (deleted != null) {
      return deleted(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DeletedImplToJson(
      this,
    );
  }
}

abstract class Deleted implements CompletedState {
  const factory Deleted({final bool hard}) = _$DeletedImpl;

  factory Deleted.fromJson(Map<String, dynamic> json) = _$DeletedImpl.fromJson;

  bool get hard;

  /// Create a copy of CompletedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeletedImplCopyWith<_$DeletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FailedState _$FailedStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'sendingFailed':
      return SendingFailed.fromJson(json);
    case 'updatingFailed':
      return UpdatingFailed.fromJson(json);
    case 'deletingFailed':
      return DeletingFailed.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'FailedState',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$FailedState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sendingFailed,
    required TResult Function() updatingFailed,
    required TResult Function(bool hard) deletingFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sendingFailed,
    TResult? Function()? updatingFailed,
    TResult? Function(bool hard)? deletingFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sendingFailed,
    TResult Function()? updatingFailed,
    TResult Function(bool hard)? deletingFailed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SendingFailed value) sendingFailed,
    required TResult Function(UpdatingFailed value) updatingFailed,
    required TResult Function(DeletingFailed value) deletingFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SendingFailed value)? sendingFailed,
    TResult? Function(UpdatingFailed value)? updatingFailed,
    TResult? Function(DeletingFailed value)? deletingFailed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SendingFailed value)? sendingFailed,
    TResult Function(UpdatingFailed value)? updatingFailed,
    TResult Function(DeletingFailed value)? deletingFailed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this FailedState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailedStateCopyWith<$Res> {
  factory $FailedStateCopyWith(
          FailedState value, $Res Function(FailedState) then) =
      _$FailedStateCopyWithImpl<$Res, FailedState>;
}

/// @nodoc
class _$FailedStateCopyWithImpl<$Res, $Val extends FailedState>
    implements $FailedStateCopyWith<$Res> {
  _$FailedStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FailedState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SendingFailedImplCopyWith<$Res> {
  factory _$$SendingFailedImplCopyWith(
          _$SendingFailedImpl value, $Res Function(_$SendingFailedImpl) then) =
      __$$SendingFailedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SendingFailedImplCopyWithImpl<$Res>
    extends _$FailedStateCopyWithImpl<$Res, _$SendingFailedImpl>
    implements _$$SendingFailedImplCopyWith<$Res> {
  __$$SendingFailedImplCopyWithImpl(
      _$SendingFailedImpl _value, $Res Function(_$SendingFailedImpl) _then)
      : super(_value, _then);

  /// Create a copy of FailedState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$SendingFailedImpl implements SendingFailed {
  const _$SendingFailedImpl({final String? $type})
      : $type = $type ?? 'sendingFailed';

  factory _$SendingFailedImpl.fromJson(Map<String, dynamic> json) =>
      _$$SendingFailedImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'FailedState.sendingFailed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SendingFailedImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sendingFailed,
    required TResult Function() updatingFailed,
    required TResult Function(bool hard) deletingFailed,
  }) {
    return sendingFailed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sendingFailed,
    TResult? Function()? updatingFailed,
    TResult? Function(bool hard)? deletingFailed,
  }) {
    return sendingFailed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sendingFailed,
    TResult Function()? updatingFailed,
    TResult Function(bool hard)? deletingFailed,
    required TResult orElse(),
  }) {
    if (sendingFailed != null) {
      return sendingFailed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SendingFailed value) sendingFailed,
    required TResult Function(UpdatingFailed value) updatingFailed,
    required TResult Function(DeletingFailed value) deletingFailed,
  }) {
    return sendingFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SendingFailed value)? sendingFailed,
    TResult? Function(UpdatingFailed value)? updatingFailed,
    TResult? Function(DeletingFailed value)? deletingFailed,
  }) {
    return sendingFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SendingFailed value)? sendingFailed,
    TResult Function(UpdatingFailed value)? updatingFailed,
    TResult Function(DeletingFailed value)? deletingFailed,
    required TResult orElse(),
  }) {
    if (sendingFailed != null) {
      return sendingFailed(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$SendingFailedImplToJson(
      this,
    );
  }
}

abstract class SendingFailed implements FailedState {
  const factory SendingFailed() = _$SendingFailedImpl;

  factory SendingFailed.fromJson(Map<String, dynamic> json) =
      _$SendingFailedImpl.fromJson;
}

/// @nodoc
abstract class _$$UpdatingFailedImplCopyWith<$Res> {
  factory _$$UpdatingFailedImplCopyWith(_$UpdatingFailedImpl value,
          $Res Function(_$UpdatingFailedImpl) then) =
      __$$UpdatingFailedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UpdatingFailedImplCopyWithImpl<$Res>
    extends _$FailedStateCopyWithImpl<$Res, _$UpdatingFailedImpl>
    implements _$$UpdatingFailedImplCopyWith<$Res> {
  __$$UpdatingFailedImplCopyWithImpl(
      _$UpdatingFailedImpl _value, $Res Function(_$UpdatingFailedImpl) _then)
      : super(_value, _then);

  /// Create a copy of FailedState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$UpdatingFailedImpl implements UpdatingFailed {
  const _$UpdatingFailedImpl({final String? $type})
      : $type = $type ?? 'updatingFailed';

  factory _$UpdatingFailedImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdatingFailedImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'FailedState.updatingFailed()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UpdatingFailedImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sendingFailed,
    required TResult Function() updatingFailed,
    required TResult Function(bool hard) deletingFailed,
  }) {
    return updatingFailed();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sendingFailed,
    TResult? Function()? updatingFailed,
    TResult? Function(bool hard)? deletingFailed,
  }) {
    return updatingFailed?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sendingFailed,
    TResult Function()? updatingFailed,
    TResult Function(bool hard)? deletingFailed,
    required TResult orElse(),
  }) {
    if (updatingFailed != null) {
      return updatingFailed();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SendingFailed value) sendingFailed,
    required TResult Function(UpdatingFailed value) updatingFailed,
    required TResult Function(DeletingFailed value) deletingFailed,
  }) {
    return updatingFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SendingFailed value)? sendingFailed,
    TResult? Function(UpdatingFailed value)? updatingFailed,
    TResult? Function(DeletingFailed value)? deletingFailed,
  }) {
    return updatingFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SendingFailed value)? sendingFailed,
    TResult Function(UpdatingFailed value)? updatingFailed,
    TResult Function(DeletingFailed value)? deletingFailed,
    required TResult orElse(),
  }) {
    if (updatingFailed != null) {
      return updatingFailed(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdatingFailedImplToJson(
      this,
    );
  }
}

abstract class UpdatingFailed implements FailedState {
  const factory UpdatingFailed() = _$UpdatingFailedImpl;

  factory UpdatingFailed.fromJson(Map<String, dynamic> json) =
      _$UpdatingFailedImpl.fromJson;
}

/// @nodoc
abstract class _$$DeletingFailedImplCopyWith<$Res> {
  factory _$$DeletingFailedImplCopyWith(_$DeletingFailedImpl value,
          $Res Function(_$DeletingFailedImpl) then) =
      __$$DeletingFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool hard});
}

/// @nodoc
class __$$DeletingFailedImplCopyWithImpl<$Res>
    extends _$FailedStateCopyWithImpl<$Res, _$DeletingFailedImpl>
    implements _$$DeletingFailedImplCopyWith<$Res> {
  __$$DeletingFailedImplCopyWithImpl(
      _$DeletingFailedImpl _value, $Res Function(_$DeletingFailedImpl) _then)
      : super(_value, _then);

  /// Create a copy of FailedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hard = null,
  }) {
    return _then(_$DeletingFailedImpl(
      hard: null == hard
          ? _value.hard
          : hard // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeletingFailedImpl implements DeletingFailed {
  const _$DeletingFailedImpl({this.hard = false, final String? $type})
      : $type = $type ?? 'deletingFailed';

  factory _$DeletingFailedImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeletingFailedImplFromJson(json);

  @override
  @JsonKey()
  final bool hard;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'FailedState.deletingFailed(hard: $hard)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeletingFailedImpl &&
            (identical(other.hard, hard) || other.hard == hard));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hard);

  /// Create a copy of FailedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeletingFailedImplCopyWith<_$DeletingFailedImpl> get copyWith =>
      __$$DeletingFailedImplCopyWithImpl<_$DeletingFailedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sendingFailed,
    required TResult Function() updatingFailed,
    required TResult Function(bool hard) deletingFailed,
  }) {
    return deletingFailed(hard);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sendingFailed,
    TResult? Function()? updatingFailed,
    TResult? Function(bool hard)? deletingFailed,
  }) {
    return deletingFailed?.call(hard);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sendingFailed,
    TResult Function()? updatingFailed,
    TResult Function(bool hard)? deletingFailed,
    required TResult orElse(),
  }) {
    if (deletingFailed != null) {
      return deletingFailed(hard);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SendingFailed value) sendingFailed,
    required TResult Function(UpdatingFailed value) updatingFailed,
    required TResult Function(DeletingFailed value) deletingFailed,
  }) {
    return deletingFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SendingFailed value)? sendingFailed,
    TResult? Function(UpdatingFailed value)? updatingFailed,
    TResult? Function(DeletingFailed value)? deletingFailed,
  }) {
    return deletingFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SendingFailed value)? sendingFailed,
    TResult Function(UpdatingFailed value)? updatingFailed,
    TResult Function(DeletingFailed value)? deletingFailed,
    required TResult orElse(),
  }) {
    if (deletingFailed != null) {
      return deletingFailed(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DeletingFailedImplToJson(
      this,
    );
  }
}

abstract class DeletingFailed implements FailedState {
  const factory DeletingFailed({final bool hard}) = _$DeletingFailedImpl;

  factory DeletingFailed.fromJson(Map<String, dynamic> json) =
      _$DeletingFailedImpl.fromJson;

  bool get hard;

  /// Create a copy of FailedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeletingFailedImplCopyWith<_$DeletingFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
