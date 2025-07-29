// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
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
  /// Serializes this MessageState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MessageState);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MessageState()';
  }
}

/// @nodoc
class $MessageStateCopyWith<$Res> {
  $MessageStateCopyWith(MessageState _, $Res Function(MessageState) __);
}

/// @nodoc
@JsonSerializable()
class MessageInitial implements MessageState {
  const MessageInitial({final String? $type}) : $type = $type ?? 'initial';
  factory MessageInitial.fromJson(Map<String, dynamic> json) =>
      _$MessageInitialFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$MessageInitialToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MessageInitial);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MessageState.initial()';
  }
}

/// @nodoc
@JsonSerializable()
class MessageOutgoing implements MessageState {
  const MessageOutgoing({required this.state, final String? $type})
      : $type = $type ?? 'outgoing';
  factory MessageOutgoing.fromJson(Map<String, dynamic> json) =>
      _$MessageOutgoingFromJson(json);

  final OutgoingState state;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageOutgoingCopyWith<MessageOutgoing> get copyWith =>
      _$MessageOutgoingCopyWithImpl<MessageOutgoing>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MessageOutgoingToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageOutgoing &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, state);

  @override
  String toString() {
    return 'MessageState.outgoing(state: $state)';
  }
}

/// @nodoc
abstract mixin class $MessageOutgoingCopyWith<$Res>
    implements $MessageStateCopyWith<$Res> {
  factory $MessageOutgoingCopyWith(
          MessageOutgoing value, $Res Function(MessageOutgoing) _then) =
      _$MessageOutgoingCopyWithImpl;
  @useResult
  $Res call({OutgoingState state});

  $OutgoingStateCopyWith<$Res> get state;
}

