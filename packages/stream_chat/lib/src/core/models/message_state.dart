// ignore_for_file: avoid_positional_boolean_parameters

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_state.freezed.dart';

part 'message_state.g.dart';

/// Helper extension for [MessageState].
extension MessageStateX on MessageState {
  /// Returns true if the message is in initial state.
  bool get isInitial => this is MessageInitial;

  /// Returns true if the message is in outgoing state.
  bool get isOutgoing => this is MessageOutgoing;

  /// Returns true if the message is in completed state.
  bool get isCompleted => this is MessageCompleted;

  /// Returns true if the message is in failed state.
  bool get isFailed => this is MessageFailed;

  /// Returns true if the message is in outgoing sending state.
  bool get isSending {
    final messageState = this;
    return messageState is MessageOutgoing && messageState.state is Sending;
  }

  /// Returns true if the message is in outgoing updating state.
  bool get isUpdating {
    final messageState = this;
    return messageState is MessageOutgoing && messageState.state is Updating;
  }

  /// Returns true if the message is in outgoing deleting state.
  bool get isDeleting => isSoftDeleting || isHardDeleting;

  /// Returns true if the message is in outgoing soft deleting state.
  bool get isSoftDeleting {
    final messageState = this;
    if (messageState is! MessageOutgoing) return false;

    final outgoingState = messageState.state;
    if (outgoingState is! Deleting) return false;

    return !outgoingState.hard;
  }

  /// Returns true if the message is in outgoing hard deleting state.
  bool get isHardDeleting {
    final messageState = this;
    if (messageState is! MessageOutgoing) return false;

    final outgoingState = messageState.state;
    if (outgoingState is! Deleting) return false;

    return outgoingState.hard;
  }

  /// Returns true if the message is in completed sent state.
  bool get isSent {
    final messageState = this;
    return messageState is MessageCompleted && messageState.state is Sent;
  }

  /// Returns true if the message is in completed updated state.
  bool get isUpdated {
    final messageState = this;
    return messageState is MessageCompleted && messageState.state is Updated;
  }

  /// Returns true if the message is in completed deleted state.
  bool get isDeleted => isSoftDeleted || isHardDeleted;

  /// Returns true if the message is in completed soft deleted state.
  bool get isSoftDeleted {
    final messageState = this;
    if (messageState is! MessageCompleted) return false;

    final completedState = messageState.state;
    if (completedState is! Deleted) return false;

    return !completedState.hard;
  }

  /// Returns true if the message is in completed hard deleted state.
  bool get isHardDeleted {
    final messageState = this;
    if (messageState is! MessageCompleted) return false;

    final completedState = messageState.state;
    if (completedState is! Deleted) return false;

    return completedState.hard;
  }

  /// Returns true if the message is in failed sending state.
  bool get isSendingFailed {
    final messageState = this;
    if (messageState is! MessageFailed) return false;
    return messageState.state is SendingFailed;
  }

  /// Returns true if the message is in failed updating state.
  bool get isUpdatingFailed {
    return switch (this) {
      MessageFailed(state: UpdatingFailed()) => true,
      MessageFailed(state: PartialUpdateFailed()) => true,
      _ => false,
    };
  }

  /// Returns true if the message is in failed deleting state.
  bool get isDeletingFailed => isSoftDeletingFailed || isHardDeletingFailed;

  /// Returns true if the message is in failed soft deleting state.
  bool get isSoftDeletingFailed {
    final messageState = this;
    if (messageState is! MessageFailed) return false;

    final failedState = messageState.state;
    if (failedState is! DeletingFailed) return false;

    return !failedState.hard;
  }

  /// Returns true if the message is in failed hard deleting state.
  bool get isHardDeletingFailed {
    final messageState = this;
    if (messageState is! MessageFailed) return false;

    final failedState = messageState.state;
    if (failedState is! DeletingFailed) return false;

    return failedState.hard;
  }
}

/// Represents the various states a message can be in.
@freezed
sealed class MessageState with _$MessageState {
  /// Initial state when the message is created.
  const factory MessageState.initial() = MessageInitial;

  /// Outgoing state when the message is being sent, updated, or deleted.
  const factory MessageState.outgoing({
    required OutgoingState state,
  }) = MessageOutgoing;

  /// Completed state when the message has been successfully sent, updated, or
  /// deleted.
  const factory MessageState.completed({
    required CompletedState state,
  }) = MessageCompleted;

