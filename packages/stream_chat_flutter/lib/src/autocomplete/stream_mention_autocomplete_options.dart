import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/autocomplete/user_mention_search.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Caps the card height so a long mention list scrolls internally
// instead of pushing the composer / header off the screen.
const _kMaxHeight = 176.0;

/// {@template user_mentions_overlay}
/// Overlay for displaying users that can be mentioned.
/// {@endtemplate}
class StreamMentionAutocompleteOptions extends StatefulWidget {
  /// Constructor for creating a [StreamMentionAutocompleteOptions].
  StreamMentionAutocompleteOptions({
    super.key,
    required this.query,
    required this.channel,
    this.client,
    this.limit = 10,
    this.mentionAllAppUsers = false,
    @Deprecated('Use mentionUserTileBuilder instead') this.mentionsTileBuilder,
    this.mentionChannelTileBuilder,
    this.mentionHereTileBuilder,
    this.mentionRoleTileBuilder,
    this.mentionUserGroupTileBuilder,
    this.mentionUserTileBuilder,
    this.onMentionChannelTap,
    this.onMentionHereTap,
    this.onMentionRoleTap,
    this.onMentionUserGroupTap,
    this.onMentionUserTap,
    this.style = AutocompleteOptionsStyle.fixed,
  }) : assert(
         channel.state != null,
         'Channel ${channel.cid} is not yet initialized',
       ),
       assert(
         !mentionAllAppUsers || (mentionAllAppUsers && client != null),
         'StreamChatClient is required in order to use mentionAllAppUsers',
       );

  /// Query for searching users.
  final String query;

  /// Limit applied on user search results.
  final int limit;

  /// The channel to search for users.
  final Channel channel;

  /// The client to search for users in case [mentionAllAppUsers] is True.
  final StreamChatClient? client;

  /// When enabled mentions search users across the entire app.
  ///
  /// Defaults to false.
  final bool mentionAllAppUsers;

  /// Customize the tile for the mentions overlay.
  @Deprecated('Use mentionUserTileBuilder instead')
  final UserMentionTileBuilder? mentionsTileBuilder;

  /// Builder for a custom `@channel` broadcast mention tile.
  final Widget Function(BuildContext context)? mentionChannelTileBuilder;

  /// Builder for a custom `@here` broadcast mention tile.
  final Widget Function(BuildContext context)? mentionHereTileBuilder;

  /// Builder for a custom role mention tile.
  final MentionRoleTileBuilder? mentionRoleTileBuilder;

  /// Builder for a custom user group mention tile.
  final MentionUserGroupTileBuilder? mentionUserGroupTileBuilder;

  /// Builder for a custom user mention tile.
  final UserMentionTileBuilder? mentionUserTileBuilder;

  /// Callback called when the "@channel" broadcast mention is selected.
  final VoidCallback? onMentionChannelTap;

  /// Callback called when the "@here" broadcast mention is selected.
  final VoidCallback? onMentionHereTap;

  /// Callback called when a role mention is selected.
  final ValueSetter<Role>? onMentionRoleTap;

  /// Callback called when a user group mention is selected.
  final ValueSetter<UserGroup>? onMentionUserGroupTap;

  /// Callback called when a user is selected.
  final ValueSetter<User>? onMentionUserTap;

  /// The visual style of the autocomplete options overlay.
  ///
  /// Defaults to [AutocompleteOptionsStyle.fixed].
  final AutocompleteOptionsStyle style;

  @override
  _StreamMentionAutocompleteOptionsState createState() => _StreamMentionAutocompleteOptionsState();
}

class _StreamMentionAutocompleteOptionsState extends State<StreamMentionAutocompleteOptions> {
  late Future<List<_MentionOption>> mentionsFuture;

  @override
  void initState() {
    super.initState();
    mentionsFuture = queryMentions(widget.query);
  }

  @override
  void didUpdateWidget(covariant StreamMentionAutocompleteOptions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.channel != oldWidget.channel ||
        widget.query != oldWidget.query ||
        widget.mentionAllAppUsers != oldWidget.mentionAllAppUsers ||
        widget.limit != oldWidget.limit) {
      mentionsFuture = queryMentions(widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_MentionOption>>(
      future: mentionsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Empty();
        final mentions = snapshot.data!;
        if (mentions.isEmpty) return const Empty();

        final colorScheme = context.streamColorScheme;
        final (:elevation, :margin, :shape) = widget.style.resolve(colorScheme.borderDefault);

        return StreamAutocompleteOptions<_MentionOption>(
          options: mentions,
          maxHeight: _kMaxHeight,
          elevation: elevation,
          margin: margin,
          shape: shape,
          optionBuilder: (context, option) => switch (option) {
            _ChannelMention() => _buildChannelTile(context),
            _HereMention() => _buildHereTile(context),
            _RoleMention(role: final role) => _buildRoleTile(context, role),
            _UserGroupMention(userGroup: final userGroup) => _buildUserGroupTile(context, userGroup),
            _UserMention(user: final user) => _buildUserTile(context, user),
          },
        );
      },
    );
  }

