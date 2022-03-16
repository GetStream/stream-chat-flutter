import 'package:flutter/material.dart';

/// {@template reactionIcon}
/// Reaction icon data
/// {@endtemplate}
class ReactionIcon {
  /// {@macro reactionIcon}
  ReactionIcon({
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
