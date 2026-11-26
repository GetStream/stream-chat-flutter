// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollUpdatedEvent {
  String? get cid;
  String? get messageId;
  Poll get poll;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of PollUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollUpdatedEventCopyWith<PollUpdatedEvent> get copyWith => _$PollUpdatedEventCopyWithImpl<PollUpdatedEvent>(
    this as PollUpdatedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollUpdatedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    messageId,
    poll,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'PollUpdatedEvent(cid: $cid, messageId: $messageId, poll: $poll, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $PollUpdatedEventCopyWith<$Res> {
  factory $PollUpdatedEventCopyWith(
    PollUpdatedEvent value,
    $Res Function(PollUpdatedEvent) _then,
  ) = _$PollUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? messageId,
    Poll poll,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$PollUpdatedEventCopyWithImpl<$Res> implements $PollUpdatedEventCopyWith<$Res> {
  _$PollUpdatedEventCopyWithImpl(this._self, this._then);

  final PollUpdatedEvent _self;
  final $Res Function(PollUpdatedEvent) _then;

  /// Create a copy of PollUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? messageId = freezed,
    Object? poll = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      PollUpdatedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as Poll,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        isLocal: null == isLocal
            ? _self.isLocal
            : isLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
mixin _$PollClosedEvent {
  String? get cid;
  String? get messageId;
  Poll get poll;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of PollClosedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollClosedEventCopyWith<PollClosedEvent> get copyWith => _$PollClosedEventCopyWithImpl<PollClosedEvent>(
    this as PollClosedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollClosedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    messageId,
    poll,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'PollClosedEvent(cid: $cid, messageId: $messageId, poll: $poll, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $PollClosedEventCopyWith<$Res> {
  factory $PollClosedEventCopyWith(
    PollClosedEvent value,
    $Res Function(PollClosedEvent) _then,
  ) = _$PollClosedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? messageId,
    Poll poll,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$PollClosedEventCopyWithImpl<$Res> implements $PollClosedEventCopyWith<$Res> {
  _$PollClosedEventCopyWithImpl(this._self, this._then);

  final PollClosedEvent _self;
  final $Res Function(PollClosedEvent) _then;

  /// Create a copy of PollClosedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? messageId = freezed,
    Object? poll = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      PollClosedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as Poll,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        isLocal: null == isLocal
            ? _self.isLocal
            : isLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
mixin _$PollDeletedEvent {
  String? get cid;
  String? get messageId;
  Poll get poll;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of PollDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollDeletedEventCopyWith<PollDeletedEvent> get copyWith => _$PollDeletedEventCopyWithImpl<PollDeletedEvent>(
    this as PollDeletedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollDeletedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    messageId,
    poll,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'PollDeletedEvent(cid: $cid, messageId: $messageId, poll: $poll, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $PollDeletedEventCopyWith<$Res> {
  factory $PollDeletedEventCopyWith(
    PollDeletedEvent value,
    $Res Function(PollDeletedEvent) _then,
  ) = _$PollDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? messageId,
    Poll poll,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$PollDeletedEventCopyWithImpl<$Res> implements $PollDeletedEventCopyWith<$Res> {
  _$PollDeletedEventCopyWithImpl(this._self, this._then);

  final PollDeletedEvent _self;
  final $Res Function(PollDeletedEvent) _then;

  /// Create a copy of PollDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? messageId = freezed,
    Object? poll = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      PollDeletedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as Poll,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        isLocal: null == isLocal
            ? _self.isLocal
            : isLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
mixin _$PollVoteCastedEvent {
  String? get cid;
  String? get messageId;
  Poll get poll;
  PollVote get pollVote;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of PollVoteCastedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollVoteCastedEventCopyWith<PollVoteCastedEvent> get copyWith =>
      _$PollVoteCastedEventCopyWithImpl<PollVoteCastedEvent>(
        this as PollVoteCastedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollVoteCastedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.pollVote, pollVote) || other.pollVote == pollVote) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    messageId,
    poll,
    pollVote,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'PollVoteCastedEvent(cid: $cid, messageId: $messageId, poll: $poll, pollVote: $pollVote, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $PollVoteCastedEventCopyWith<$Res> {
  factory $PollVoteCastedEventCopyWith(
    PollVoteCastedEvent value,
    $Res Function(PollVoteCastedEvent) _then,
  ) = _$PollVoteCastedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? messageId,
    Poll poll,
    PollVote pollVote,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$PollVoteCastedEventCopyWithImpl<$Res> implements $PollVoteCastedEventCopyWith<$Res> {
  _$PollVoteCastedEventCopyWithImpl(this._self, this._then);

  final PollVoteCastedEvent _self;
  final $Res Function(PollVoteCastedEvent) _then;

  /// Create a copy of PollVoteCastedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? messageId = freezed,
    Object? poll = null,
    Object? pollVote = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      PollVoteCastedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as Poll,
        pollVote: null == pollVote
            ? _self.pollVote
            : pollVote // ignore: cast_nullable_to_non_nullable
                  as PollVote,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        isLocal: null == isLocal
            ? _self.isLocal
            : isLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
mixin _$PollVoteChangedEvent {
  String? get cid;
  String? get messageId;
  Poll get poll;
  PollVote get pollVote;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of PollVoteChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollVoteChangedEventCopyWith<PollVoteChangedEvent> get copyWith =>
      _$PollVoteChangedEventCopyWithImpl<PollVoteChangedEvent>(
        this as PollVoteChangedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollVoteChangedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.pollVote, pollVote) || other.pollVote == pollVote) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    messageId,
    poll,
    pollVote,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'PollVoteChangedEvent(cid: $cid, messageId: $messageId, poll: $poll, pollVote: $pollVote, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $PollVoteChangedEventCopyWith<$Res> {
  factory $PollVoteChangedEventCopyWith(
    PollVoteChangedEvent value,
    $Res Function(PollVoteChangedEvent) _then,
  ) = _$PollVoteChangedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? messageId,
    Poll poll,
    PollVote pollVote,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$PollVoteChangedEventCopyWithImpl<$Res> implements $PollVoteChangedEventCopyWith<$Res> {
  _$PollVoteChangedEventCopyWithImpl(this._self, this._then);

  final PollVoteChangedEvent _self;
  final $Res Function(PollVoteChangedEvent) _then;

  /// Create a copy of PollVoteChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? messageId = freezed,
    Object? poll = null,
    Object? pollVote = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      PollVoteChangedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as Poll,
        pollVote: null == pollVote
            ? _self.pollVote
            : pollVote // ignore: cast_nullable_to_non_nullable
                  as PollVote,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        isLocal: null == isLocal
            ? _self.isLocal
            : isLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
mixin _$PollVoteRemovedEvent {
  String? get cid;
  String? get messageId;
  Poll get poll;
  PollVote get pollVote;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of PollVoteRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollVoteRemovedEventCopyWith<PollVoteRemovedEvent> get copyWith =>
      _$PollVoteRemovedEventCopyWithImpl<PollVoteRemovedEvent>(
        this as PollVoteRemovedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollVoteRemovedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.pollVote, pollVote) || other.pollVote == pollVote) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    messageId,
    poll,
    pollVote,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'PollVoteRemovedEvent(cid: $cid, messageId: $messageId, poll: $poll, pollVote: $pollVote, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $PollVoteRemovedEventCopyWith<$Res> {
  factory $PollVoteRemovedEventCopyWith(
    PollVoteRemovedEvent value,
    $Res Function(PollVoteRemovedEvent) _then,
  ) = _$PollVoteRemovedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? messageId,
    Poll poll,
    PollVote pollVote,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$PollVoteRemovedEventCopyWithImpl<$Res> implements $PollVoteRemovedEventCopyWith<$Res> {
  _$PollVoteRemovedEventCopyWithImpl(this._self, this._then);

  final PollVoteRemovedEvent _self;
  final $Res Function(PollVoteRemovedEvent) _then;

  /// Create a copy of PollVoteRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? messageId = freezed,
    Object? poll = null,
    Object? pollVote = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      PollVoteRemovedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as Poll,
        pollVote: null == pollVote
            ? _self.pollVote
            : pollVote // ignore: cast_nullable_to_non_nullable
                  as PollVote,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        isLocal: null == isLocal
            ? _self.isLocal
            : isLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
mixin _$PollAnswerCastedEvent {
  String? get cid;
  String? get messageId;
  Poll get poll;
  PollVote get pollVote;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of PollAnswerCastedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollAnswerCastedEventCopyWith<PollAnswerCastedEvent> get copyWith =>
      _$PollAnswerCastedEventCopyWithImpl<PollAnswerCastedEvent>(
        this as PollAnswerCastedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollAnswerCastedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.pollVote, pollVote) || other.pollVote == pollVote) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    messageId,
    poll,
    pollVote,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'PollAnswerCastedEvent(cid: $cid, messageId: $messageId, poll: $poll, pollVote: $pollVote, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $PollAnswerCastedEventCopyWith<$Res> {
  factory $PollAnswerCastedEventCopyWith(
    PollAnswerCastedEvent value,
    $Res Function(PollAnswerCastedEvent) _then,
  ) = _$PollAnswerCastedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? messageId,
    Poll poll,
    PollVote pollVote,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$PollAnswerCastedEventCopyWithImpl<$Res> implements $PollAnswerCastedEventCopyWith<$Res> {
  _$PollAnswerCastedEventCopyWithImpl(this._self, this._then);

  final PollAnswerCastedEvent _self;
  final $Res Function(PollAnswerCastedEvent) _then;

  /// Create a copy of PollAnswerCastedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? messageId = freezed,
    Object? poll = null,
    Object? pollVote = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      PollAnswerCastedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as Poll,
        pollVote: null == pollVote
            ? _self.pollVote
            : pollVote // ignore: cast_nullable_to_non_nullable
                  as PollVote,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        isLocal: null == isLocal
            ? _self.isLocal
            : isLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
mixin _$PollAnswerRemovedEvent {
  String? get cid;
  String? get messageId;
  Poll get poll;
  PollVote get pollVote;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of PollAnswerRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollAnswerRemovedEventCopyWith<PollAnswerRemovedEvent> get copyWith =>
      _$PollAnswerRemovedEventCopyWithImpl<PollAnswerRemovedEvent>(
        this as PollAnswerRemovedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollAnswerRemovedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.pollVote, pollVote) || other.pollVote == pollVote) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    messageId,
    poll,
    pollVote,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'PollAnswerRemovedEvent(cid: $cid, messageId: $messageId, poll: $poll, pollVote: $pollVote, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $PollAnswerRemovedEventCopyWith<$Res> {
  factory $PollAnswerRemovedEventCopyWith(
    PollAnswerRemovedEvent value,
    $Res Function(PollAnswerRemovedEvent) _then,
  ) = _$PollAnswerRemovedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? messageId,
    Poll poll,
    PollVote pollVote,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$PollAnswerRemovedEventCopyWithImpl<$Res> implements $PollAnswerRemovedEventCopyWith<$Res> {
  _$PollAnswerRemovedEventCopyWithImpl(this._self, this._then);

  final PollAnswerRemovedEvent _self;
  final $Res Function(PollAnswerRemovedEvent) _then;

  /// Create a copy of PollAnswerRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? messageId = freezed,
    Object? poll = null,
    Object? pollVote = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      PollAnswerRemovedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as Poll,
        pollVote: null == pollVote
            ? _self.pollVote
            : pollVote // ignore: cast_nullable_to_non_nullable
                  as PollVote,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        isLocal: null == isLocal
            ? _self.isLocal
            : isLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
