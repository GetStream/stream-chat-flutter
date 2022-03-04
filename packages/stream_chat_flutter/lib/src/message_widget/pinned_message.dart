import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class PinnedMessage extends StatelessWidget {
  const PinnedMessage({
    Key? key,
    required this.pinnedBy,
    required this.currentUser,
  }) : super(key: key);

  final User pinnedBy;
  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamSvgIcon.pin(
            size: 16,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            context.translations.pinnedByUserText(
              pinnedBy: pinnedBy,
              currentUser: currentUser,
            ),
            style: TextStyle(
              color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