/// @nodoc
class _$MessageOutgoingCopyWithImpl<$Res>
    implements $MessageOutgoingCopyWith<$Res> {
  _$MessageOutgoingCopyWithImpl(this._self, this._then);

  final MessageOutgoing _self;
  final $Res Function(MessageOutgoing) _then;

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? state = null,
  }) {
    return _then(MessageOutgoing(
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as OutgoingState,
    ));
  }

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OutgoingStateCopyWith<$Res> get state {
    return $OutgoingStateCopyWith<$Res>(_self.state, (value) {
      return _then(_self.copyWith(state: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class MessageCompleted implements MessageState {
  const MessageCompleted({required this.state, final String? $type})
      : $type = $type ?? 'completed';
  factory MessageCompleted.fromJson(Map<String, dynamic> json) =>
      _$MessageCompletedFromJson(json);

  final CompletedState state;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageCompletedCopyWith<MessageCompleted> get copyWith =>
      _$MessageCompletedCopyWithImpl<MessageCompleted>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MessageCompletedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageCompleted &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, state);

  @override
  String toString() {
    return 'MessageState.completed(state: $state)';
  }
}

/// @nodoc
abstract mixin class $MessageCompletedCopyWith<$Res>
    implements $MessageStateCopyWith<$Res> {
  factory $MessageCompletedCopyWith(
          MessageCompleted value, $Res Function(MessageCompleted) _then) =
      _$MessageCompletedCopyWithImpl;
  @useResult
  $Res call({CompletedState state});

  $CompletedStateCopyWith<$Res> get state;
}

/// @nodoc
class _$MessageCompletedCopyWithImpl<$Res>
    implements $MessageCompletedCopyWith<$Res> {
  _$MessageCompletedCopyWithImpl(this._self, this._then);

  final MessageCompleted _self;
  final $Res Function(MessageCompleted) _then;

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? state = null,
  }) {
    return _then(MessageCompleted(
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as CompletedState,
    ));
  }

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CompletedStateCopyWith<$Res> get state {
    return $CompletedStateCopyWith<$Res>(_self.state, (value) {
      return _then(_self.copyWith(state: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class MessageFailed implements MessageState {
  const MessageFailed({required this.state, this.reason, final String? $type})
      : $type = $type ?? 'failed';
  factory MessageFailed.fromJson(Map<String, dynamic> json) =>
      _$MessageFailedFromJson(json);

  final FailedState state;
  final Object? reason;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageFailedCopyWith<MessageFailed> get copyWith =>
      _$MessageFailedCopyWithImpl<MessageFailed>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MessageFailedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageFailed &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other.reason, reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, state, const DeepCollectionEquality().hash(reason));

  @override
  String toString() {
    return 'MessageState.failed(state: $state, reason: $reason)';
  }
}

/// @nodoc
abstract mixin class $MessageFailedCopyWith<$Res>
    implements $MessageStateCopyWith<$Res> {
  factory $MessageFailedCopyWith(
          MessageFailed value, $Res Function(MessageFailed) _then) =
      _$MessageFailedCopyWithImpl;
  @useResult
  $Res call({FailedState state, Object? reason});

  $FailedStateCopyWith<$Res> get state;
}

/// @nodoc
class _$MessageFailedCopyWithImpl<$Res>
    implements $MessageFailedCopyWith<$Res> {
  _$MessageFailedCopyWithImpl(this._self, this._then);

  final MessageFailed _self;
  final $Res Function(MessageFailed) _then;

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? state = null,
    Object? reason = freezed,
  }) {
    return _then(MessageFailed(
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as FailedState,
      reason: freezed == reason ? _self.reason : reason,
    ));
  }

  /// Create a copy of MessageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FailedStateCopyWith<$Res> get state {
    return $FailedStateCopyWith<$Res>(_self.state, (value) {
      return _then(_self.copyWith(state: value));
    });
  }
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
  /// Serializes this OutgoingState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is OutgoingState);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OutgoingState()';
  }
}

/// @nodoc
class $OutgoingStateCopyWith<$Res> {
  $OutgoingStateCopyWith(OutgoingState _, $Res Function(OutgoingState) __);
}

/// @nodoc
@JsonSerializable()
class Sending implements OutgoingState {
  const Sending({final String? $type}) : $type = $type ?? 'sending';
  factory Sending.fromJson(Map<String, dynamic> json) =>
      _$SendingFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$SendingToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Sending);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OutgoingState.sending()';
  }
}

/// @nodoc
@JsonSerializable()
class Updating implements OutgoingState {
  const Updating({final String? $type}) : $type = $type ?? 'updating';
  factory Updating.fromJson(Map<String, dynamic> json) =>
      _$UpdatingFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$UpdatingToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Updating);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'OutgoingState.updating()';
  }
}

/// @nodoc
@JsonSerializable()
class Deleting implements OutgoingState {
  const Deleting({this.hard = false, final String? $type})
      : $type = $type ?? 'deleting';
  factory Deleting.fromJson(Map<String, dynamic> json) =>
      _$DeletingFromJson(json);

  @JsonKey()
  final bool hard;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of OutgoingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeletingCopyWith<Deleting> get copyWith =>
      _$DeletingCopyWithImpl<Deleting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DeletingToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Deleting &&
            (identical(other.hard, hard) || other.hard == hard));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hard);

  @override
  String toString() {
    return 'OutgoingState.deleting(hard: $hard)';
  }
}

/// @nodoc
abstract mixin class $DeletingCopyWith<$Res>
    implements $OutgoingStateCopyWith<$Res> {
  factory $DeletingCopyWith(Deleting value, $Res Function(Deleting) _then) =
      _$DeletingCopyWithImpl;
  @useResult
  $Res call({bool hard});
}

/// @nodoc
class _$DeletingCopyWithImpl<$Res> implements $DeletingCopyWith<$Res> {
  _$DeletingCopyWithImpl(this._self, this._then);

  final Deleting _self;
  final $Res Function(Deleting) _then;

  /// Create a copy of OutgoingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? hard = null,
  }) {
    return _then(Deleting(
      hard: null == hard
          ? _self.hard
          : hard // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
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
  /// Serializes this CompletedState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CompletedState);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CompletedState()';
  }
}

/// @nodoc
class $CompletedStateCopyWith<$Res> {
  $CompletedStateCopyWith(CompletedState _, $Res Function(CompletedState) __);
}

/// @nodoc
@JsonSerializable()
class Sent implements CompletedState {
  const Sent({final String? $type}) : $type = $type ?? 'sent';
  factory Sent.fromJson(Map<String, dynamic> json) => _$SentFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$SentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Sent);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CompletedState.sent()';
  }
}

