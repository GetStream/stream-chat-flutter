// ignore_for_file: avoid_redundant_argument_values

import 'package:stream_chat/stream_chat.dart';

/// Extension methods for reading related operations on a ChannelClientState.
extension ChannelReadHelper on ChannelClientState {
  /// Get the [Read] object for a specific user identified by [userId].
  Read? userReadOf({String? userId}) => read.userReadOf(userId: userId);

  /// Stream of [Read] object for a specific user identified by [userId].
  Stream<Read?> userReadStreamOf({String? userId}) {
    return readStream.map((read) => read.userReadOf(userId: userId));
  }

  /// Returns the list of [Read]s that have marked the given [msg] as read.
  ///
  /// The [Read] is considered to have read the message if:
  /// - The read user is not the sender of the message.
  /// - The read's lastRead is after or equal to the message's createdAt.
  List<Read> readsOf({required Message message}) {
    return read.readsOf(message: message);
  }

  /// Stream of list of [Read]s that have marked the given [msg] as read.
  ///
  /// The [Read] is considered to have read the message if:
  /// - The read user is not the sender of the message.
  /// - The read's lastRead is after or equal to the message's createdAt.
  Stream<List<Read>> readsOfStream({required Message message}) {
    return readStream.map((read) => read.readsOf(message: message));
  }

  /// Returns the list of [Read]s that have marked the given [message] as
  /// delivered.
  ///
  /// The [Read] is considered to have delivered the message if:
  /// - The read user is not the sender of the message.
  /// - The read contains a non-null lastDeliveredAt.
  /// - The read's lastDeliveredAt is after or equal to the message's createdAt.
  List<Read> deliveriesOf({required Message message}) {
    return read.deliveriesOf(message: message);
  }

  /// Stream of list of [Read]s that have marked the given [message] as
  /// delivered.
  ///
  /// The [Read] is considered to have delivered the message if:
  /// - The read user is not the sender of the message.
  /// - The read contains a non-null lastDeliveredAt.
  /// - The read's lastDeliveredAt is after or equal to the message's createdAt.
  Stream<List<Read>> deliveriesOfStream({required Message message}) {
    return readStream.map((read) => read.deliveriesOf(message: message));
  }
}
