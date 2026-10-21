import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_delivery.freezed.dart';

/// A delivery receipt for a message in a channel.
///
/// It tells the sender that the current user received the message.
///
/// See also:
///
///  * [StreamChatClient.markChannelsDelivered], which sends receipts.
///  * [ChannelDeliveryReporter], which sends them for loaded channels.
@freezed
class MessageDelivery with _$MessageDelivery {
  /// Creates a delivery receipt for a message.
  const MessageDelivery({
    required this.channelCid,
    required this.messageId,
  });

  /// The cid of the message's channel, such as `messaging:general`.
  @override
  final String channelCid;

  /// The id of the message received.
  @override
  final String messageId;
}