/// @nodoc
@JsonSerializable()
class Updated implements CompletedState {
  const Updated({final String? $type}) : $type = $type ?? 'updated';
  factory Updated.fromJson(Map<String, dynamic> json) =>
      _$UpdatedFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$UpdatedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is Updated);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CompletedState.updated()';
  }
}

/// @nodoc
@JsonSerializable()
class Deleted implements CompletedState {
  const Deleted({this.hard = false, final String? $type})
      : $type = $type ?? 'deleted';
  factory Deleted.fromJson(Map<String, dynamic> json) =>
      _$DeletedFromJson(json);

  @JsonKey()
  final bool hard;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of CompletedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeletedCopyWith<Deleted> get copyWith =>
      _$DeletedCopyWithImpl<Deleted>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DeletedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Deleted &&
            (identical(other.hard, hard) || other.hard == hard));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hard);

  @override
  String toString() {
    return 'CompletedState.deleted(hard: $hard)';
  }
}

/// @nodoc
abstract mixin class $DeletedCopyWith<$Res>
    implements $CompletedStateCopyWith<$Res> {
  factory $DeletedCopyWith(Deleted value, $Res Function(Deleted) _then) =
      _$DeletedCopyWithImpl;
  @useResult
  $Res call({bool hard});
}

/// @nodoc
class _$DeletedCopyWithImpl<$Res> implements $DeletedCopyWith<$Res> {
  _$DeletedCopyWithImpl(this._self, this._then);

  final Deleted _self;
  final $Res Function(Deleted) _then;

