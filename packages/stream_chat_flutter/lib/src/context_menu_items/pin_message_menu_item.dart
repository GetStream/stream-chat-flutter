import 'package:flutter/widgets.dart' show BuildContext, VoidCallback;
import 'package:native_context_menu/native_context_menu.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Allows a user to pin a message in a chat via context menu click.
class PinMessageMenuItem extends MenuItem {
  /// Builds a [PinMessageMenuItem].
  PinMessageMenuItem({
    String title = 'Pin Message',
    required this.pinned,
    required this.context,
    required this.message,
  }) : super(title: title);

  /// Whether [message] is currently pinned or not.
  final bool pinned;

  /// The [BuildContext] to use for pinning/unpinning the [message].
  final BuildContext context;

  /// The message to pin or unpin.
  final Message message;

  @override
  VoidCallback? get onSelected {
    return () async {
      final channel = StreamChannel.of(context).channel;

      try {
        if (!pinned) {
          await channel.pinMessage(message);
        } else {
          await channel.unpinMessage(message);
        }
      } catch (e) {
        throw Exception(e);
      }
    };
  }
}
