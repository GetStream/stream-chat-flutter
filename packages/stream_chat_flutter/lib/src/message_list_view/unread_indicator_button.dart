import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:svg_icon_widget/svg_icon_widget.dart';

typedef OnUnreadIndicatorDismissTap = Future<void> Function();
typedef OnUnreadIndicatorTap = Future<void> Function(String lastReadMessageId);
typedef UnreadIndicatorBuilder = Widget Function(
  int unreadCount,
  OnUnreadIndicatorTap onTap,
  OnUnreadIndicatorDismissTap onDismissTap,
);

class UnreadIndicatorButton extends StatelessWidget {
  const UnreadIndicatorButton({
    super.key,
    required this.onTap,
    required this.onDismissTap,
    this.unreadIndicatorBuilder,
  });

  final OnUnreadIndicatorTap onTap;

  final OnUnreadIndicatorDismissTap onDismissTap;

  final UnreadIndicatorBuilder? unreadIndicatorBuilder;

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    if (channel.state == null) return const Empty();

    return BetterStreamBuilder(
      initialData: channel.state!.currentUserRead,
      stream: channel.state!.currentUserReadStream,
      builder: (context, currentUserRead) {
        final unreadCount = currentUserRead.unreadMessages;
        if (unreadCount <= 0) return const Empty();

        if (unreadIndicatorBuilder case final builder?) {
          return builder(unreadCount, onTap, onDismissTap);
        }

        final theme = StreamChatTheme.of(context);
        final textTheme = theme.textTheme;
        final colorTheme = theme.colorTheme;

        return Material(
          elevation: 4,
          clipBehavior: Clip.antiAlias,
          color: colorTheme.textLowEmphasis,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: InkWell(
            onTap: switch (currentUserRead.lastReadMessageId) {
              final messageId? => () => onTap(messageId),
              _ => null,
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 8, 2),
              child: Row(
                children: [
                  Text(
                    context.translations.unreadCountIndicatorLabel(
                      unreadCount: unreadCount,
                    ),
                    style: textTheme.body.copyWith(color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    iconSize: 24,
                    icon: const SvgIcon(StreamSvgIcons.close),
                    padding: const EdgeInsets.all(4),
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: const Size.square(24),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: onDismissTap,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