  Widget _buildChannelTile(BuildContext context) {
    final builder = widget.mentionChannelTileBuilder;
    if (builder != null) {
      return Material(
        color: context.streamColorScheme.backgroundElevation1,
        child: InkWell(
          onTap: widget.onMentionChannelTap,
          child: builder(context),
        ),
      );
    }
    return _MentionChannelTile(onTap: widget.onMentionChannelTap);
  }

  Widget _buildHereTile(BuildContext context) {
    final builder = widget.mentionHereTileBuilder;
    if (builder != null) {
      return Material(
        color: context.streamColorScheme.backgroundElevation1,
        child: InkWell(
          onTap: widget.onMentionHereTap,
          child: builder(context),
        ),
      );
    }
    return _MentionHereTile(onTap: widget.onMentionHereTap);
  }

  Widget _buildRoleTile(BuildContext context, Role role) {
    final tap = widget.onMentionRoleTap == null ? null : () => widget.onMentionRoleTap!(role);
    final builder = widget.mentionRoleTileBuilder;
    if (builder != null) {
      return Material(
        color: context.streamColorScheme.backgroundElevation1,
        child: InkWell(
          onTap: tap,
          child: builder(context, role),
        ),
      );
    }
    return _MentionRoleTile(role: role.name, onTap: tap);
  }

  Widget _buildUserGroupTile(BuildContext context, UserGroup userGroup) {
    final tap = widget.onMentionUserGroupTap == null ? null : () => widget.onMentionUserGroupTap!(userGroup);
    final builder = widget.mentionUserGroupTileBuilder;
    if (builder != null) {
      return Material(
        color: context.streamColorScheme.backgroundElevation1,
        child: InkWell(
          onTap: tap,
          child: builder(context, userGroup),
        ),
      );
    }
    return _MentionUserGroupTile(userGroup: userGroup, onTap: widget.onMentionUserGroupTap);
  }

  Widget _buildUserTile(BuildContext context, User user) {
    final builder = widget.mentionUserTileBuilder ?? widget.mentionsTileBuilder;
    if (builder != null) {
      return Material(
        color: context.streamColorScheme.backgroundElevation1,
        child: InkWell(
          onTap: widget.onMentionUserTap == null ? null : () => widget.onMentionUserTap!(user),
          child: builder(context, user),
        ),
      );
    }
    return _MentionUserTile(user: user, onTap: widget.onMentionUserTap);
  }

  List<User> get membersAndWatchers {
    final state = widget.channel.state!;
    return {
      ...state.watchers,
      ...state.members.map((it) => it.user),
    }.whereType<User>().toList(growable: false);
  }

  Future<List<_MentionOption>> queryMentions(String query) async {
    final broadcasts = _broadcastMentions(query);
    final rolesFuture = _fetchRoles(query);
    final groupsFuture = _fetchUserGroups(query);
    final usersFuture = _fetchUsers(query);

    final (roles, groups, users) = await (rolesFuture, groupsFuture, usersFuture).wait;

    return [
      ...broadcasts,
      ...roles.map(_RoleMention.new),
      ...groups.map(_UserGroupMention.new),
      ...users.map(_UserMention.new),
    ];
  }

  List<_MentionOption> _broadcastMentions(String query) {
    final channel = widget.channel;
    final normalized = query.toLowerCase();
    final showChannel = channel.canNotifyChannel && (query.isEmpty || 'channel'.startsWith(normalized));
    final showHere = channel.canNotifyHere && (query.isEmpty || 'here'.startsWith(normalized));
    return [
      if (showChannel) const _ChannelMention(),
      if (showHere) const _HereMention(),
    ];
  }

  Future<List<Role>> _fetchRoles(String query) async {
    if (query.isEmpty || !widget.channel.canNotifyRole) return const [];
    try {
      final response = await widget.channel.client.searchRoles(query);
      return response.roles;
    } catch (_) {
      return const [];
    }
  }

  Future<List<UserGroup>> _fetchUserGroups(String query) async {
    if (query.isEmpty || !widget.channel.canNotifyGroup) return const [];
    try {
      final response = await widget.channel.client.searchUserGroups(
        query,
        teamId: widget.channel.team,
      );
      return response.userGroups;
    } catch (_) {
      return const [];
    }
  }

