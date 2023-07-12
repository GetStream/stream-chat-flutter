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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
}

/// @nodoc
abstract class _$$MessageInitialCopyWith<$Res> {
  factory _$$MessageInitialCopyWith(
          _$MessageInitial value, $Res Function(_$MessageInitial) then) =
      __$$MessageInitialCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MessageInitialCopyWithImpl<$Res>
    extends _$MessageStateCopyWithImpl<$Res, _$MessageInitial>
    implements _$$MessageInitialCopyWith<$Res> {
  __$$MessageInitialCopyWithImpl(
      _$MessageInitial _value, $Res Function(_$MessageInitial) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$MessageInitial implements MessageInitial {
  const _$MessageInitial({final String? $type}) : $type = $type ?? 'initial';

  factory _$MessageInitial.fromJson(Map<String, dynamic> json) =>
      _$$MessageInitialFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MessageState.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$MessageInitial);
  }

  @JsonKey(ignore: true)
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
    return _$$MessageInitialToJson(
      this,
    );
  }
}

abstract class MessageInitial implements MessageState {
  const factory MessageInitial() = _$MessageInitial;

  factory MessageInitial.fromJson(Map<String, dynamic> json) =
      _$MessageInitial.fromJson;
}

/// @nodoc
abstract class _$$MessageOutgoingCopyWith<$Res> {
  factory _$$MessageOutgoingCopyWith(
          _$MessageOutgoing value, $Res Function(_$MessageOutgoing) then) =
      __$$MessageOutgoingCopyWithImpl<$Res>;
  @useResult
  $Res call({OutgoingState state});

  $OutgoingStateCopyWith<$Res> get state;
}

/// @nodoc
class __$$MessageOutgoingCopyWithImpl<$Res>
    extends _$MessageStateCopyWithImpl<$Res, _$MessageOutgoing>
    implements _$$MessageOutgoingCopyWith<$Res> {
  __$$MessageOutgoingCopyWithImpl(
      _$MessageOutgoing _value, $Res Function(_$MessageOutgoing) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
  }) {
    return _then(_$MessageOutgoing(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as OutgoingState,
    ));
  }

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
class _$MessageOutgoing implements MessageOutgoing {
  const _$MessageOutgoing({required this.state, final String? $type})
      : $type = $type ?? 'outgoing';

  factory _$MessageOutgoing.fromJson(Map<String, dynamic> json) =>
      _$$MessageOutgoingFromJson(json);

  @override
  final OutgoingState state;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MessageState.outgoing(state: $state)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageOutgoing &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, state);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageOutgoingCopyWith<_$MessageOutgoing> get copyWith =>
      __$$MessageOutgoingCopyWithImpl<_$MessageOutgoing>(this, _$identity);

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
    return _$$MessageOutgoingToJson(
      this,
    );
  }
}

abstract class MessageOutgoing implements MessageState {
  const factory MessageOutgoing({required final OutgoingState state}) =
      _$MessageOutgoing;

  factory MessageOutgoing.fromJson(Map<String, dynamic> json) =
      _$MessageOutgoing.fromJson;

  OutgoingState get state;
  @JsonKey(ignore: true)
  _$$MessageOutgoingCopyWith<_$MessageOutgoing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MessageCompletedCopyWith<$Res> {
  factory _$$MessageCompletedCopyWith(
          _$MessageCompleted value, $Res Function(_$MessageCompleted) then) =
      __$$MessageCompletedCopyWithImpl<$Res>;
  @useResult
  $Res call({CompletedState state});

  $CompletedStateCopyWith<$Res> get state;
}

/// @nodoc
class __$$MessageCompletedCopyWithImpl<$Res>
    extends _$MessageStateCopyWithImpl<$Res, _$MessageCompleted>
    implements _$$MessageCompletedCopyWith<$Res> {
  __$$MessageCompletedCopyWithImpl(
      _$MessageCompleted _value, $Res Function(_$MessageCompleted) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
  }) {
    return _then(_$MessageCompleted(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as CompletedState,
    ));
  }

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
class _$MessageCompleted implements MessageCompleted {
  const _$MessageCompleted({required this.state, final String? $type})
      : $type = $type ?? 'completed';

  factory _$MessageCompleted.fromJson(Map<String, dynamic> json) =>
      _$$MessageCompletedFromJson(json);

  @override
  final CompletedState state;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'MessageState.completed(state: $state)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageCompleted &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, state);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageCompletedCopyWith<_$MessageCompleted> get copyWith =>
      __$$MessageCompletedCopyWithImpl<_$MessageCompleted>(this, _$identity);

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
    return _$$MessageCompletedToJson(
      this,
    );
  }
}

