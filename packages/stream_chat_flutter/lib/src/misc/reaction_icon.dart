// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

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
    required this.builder,
  });

  /// Type of reaction
  final String type;

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
    StreamReactionIcon(type: 'love', builder: _loveReactionBuilder),
    StreamReactionIcon(type: 'like', builder: _likeReactionBuilder),
    StreamReactionIcon(type: 'sad', builder: _sadReactionBuilder),
    StreamReactionIcon(type: 'haha', builder: _hahaReactionBuilder),
    StreamReactionIcon(type: 'wow', builder: _wowReactionBuilder),
  ];

  static Widget _loveReactionBuilder(
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

  static Widget _likeReactionBuilder(
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

  static Widget _sadReactionBuilder(
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

  static Widget _hahaReactionBuilder(
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

  static Widget _wowReactionBuilder(
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
}
