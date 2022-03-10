import 'package:flutter/material.dart';

/// Reaction icon data
@Deprecated("Use 'StreamReactionIcon' instead")
typedef ReactionIcon = StreamReactionIcon;

/// Reaction icon data
class StreamReactionIcon {
  /// Constructor for creating [StreamReactionIcon]
  StreamReactionIcon({
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
