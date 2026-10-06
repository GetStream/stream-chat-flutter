import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_delivery.freezed.dart';

/// A delivery receipt for a message in a channel.
///
/// Used to acknowledge that the current user has received a message,
/// notifying the sender that their message was delivered.
@freezed
class MessageDelivery with _$MessageDelivery {
  /// Creates a delivery receipt for a message.
  const MessageDelivery({
    required this.channelCid,
    required this.messageId,
  });

  /// The cid of the channel that contains the message, such as `messaging:general`.
  @override
  final String channelCid;

  /// The id of the message received.
  @override
  final String messageId;
}