  /// Failed state when the message fails to be sent, updated, or deleted.
  const factory MessageState.failed({
    required FailedState state,
    Object? reason,
  }) = MessageFailed;

  /// Creates a new instance from a json
  factory MessageState.fromJson(Map<String, dynamic> json) =>
      _$MessageStateFromJson(json);

  /// Deleting state when the message is being deleted.
  factory MessageState.deleting({required bool hard}) {
    return MessageState.outgoing(
      state: OutgoingState.deleting(hard: hard),
    );
  }

  /// Deleting state when the message has been successfully deleted.
  factory MessageState.deleted({required bool hard}) {
    return MessageState.completed(
      state: CompletedState.deleted(hard: hard),
    );
  }

  /// Deleting failed state when the message fails to be deleted.
  factory MessageState.deletingFailed({required bool hard}) {
    return MessageState.failed(
      state: FailedState.deletingFailed(hard: hard),
    );
  }

  /// Sending failed state when the message fails to be sent.
  factory MessageState.sendingFailed({
    required bool skipPush,
    required bool skipEnrichUrl,
  }) {
    return MessageState.failed(
      state: FailedState.sendingFailed(
        skipPush: skipPush,
        skipEnrichUrl: skipEnrichUrl,
      ),
    );
  }

  /// Updating failed state when the message fails to be updated.
  factory MessageState.updatingFailed({
    bool skipPush = false,
    required bool skipEnrichUrl,
  }) {
    return MessageState.failed(
      state: FailedState.updatingFailed(
        skipPush: skipPush,
        skipEnrichUrl: skipEnrichUrl,
      ),
    );
  }

  factory MessageState.partialUpdateFailed({
    Map<String, Object?>? set,
    List<String>? unset,
    bool skipEnrichUrl = false,
  }) {
    return MessageState.failed(
      state: FailedState.partialUpdateFailed(
        set: set,
        unset: unset,
        skipEnrichUrl: skipEnrichUrl,
      ),
    );
  }

  /// Sending state when the message is being sent.
  static const sending = MessageState.outgoing(
    state: OutgoingState.sending(),
  );

  /// Updating state when the message is being updated.
  static const updating = MessageState.outgoing(
    state: OutgoingState.updating(),
  );

  /// Deleting state when the message is being soft deleted.
  static const softDeleting = MessageState.outgoing(
    state: OutgoingState.deleting(),
  );

  /// Hard deleting state when the message is being hard deleted.
  static const hardDeleting = MessageState.outgoing(
    state: OutgoingState.deleting(hard: true),
  );

  /// Sent state when the message has been successfully sent.
  static const sent = MessageState.completed(
    state: CompletedState.sent(),
  );

  /// Updated state when the message has been successfully updated.
  static const updated = MessageState.completed(
    state: CompletedState.updated(),
  );

  /// Deleted state when the message has been successfully soft deleted.
  static const softDeleted = MessageState.completed(
    state: CompletedState.deleted(),
  );

  /// Hard deleted state when the message has been successfully hard deleted.
  static const hardDeleted = MessageState.completed(
    state: CompletedState.deleted(hard: true),
  );

  /// Deleting failed state when the message fails to be soft deleted.
  static const softDeletingFailed = MessageState.failed(
    state: FailedState.deletingFailed(),
  );

  /// Hard deleting failed state when the message fails to be hard deleted.
  static const hardDeletingFailed = MessageState.failed(
    state: FailedState.deletingFailed(hard: true),
  );
}

/// Represents the state of an outgoing message.
@freezed
sealed class OutgoingState with _$OutgoingState {
  /// Sending state when the message is being sent.
  const factory OutgoingState.sending() = Sending;

  /// Updating state when the message is being updated.
  const factory OutgoingState.updating() = Updating;

  /// Deleting state when the message is being deleted.
  const factory OutgoingState.deleting({
    @Default(false) bool hard,
  }) = Deleting;

  /// Creates a new instance from a json
  factory OutgoingState.fromJson(Map<String, dynamic> json) =>
      _$OutgoingStateFromJson(json);
}

/// Represents the completed state of a message.
@freezed
sealed class CompletedState with _$CompletedState {
  /// Sent state when the message has been successfully sent.
  const factory CompletedState.sent() = Sent;

  /// Updated state when the message has been successfully updated.
  const factory CompletedState.updated() = Updated;

