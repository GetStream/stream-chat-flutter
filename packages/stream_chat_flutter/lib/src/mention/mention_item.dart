import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Renders a single mention suggestion row.
///
/// Customise rendering globally by registering a [StreamComponentBuilder]
/// for [StreamMentionItemProps] through [streamChatComponentBuilders]. When
/// no builder is registered the [DefaultStreamMentionItem] fallback is used.
///
/// For per-instance overrides, set `mentionItemBuilder` on
/// [StreamMentionAutocompleteOptions] or [StreamMessageComposer].
class StreamMentionItem extends StatelessWidget {
  /// Creates a [StreamMentionItem] for the given [mention].
  StreamMentionItem({
    super.key,
    required StreamMention mention,
    VoidCallback? onTap,
  }) : props = StreamMentionItemProps(mention: mention, onTap: onTap);

  /// Creates a [StreamMentionItem] from a pre-built [StreamMentionItemProps].
  const StreamMentionItem.fromProps({super.key, required this.props});

  /// The properties for the mention item.
  final StreamMentionItemProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamMentionItemProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamMentionItem(props: props);
  }
}

/// A builder function that takes [StreamMentionItemProps] and returns a
/// custom mention item widget.
typedef StreamMentionItemBuilder = StreamComponentBuilder<StreamMentionItemProps>;

/// Properties for a [StreamMentionItem].
class StreamMentionItemProps {
  /// Creates a new [StreamMentionItemProps].
  const StreamMentionItemProps({
    required this.mention,
    this.onTap,
  });

  /// The mention that this item represents.
  final StreamMention mention;

  /// Called when the item is tapped.
  final VoidCallback? onTap;
}

/// Default rendering for a [StreamMentionItem].
///
/// Switches on the runtime type of [StreamMentionItemProps.mention] and
/// renders the matching built-in item. Unknown subclasses of [StreamMention]
/// fall back to a generic item using [StreamMention.display] as the title.
class DefaultStreamMentionItem extends StatelessWidget {
  /// Creates a new [DefaultStreamMentionItem].
  const DefaultStreamMentionItem({super.key, required this.props});

  /// The properties for the mention item.
  final StreamMentionItemProps props;

  @override
  Widget build(BuildContext context) {
    final mention = props.mention;
    final onTap = props.onTap;
    return switch (mention) {
      StreamChannelMention() => _MentionChannelItem(onTap: onTap),
      StreamHereMention() => _MentionHereItem(onTap: onTap),
      StreamRoleMention(:final role) => _MentionRoleItem(role: role, onTap: onTap),
      StreamGroupMention(:final userGroup) => _MentionUserGroupItem(userGroup: userGroup, onTap: onTap),
      StreamUserMention(:final user) => _MentionUserItem(user: user, onTap: onTap),
      _ => _MentionFallbackItem(display: mention.display, onTap: onTap),
    };
  }
}

/// Shared row layout for every mention autocomplete item.
class _MentionItem extends StatelessWidget {
  const _MentionItem({
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

/// Circular icon badge used as the leading widget for non-user mention items.
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

class _MentionChannelItem extends StatelessWidget {
  const _MentionChannelItem({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _MentionItem(
      leading: _MentionIconBadge(icon: context.streamIcons.megaphone),
      title: '@channel',
      subtitle: context.translations.notifyChannelText,
      onTap: onTap,
    );
  }
}

class _MentionHereItem extends StatelessWidget {
  const _MentionHereItem({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _MentionItem(
      leading: _MentionIconBadge(icon: context.streamIcons.megaphone),
      title: '@here',
      subtitle: context.translations.notifyHereText,
      onTap: onTap,
    );
  }
}

class _MentionRoleItem extends StatelessWidget {
  const _MentionRoleItem({required this.role, this.onTap});

  final String role;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _MentionItem(
      leading: _MentionIconBadge(icon: context.streamIcons.shield),
      title: '@$role',
      subtitle: context.translations.notifyRoleText(role),
      onTap: onTap,
    );
  }
}

class _MentionUserGroupItem extends StatelessWidget {
  const _MentionUserGroupItem({required this.userGroup, this.onTap});

  final UserGroup userGroup;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final description = userGroup.description;
    return _MentionItem(
      leading: _MentionIconBadge(icon: context.streamIcons.users),
      title: '@${userGroup.name}',
      subtitle: description?.isNotEmpty == true ? description : null,
      onTap: onTap,
    );
  }
}

class _MentionUserItem extends StatelessWidget {
  const _MentionUserItem({required this.user, this.onTap});

  final User user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _MentionItem(
      leading: StreamUserAvatar(size: .md, user: user),
      title: user.name,
      onTap: onTap,
    );
  }
}

class _MentionFallbackItem extends StatelessWidget {
  const _MentionFallbackItem({required this.display, this.onTap});

  final String display;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _MentionItem(
      leading: _MentionIconBadge(icon: context.streamIcons.megaphone),
      title: '@$display',
      onTap: onTap,
    );
  }
}