abstract class MessageCompleted implements MessageState {
  const factory MessageCompleted({required final CompletedState state}) =
      _$MessageCompleted;

  factory MessageCompleted.fromJson(Map<String, dynamic> json) =
      _$MessageCompleted.fromJson;

  CompletedState get state;
  @JsonKey(ignore: true)
  _$$MessageCompletedCopyWith<_$MessageCompleted> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MessageFailedCopyWith<$Res> {
  factory _$$MessageFailedCopyWith(
          _$MessageFailed value, $Res Function(_$MessageFailed) then) =
      __$$MessageFailedCopyWithImpl<$Res>;
  @useResult
  $Res call({FailedState state, Object? reason});

  $FailedStateCopyWith<$Res> get state;
}

/// @nodoc
class __$$MessageFailedCopyWithImpl<$Res>
    extends _$MessageStateCopyWithImpl<$Res, _$MessageFailed>
    implements _$$MessageFailedCopyWith<$Res> {
  __$$MessageFailedCopyWithImpl(
      _$MessageFailed _value, $Res Function(_$MessageFailed) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? reason = freezed,
  }) {
    return _then(_$MessageFailed(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as FailedState,
      reason: freezed == reason ? _value.reason : reason,
    ));
  }

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
class _$MessageFailed implements MessageFailed {
  const _$MessageFailed({required this.state, this.reason, final String? $type})
      : $type = $type ?? 'failed';

  factory _$MessageFailed.fromJson(Map<String, dynamic> json) =>
      _$$MessageFailedFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageFailed &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other.reason, reason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, state, const DeepCollectionEquality().hash(reason));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageFailedCopyWith<_$MessageFailed> get copyWith =>
      __$$MessageFailedCopyWithImpl<_$MessageFailed>(this, _$identity);

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
    return _$$MessageFailedToJson(
      this,
    );
  }
}

abstract class MessageFailed implements MessageState {
  const factory MessageFailed(
      {required final FailedState state,
      final Object? reason}) = _$MessageFailed;

  factory MessageFailed.fromJson(Map<String, dynamic> json) =
      _$MessageFailed.fromJson;

  FailedState get state;
  Object? get reason;
  @JsonKey(ignore: true)
  _$$MessageFailedCopyWith<_$MessageFailed> get copyWith =>
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
}

/// @nodoc
abstract class _$$SendingCopyWith<$Res> {
  factory _$$SendingCopyWith(_$Sending value, $Res Function(_$Sending) then) =
      __$$SendingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SendingCopyWithImpl<$Res>
    extends _$OutgoingStateCopyWithImpl<$Res, _$Sending>
    implements _$$SendingCopyWith<$Res> {
  __$$SendingCopyWithImpl(_$Sending _value, $Res Function(_$Sending) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$Sending implements Sending {
  const _$Sending({final String? $type}) : $type = $type ?? 'sending';

  factory _$Sending.fromJson(Map<String, dynamic> json) =>
      _$$SendingFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'OutgoingState.sending()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Sending);
  }

  @JsonKey(ignore: true)
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
    return _$$SendingToJson(
      this,
    );
  }
}

abstract class Sending implements OutgoingState {
  const factory Sending() = _$Sending;

  factory Sending.fromJson(Map<String, dynamic> json) = _$Sending.fromJson;
}

/// @nodoc
abstract class _$$UpdatingCopyWith<$Res> {
  factory _$$UpdatingCopyWith(
          _$Updating value, $Res Function(_$Updating) then) =
      __$$UpdatingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UpdatingCopyWithImpl<$Res>
    extends _$OutgoingStateCopyWithImpl<$Res, _$Updating>
    implements _$$UpdatingCopyWith<$Res> {
  __$$UpdatingCopyWithImpl(_$Updating _value, $Res Function(_$Updating) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$Updating implements Updating {
  const _$Updating({final String? $type}) : $type = $type ?? 'updating';

  factory _$Updating.fromJson(Map<String, dynamic> json) =>
      _$$UpdatingFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'OutgoingState.updating()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Updating);
  }

  @JsonKey(ignore: true)
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
    return _$$UpdatingToJson(
      this,
    );
  }
}

abstract class Updating implements OutgoingState {
  const factory Updating() = _$Updating;

