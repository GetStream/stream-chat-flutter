import 'package:flutter/widgets.dart';
import 'package:native_context_menu/native_context_menu.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

///
class PinMessageMenuItem extends MenuItem {
  ///
  PinMessageMenuItem({
    String title = 'Pin Message',
    required this.pinned,
    required this.context,
    required this.message,
  }) : super(title: title);

  ///
  final bool pinned;

  ///
  final BuildContext context;

  ///
  final Message message;

  @override
  VoidCallback? get onSelected => () async {
    final channel = StreamChannel.of(context).channel;

    try {
      if (!pinned) {
        await channel.pinMessage(message);
      } else {
        await channel.unpinMessage(message);
      }
    } catch (e) {

    }
  };
}
