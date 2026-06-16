import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Renders a single mention suggestion row.
///
/// Customise rendering globally by registering a [StreamComponentBuilder]
/// for [StreamMentionTileProps] through [streamChatComponentBuilders]. When
/// no builder is registered the [DefaultStreamMentionTile] fallback is used.
///
/// For per-instance overrides, set `mentionTileBuilder` on
/// [StreamMentionAutocompleteOptions] or [StreamMessageComposer].
class StreamMentionTile extends StatelessWidget {
  /// Creates a [StreamMentionTile] for the given [mention].
  StreamMentionTile({
    super.key,
    required StreamMention mention,
    VoidCallback? onTap,
  }) : props = StreamMentionTileProps(mention: mention, onTap: onTap);

  /// Creates a [StreamMentionTile] from a pre-built [StreamMentionTileProps].
  const StreamMentionTile.fromProps({super.key, required this.props});

  /// The properties for the mention tile.
  final StreamMentionTileProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamMentionTileProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamMentionTile(props: props);
  }
}

/// A builder function that takes [StreamMentionTileProps] and returns a
/// custom mention tile widget.
typedef StreamMentionTileBuilder = StreamComponentBuilder<StreamMentionTileProps>;

/// Properties for a [StreamMentionTile].
class StreamMentionTileProps {
  /// Creates a new [StreamMentionTileProps].
  const StreamMentionTileProps({
    required this.mention,
    this.onTap,
  });

  /// The mention that this tile represents.
  final StreamMention mention;

  /// Called when the tile is tapped.
  final VoidCallback? onTap;
}

/// Default rendering for a [StreamMentionTile].
///
/// Switches on the runtime type of [StreamMentionTileProps.mention] and
/// renders the matching built-in tile. Unknown subclasses of [StreamMention]
/// fall back to a generic tile using [StreamMention.display] as the title.
class DefaultStreamMentionTile extends StatelessWidget {
  /// Creates a new [DefaultStreamMentionTile].
  const DefaultStreamMentionTile({super.key, required this.props});

  /// The properties for the mention tile.
  final StreamMentionTileProps props;

  @override
  Widget build(BuildContext context) {
    final mention = props.mention;
    final onTap = props.onTap;
    if (mention is StreamChannelMention) {
      return _MentionChannelTile(onTap: onTap);
    }
    if (mention is StreamHereMention) {
      return _MentionHereTile(onTap: onTap);
    }
    if (mention is StreamRoleMention) {
      return _MentionRoleTile(role: mention.role, onTap: onTap);
    }
    if (mention is StreamGroupMention) {
      return _MentionUserGroupTile(userGroup: mention.userGroup, onTap: onTap);
    }
    if (mention is StreamUserMention) {
      return _MentionUserTile(user: mention.user, onTap: onTap);
    }
    return _MentionFallbackTile(display: mention.display, onTap: onTap);
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

class _MentionUserGroupTile extends StatelessWidget {
  const _MentionUserGroupTile({required this.userGroup, this.onTap});

  final UserGroup userGroup;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final description = userGroup.description;
    return _MentionTile(
      leading: _MentionIconBadge(icon: context.streamIcons.users),
      title: '@${userGroup.name}',
      subtitle: description?.isNotEmpty == true ? description : null,
      onTap: onTap,
    );
  }
}

class _MentionUserTile extends StatelessWidget {
  const _MentionUserTile({required this.user, this.onTap});

  final User user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _MentionTile(
      leading: StreamUserAvatar(size: .md, user: user),
      title: user.name,
      onTap: onTap,
    );
  }
}

class _MentionFallbackTile extends StatelessWidget {
  const _MentionFallbackTile({required this.display, this.onTap});

  final String display;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _MentionTile(
      leading: _MentionIconBadge(icon: context.streamIcons.megaphone),
      title: '@$display',
      onTap: onTap,
    );
  }
}
