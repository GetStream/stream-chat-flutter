import 'package:flutter/material.dart';
import 'package:sample_app/pages/channel_file_display_screen.dart';
import 'package:sample_app/pages/channel_media_display_screen.dart';
import 'package:sample_app/pages/pinned_messages_screen.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Detail screen for a group channel.
///
/// Surfaces the group avatar, name, member count, plus channel content
/// shortcuts (pinned messages, media, files), a preview of the member list
/// (with _Add_ / _View all_ affordances), and conversation actions
/// (mute, leave) — see Figma frame `8779:381156`.
class GroupInfoScreen extends StatelessWidget {
  /// Creates a [GroupInfoScreen].
  const GroupInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final channel = StreamChannel.of(context).channel;

    return Scaffold(
      backgroundColor: colorScheme.backgroundApp,
      appBar: StreamAppBar(
        title: const Text('Group Info'),
        actions: [
          if (channel.canUpdateChannel)
            Padding(
              padding: EdgeInsetsDirectional.only(end: spacing.sm),
              child: StreamButton(
                type: .outline,
                style: .secondary,
                size: .small,
                onPressed: () => _showNotImplementedSnack(
                  context,
                  'Editing the group',
                ),
                child: const Text('Edit'),
              ),
            ),
        ],
      ),
      // Action / chevron icons share a uniform 20px size — set once at the
      // top of the body so individual rows stay style-free.
      body: IconTheme.merge(
        data: const IconThemeData(size: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _GroupInfoHeader(),
              Padding(
                padding: EdgeInsets.fromLTRB(spacing.md, 0, spacing.md, spacing.md),
                child: const _MediaSection(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(spacing.md, 0, spacing.md, spacing.md),
                child: const _MembersSection(),
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

/// Hero header — channel avatar group, channel name with optional inline
/// mute state icon, and a "X members · Y online" subtitle driven by
/// [StreamChannelInfo].
class _GroupInfoHeader extends StatelessWidget {
  const _GroupInfoHeader();

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
          StreamChannelAvatar(channel: channel, size: .xxl),
          SizedBox(height: spacing.sm),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: spacing.xxs,
            children: [
              Flexible(
                child: StreamChannelName(
                  channel: channel,
                  textStyle: textTheme.headingLg.copyWith(color: colorScheme.textPrimary),
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
          StreamChannelInfo(
            channel: channel,
            showTypingIndicator: false,
            textStyle: textTheme.bodyDefault.copyWith(color: colorScheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// Card grouping the read-only channel-content shortcuts.
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

/// Members card — header with count and _Add_ affordance, the first
/// [_kPreviewLimit] members, and a _View all_ footer when the channel has
/// more.
const _kPreviewLimit = 5;

class _MembersSection extends StatelessWidget {
  const _MembersSection();

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    final currentUserId = StreamChat.of(context).currentUser?.id;

    return BetterStreamBuilder<List<Member>>(
      stream: channel.state!.membersStream,
      initialData: channel.state!.members,
      builder: (context, members) {
        // Sort the current user to the top so the "You" row is always the
        // first member rendered, matching the Figma.
        final sorted = [...members]
          ..sort((a, b) {
            if (a.userId == currentUserId) return -1;
            if (b.userId == currentUserId) return 1;
            return 0;
          });
        final preview = sorted.take(_kPreviewLimit).toList();
        final overflow = sorted.length - preview.length;

        return _Section(
          children: [
            _MembersHeader(count: members.length),
            for (final member in preview) _MemberTile(member: member, isCurrentUser: member.userId == currentUserId),
            if (overflow > 0)
              _ViewAllTile(
                onTap: () => _showNotImplementedSnack(context, 'The all-members sheet'),
              ),
          ],
        );
      },
    );
  }
}

/// Header row at the top of [_MembersSection] — shows the total member
/// count on the left and an _Add_ button on the right (when the current
/// user can update the channel).
class _MembersHeader extends StatelessWidget {
  const _MembersHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final channel = StreamChannel.of(context).channel;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$count members',
              style: textTheme.bodyDefault.copyWith(color: colorScheme.textPrimary),
            ),
          ),
          if (channel.canUpdateChannel)
            StreamButton(
              type: .outline,
              style: .secondary,
              size: .small,
              onPressed: () => _showNotImplementedSnack(context, 'Adding members'),
              child: const Text('Add'),
            ),
        ],
      ),
    );
  }
}

/// A single member row — avatar with online indicator, name (with "You"
/// substitution for the current user), online / last-seen subtitle, and an
/// optional _Admin_ trailing label for moderators / owners.
class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member, required this.isCurrentUser});

  final Member member;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final user = member.user;
    if (user == null) return const SizedBox.shrink();

    final name = isCurrentUser ? 'You' : user.name;
    final isAdmin = const {'admin', 'channel_moderator', 'owner'}.contains(member.channelRole);

    return StreamListTile(
      leading: StreamUserAvatar(
        user: user,
        size: .md,
        showOnlineIndicator: user.online,
      ),
      title: Text(name),
      subtitle: Text(_userStatus(user)),
      trailing: isAdmin
          ? Text(
              'Admin',
              style: textTheme.captionDefault.copyWith(color: colorScheme.textTertiary),
            )
          : null,
    );
  }

  String _userStatus(User user) {
    if (user.online) return 'Online';
    final lastActive = user.lastActive;
    if (lastActive == null) return 'Offline';
    return 'Last seen ${Jiffy.parseFromDateTime(lastActive).fromNow()}';
  }
}

/// Footer row at the bottom of the members card — full-width tappable
/// _View all_ that pushes the all-members sheet.
class _ViewAllTile extends StatelessWidget {
  const _ViewAllTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colorScheme.borderSubtle)),
        ),
        padding: EdgeInsets.symmetric(vertical: spacing.sm),
        alignment: Alignment.center,
        child: Text(
          'View all',
          style: textTheme.headingSm.copyWith(color: colorScheme.textPrimary),
        ),
      ),
    );
  }
}

