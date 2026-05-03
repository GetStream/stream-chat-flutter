import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/widgets/add_members_sheet.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// ---------------------------------------------------------------------------
// Public sheets + dispatcher
// ---------------------------------------------------------------------------

/// {@template showAllMembersSheet}
/// Displays a bottom sheet listing every member of [channel] — Figma frame
/// `8833:434949`. Tapping a member stacks a [ContactDetailSheet] over this
/// one.
/// {@endtemplate}
Future<void> showAllMembersSheet(BuildContext context, Channel channel) {
  return showStreamSheet<void>(
    context: context,
    isDismissible: true,
    builder: (_, scrollController) => StreamChannel(
      channel: channel,
      child: AllMembersSheet(scrollController: scrollController),
    ),
  );
}

/// {@template showContactDetailSheet}
/// Displays a compact bottom sheet with quick actions for a single [user]
/// — Figma frame `8833:434317`.
///
/// Resolves to the [ContactDetailAction] the user picked, or `null` if
/// they dismissed it. For the common case of opening the sheet *and*
/// running the action, prefer [openContactDetail] which combines both.
/// {@endtemplate}
Future<ContactDetailAction?> showContactDetailSheet({
  required BuildContext context,
  required User user,
}) {
  return showStreamSheet<ContactDetailAction>(
    context: context,
    isDismissible: true,
    builder: (_, _) => ContactDetailSheet(user: user),
  );
}

/// Opens [showContactDetailSheet] and dispatches the action the user picks.
///
/// Mirrors the dispatch pattern used by `StreamMessageWidget._onActionTap`:
/// callers don't have to know what each action means — they just plug this
/// into a member-row's `onTap`.
Future<void> openContactDetail(BuildContext context, User user) async {
  final action = await showContactDetailSheet(context: context, user: user);
  if (action == null || !context.mounted) return;
  await _onContactDetailAction(context, user, action);
}

/// {@template contactDetailAction}
/// A sealed class representing the actions a user can pick from a
/// [ContactDetailSheet].
/// {@endtemplate}
sealed class ContactDetailAction {
  /// {@macro contactDetailAction}
  const ContactDetailAction();
}

/// User tapped _Send Direct Message_.
final class SendDirectMessage extends ContactDetailAction {
  /// {@macro contactDetailAction}
  const SendDirectMessage();
}

/// User tapped _Mute User_.
final class MuteUser extends ContactDetailAction {
  /// {@macro contactDetailAction}
  const MuteUser();
}

/// User tapped _Unmute User_.
final class UnmuteUser extends ContactDetailAction {
  /// {@macro contactDetailAction}
  const UnmuteUser();
}

/// User tapped _Block User_.
final class BlockUser extends ContactDetailAction {
  /// {@macro contactDetailAction}
  const BlockUser();
}

// ---------------------------------------------------------------------------
// AllMembersSheet
// ---------------------------------------------------------------------------

/// {@template allMembersSheet}
/// Bottom-sheet body listing every member of the enclosing channel.
///
/// Tapping a member opens a stacked [ContactDetailSheet]; the parent sheet
/// stays mounted underneath so users return to the same scroll position
/// after dismissing the detail sheet.
/// {@endtemplate}
class AllMembersSheet extends StatelessWidget {
  /// {@macro allMembersSheet}
  const AllMembersSheet({super.key, this.scrollController});

  /// Scroll controller forwarded by [showStreamSheet]; attached to the
  /// inner [ListView] so dragging the list past the top dismisses the sheet.
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final channel = StreamChannel.of(context).channel;
    final currentUserId = StreamChat.of(context).currentUser?.id;

