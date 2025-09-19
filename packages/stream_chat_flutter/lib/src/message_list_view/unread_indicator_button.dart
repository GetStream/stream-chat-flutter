import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:svg_icon_widget/svg_icon_widget.dart';

/// Function signature for handling the dismiss action on the unread indicator.
typedef OnUnreadIndicatorDismissTap = Future<void> Function();

/// Function signature for handling taps on the unread indicator.
/// [lastReadMessageId] is the ID of the last read message.
typedef OnUnreadIndicatorTap = Future<void> Function(String? lastReadMessageId);

/// Function signature for building a custom unread indicator.
///
/// [unreadCount] is the number of unread messages.
/// [onTap] is called when the indicator is tapped.
/// [onDismissTap] is called when the dismiss action is triggered.
typedef UnreadIndicatorBuilder = Widget Function(
  int unreadCount,
  OnUnreadIndicatorTap onTap,
  OnUnreadIndicatorDismissTap onDismissTap,
);

/// {@template unreadIndicatorButton}
/// A button that displays the number of unread messages in a channel.
///
/// This widget listens to the current user's read state and shows
/// an indicator when there are unread messages. Users can tap on the
/// indicator to navigate to the oldest unread message or dismiss it.
/// {@endtemplate}
class UnreadIndicatorButton extends StatelessWidget {
  /// {@macro unreadIndicatorButton}
  const UnreadIndicatorButton({
    super.key,
    required this.onTap,
    required this.onDismissTap,
    this.unreadIndicatorBuilder,
  });

  /// Callback triggered when the indicator is tapped.
  ///
  /// This is typically used to navigate to the oldest unread message.
  final OnUnreadIndicatorTap onTap;

  /// Callback triggered when the dismiss button is tapped.
  ///
  /// This is typically used to mark all messages as read.
  final OnUnreadIndicatorDismissTap onDismissTap;

  /// Optional builder for customizing the appearance of the unread indicator.
  ///
  /// If not provided, a default indicator will be built.
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
            onTap: () => onTap(currentUserRead.lastReadMessageId),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 2, 8, 2),
              child: Row(
                children: [
                  Text(
                    context.translations.unreadCountIndicatorLabel(
                      unreadCount: unreadCount,
                    ),
                    style: textTheme.body.copyWith(color: colorTheme.barsBg),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    iconSize: 24,
                    icon: const SvgIcon(StreamSvgIcons.close),
                    padding: const EdgeInsets.all(4),
                    style: IconButton.styleFrom(
                      foregroundColor: colorTheme.barsBg,
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
