import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template channelDetailAction}
/// A sealed class that represents the actions a user can pick from a
/// [ChannelDetailSheet].
///
/// Mirrors the dispatch pattern used by `StreamMessageWidget` and
/// `MessageAction`: the sheet pops itself with one of these values when an
/// action is tapped, and callers switch on the returned action to decide
/// what to do.
/// {@endtemplate}
sealed class ChannelDetailAction {
  /// {@macro channelDetailAction}
  const ChannelDetailAction();
}

/// User tapped _View Info_ — caller is expected to navigate to the chat or
/// group info screen.
final class ViewChannelInfo extends ChannelDetailAction {
  /// {@macro channelDetailAction}
  const ViewChannelInfo();
}

/// User tapped _Pin Chat_ — caller is expected to invoke [Channel.pin].
final class PinChannel extends ChannelDetailAction {
  /// {@macro channelDetailAction}
  const PinChannel();
}

/// User tapped _Unpin Chat_ — caller is expected to invoke [Channel.unpin].
final class UnpinChannel extends ChannelDetailAction {
  /// {@macro channelDetailAction}
  const UnpinChannel();
}

/// User tapped _Leave Group_ — caller is expected to confirm and remove the
/// current user from the channel members.
final class LeaveChannel extends ChannelDetailAction {
  /// {@macro channelDetailAction}
  const LeaveChannel();
}

/// User tapped _Delete Group_ / _Delete Conversation_ — caller is expected
/// to confirm and invoke [Channel.delete].
final class DeleteChannel extends ChannelDetailAction {
  /// {@macro channelDetailAction}
  const DeleteChannel();
}

/// {@template showChannelDetailSheet}
/// Displays a [ChannelDetailSheet] for [channel] — the redesigned long-press
/// menu surfaced from the channel list.
///
/// Resolves to the [ChannelDetailAction] the user picked, or `null` if the
/// sheet was dismissed without selecting one (drag-down, scrim tap, back
/// gesture). Callers should switch on the returned action.
///
/// Built on top of [showStreamSheet] so it inherits the design system's drag
/// handle, scrim, and drag-to-dismiss interaction.
/// {@endtemplate}
Future<ChannelDetailAction?> showChannelDetailSheet({
  required BuildContext context,
  required Channel channel,
}) {
  return showStreamSheet<ChannelDetailAction>(
    context: context,
    isDismissible: true,
    builder: (_, _) => StreamChannel(
      channel: channel,
      child: ChannelDetailSheet(channel: channel),
    ),
  );
}

/// {@template channelDetailSheet}
/// A bottom sheet that displays detailed information and actions for a
/// [Channel].
///
/// Composed of:
///
///  * A header with the channel avatar, name (with mute / pin state
///    indicators), and member count.
///  * A list of channel actions — _View Info_, _Pin / Unpin Chat_,
///    _Leave Group_, _Delete Group / Conversation_.
///
/// Tapping an action pops the route with the corresponding
/// [ChannelDetailAction] subtype; the caller is responsible for performing
/// the action. Destructive actions (leave / delete) are styled via a local
/// [StreamListTileTheme] override that swaps the icon and title colors to
/// [StreamColorScheme.accentError].
///
/// Designed to be hosted inside a [showStreamSheet] route — see
/// [showChannelDetailSheet] for the convenience entry point.
/// {@endtemplate}
class ChannelDetailSheet extends StatelessWidget {
  /// {@macro channelDetailSheet}
  const ChannelDetailSheet({super.key, required this.channel});

  /// The channel whose information and actions are displayed.
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final icons = context.streamIcons;

    final currentUserId = StreamChat.of(context).currentUser?.id;
    final isOneToOne = channel.isDistinct && channel.memberCount == 2;
    final canLeave = currentUserId != null && !isOneToOne && channel.canLeaveChannel;
    final canDelete = channel.canDeleteChannel;

    void emit(ChannelDetailAction action) => Navigator.of(context).pop(action);

