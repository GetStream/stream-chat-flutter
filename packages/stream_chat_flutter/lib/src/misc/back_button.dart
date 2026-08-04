import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/app_bar_behavior.dart';
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
    this.isFloating,
    Widget? unreadIndicator = _unset,
  }) : _unreadIndicator = unreadIndicator;

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

  /// Whether the button adopts its floating presentation — an outlined button
  /// instead of a ghost one.
  ///
  /// When null, falls back to [StreamAppBarStyle.behavior] from the ambient
  /// [StreamAppBarTheme], then to the ambient [StreamAppStyle].
  final bool? isFloating;

  /// The unread badge overlaid on the top-end corner of the button.
  ///
  /// Typically a [StreamUnreadIndicator]. The badge hides itself when its
  /// count is zero. Null when not explicitly set.
  Widget? get unreadIndicator => identical(_unreadIndicator, _unset) ? null : _unreadIndicator;

  final Widget? _unreadIndicator;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final backTooltip = localizations.backButtonTooltip;

    final iconData = switch (Theme.of(context).platform) {
      .iOS || .macOS => context.streamIcons.chevronLeft,
      _ => context.streamIcons.arrowLeft,
    };
    final isFloating = this.isFloating ?? isFloatingAppBar(context);

    Widget button = StreamButton.icon(
      type: isFloating ? .outline : .ghost,
      isFloating: isFloating,
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
    if (!identical(_unreadIndicator, _unset)) return _unreadIndicator;
    if (!showUnreadCount) return null;
    return switch (channelId) {
      final cid? => StreamUnreadIndicator.channels(cid: cid),
      _ => const StreamUnreadIndicator(),
    };
  }
}

class _WidgetSentinel extends Widget {
  const _WidgetSentinel();

  @override
  Element createElement() => throw StateError('_WidgetSentinel must never be built.');
}

const _unset = _WidgetSentinel();