    return BetterStreamBuilder<List<Member>>(
      stream: channel.state!.membersStream,
      initialData: channel.state!.members,
      builder: (context, members) {
        final sorted = [...members]
          ..sort((a, b) {
            if (a.userId == currentUserId) return -1;
            if (b.userId == currentUserId) return 1;
            return 0;
          });

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamSheetHeader(
              title: Text('${members.length} Members'),
              // Default `.medium` size — matches the auto-implied close
              // button on the leading side so the header stays balanced.
              trailing: StreamButton.icon(
                icon: Icon(context.streamIcons.userAdd),
                type: .outline,
                style: .secondary,
                onPressed: () => showAddMembersSheet(context, channel),
              ),
            ),
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.md,
                  vertical: spacing.xs,
                ),
                itemCount: sorted.length,
                itemBuilder: (context, index) {
                  final member = sorted[index];
                  final isCurrentUser = member.userId == currentUserId;
                  return ChannelMemberTile(
                    member: member,
                    isCurrentUser: isCurrentUser,
                    onTap: isCurrentUser
                        ? null
                        : () {
                            final user = member.user;
                            if (user != null) openContactDetail(context, user);
                          },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// ContactDetailSheet
// ---------------------------------------------------------------------------

/// {@template contactDetailSheet}
/// Compact bottom sheet showing a member's avatar / name / online status
/// followed by quick actions: _Send Direct Message_, _Mute / Unmute User_,
/// _Block User_.
///
/// Pops the route with one of [ContactDetailAction]'s subtypes when the
/// user picks an action — caller dispatches via [openContactDetail].
/// {@endtemplate}
class ContactDetailSheet extends StatelessWidget {
  /// {@macro contactDetailSheet}
  const ContactDetailSheet({super.key, required this.user});

  /// The member the sheet is showing actions for.
  final User user;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final icons = context.streamIcons;
    final client = StreamChat.of(context).client;

    void emit(ContactDetailAction action) => Navigator.of(context).pop(action);

    return SafeArea(
      top: false,
      child: IconTheme.merge(
        data: const IconThemeData(size: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.md,
                spacing.lg,
                spacing.md,
                spacing.md,
              ),
              child: _ContactDetailHeader(user: user),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: colorScheme.borderSubtle,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.xs),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ActionTile(
                    icon: icons.messageBubble,
                    label: 'Send Direct Message',
                    onTap: () => emit(const SendDirectMessage()),
                  ),
                  // Reactively flip Mute / Unmute as the global mute list
                  // updates — emits MuteUser when not yet muted.
                  BetterStreamBuilder<bool>(
                    stream: client.state.currentUserStream
                        .map(
                          (u) => u?.mutes.any((m) => m.target.id == user.id) ?? false,
                        )
                        .distinct(),
                    initialData: client.state.currentUser?.mutes.any((m) => m.target.id == user.id) ?? false,
                    builder: (context, isMuted) => _ActionTile(
                      icon: isMuted ? icons.audio : icons.mute,
                      label: isMuted ? 'Unmute User' : 'Mute User',
                      onTap: () => emit(
                        isMuted ? const UnmuteUser() : const MuteUser(),
                      ),
                    ),
                  ),
                  _ActionTile(
                    icon: icons.noSign,
                    label: 'Block User',
                    onTap: () => emit(const BlockUser()),
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

/// Compact header for [ContactDetailSheet] — avatar with online indicator
/// on the left, name + online status stacked on the right.
class _ContactDetailHeader extends StatelessWidget {
  const _ContactDetailHeader({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    return Row(
      spacing: spacing.sm,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamUserAvatar(user: user, size: .lg, showOnlineIndicator: user.online),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: spacing.xxxs,
            children: [
              Text(
                user.name,
                style: textTheme.headingSm.copyWith(color: colorScheme.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                _userStatus(user),
                style: textTheme.captionDefault.copyWith(color: colorScheme.textSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    return StreamListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xxs,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ChannelMemberTile (shared)
// ---------------------------------------------------------------------------

/// {@template channelMemberTile}
/// Single channel-member row — avatar with online indicator, name (with a
/// "You" substitution for the current user), an online / last-seen
/// subtitle, and an _Admin_ trailing label for moderators / owners.
///
/// Used by both the group-info screen members preview and the
/// [AllMembersSheet]; lifted here so the two surfaces always render
/// identically.
/// {@endtemplate}
class ChannelMemberTile extends StatelessWidget {
  /// {@macro channelMemberTile}
  const ChannelMemberTile({
    super.key,
    required this.member,
    required this.isCurrentUser,
    this.onTap,
  });

  /// The member being rendered.
  final Member member;

  /// Whether [member] is the currently signed-in user. When `true`, the
  /// tile shows the literal string "You" in place of the user's name.
  final bool isCurrentUser;

  /// Optional tap handler — typically opens [ContactDetailSheet] for the
  /// member's user. Pass `null` to make the row non-interactive.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final user = member.user;
    if (user == null) return const SizedBox.shrink();

    final name = isCurrentUser ? 'You' : user.name;
    final isAdmin = const {'admin', 'channel_moderator', 'owner'}.contains(member.channelRole);

    return StreamListTile(
      leading: StreamUserAvatar(user: user, size: .md, showOnlineIndicator: user.online),
      title: Text(name),
      subtitle: Text(_userStatus(user)),
      trailing: isAdmin
          ? Text(
              'Admin',
              style: textTheme.captionDefault.copyWith(color: colorScheme.textTertiary),
            )
          : null,
      onTap: onTap,
    );
  }
}

// ---------------------------------------------------------------------------
// Internals
// ---------------------------------------------------------------------------

Future<void> _onContactDetailAction(
  BuildContext context,
  User user,
  ContactDetailAction action,
) async => switch (action) {
  SendDirectMessage() => _openDirectChannel(context, user),
  MuteUser() => StreamChat.of(context).client.muteUser(user.id),
  UnmuteUser() => StreamChat.of(context).client.unmuteUser(user.id),
  BlockUser() => _showNotImplementedSnack(context, 'Blocking users'),
};

/// Finds (or creates) a 1-1 distinct messaging channel between the current
/// user and [user] and pushes it via [GoRouter]. Pops any enclosing
/// [StreamSheetRoute] first so the new channel page lands on the regular
/// page stack instead of stacking on top of a still-visible sheet.
Future<void> _openDirectChannel(BuildContext context, User user) async {
  final chat = StreamChat.of(context);
  final router = GoRouter.of(context);
  final currentUser = chat.currentUser;
  if (currentUser == null) return;

  final existing = await chat.client.queryChannelsOnline(
    state: false,
    watch: false,
    filter: Filter.raw(
      value: {
        'members': [currentUser.id, user.id],
        'distinct': true,
      },
    ),
    messageLimit: 0,
    paginationParams: const PaginationParams(limit: 1),
  );

  Channel channel;
  if (existing.isNotEmpty) {
    channel = existing.first;
    if (channel.state == null) await channel.watch();
  } else {
    channel = chat.client.channel(
      'messaging',
      extraData: {
        'members': [currentUser.id, user.id],
      },
    );
    await channel.watch();
  }

  if (!context.mounted) return;
  // Drop the enclosing all-members sheet (if any) so the channel page
  // doesn't render on top of a half-open sheet.
  if (StreamSheetRoute.hasParentSheet(context)) {
    StreamSheetRoute.popSheet(context);
  }
  router.pushNamed(
    Routes.CHANNEL_PAGE.name,
    pathParameters: Routes.CHANNEL_PAGE.params(channel),
  );
}

void _showNotImplementedSnack(BuildContext context, String feature) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('$feature is not implemented yet.')),
  );
}

String _userStatus(User user) {
  if (user.online) return 'Online';
  final lastActive = user.lastActive;
  if (lastActive == null) return 'Offline';
  return 'Last seen ${Jiffy.parseFromDateTime(lastActive).fromNow()}';
}
