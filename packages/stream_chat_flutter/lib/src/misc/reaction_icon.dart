import 'package:flutter/material.dart';

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

  /// Asset to display for reaction
  final Widget Function(
    BuildContext,
    bool highlighted,
    double size,
  ) builder;
}
