import 'package:flutter/material.dart';

/// {@template reactionIconBuilder}
/// Signature for a function that builds a reaction icon.
/// {@endtemplate}
typedef ReactionIconBuilder = Widget Function(
  BuildContext context,
  // ignore: avoid_positional_boolean_parameters
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
}