    return SafeArea(
      top: false,
      child: IconTheme.merge(
        data: const IconThemeData(size: 20),
        child: Column(
          mainAxisSize: .min,
          children: [
            Padding(
              padding: .symmetric(horizontal: spacing.sm, vertical: spacing.xl),
              child: _ChannelDetailHeader(channel: channel),
            ),
            Padding(
              padding: .symmetric(horizontal: spacing.xxs),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ChannelDetailAction(
                    icon: icons.info,
                    label: 'View Info',
                    onTap: () => emit(const ViewChannelInfo()),
                  ),
                  BetterStreamBuilder<bool>(
                    stream: channel.isPinnedStream,
                    initialData: channel.isPinned,
                    builder: (context, isPinned) => _ChannelDetailAction(
                      icon: isPinned ? icons.unpin : icons.pin,
                      label: isPinned ? 'Unpin Chat' : 'Pin Chat',
                      onTap: () => emit(
                        isPinned ? const UnpinChannel() : const PinChannel(),
                      ),
                    ),
                  ),
                  if (canLeave)
                    _ChannelDetailAction(
                      icon: icons.leave,
                      label: 'Leave Group',
                      destructive: true,
                      onTap: () => emit(const LeaveChannel()),
                    ),
                  if (canDelete)
                    _ChannelDetailAction(
                      icon: icons.delete,
                      label: isOneToOne ? 'Delete Conversation' : 'Delete Group',
                      destructive: true,
                      onTap: () => emit(const DeleteChannel()),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The header row of the [ChannelDetailSheet] — channel avatar on the left,
/// channel name (with mute / pin state) and member count on the right.
class _ChannelDetailHeader extends StatelessWidget {
  const _ChannelDetailHeader({required this.channel});

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    return Row(
      spacing: spacing.sm,
      crossAxisAlignment: .center,
      children: [
        StreamChannelAvatar(channel: channel, size: .lg),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: spacing.xxs,
            children: [
              _ChannelDetailHeaderTitle(channel: channel),
              StreamChannelInfo(
                channel: channel,
                showTypingIndicator: false,
                textStyle: textTheme.captionDefault.copyWith(
                  color: colorScheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The title row inside [_ChannelDetailHeader] — channel name followed by
/// optional mute and pin state-indicator icons.
class _ChannelDetailHeaderTitle extends StatelessWidget {
  const _ChannelDetailHeaderTitle({required this.channel});

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final icons = context.streamIcons;

    return Row(
      mainAxisSize: .min,
      spacing: spacing.xs,
      children: [
        Flexible(
          child: StreamChannelName(
            channel: channel,
            textStyle: textTheme.headingSm.copyWith(
              color: colorScheme.textPrimary,
            ),
          ),
        ),
        Row(
          mainAxisSize: .min,
          spacing: spacing.xxs,
          children: [
            BetterStreamBuilder<bool>(
              stream: channel.isMutedStream,
              initialData: channel.isMuted,
              builder: (context, isMuted) {
                if (!isMuted) return const SizedBox.shrink();
                return Icon(icons.mute, color: colorScheme.textPrimary);
              },
            ),
            BetterStreamBuilder<bool>(
              stream: channel.isPinnedStream,
              initialData: channel.isPinned,
              builder: (context, isPinned) {
                if (!isPinned) return const SizedBox.shrink();
                return Icon(icons.pin, color: colorScheme.textPrimary);
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// A single tappable action row inside the [ChannelDetailSheet].
///
/// Wraps [StreamListTile] so all theming (typography, padding, ink effects,
/// disabled / selected state colors) flows from [StreamListTileTheme]. When
/// [destructive] is true, a local [StreamListTileTheme] override paints the
/// icon and title with [StreamColorScheme.accentError].
class _ChannelDetailAction extends StatelessWidget {
  const _ChannelDetailAction({
    required this.icon,
    required this.label,
    this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;

    return StreamListTileTheme(
      data: StreamListTileThemeData(
        iconColor: destructive ? .all(colorScheme.accentError) : null,
        titleColor: destructive ? .all(colorScheme.accentError) : null,
        minTileHeight: 44, // Matches the design's tap target size for action rows
        contentPadding: .symmetric(horizontal: spacing.sm),
      ),
      child: StreamListTile(
        leading: Icon(icon),
        title: Text(label),
        onTap: onTap,
      ),
    );
  }
}
