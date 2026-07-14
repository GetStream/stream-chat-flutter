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
      "Use 'unreadCount: StreamBackButtonUnreadCount.total()' instead. "
      'This will be removed in a future version.',
    )
    this.showUnreadCount = false,
    @Deprecated(
      "Use 'unreadCount: StreamBackButtonUnreadCount.channel(cid)' instead. "
      'This will be removed in a future version.',
    )
    this.channelId,
    this.unreadCount,
  });

  /// Callback for when button is pressed
  final VoidCallback? onPressed;

  /// Show unread count
  @Deprecated(
    "Use 'unreadCount: StreamBackButtonUnreadCount.total()' instead. "
    'This will be removed in a future version.',
  )
  final bool showUnreadCount;

  /// Channel ID used to retrieve unread count
  @Deprecated(
    "Use 'unreadCount: StreamBackButtonUnreadCount.channel(cid)' instead. "
    'This will be removed in a future version.',
  )
  final String? channelId;

  /// The unread count configuration for the back button.
  final StreamBackButtonUnreadCount? unreadCount;

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

    if (_effectiveUnreadCount case final effectiveUnreadCount?) {
      button = switch (effectiveUnreadCount) {
        _TotalUnreadCount(:final excludeCid) => StreamUnreadIndicator(
          offset: .zero,
          excludeCid: excludeCid,
          child: button,
        ),
        _ChannelUnreadCount(:final cid) => StreamUnreadIndicator.channels(
          offset: .zero,
          cid: cid,
          child: button,
        ),
      };
    }

    return button;
  }

  StreamBackButtonUnreadCount? get _effectiveUnreadCount {
    if (unreadCount case final effective?) return effective;
    if (!showUnreadCount) return null;
    return switch (channelId) {
      final cid? => StreamBackButtonUnreadCount.channel(cid),
      _ => const StreamBackButtonUnreadCount.total(),
    };
  }
}

/// Configures the unread badge on a [StreamBackButton].
sealed class StreamBackButtonUnreadCount {
  const StreamBackButtonUnreadCount();

  /// Shows the total unread message count across all channels.
  ///
  /// Set [excludeCid] to omit a channel's unread messages from the total -
  /// for example, the currently open channel.
  const factory StreamBackButtonUnreadCount.total({String? excludeCid}) = _TotalUnreadCount;

  /// Shows the unread message count of the channel identified by [cid].
  const factory StreamBackButtonUnreadCount.channel(String cid) = _ChannelUnreadCount;
}

final class _TotalUnreadCount extends StreamBackButtonUnreadCount {
  const _TotalUnreadCount({this.excludeCid});

  final String? excludeCid;
}

final class _ChannelUnreadCount extends StreamBackButtonUnreadCount {
  const _ChannelUnreadCount(this.cid);

  final String cid;
}
