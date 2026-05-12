import 'package:flutter/material.dart';
import 'package:sample_app/utils/client_extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template channelDetailAction}
/// A sealed class that represents the actions a user can pick from a
/// [ChannelDetailSheet].
///
/// The sheet pops itself with one of these values when an action is tapped,
/// and callers switch on the returned action to decide what to do.
/// {@endtemplate}
sealed class ChannelDetailAction {
  /// {@macro channelDetailAction}
  const ChannelDetailAction();
}

/// User tapped _View Info_ — caller is expected to push the chat or group
/// info screen depending on whether [user] is set.
///
/// On 1-1 channels, [user] carries the other member; the caller pushes
/// `ChatInfoScreen` for that user. On group channels, [user] is `null` and
/// the caller pushes `GroupInfoScreen`.
final class ViewChannelInfo extends ChannelDetailAction {
  /// {@macro channelDetailAction}
  const ViewChannelInfo({this.user});

  /// The other member of the 1-1 channel, or `null` for group channels.
  final User? user;
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

/// User tapped _Mute User_ — caller is expected to invoke
/// [StreamChatClient.muteUser] for [user].
final class MuteChannelMember extends ChannelDetailAction {
  /// {@macro channelDetailAction}
  const MuteChannelMember({required this.user});

  /// The mute target — the other member of the 1-1 channel.
  final User user;
}

/// User tapped _Unmute User_ — caller is expected to invoke
/// [StreamChatClient.unmuteUser] for [user].
final class UnmuteChannelMember extends ChannelDetailAction {
  /// {@macro channelDetailAction}
  const UnmuteChannelMember({required this.user});

  /// The unmute target — the other member of the 1-1 channel.
  final User user;
}

/// User tapped _Block User_ — caller is expected to invoke
/// [StreamChatClient.blockUser] for [user].
///
/// Block is one-way from this sheet: blocked users' channels are filtered out
/// of the channel list, so the sheet can never re-open for an already-blocked
/// user. Unblock lives on a different surface (e.g. blocked-users settings).
final class BlockChannelMember extends ChannelDetailAction {
  /// {@macro channelDetailAction}
  const BlockChannelMember({required this.user});

  /// The block target — the other member of the 1-1 channel.
  final User user;
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
///    _Mute / Unmute User_, _Block / Unblock User_ (1-1 only),
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
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;

    final client = StreamChat.of(context).client;
    final currentUserId = client.state.currentUser?.id;

    final isOneToOne = channel.isOneToOne;
    final canLeave = !isOneToOne && channel.canLeaveChannel;
    final canDelete = channel.canDeleteChannel;

    // For 1-1 channels, mute/block actions target the other member.
    final channelMembers = channel.state?.members ?? [];
    final otherUser = isOneToOne ? channelMembers.firstWhere((m) => m.userId != currentUserId).user : null;

    void emit(ChannelDetailAction action) => Navigator.of(context).pop(action);

    return SafeArea(
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
                    icon: Icon(icons.info),
                    label: const Text('View Info'),
                    onTap: () => emit(ViewChannelInfo(user: otherUser)),
                  ),
                  BetterStreamBuilder<bool>(
                    stream: channel.isPinnedStream,
                    initialData: channel.isPinned,
                    builder: (context, isPinned) => _ChannelDetailAction(
                      icon: Icon(isPinned ? icons.unpin : icons.pin),
                      label: Text(isPinned ? 'Unpin Chat' : 'Pin Chat'),
                      onTap: () => emit(isPinned ? const UnpinChannel() : const PinChannel()),
                    ),
                  ),
                  if (otherUser != null) ...[
                    BetterStreamBuilder<bool>(
                      stream: client.userMutedStream(otherUser.id),
                      initialData: client.isUserMuted(otherUser.id),
                      builder: (context, isMuted) => _ChannelDetailAction(
                        icon: Icon(isMuted ? icons.audio : icons.mute),
                        label: Text(isMuted ? 'Unmute User' : 'Mute User'),
                        onTap: () => emit(
                          isMuted ? UnmuteChannelMember(user: otherUser) : MuteChannelMember(user: otherUser),
                        ),
                      ),
                    ),
                    _ChannelDetailAction(
                      icon: Icon(icons.noSign),
                      label: const Text('Block User'),
                      onTap: () => emit(BlockChannelMember(user: otherUser)),
                    ),
                  ],
                  if (canLeave)
                    _ChannelDetailAction(
                      icon: Icon(icons.leave),
                      label: const Text('Leave Group'),
                      destructive: true,
                      onTap: () => emit(const LeaveChannel()),
                    ),
                  if (canDelete)
                    _ChannelDetailAction(
                      icon: Icon(icons.delete),
                      label: Text(isOneToOne ? 'Delete Chat' : 'Delete Group'),
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

  final Widget icon;
  final Widget label;
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
        leading: icon,
        title: label,
        onTap: onTap,
      ),
    );
  }
}
