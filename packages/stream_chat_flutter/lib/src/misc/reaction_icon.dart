// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template reactionIconBuilder}
/// Signature for a function that builds a reaction icon.
/// {@endtemplate}
typedef ReactionIconBuilder = Widget Function(
  BuildContext context,
  bool isHighlighted,
  double iconSize,
);

/// {@template streamReactionIcon}
/// Reaction icon data
/// {@endtemplate}
class StreamReactionIcon {
  /// {@macro streamReactionIcon}
  const StreamReactionIcon({
    required this.type,
    this.emojiCode,
    required this.builder,
  });

  /// Creates a reaction icon with a default unknown icon.
  const StreamReactionIcon.unknown()
      : type = 'unknown',
        emojiCode = null,
        builder = _unknownBuilder;

  /// Converts this [StreamReactionIcon] to a [Reaction] object.
  Reaction toReaction() => Reaction(type: type, emojiCode: emojiCode);

  /// Type of reaction
  final String type;

  /// Optional emoji code for the reaction.
  ///
  /// Used to display a custom emoji in the notification.
  final String? emojiCode;

  /// {@macro reactionIconBuilder}
  final ReactionIconBuilder builder;

  /// The default list of reaction icons provided by Stream Chat.
  ///
  /// This includes five reactions:
  /// - love: Represented by a heart icon
  /// - like: Represented by a thumbs up icon
  /// - sad: Represented by a thumbs down icon
  /// - haha: Represented by a laughing face icon
  /// - wow: Represented by a surprised face icon
  ///
  /// These default reactions can be used directly or as a starting point for
  /// custom reaction configurations.
  static const List<StreamReactionIcon> defaultReactions = [
    StreamReactionIcon(type: 'love', emojiCode: '❤️', builder: _loveBuilder),
    StreamReactionIcon(type: 'like', emojiCode: '👍', builder: _likeBuilder),
    StreamReactionIcon(type: 'sad', emojiCode: '👎', builder: _sadBuilder),
    StreamReactionIcon(type: 'haha', emojiCode: '😂', builder: _hahaBuilder),
    StreamReactionIcon(type: 'wow', emojiCode: '😮', builder: _wowBuilder),
  ];

  static Widget _loveBuilder(
    BuildContext context,
    bool highlighted,
    double size,
  ) {
    final theme = StreamChatTheme.of(context);
    final iconColor = switch (highlighted) {
      true => theme.colorTheme.accentPrimary,
      false => theme.primaryIconTheme.color,
    };

    return StreamSvgIcon(
      icon: StreamSvgIcons.loveReaction,
      color: iconColor,
      size: size,
    );
  }

  static Widget _likeBuilder(
    BuildContext context,
    bool highlighted,
    double size,
  ) {
    final theme = StreamChatTheme.of(context);
    final iconColor = switch (highlighted) {
      true => theme.colorTheme.accentPrimary,
      false => theme.primaryIconTheme.color,
    };

    return StreamSvgIcon(
      icon: StreamSvgIcons.thumbsUpReaction,
      color: iconColor,
      size: size,
    );
  }

  static Widget _sadBuilder(
    BuildContext context,
    bool highlighted,
    double size,
  ) {
    final theme = StreamChatTheme.of(context);
    final iconColor = switch (highlighted) {
      true => theme.colorTheme.accentPrimary,
      false => theme.primaryIconTheme.color,
    };

    return StreamSvgIcon(
      icon: StreamSvgIcons.thumbsDownReaction,
      color: iconColor,
      size: size,
    );
  }

  static Widget _hahaBuilder(
    BuildContext context,
    bool highlighted,
    double size,
  ) {
    final theme = StreamChatTheme.of(context);
    final iconColor = switch (highlighted) {
      true => theme.colorTheme.accentPrimary,
      false => theme.primaryIconTheme.color,
    };

    return StreamSvgIcon(
      icon: StreamSvgIcons.lolReaction,
      color: iconColor,
      size: size,
    );
  }

  static Widget _wowBuilder(
    BuildContext context,
    bool highlighted,
    double size,
  ) {
    final theme = StreamChatTheme.of(context);
    final iconColor = switch (highlighted) {
      true => theme.colorTheme.accentPrimary,
      false => theme.primaryIconTheme.color,
    };

    return StreamSvgIcon(
      icon: StreamSvgIcons.wutReaction,
      color: iconColor,
      size: size,
    );
  }

  static Widget _unknownBuilder(
    BuildContext context,
    bool highlighted,
    double size,
  ) {
    final theme = StreamChatTheme.of(context);
    final iconColor = switch (highlighted) {
      true => theme.colorTheme.accentPrimary,
      false => theme.primaryIconTheme.color,
    };

    return Icon(
      Icons.help_outline_rounded,
      color: iconColor,
      size: size,
    );
  }
}
