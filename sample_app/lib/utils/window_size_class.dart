import 'package:flutter/widgets.dart';

/// The amount of room a window has for its content, measured on both axes.
enum WindowSizeClass {
  /// Room for one pane, such as a phone in either orientation.
  compact,

  /// Room for two panes, such as a tablet or an unfolded foldable.
  regular;

  /// The size class of a window of the given [size].
  ///
  /// A window is regular only when it is at least 600 wide and 600 tall, so a
  /// phone in landscape stays compact.
  static WindowSizeClass fromSize(Size size) {
    return switch (size) {
      Size(width: >= _regularExtent, height: >= _regularExtent) => regular,
      _ => compact,
    };
  }

  /// The size class of the window that encloses [context].
  ///
  /// The widget that owns [context] rebuilds whenever the window's size changes.
  static WindowSizeClass of(BuildContext context) => fromSize(MediaQuery.sizeOf(context));

  // The shortest a regular window is on each axis.
  static const _regularExtent = 600.0;
}