  /// Deleted state when the message has been successfully deleted.
  const factory CompletedState.deleted({
    @Default(false) bool hard,
  }) = Deleted;

  /// Creates a new instance from a json
  factory CompletedState.fromJson(Map<String, dynamic> json) =>
      _$CompletedStateFromJson(json);
}

/// Represents the failed state of a message.
@freezed
sealed class FailedState with _$FailedState {
  /// Sending failed state when the message fails to be sent.
  const factory FailedState.sendingFailed({
    @Default(false) bool skipPush,
    @Default(false) bool skipEnrichUrl,
  }) = SendingFailed;

  /// Updating failed state when the message fails to be updated.
  const factory FailedState.updatingFailed({
    @Default(false) bool skipPush,
    @Default(false) bool skipEnrichUrl,
  }) = UpdatingFailed;

  const factory FailedState.partialUpdateFailed({
    Map<String, Object?>? set,
    List<String>? unset,
    @Default(false) bool skipEnrichUrl,
  }) = PartialUpdateFailed;

  /// Deleting failed state when the message fails to be deleted.
  const factory FailedState.deletingFailed({
    @Default(false) bool hard,
  }) = DeletingFailed;

  /// Creates a new instance from a json
  factory FailedState.fromJson(Map<String, dynamic> json) =>
      _$FailedStateFromJson(json);
}

// coverage:ignore-start

/// @nodoc
extension MessageStatePatternMatching on MessageState {
  /// @nodoc
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(OutgoingState state) outgoing,
    required TResult Function(CompletedState state) completed,
    required TResult Function(FailedState state, Object? reason) failed,
  }) {
    final messageState = this;
    return switch (messageState) {
      MessageInitial() => initial(),
      MessageOutgoing() => outgoing(messageState.state),
      MessageCompleted() => completed(messageState.state),
      MessageFailed() => failed(messageState.state, messageState.reason),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(OutgoingState state)? outgoing,
    TResult? Function(CompletedState state)? completed,
    TResult? Function(FailedState state, Object? reason)? failed,
  }) {
    final messageState = this;
    return switch (messageState) {
      MessageInitial() => initial?.call(),
      MessageOutgoing() => outgoing?.call(messageState.state),
      MessageCompleted() => completed?.call(messageState.state),
      MessageFailed() => failed?.call(messageState.state, messageState.reason),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(OutgoingState state)? outgoing,
    TResult Function(CompletedState state)? completed,
    TResult Function(FailedState state, Object? reason)? failed,
    required TResult orElse(),
  }) {
    final messageState = this;
    final result = switch (messageState) {
      MessageInitial() => initial?.call(),
      MessageOutgoing() => outgoing?.call(messageState.state),
      MessageCompleted() => completed?.call(messageState.state),
      MessageFailed() => failed?.call(messageState.state, messageState.reason),
    };

    return result ?? orElse();
  }

  /// @nodoc
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MessageInitial value) initial,
    required TResult Function(MessageOutgoing value) outgoing,
    required TResult Function(MessageCompleted value) completed,
    required TResult Function(MessageFailed value) failed,
  }) {
    final messageState = this;
    return switch (messageState) {
      MessageInitial() => initial(messageState),
      MessageOutgoing() => outgoing(messageState),
      MessageCompleted() => completed(messageState),
      MessageFailed() => failed(messageState),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MessageInitial value)? initial,
    TResult? Function(MessageOutgoing value)? outgoing,
    TResult? Function(MessageCompleted value)? completed,
    TResult? Function(MessageFailed value)? failed,
  }) {
    final messageState = this;
    return switch (messageState) {
      MessageInitial() => initial?.call(messageState),
      MessageOutgoing() => outgoing?.call(messageState),
      MessageCompleted() => completed?.call(messageState),
      MessageFailed() => failed?.call(messageState),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MessageInitial value)? initial,
    TResult Function(MessageOutgoing value)? outgoing,
    TResult Function(MessageCompleted value)? completed,
    TResult Function(MessageFailed value)? failed,
    required TResult orElse(),
  }) {
    final messageState = this;
    final result = switch (messageState) {
      MessageInitial() => initial?.call(messageState),
      MessageOutgoing() => outgoing?.call(messageState),
      MessageCompleted() => completed?.call(messageState),
      MessageFailed() => failed?.call(messageState),
    };

    return result ?? orElse();
  }
}