/// Card grouping the conversation-level actions — mute and leave. Group
/// channels intentionally don't expose a destructive delete here; that
/// action lives on the channel-list long-press sheet.
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
            label: isMuted ? 'Unmute Group' : 'Mute Group',
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
        if (channel.canLeaveChannel)
          _Tile(
            icon: icons.leave,
            label: 'Leave Group',
            destructive: true,
            onTap: () => _confirmLeave(context),
          ),
      ],
    );
  }

  Future<void> _confirmLeave(BuildContext context) async {
    final navigator = Navigator.of(context);
    final channel = StreamChannel.of(context).channel;
    final currentUserId = StreamChat.of(context).currentUser?.id;
    if (currentUserId == null) return;

    final confirmed = await _showConfirmationDialog(
      context: context,
      title: 'Leave group',
      content: 'Are you sure you want to leave this group?',
      confirmLabel: 'Leave',
    );
    if (confirmed != true) return;

    await channel.removeMembers([currentUserId]);
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

/// A single row inside a [_Section] — leading icon, label, optional
/// trailing widget. Defaults the trailing to a chevron when [onTap] is
/// provided and no explicit [trailing] is passed. [destructive] paints
/// both the icon and the label with [StreamColorScheme.accentError] via a
/// local [StreamListTileTheme] override.
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

void _showNotImplementedSnack(BuildContext context, String feature) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('$feature is not implemented yet.')),
  );
}

// Stream-styled confirmation dialog with a destructive primary action.
//
// Mirrors the dialog pattern used by the poll interactor and the
// SDK-internal `StreamMessageActionConfirmationModal` — a Material
// [AlertDialog] with two ghost [StreamButton]s, secondary for cancel and
// destructive for confirm. Resolves to `true` on confirm, `false` on
// cancel, `null` on dismiss.
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
