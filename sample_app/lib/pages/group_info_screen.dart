import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/pages/channel_file_display_screen.dart';
import 'package:sample_app/pages/channel_media_display_screen.dart';
import 'package:sample_app/pages/pinned_messages_screen.dart';
import 'package:sample_app/widgets/add_members_sheet.dart';
import 'package:sample_app/widgets/all_members_sheet.dart';
import 'package:sample_app/widgets/edit_group_sheet.dart';
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

    return StreamScaffold(
      backgroundColor: colorScheme.backgroundApp,
      appBar: StreamAppBar(
        title: const Text('Group Info'),
        trailing: switch (channel.canUpdateChannel) {
          true => StreamButton(
            type: .outline,
            style: .secondary,
            size: .small,
            onPressed: () => showEditGroupSheet(context, channel),
            child: const Text('Edit'),
          ),
          false => null,
        },
      ),
      // Action / chevron icons share a uniform 20px size — set once at the
      // top of the body so individual rows stay style-free.
      body: Builder(
        builder: (context) {
          final topInset = StreamScaffoldInsets.maybeOf(context)?.topPadding ?? 0.0;
          return IconTheme.merge(
            data: const IconThemeData(size: 20),
            child: SingleChildScrollView(
              padding: .directional(
                top: spacing.xxl + topInset,
                bottom: spacing.xxxl,
                start: spacing.md,
                end: spacing.md,
              ),
              child: Column(
                mainAxisSize: .min,
                children: [
                  const _GroupInfoHeader(),
                  SizedBox(height: spacing.xxl),
                  const _MediaSection(),
                  SizedBox(height: spacing.md),
                  const _MembersSection(),
                  SizedBox(height: spacing.md),
                  const _ActionsSection(),
                ],
              ),
            ),
          );
        },
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

    return Column(
      children: [
        StreamChannelAvatar(channel: channel, size: .xxl),
        SizedBox(height: spacing.md),
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
        SizedBox(height: spacing.xs),
        StreamChannelInfo(
          channel: channel,
          showTypingIndicator: false,
          textStyle: textTheme.captionDefault.copyWith(color: colorScheme.textSecondary),
        ),
      ],
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
          icon: Icon(icons.pin),
          label: const Text('Pinned Messages'),
          trailing: Icon(icons.chevronRight),
          onTap: () => _push(context, const PinnedMessagesScreen()),
        ),
        _Tile(
          icon: Icon(icons.image),
          label: const Text('Photos & Videos'),
          trailing: Icon(icons.chevronRight),
          onTap: () => _push(context, const ChannelMediaDisplayScreen()),
        ),
        _Tile(
          icon: Icon(icons.folder),
          label: const Text('Files'),
          trailing: Icon(icons.chevronRight),
          onTap: () => _push(context, const ChannelFileDisplayScreen()),
        ),
      ],
    );
  }

  void _push(BuildContext context, Widget destination) {
    final channel = StreamChannel.of(context).channel;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StreamChannel.value(channel: channel, child: destination),
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
        final sorted = [...members].sorted((a, b) {
          if (a.userId == currentUserId) return -1;
          if (b.userId == currentUserId) return 1;
          return 0;
        });

        final preview = sorted.take(_kPreviewLimit).toList();
        final overflow = sorted.length - preview.length;

        final spacing = context.streamSpacing;
        final colorScheme = context.streamColorScheme;

        return _Section(
          children: [
            _MembersHeader(count: members.length),
            for (final member in preview)
              ChannelMemberTile(
                member: member,
                isCurrentUser: member.userId == currentUserId,
                onTap: switch (member.userId) {
                  final id? when id != currentUserId => () {
                    final user = member.user;
                    if (user != null) openContactDetail(context, user);
                  },
                  _ => null,
                },
              ),
            if (overflow > 0) ...[
              SizedBox(height: spacing.sm),
              Divider(height: 1, color: colorScheme.borderDefault),
              StreamButton(
                type: .ghost,
                style: .secondary,
                size: .small,
                onPressed: () => showAllMembersSheet(context, channel),
                child: const Text('View all'),
              ),
            ],
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
      padding: .symmetric(horizontal: spacing.md),
      // Pin a min height so the header stays the same size whether or not
      // the _Add_ button is rendered — without it, hiding the button
      // (distinct channels, insufficient permissions) collapses the row to
      // the title's natural text height.
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$count members',
                style: textTheme.headingSm.copyWith(color: colorScheme.textPrimary),
              ),
            ),
            // Hide the affordance when the channel is distinct (1:1) — the
            // API rejects member changes on those, so showing a tappable
            // button that always errors is worse than no button at all.
            if (channel.canUpdateChannelMembers && !channel.isDistinct)
              StreamButton(
                type: .outline,
                style: .secondary,
                size: .small,
                onPressed: () => showAddMembersSheet(context, channel),
                child: const Text('Add'),
              ),
          ],
        ),
      ),
    );
  }
}