/// @nodoc
extension OutgoingStatePatternMatching on OutgoingState {
  /// @nodoc
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sending,
    required TResult Function() updating,
    required TResult Function(bool hard) deleting,
  }) {
    final outgoingState = this;
    return switch (outgoingState) {
      Sending() => sending(),
      Updating() => updating(),
      Deleting() => deleting(outgoingState.hard),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sending,
    TResult? Function()? updating,
    TResult? Function(bool hard)? deleting,
  }) {
    final outgoingState = this;
    return switch (outgoingState) {
      Sending() => sending?.call(),
      Updating() => updating?.call(),
      Deleting() => deleting?.call(outgoingState.hard),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sending,
    TResult Function()? updating,
    TResult Function(bool hard)? deleting,
    required TResult orElse(),
  }) {
    final outgoingState = this;
    final result = switch (outgoingState) {
      Sending() => sending?.call(),
      Updating() => updating?.call(),
      Deleting() => deleting?.call(outgoingState.hard),
    };

    return result ?? orElse();
  }

  /// @nodoc
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Sending value) sending,
    required TResult Function(Updating value) updating,
    required TResult Function(Deleting value) deleting,
  }) {
    final outgoingState = this;
    return switch (outgoingState) {
      Sending() => sending(outgoingState),
      Updating() => updating(outgoingState),
      Deleting() => deleting(outgoingState),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Sending value)? sending,
    TResult? Function(Updating value)? updating,
    TResult? Function(Deleting value)? deleting,
  }) {
    final outgoingState = this;
    return switch (outgoingState) {
      Sending() => sending?.call(outgoingState),
      Updating() => updating?.call(outgoingState),
      Deleting() => deleting?.call(outgoingState),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Sending value)? sending,
    TResult Function(Updating value)? updating,
    TResult Function(Deleting value)? deleting,
    required TResult orElse(),
  }) {
    final outgoingState = this;
    final result = switch (outgoingState) {
      Sending() => sending?.call(outgoingState),
      Updating() => updating?.call(outgoingState),
      Deleting() => deleting?.call(outgoingState),
    };

    return result ?? orElse();
  }
}

/// @nodoc
extension CompletedStatePatternMatching on CompletedState {
  /// @nodoc
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sent,
    required TResult Function() updated,
    required TResult Function(bool hard) deleted,
  }) {
    final completedState = this;
    return switch (completedState) {
      Sent() => sent(),
      Updated() => updated(),
      Deleted() => deleted(completedState.hard),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sent,
    TResult? Function()? updated,
    TResult? Function(bool hard)? deleted,
  }) {
    final completedState = this;
    return switch (completedState) {
      Sent() => sent?.call(),
      Updated() => updated?.call(),
      Deleted() => deleted?.call(completedState.hard),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sent,
    TResult Function()? updated,
    TResult Function(bool hard)? deleted,
    required TResult orElse(),
  }) {
    final completedState = this;
    final result = switch (completedState) {
      Sent() => sent?.call(),
      Updated() => updated?.call(),
      Deleted() => deleted?.call(completedState.hard),
    };

    return result ?? orElse();
  }

  /// @nodoc
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Sent value) sent,
    required TResult Function(Updated value) updated,
    required TResult Function(Deleted value) deleted,
  }) {
    final completedState = this;
    return switch (completedState) {
      Sent() => sent(completedState),
      Updated() => updated(completedState),
      Deleted() => deleted(completedState),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Sent value)? sent,
    TResult? Function(Updated value)? updated,
    TResult? Function(Deleted value)? deleted,
  }) {
    final completedState = this;
    return switch (completedState) {
      Sent() => sent?.call(completedState),
      Updated() => updated?.call(completedState),
      Deleted() => deleted?.call(completedState),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Sent value)? sent,
    TResult Function(Updated value)? updated,
    TResult Function(Deleted value)? deleted,
    required TResult orElse(),
  }) {
    final completedState = this;
    final result = switch (completedState) {
      Sent() => sent?.call(completedState),
      Updated() => updated?.call(completedState),
      Deleted() => deleted?.call(completedState),
    };

    return result ?? orElse();
  }
}

