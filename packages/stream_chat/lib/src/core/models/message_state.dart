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
    final messageState = this;
    if (messageState is! MessageFailed) return false;
    return messageState.state is UpdatingFailed;
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

  /// Sending failed state when the message fails to be sent.
  static const sendingFailed = MessageState.failed(
    state: FailedState.sendingFailed(),
  );

  /// Updating failed state when the message fails to be updated.
  static const updatingFailed = MessageState.failed(
    state: FailedState.updatingFailed(),
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
  const factory FailedState.sendingFailed() = SendingFailed;

  /// Updating failed state when the message fails to be updated.
  const factory FailedState.updatingFailed() = UpdatingFailed;

  /// Deleting failed state when the message fails to be deleted.
  const factory FailedState.deletingFailed({
    @Default(false) bool hard,
  }) = DeletingFailed;

  /// Creates a new instance from a json
  factory FailedState.fromJson(Map<String, dynamic> json) =>
      _$FailedStateFromJson(json);
}