  factory Updating.fromJson(Map<String, dynamic> json) = _$Updating.fromJson;
}

/// @nodoc
abstract class _$$DeletingCopyWith<$Res> {
  factory _$$DeletingCopyWith(
          _$Deleting value, $Res Function(_$Deleting) then) =
      __$$DeletingCopyWithImpl<$Res>;
  @useResult
  $Res call({bool hard});
}

/// @nodoc
class __$$DeletingCopyWithImpl<$Res>
    extends _$OutgoingStateCopyWithImpl<$Res, _$Deleting>
    implements _$$DeletingCopyWith<$Res> {
  __$$DeletingCopyWithImpl(_$Deleting _value, $Res Function(_$Deleting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hard = null,
  }) {
    return _then(_$Deleting(
      hard: null == hard
          ? _value.hard
          : hard // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$Deleting implements Deleting {
  const _$Deleting({this.hard = false, final String? $type})
      : $type = $type ?? 'deleting';

  factory _$Deleting.fromJson(Map<String, dynamic> json) =>
      _$$DeletingFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Deleting &&
            (identical(other.hard, hard) || other.hard == hard));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, hard);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeletingCopyWith<_$Deleting> get copyWith =>
      __$$DeletingCopyWithImpl<_$Deleting>(this, _$identity);

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
    return _$$DeletingToJson(
      this,
    );
  }
}

abstract class Deleting implements OutgoingState {
  const factory Deleting({final bool hard}) = _$Deleting;

  factory Deleting.fromJson(Map<String, dynamic> json) = _$Deleting.fromJson;

  bool get hard;
  @JsonKey(ignore: true)
  _$$DeletingCopyWith<_$Deleting> get copyWith =>
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
}

/// @nodoc
abstract class _$$SentCopyWith<$Res> {
  factory _$$SentCopyWith(_$Sent value, $Res Function(_$Sent) then) =
      __$$SentCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SentCopyWithImpl<$Res>
    extends _$CompletedStateCopyWithImpl<$Res, _$Sent>
    implements _$$SentCopyWith<$Res> {
  __$$SentCopyWithImpl(_$Sent _value, $Res Function(_$Sent) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$Sent implements Sent {
  const _$Sent({final String? $type}) : $type = $type ?? 'sent';

  factory _$Sent.fromJson(Map<String, dynamic> json) => _$$SentFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'CompletedState.sent()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Sent);
  }

  @JsonKey(ignore: true)
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
    return _$$SentToJson(
      this,
    );
  }
}

abstract class Sent implements CompletedState {
  const factory Sent() = _$Sent;

  factory Sent.fromJson(Map<String, dynamic> json) = _$Sent.fromJson;
}

/// @nodoc
abstract class _$$UpdatedCopyWith<$Res> {
  factory _$$UpdatedCopyWith(_$Updated value, $Res Function(_$Updated) then) =
      __$$UpdatedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UpdatedCopyWithImpl<$Res>
    extends _$CompletedStateCopyWithImpl<$Res, _$Updated>
    implements _$$UpdatedCopyWith<$Res> {
  __$$UpdatedCopyWithImpl(_$Updated _value, $Res Function(_$Updated) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$Updated implements Updated {
  const _$Updated({final String? $type}) : $type = $type ?? 'updated';

  factory _$Updated.fromJson(Map<String, dynamic> json) =>
      _$$UpdatedFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'CompletedState.updated()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Updated);
  }

  @JsonKey(ignore: true)
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
    return _$$UpdatedToJson(
      this,
    );
  }
}

abstract class Updated implements CompletedState {
  const factory Updated() = _$Updated;

  factory Updated.fromJson(Map<String, dynamic> json) = _$Updated.fromJson;
}

/// @nodoc
abstract class _$$DeletedCopyWith<$Res> {
  factory _$$DeletedCopyWith(_$Deleted value, $Res Function(_$Deleted) then) =
      __$$DeletedCopyWithImpl<$Res>;
  @useResult
  $Res call({bool hard});
}

/// @nodoc
class __$$DeletedCopyWithImpl<$Res>
    extends _$CompletedStateCopyWithImpl<$Res, _$Deleted>
    implements _$$DeletedCopyWith<$Res> {
  __$$DeletedCopyWithImpl(_$Deleted _value, $Res Function(_$Deleted) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hard = null,
  }) {
    return _then(_$Deleted(
      hard: null == hard
          ? _value.hard
          : hard // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$Deleted implements Deleted {
  const _$Deleted({this.hard = false, final String? $type})
      : $type = $type ?? 'deleted';

  factory _$Deleted.fromJson(Map<String, dynamic> json) =>
      _$$DeletedFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Deleted &&
            (identical(other.hard, hard) || other.hard == hard));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, hard);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeletedCopyWith<_$Deleted> get copyWith =>
      __$$DeletedCopyWithImpl<_$Deleted>(this, _$identity);

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
    return _$$DeletedToJson(
      this,
    );
  }
}

abstract class Deleted implements CompletedState {
  const factory Deleted({final bool hard}) = _$Deleted;

