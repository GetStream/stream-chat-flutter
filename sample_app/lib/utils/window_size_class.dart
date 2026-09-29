import 'package:flutter/widgets.dart';

/// How much room a window has for its content, measured on both axes.
enum WindowSizeClass {
  /// Room for one pane, such as a phone in either orientation.
  compact,

  /// Room for two panes, such as a tablet or an unfolded foldable.
  regular;

  /// Returns the size class of a window of the given [size].
  ///
  /// A window is regular only when it is at least 600 wide and 600 tall, so a
  /// phone in landscape stays compact.
  static WindowSizeClass fromSize(Size size) {
    return switch (size) {
      Size(width: >= _kRegularExtent, height: >= _kRegularExtent) => regular,
      _ => compact,
    };
  }

  /// Returns the size class of the window that encloses [context].
  static WindowSizeClass of(BuildContext context) => fromSize(MediaQuery.sizeOf(context));
}

// The shortest a regular window is on each axis.
const _kRegularExtent = 600.0;