/// Card grouping the conversation-level actions — mute, leave, and (for
/// admins) delete. Mirrors the destructive actions exposed on the
/// channel-list long-press sheet so both surfaces stay in sync.
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
            icon: Icon(isMuted ? icons.audio : icons.mute),
            label: Text(isMuted ? 'Unmute Group' : 'Mute Group'),
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
            icon: Icon(icons.leave),
            label: const Text('Leave Group'),
            destructive: true,
            onTap: () => _confirmLeave(context),
          ),
        if (channel.canDeleteChannel)
          _Tile(
            icon: Icon(icons.delete),
            label: const Text('Delete Group'),
            destructive: true,
            onTap: () => _confirmDelete(context),
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
    // Pop every screen until we land on the channel list — going back to
    // the channel page would crash since we're no longer a member.
    navigator.popUntil((route) => route.isFirst);
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final navigator = Navigator.of(context);
    final channel = StreamChannel.of(context).channel;

    final confirmed = await _showConfirmationDialog(
      context: context,
      title: 'Delete group',
      content: 'Are you sure you want to delete this group?',
      confirmLabel: 'Delete',
    );
    if (confirmed != true) return;

    await channel.delete();
    // Pop every screen until we land on the channel list — going back to
    // the channel page would crash trying to read state from the now
    // deleted channel.
    navigator.popUntil((route) => route.isFirst);
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
    final radius = context.streamRadius;
    final spacing = context.streamSpacing;

    final colorScheme = context.streamColorScheme;

    return Material(
      color: colorScheme.backgroundSurfaceCard,
      shape: RoundedSuperellipseBorder(borderRadius: .all(radius.lg)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: .symmetric(vertical: spacing.xs, horizontal: spacing.xxs),
        child: Column(mainAxisSize: .min, children: children),
      ),
    );
  }
}

/// A single row inside a [_Section] — leading icon, label, and an optional
/// [trailing] widget. Navigation rows should pass an explicit chevron;
/// action rows that confirm or toggle in place pass [trailing] only when
/// they need a control (e.g. a switch). Setting [destructive] paints both
/// the icon and the label with [StreamColorScheme.accentError] via a local
/// [StreamListTileTheme] override.
class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.destructive = false,
  });

  final Widget icon;
  final Widget label;
  final VoidCallback? onTap;
  final Widget? trailing;
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
        trailing: trailing,
        title: label,
        onTap: onTap,
      ),
    );
  }
}

// Stream-styled confirmation dialog with a destructive primary action.
//
// Mirrors the dialog pattern used by the poll interactor and the
// SDK-internal `StreamMessageActionConfirmationModal` — a Material
// [AlertDialog] with a ghost secondary cancel and a solid destructive
// confirm. Resolves to `true` on confirm, `false` on cancel, `null` on
// dismiss.
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
          type: .solid,
          style: .destructive,
          size: .small,
          onPressed: () => Navigator.of(context).maybePop(true),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