  /// Create a copy of CompletedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? hard = null,
  }) {
    return _then(Deleted(
      hard: null == hard
          ? _self.hard
          : hard // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
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
  /// Serializes this FailedState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FailedState);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'FailedState()';
  }
}

/// @nodoc
class $FailedStateCopyWith<$Res> {
  $FailedStateCopyWith(FailedState _, $Res Function(FailedState) __);
}

/// @nodoc
@JsonSerializable()
class SendingFailed implements FailedState {
  const SendingFailed(
      {this.skipPush = false, this.skipEnrichUrl = false, final String? $type})
      : $type = $type ?? 'sendingFailed';
  factory SendingFailed.fromJson(Map<String, dynamic> json) =>
      _$SendingFailedFromJson(json);

  @JsonKey()
  final bool skipPush;
  @JsonKey()
  final bool skipEnrichUrl;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of FailedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SendingFailedCopyWith<SendingFailed> get copyWith =>
      _$SendingFailedCopyWithImpl<SendingFailed>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SendingFailedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendingFailed &&
            (identical(other.skipPush, skipPush) ||
                other.skipPush == skipPush) &&
            (identical(other.skipEnrichUrl, skipEnrichUrl) ||
                other.skipEnrichUrl == skipEnrichUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, skipPush, skipEnrichUrl);

  @override
  String toString() {
    return 'FailedState.sendingFailed(skipPush: $skipPush, skipEnrichUrl: $skipEnrichUrl)';
  }
}

/// @nodoc
abstract mixin class $SendingFailedCopyWith<$Res>
    implements $FailedStateCopyWith<$Res> {
  factory $SendingFailedCopyWith(
          SendingFailed value, $Res Function(SendingFailed) _then) =
      _$SendingFailedCopyWithImpl;
  @useResult
  $Res call({bool skipPush, bool skipEnrichUrl});
}

/// @nodoc
class _$SendingFailedCopyWithImpl<$Res>
    implements $SendingFailedCopyWith<$Res> {
  _$SendingFailedCopyWithImpl(this._self, this._then);

  final SendingFailed _self;
  final $Res Function(SendingFailed) _then;

  /// Create a copy of FailedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? skipPush = null,
    Object? skipEnrichUrl = null,
  }) {
    return _then(SendingFailed(
      skipPush: null == skipPush
          ? _self.skipPush
          : skipPush // ignore: cast_nullable_to_non_nullable
              as bool,
      skipEnrichUrl: null == skipEnrichUrl
          ? _self.skipEnrichUrl
          : skipEnrichUrl // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class UpdatingFailed implements FailedState {
  const UpdatingFailed(
      {this.skipPush = false, this.skipEnrichUrl = false, final String? $type})
      : $type = $type ?? 'updatingFailed';
  factory UpdatingFailed.fromJson(Map<String, dynamic> json) =>
      _$UpdatingFailedFromJson(json);

  @JsonKey()
  final bool skipPush;
  @JsonKey()
  final bool skipEnrichUrl;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of FailedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdatingFailedCopyWith<UpdatingFailed> get copyWith =>
      _$UpdatingFailedCopyWithImpl<UpdatingFailed>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UpdatingFailedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdatingFailed &&
            (identical(other.skipPush, skipPush) ||
                other.skipPush == skipPush) &&
            (identical(other.skipEnrichUrl, skipEnrichUrl) ||
                other.skipEnrichUrl == skipEnrichUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, skipPush, skipEnrichUrl);

  @override
  String toString() {
    return 'FailedState.updatingFailed(skipPush: $skipPush, skipEnrichUrl: $skipEnrichUrl)';
  }
}

/// @nodoc
abstract mixin class $UpdatingFailedCopyWith<$Res>
    implements $FailedStateCopyWith<$Res> {
  factory $UpdatingFailedCopyWith(
          UpdatingFailed value, $Res Function(UpdatingFailed) _then) =
      _$UpdatingFailedCopyWithImpl;
  @useResult
  $Res call({bool skipPush, bool skipEnrichUrl});
}

/// @nodoc
class _$UpdatingFailedCopyWithImpl<$Res>
    implements $UpdatingFailedCopyWith<$Res> {
  _$UpdatingFailedCopyWithImpl(this._self, this._then);

  final UpdatingFailed _self;
  final $Res Function(UpdatingFailed) _then;

  /// Create a copy of FailedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? skipPush = null,
    Object? skipEnrichUrl = null,
  }) {
    return _then(UpdatingFailed(
      skipPush: null == skipPush
          ? _self.skipPush
          : skipPush // ignore: cast_nullable_to_non_nullable
              as bool,
      skipEnrichUrl: null == skipEnrichUrl
          ? _self.skipEnrichUrl
          : skipEnrichUrl // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class DeletingFailed implements FailedState {
  const DeletingFailed({this.hard = false, final String? $type})
      : $type = $type ?? 'deletingFailed';
  factory DeletingFailed.fromJson(Map<String, dynamic> json) =>
      _$DeletingFailedFromJson(json);

  @JsonKey()
  final bool hard;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of FailedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeletingFailedCopyWith<DeletingFailed> get copyWith =>
      _$DeletingFailedCopyWithImpl<DeletingFailed>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DeletingFailedToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeletingFailed &&
            (identical(other.hard, hard) || other.hard == hard));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hard);

  @override
  String toString() {
    return 'FailedState.deletingFailed(hard: $hard)';
  }
}

/// @nodoc
abstract mixin class $DeletingFailedCopyWith<$Res>
    implements $FailedStateCopyWith<$Res> {
  factory $DeletingFailedCopyWith(
          DeletingFailed value, $Res Function(DeletingFailed) _then) =
      _$DeletingFailedCopyWithImpl;
  @useResult
  $Res call({bool hard});
}

/// @nodoc
class _$DeletingFailedCopyWithImpl<$Res>
    implements $DeletingFailedCopyWith<$Res> {
  _$DeletingFailedCopyWithImpl(this._self, this._then);

  final DeletingFailed _self;
  final $Res Function(DeletingFailed) _then;

  /// Create a copy of FailedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? hard = null,
  }) {
    return _then(DeletingFailed(
      hard: null == hard
          ? _self.hard
          : hard // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