  factory Deleted.fromJson(Map<String, dynamic> json) = _$Deleted.fromJson;

  bool get hard;
  @JsonKey(ignore: true)
  _$$DeletedCopyWith<_$Deleted> get copyWith =>
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
}

/// @nodoc
abstract class _$$SendingFailedCopyWith<$Res> {
  factory _$$SendingFailedCopyWith(
          _$SendingFailed value, $Res Function(_$SendingFailed) then) =
      __$$SendingFailedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SendingFailedCopyWithImpl<$Res>
    extends _$FailedStateCopyWithImpl<$Res, _$SendingFailed>
    implements _$$SendingFailedCopyWith<$Res> {
  __$$SendingFailedCopyWithImpl(
      _$SendingFailed _value, $Res Function(_$SendingFailed) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$SendingFailed implements SendingFailed {
  const _$SendingFailed({final String? $type})
      : $type = $type ?? 'sendingFailed';

  factory _$SendingFailed.fromJson(Map<String, dynamic> json) =>
      _$$SendingFailedFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'FailedState.sendingFailed()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SendingFailed);
  }

  @JsonKey(ignore: true)
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
    return _$$SendingFailedToJson(
      this,
    );
  }
}

abstract class SendingFailed implements FailedState {
  const factory SendingFailed() = _$SendingFailed;

  factory SendingFailed.fromJson(Map<String, dynamic> json) =
      _$SendingFailed.fromJson;
}

/// @nodoc
abstract class _$$UpdatingFailedCopyWith<$Res> {
  factory _$$UpdatingFailedCopyWith(
          _$UpdatingFailed value, $Res Function(_$UpdatingFailed) then) =
      __$$UpdatingFailedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UpdatingFailedCopyWithImpl<$Res>
    extends _$FailedStateCopyWithImpl<$Res, _$UpdatingFailed>
    implements _$$UpdatingFailedCopyWith<$Res> {
  __$$UpdatingFailedCopyWithImpl(
      _$UpdatingFailed _value, $Res Function(_$UpdatingFailed) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$UpdatingFailed implements UpdatingFailed {
  const _$UpdatingFailed({final String? $type})
      : $type = $type ?? 'updatingFailed';

  factory _$UpdatingFailed.fromJson(Map<String, dynamic> json) =>
      _$$UpdatingFailedFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'FailedState.updatingFailed()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UpdatingFailed);
  }

  @JsonKey(ignore: true)
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
    return _$$UpdatingFailedToJson(
      this,
    );
  }
}

abstract class UpdatingFailed implements FailedState {
  const factory UpdatingFailed() = _$UpdatingFailed;

  factory UpdatingFailed.fromJson(Map<String, dynamic> json) =
      _$UpdatingFailed.fromJson;
}

/// @nodoc
abstract class _$$DeletingFailedCopyWith<$Res> {
  factory _$$DeletingFailedCopyWith(
          _$DeletingFailed value, $Res Function(_$DeletingFailed) then) =
      __$$DeletingFailedCopyWithImpl<$Res>;
  @useResult
  $Res call({bool hard});
}

/// @nodoc
class __$$DeletingFailedCopyWithImpl<$Res>
    extends _$FailedStateCopyWithImpl<$Res, _$DeletingFailed>
    implements _$$DeletingFailedCopyWith<$Res> {
  __$$DeletingFailedCopyWithImpl(
      _$DeletingFailed _value, $Res Function(_$DeletingFailed) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hard = null,
  }) {
    return _then(_$DeletingFailed(
      hard: null == hard
          ? _value.hard
          : hard // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeletingFailed implements DeletingFailed {
  const _$DeletingFailed({this.hard = false, final String? $type})
      : $type = $type ?? 'deletingFailed';

  factory _$DeletingFailed.fromJson(Map<String, dynamic> json) =>
      _$$DeletingFailedFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeletingFailed &&
            (identical(other.hard, hard) || other.hard == hard));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, hard);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeletingFailedCopyWith<_$DeletingFailed> get copyWith =>
      __$$DeletingFailedCopyWithImpl<_$DeletingFailed>(this, _$identity);

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
    return _$$DeletingFailedToJson(
      this,
    );
  }
}

abstract class DeletingFailed implements FailedState {
  const factory DeletingFailed({final bool hard}) = _$DeletingFailed;

  factory DeletingFailed.fromJson(Map<String, dynamic> json) =
      _$DeletingFailed.fromJson;

  bool get hard;
  @JsonKey(ignore: true)
  _$$DeletingFailedCopyWith<_$DeletingFailed> get copyWith =>
      throw _privateConstructorUsedError;
}
