import 'package:json_annotation/json_annotation.dart';

part 'message_delivery_info.g.dart';

/// A delivery receipt for a message in a channel.
///
/// Used to acknowledge that the current user has received a message,
/// notifying the sender that their message was delivered.
@JsonSerializable(createFactory: false)
class MessageDeliveryInfo {
  /// Creates a delivery receipt for a message.
  const MessageDeliveryInfo({
    required this.channelCid,
    required this.messageId,
  });

  /// The channel identifier containing the message.
  @JsonKey(name: 'cid')
  final String channelCid;

  /// The identifier of the message received.
  @JsonKey(name: 'id')
  final String messageId;

  /// Converts this [MessageDeliveryInfo] to JSON.
  Map<String, dynamic> toJson() => _$MessageDeliveryInfoToJson(this);
}
