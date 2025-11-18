import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/user.dart';

part 'read.g.dart';

/// The class that defines a read event
@JsonSerializable()
class Read extends Equatable {
  /// Constructor used for json serialization
  const Read({
    required this.lastRead,
    required this.user,
    this.lastReadMessageId,
    int? unreadMessages,
    this.lastDeliveredAt,
    this.lastDeliveredMessageId,
  }) : unreadMessages = unreadMessages ?? 0;

  /// Create a new instance from a json
  factory Read.fromJson(Map<String, dynamic> json) => _$ReadFromJson(json);

  /// Date of the read event
  final DateTime lastRead;

  /// User who sent the event
  final User user;

  /// Number of unread messages
  final int unreadMessages;

  /// The id of the last read message
  final String? lastReadMessageId;

  /// Date of the last delivered message
  final DateTime? lastDeliveredAt;

  /// The id of the last delivered message
  final String? lastDeliveredMessageId;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ReadToJson(this);

  /// Creates a copy of [Read] with specified attributes overridden.
  Read copyWith({
    DateTime? lastRead,
    String? lastReadMessageId,
    User? user,
    int? unreadMessages,
    DateTime? lastDeliveredAt,
    String? lastDeliveredMessageId,
  }) {
    return Read(
      lastRead: lastRead ?? this.lastRead,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
      user: user ?? this.user,
      unreadMessages: unreadMessages ?? this.unreadMessages,
      lastDeliveredAt: lastDeliveredAt ?? this.lastDeliveredAt,
      lastDeliveredMessageId:
          lastDeliveredMessageId ?? this.lastDeliveredMessageId,
    );
  }

  /// Creates a new [Read] which is the merge of this and [other].
  Read merge(Read? other) {
    if (other == null) return this;

    return copyWith(
      lastRead: other.lastRead,
      lastReadMessageId: other.lastReadMessageId,
      user: other.user,
      unreadMessages: other.unreadMessages,
      lastDeliveredAt: other.lastDeliveredAt,
      lastDeliveredMessageId: other.lastDeliveredMessageId,
    );
  }

  @override
  List<Object?> get props => [
        lastRead,
        lastReadMessageId,
        user,
        unreadMessages,
        lastDeliveredAt,
        lastDeliveredMessageId,
      ];
}

/// Helper extension methods for [Iterable]<[Read]>.
///
/// Adds methods to easily query reads for specific users or messages.
extension ReadIterableExtension on Iterable<Read> {
  /// Returns the [Read] for the given [userId], or null if not found.
  Read? userReadOf({String? userId}) {
    if (userId == null) return null;
    return firstWhereOrNull((read) => read.user.id == userId);
  }

  /// Returns the list of [Read]s that have marked the given [message] as read.
  ///
  /// The [Read] is considered to have read the message if:
  /// - The read user is not the sender of the message.
  /// - The read's lastRead is after or equal to the message's createdAt.
  List<Read> readsOf({required Message message}) {
    final sender = message.user;
    if (sender == null) return <Read>[];

    return where((read) {
      if (read.user.id == sender.id) return false;
      if (read.lastRead.isBefore(message.createdAt)) return false;

      return true;
    }).toList();
  }

  /// Returns the list of [Read]s that have marked the given [message] as
  /// delivered.
  ///
  /// The [Read] is considered to have received the message if:
  /// - The read user is not the sender of the message.
  /// - The read contains a non-null lastDeliveredAt that is after or equal to
  ///   the message's createdAt, OR the user has already read the message.
  List<Read> deliveriesOf({required Message message}) {
    final sender = message.user;
    if (sender == null) return <Read>[];

    return where((read) {
      if (read.user.id == sender.id) return false;

      // Early check if the message is already read by the user.
      //
      // This covers the case where lastDeliveredAt is null but the message
      // has already been read.
      final lastReadAt = read.lastRead;
      if (!lastReadAt.isBefore(message.createdAt)) return true;

      final lastDeliveredAt = read.lastDeliveredAt;
      if (lastDeliveredAt == null) return false;

      if (lastDeliveredAt.isBefore(message.createdAt)) return false;

      return true;
    }).toList();
  }
}