  Future<List<User>> _fetchUsers(String query) async {
    try {
      if (widget.mentionAllAppUsers) {
        return await _queryUsers(query);
      }

      final channelState = widget.channel.state!;
      final memberCount = widget.channel.memberCount;
      final allMembersCached = memberCount != null && memberCount == channelState.members.length;

      // When every channel member is already cached locally we can match
      // against the in-memory member + watcher set instead of hitting
      // queryMembers.
      if (allMembersCached) {
        return searchUsersForMention(membersAndWatchers, query);
      }

      final result = await _queryMembers(query);
      return result.map((it) => it.user).whereType<User>().toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  Future<List<Member>> _queryMembers(String query) async {
    final response = await widget.channel.queryMembers(
      pagination: PaginationParams(limit: widget.limit),
      filter: query.isEmpty ? const Filter.empty() : Filter.autoComplete('name', query),
    );
    return response.members;
  }

  Future<List<User>> _queryUsers(String query) async {
    assert(
      widget.client != null,
      'StreamChatClient is required in order to query all app users',
    );
    final response = await widget.client!.queryUsers(
      pagination: PaginationParams(limit: widget.limit),
      filter: query.isEmpty
          ? const Filter.empty()
          : Filter.or([
              Filter.autoComplete('id', query),
              Filter.autoComplete('name', query),
            ]),
      sort: [const SortOption.asc('id')],
    );
    return response.users;
  }
}

/// Shared row layout for every mention autocomplete tile.
class _MentionTile extends StatelessWidget {
  const _MentionTile({
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final subtitle = this.subtitle;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xxs),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.sm,
              vertical: spacing.xs,
            ),
            child: Row(
              spacing: spacing.sm,
              children: [
                leading,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: spacing.xxxs,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyDefault,
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.metadataDefault.copyWith(
                            color: colorScheme.textTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular icon badge used as the leading widget for non-user mention tiles.
class _MentionIconBadge extends StatelessWidget {
  const _MentionIconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.backgroundSurfaceSubtle,
        border: Border.all(color: colorScheme.borderSubtle),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.xs),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

/// Represents the tile for "@channel" mention.
class _MentionChannelTile extends StatelessWidget {
  const _MentionChannelTile({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _MentionTile(
      leading: _MentionIconBadge(icon: context.streamIcons.megaphone),
      title: '@channel',
      subtitle: context.translations.notifyChannelText,
      onTap: onTap,
    );
  }
}

/// Represents the tile for "@here" mention.
class _MentionHereTile extends StatelessWidget {
  const _MentionHereTile({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _MentionTile(
      leading: _MentionIconBadge(icon: context.streamIcons.megaphone),
      title: '@here',
      subtitle: context.translations.notifyHereText,
      onTap: onTap,
    );
  }
}

/// Represents the tile for role mentions.
class _MentionRoleTile extends StatelessWidget {
  const _MentionRoleTile({required this.role, this.onTap});

  final String role;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _MentionTile(
      leading: _MentionIconBadge(icon: context.streamIcons.shield),
      title: '@$role',
      subtitle: context.translations.notifyRoleText(role),
      onTap: onTap,
    );
  }
}

/// Represents the tile for user group mentions.
class _MentionUserGroupTile extends StatelessWidget {
  const _MentionUserGroupTile({required this.userGroup, this.onTap});

  final UserGroup userGroup;
  final ValueSetter<UserGroup>? onTap;

  @override
  Widget build(BuildContext context) {
    final description = userGroup.description;
    return _MentionTile(
      leading: _MentionIconBadge(icon: context.streamIcons.users),
      title: '@${userGroup.name}',
      subtitle: description?.isNotEmpty == true ? description : null,
      onTap: onTap == null ? null : () => onTap!(userGroup),
    );
  }
}

/// Represents the tile for user mentions.
class _MentionUserTile extends StatelessWidget {
  const _MentionUserTile({required this.user, this.onTap});

  final User user;
  final ValueSetter<User>? onTap;

  @override
  Widget build(BuildContext context) {
    return _MentionTile(
      leading: StreamUserAvatar(size: .md, user: user),
      title: user.name,
      onTap: onTap == null ? null : () => onTap!(user),
    );
  }
}

/// Represents a single entry in the mention autocomplete list.
sealed class _MentionOption {
  const _MentionOption();
}

/// Broadcast mention that notifies all members of the channel.
class _ChannelMention extends _MentionOption {
  const _ChannelMention();
}

/// Broadcast mention that notifies all online members of the channel.
class _HereMention extends _MentionOption {
  const _HereMention();
}

/// Role mention backed by a [Role] returned from the search endpoint.
class _RoleMention extends _MentionOption {
  const _RoleMention(this.role);

  final Role role;
}

/// User group mention backed by a [UserGroup] returned from the search
/// endpoint.
class _UserGroupMention extends _MentionOption {
  const _UserGroupMention(this.userGroup);

  final UserGroup userGroup;
}

/// User mention backed by a [User] from channel membership or user search.
class _UserMention extends _MentionOption {
  const _UserMention(this.user);

  final User user;
}
