import 'package:flutter/material.dart';
import 'package:sample_app/pages/channel_file_display_screen.dart';
import 'package:sample_app/pages/channel_media_display_screen.dart';
import 'package:sample_app/pages/pinned_messages_screen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Detail screen for a 1:1 chat correspondence.
///
/// Surfaces the other party's avatar, name, online status, plus channel
/// shortcuts (pinned messages, media, files) and conversation actions
/// (mute, block, delete) — see Figma frame `8833:431680`.
class ChatInfoScreen extends StatelessWidget {
  /// Creates a [ChatInfoScreen].
  const ChatInfoScreen({super.key, this.user});

  /// The other user in the conversation.
  ///
  /// Required at runtime — the screen renders an [Offstage] when null so
  /// callers don't need to thread an additional null check.
  final User? user;

  @override
  Widget build(BuildContext context) {
    final user = this.user;
    if (user == null) return const Offstage();

    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;

    return Scaffold(
      backgroundColor: colorScheme.backgroundApp,
      appBar: StreamAppBar(title: const Text('Contact Info')),
      // Action / chevron icons share a uniform 20px size — set once at the
      // top of the body so individual rows stay style-free.
      body: IconTheme.merge(
        data: const IconThemeData(size: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ContactInfoHeader(user: user),
              Padding(
                padding: EdgeInsets.fromLTRB(spacing.md, 0, spacing.md, spacing.md),
                child: const _MediaSection(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.md),
                child: const _ActionsSection(),
              ),
              SizedBox(height: spacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

/// Hero header — large avatar with optional online indicator, name with an
/// inline mute-state icon, and an online / last-seen subtitle.
class _ContactInfoHeader extends StatelessWidget {
  const _ContactInfoHeader({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final channel = StreamChannel.of(context).channel;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xl,
      ),
      child: Column(
        children: [
          StreamUserAvatar(
            user: user,
            size: .xxl,
            showOnlineIndicator: user.online,
          ),
          SizedBox(height: spacing.sm),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: spacing.xxs,
            children: [
              Flexible(
                child: Text(
                  user.name,
                  style: textTheme.headingLg.copyWith(color: colorScheme.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              BetterStreamBuilder<bool>(
                stream: channel.isMutedStream,
                initialData: channel.isMuted,
                builder: (context, isMuted) {
                  if (!isMuted) return const SizedBox.shrink();
                  return Icon(
                    context.streamIcons.mute,
                    color: colorScheme.textTertiary,
                  );
                },
              ),
            ],
          ),
          SizedBox(height: spacing.xxs),
          Text(
            _onlineLabel(user),
            style: textTheme.bodyDefault.copyWith(color: colorScheme.textSecondary),
          ),
        ],
      ),
    );
  }

  String _onlineLabel(User user) {
    if (user.online) return 'Online';
    final lastActive = user.lastActive;
    if (lastActive == null) return 'Offline';
    return 'Last seen ${Jiffy.parseFromDateTime(lastActive).fromNow()}';
  }
}

/// Card grouping the read-only channel-content shortcuts (pinned, media,
/// files).
class _MediaSection extends StatelessWidget {
  const _MediaSection();

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    return _Section(
      children: [
        _Tile(
          icon: icons.pin,
          label: 'Pinned Messages',
          onTap: () => _push(context, const PinnedMessagesScreen()),
        ),
        _Tile(
          icon: icons.imageLarge,
          label: 'Photos & Videos',
          onTap: () => _push(context, const ChannelMediaDisplayScreen()),
        ),
        _Tile(
          icon: icons.file,
          label: 'Files',
          onTap: () => _push(context, const ChannelFileDisplayScreen()),
        ),
      ],
    );
  }

  void _push(BuildContext context, Widget destination) {
    final channel = StreamChannel.of(context).channel;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StreamChannel(channel: channel, child: destination),
      ),
    );
  }
}

/// Card grouping the conversation-level actions — mute, block, delete.
class _ActionsSection extends StatelessWidget {
  const _ActionsSection();

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final channel = StreamChannel.of(context).channel;

    return _Section(
      children: [
        BetterStreamBuilder<bool>(
          stream: channel.isMutedStream,
          initialData: channel.isMuted,
          builder: (context, isMuted) => _Tile(
            icon: isMuted ? icons.audio : icons.mute,
            label: isMuted ? 'Unmute User' : 'Mute User',
            trailing: StreamSwitch(
              value: isMuted,
              onChanged: (_) {
                if (isMuted) {
                  channel.unmute();
                } else {
                  channel.mute();
                }
              },
            ),
          ),
        ),
        _Tile(
          icon: icons.noSign,
          label: 'Block User',
          onTap: () => _showNotImplementedSnack(context),
        ),
        if (channel.canDeleteChannel)
          _Tile(
            icon: icons.delete,
            label: 'Delete Conversation',
            destructive: true,
            onTap: () => _confirmDelete(context),
          ),
      ],
    );
  }

  void _showNotImplementedSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Blocking users is not implemented in the sample app.')),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final navigator = Navigator.of(context);
    final channel = StreamChannel.of(context).channel;

    final confirmed = await _showConfirmationDialog(
      context: context,
      title: 'Delete conversation',
      content: 'Are you sure you want to delete this conversation?',
      confirmLabel: 'Delete',
    );
    if (confirmed != true) return;

    await channel.delete();
    if (navigator.canPop()) navigator.pop();
  }
}

/// A rounded section card that visually groups its [children] with a single
/// background colour and clipped ink ripples — matches the Figma's "soft
/// grey card" pattern shared across detail screens.
class _Section extends StatelessWidget {
  const _Section({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final radius = context.streamRadius;

    return Material(
      color: colorScheme.backgroundSurfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(radius.lg)),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

/// A single row inside a [_Section] — leading icon, label, trailing widget.
///
/// Defaults the trailing to a chevron when [onTap] is provided and no
/// explicit [trailing] was passed. Setting [destructive] paints both the
/// icon and the label with [StreamColorScheme.accentError] via a local
/// [StreamListTileTheme] override.
class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final icons = context.streamIcons;

    final effectiveTrailing =
        trailing ?? (onTap != null ? Icon(icons.chevronRight, color: colorScheme.textTertiary) : null);

    Widget tile = StreamListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: effectiveTrailing,
      onTap: onTap,
    );

    if (destructive) {
      final errorColor = WidgetStateProperty.all<Color?>(colorScheme.accentError);
      tile = StreamListTileTheme(
        data: context.streamListTileTheme.copyWith(
          iconColor: errorColor,
          titleColor: errorColor,
        ),
        child: tile,
      );
    }

    return tile;
  }
}

// Stream-styled confirmation dialog with a destructive primary action.
//
// Mirrors the dialog pattern used by the poll interactor (e.g.
// `showPollEndVoteDialog` / `showPollDeleteOptionDialog`) and the
// SDK-internal `StreamMessageActionConfirmationModal`: a Material
// [AlertDialog] with two ghost [StreamButton]s, secondary for cancel and
// destructive for confirm.
//
// Resolves to `true` on confirm, `false` on cancel, `null` on dismiss.
Future<bool?> _showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmLabel,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => _ConfirmationDialog(
      title: title,
      content: content,
      confirmLabel: confirmLabel,
    ),
  );
}

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog({
    required this.title,
    required this.content,
    required this.confirmLabel,
  });

  final String title;
  final String content;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.backgroundElevation1,
      title: Text(title),
      content: Text(content),
      actions: [
        StreamButton(
          type: .ghost,
          style: .secondary,
          size: .small,
          onPressed: () => Navigator.of(context).maybePop(false),
          child: Text(context.translations.cancelLabel),
        ),
        StreamButton(
          type: .ghost,
          style: .destructive,
          size: .small,
          onPressed: () => Navigator.of(context).maybePop(true),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
