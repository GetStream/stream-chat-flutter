import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template pinnedMessage}
/// A pinned message in a chat.
///
/// Used in [MessageWidgetContent]. Should not be used elsewhere.
/// {@endtemplate}
class PinnedMessage extends StatelessWidget {
  /// {@macro pinnedMessage}
  const PinnedMessage({
    super.key,
    required this.pinnedBy,
    required this.currentUser,
  });

  /// The [User] who pinned this message.
  final User pinnedBy;

  /// The current [User].
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
