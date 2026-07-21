import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamBackButton}
/// A custom back button implementation
/// {@endtemplate}
class StreamBackButton extends StatelessWidget {
  /// {@macro streamBackButton}
  const StreamBackButton({
    super.key,
    this.onPressed,
    @Deprecated(
      "Use 'unreadIndicator: StreamUnreadIndicator()' instead. "
      'This will be removed in a future version.',
    )
    this.showUnreadCount = false,
    @Deprecated(
      "Use 'unreadIndicator: StreamUnreadIndicator.channels(cid: cid)' instead. "
      'This will be removed in a future version.',
    )
    this.channelId,
    this.unreadIndicator,
  });

  /// Callback for when button is pressed
  final VoidCallback? onPressed;

  /// Show unread count
  @Deprecated(
    "Use 'unreadIndicator: StreamUnreadIndicator()' instead. "
    'This will be removed in a future version.',
  )
  final bool showUnreadCount;

  /// Channel ID used to retrieve unread count
  @Deprecated(
    "Use 'unreadIndicator: StreamUnreadIndicator.channels(cid: cid)' instead. "
    'This will be removed in a future version.',
  )
  final String? channelId;

  /// The unread badge overlaid on the top-end corner of the button.
  ///
  /// Typically a [StreamUnreadIndicator]. The badge hides itself when its
  /// count is zero.
  final Widget? unreadIndicator;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final backTooltip = localizations.backButtonTooltip;

    final iconData = switch (Theme.of(context).platform) {
      .iOS || .macOS => context.streamIcons.chevronLeft,
      _ => context.streamIcons.arrowLeft,
    };

    Widget button = StreamButton.icon(
      type: .ghost,
      size: .medium,
      style: .secondary,
      tooltip: backTooltip,
      icon: Icon(iconData),
      onPressed: () {
        if (onPressed case final onPressed?) {
          return onPressed();
        }

        Navigator.maybePop(context);
      },
    );

    if (_effectiveUnreadIndicator case final indicator?) {
      // The indicator is childless here, so it renders only the bare badge
      // (or nothing when the count is zero). Overlay it on the top-end corner
      // of the button.
      button = Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.none,
              alignment: AlignmentDirectional.topEnd,
              child: indicator,
            ),
          ),
        ],
      );
    }

    return button;
  }

  Widget? get _effectiveUnreadIndicator {
    if (unreadIndicator case final effective?) return effective;
    if (!showUnreadCount) return null;
    return switch (channelId) {
      final cid? => StreamUnreadIndicator.channels(cid: cid),
      _ => const StreamUnreadIndicator(),
    };
  }
}