/// @nodoc
extension FailedStatePatternMatching on FailedState {
  /// @nodoc
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool skipPush, bool skipEnrichUrl) sendingFailed,
    required TResult Function(bool skipPush, bool skipEnrichUrl) updatingFailed,
    required TResult Function(
            Map<String, Object?>? set, List<String>? unset, bool skipEnrichUrl)
        partialUpdateFailed,
    required TResult Function(bool hard) deletingFailed,
  }) {
    final failedState = this;
    return switch (failedState) {
      SendingFailed() =>
        sendingFailed(failedState.skipPush, failedState.skipEnrichUrl),
      UpdatingFailed() =>
        updatingFailed(failedState.skipPush, failedState.skipEnrichUrl),
      PartialUpdateFailed() => partialUpdateFailed(
          failedState.set, failedState.unset, failedState.skipEnrichUrl),
      DeletingFailed() => deletingFailed(failedState.hard),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(bool skipPush, bool skipEnrichUrl)? sendingFailed,
    TResult? Function(bool skipPush, bool skipEnrichUrl)? updatingFailed,
    required TResult Function(
            Map<String, Object?>? set, List<String>? unset, bool skipEnrichUrl)
        partialUpdateFailed,
    TResult? Function(bool hard)? deletingFailed,
  }) {
    final failedState = this;
    return switch (failedState) {
      SendingFailed() =>
        sendingFailed?.call(failedState.skipPush, failedState.skipEnrichUrl),
      UpdatingFailed() =>
        updatingFailed?.call(failedState.skipPush, failedState.skipEnrichUrl),
      PartialUpdateFailed() => partialUpdateFailed(
          failedState.set, failedState.unset, failedState.skipEnrichUrl),
      DeletingFailed() => deletingFailed?.call(failedState.hard),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool skipPush, bool skipEnrichUrl)? sendingFailed,
    TResult Function(bool skipPush, bool skipEnrichUrl)? updatingFailed,
    required TResult Function(
            Map<String, Object?>? set, List<String>? unset, bool skipEnrichUrl)
        partialUpdateFailed,
    TResult Function(bool hard)? deletingFailed,
    required TResult orElse(),
  }) {
    final failedState = this;
    final result = switch (failedState) {
      SendingFailed() =>
        sendingFailed?.call(failedState.skipPush, failedState.skipEnrichUrl),
      UpdatingFailed() =>
        updatingFailed?.call(failedState.skipPush, failedState.skipEnrichUrl),
      PartialUpdateFailed() => partialUpdateFailed(
          failedState.set, failedState.unset, failedState.skipEnrichUrl),
      DeletingFailed() => deletingFailed?.call(failedState.hard),
    };

    return result ?? orElse();
  }

  /// @nodoc
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SendingFailed value) sendingFailed,
    required TResult Function(UpdatingFailed value) updatingFailed,
    required TResult Function(PartialUpdateFailed value) partialUpdateFailed,
    required TResult Function(DeletingFailed value) deletingFailed,
  }) {
    final failedState = this;
    return switch (failedState) {
      SendingFailed() => sendingFailed(failedState),
      UpdatingFailed() => updatingFailed(failedState),
      PartialUpdateFailed() => partialUpdateFailed(failedState),
      DeletingFailed() => deletingFailed(failedState),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SendingFailed value)? sendingFailed,
    TResult? Function(UpdatingFailed value)? updatingFailed,
    TResult? Function(PartialUpdateFailed value)? partialUpdateFailed,
    TResult? Function(DeletingFailed value)? deletingFailed,
  }) {
    final failedState = this;
    return switch (failedState) {
      SendingFailed() => sendingFailed?.call(failedState),
      UpdatingFailed() => updatingFailed?.call(failedState),
      PartialUpdateFailed() => partialUpdateFailed?.call(failedState),
      DeletingFailed() => deletingFailed?.call(failedState),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SendingFailed value)? sendingFailed,
    TResult Function(UpdatingFailed value)? updatingFailed,
    TResult Function(PartialUpdateFailed value)? partialUpdateFailed,
    TResult Function(DeletingFailed value)? deletingFailed,
    required TResult orElse(),
  }) {
    final failedState = this;
    final result = switch (failedState) {
      SendingFailed() => sendingFailed?.call(failedState),
      UpdatingFailed() => updatingFailed?.call(failedState),
      PartialUpdateFailed() => partialUpdateFailed?.call(failedState),
      DeletingFailed() => deletingFailed?.call(failedState),
    };

    return result ?? orElse();
  }
}

// coverage:ignore-end
