import 'package:flutter/material.dart';

/// Reaction icon data
class ReactionIcon {
  /// Constructor for creating [ReactionIcon]
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
