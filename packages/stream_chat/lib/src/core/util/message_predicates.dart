import 'package:stream_chat/src/core/models/message.dart';

/// Predicates over a [Message] used by the channel state management.
extension MessagePredicates on Message {
  /// Whether the message is shown in the channel message list.
  ///
  /// Non-thread messages always are; thread replies only when explicitly
  /// marked to also show in the channel.
  bool get isShownInChannel {
    // Non-thread messages are always shown in the channel.
    if (parentId == null) return true;

    // Thread messages are only shown if explicitly marked.
    return showInChannel == true;
  }

  /// Whether the message represents a currently valid pin.
  ///
  /// Returns `false` if the message is deleted, not pinned, or its
  /// [Message.pinExpires] has passed.
  bool get hasValidPin {
    // If the message is deleted, the pin is not valid.
    if (isDeleted) return false;

    // If the message is not pinned, it's not valid.
    if (pinned != true) return false;

    // If there's no expiration, the pin is valid.
    final expiresAt = pinExpires;
    if (expiresAt == null) return true;

    // If there's an expiration, check if it's still valid.
    return expiresAt.isAfter(DateTime.now());
  }
}
