import 'package:equatable/equatable.dart';

/// {@template pendingOperation}
/// A durable record of an optimistic mutation awaiting server confirmation
/// (e.g. a reaction added or removed while offline).
///
/// Operations are replayed at-least-once on reconnect, so the server-side
/// effect of every operation type must be idempotent.
/// {@endtemplate}
class PendingOperation extends Equatable {
  /// {@macro pendingOperation}
  const PendingOperation({
    required this.type,
    required this.payload,
    this.id,
    this.targetMessageId,
  });

  /// The database autoincrement id, assigned when the operation is stored;
  /// `null` until then.
  final int? id;

  /// The discriminator persisted in the `type` column, e.g. `reaction.add`.
  final String type;

  /// The id of the message the operation targets, if any.
  final String? targetMessageId;

  /// The operation-specific value fields, stored as JSON.
  final Map<String, dynamic> payload;

  @override
  List<Object?> get props => [
    type,
    targetMessageId,
    payload,
  ];
}
