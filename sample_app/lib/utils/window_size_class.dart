import 'package:flutter/widgets.dart';

/// How much room a window has across, from the narrowest class to the widest.
enum WindowWidthClass {
  /// Narrower than 600, such as a phone in portrait.
  compact(0),

  /// At least 600 wide, such as a foldable or a tablet in portrait.
  medium(600),

  /// At least 840 wide, such as a foldable or a tablet in landscape.
  expanded(840),

  /// At least 1200 wide, such as a desktop window.
  large(1200),

  /// At least 1600 wide, such as a large desktop window.
  extraLarge(1600);

  const WindowWidthClass(this.minWidth);

  /// The narrowest a window of this class is.
  final double minWidth;

  /// The class of a window that is [width] wide.
  static WindowWidthClass fromWidth(double width) => values.lastWhere((it) => width >= it.minWidth);

  /// Whether this class is [other] or a wider one.
  bool isAtLeast(WindowWidthClass other) => index >= other.index;
}

/// How much room a window has from top to bottom, from the shortest class to
/// the tallest.
enum WindowHeightClass {
  /// Shorter than 480, such as a phone in landscape.
  compact(0),

  /// At least 480 tall, such as a phone in portrait or a tablet in landscape.
  medium(480),

  /// At least 900 tall, such as a tablet in portrait.
  expanded(900);

  const WindowHeightClass(this.minHeight);

  /// The shortest a window of this class is.
  final double minHeight;

  /// The class of a window that is [height] tall.
  static WindowHeightClass fromHeight(double height) => values.lastWhere((it) => height >= it.minHeight);

  /// Whether this class is [other] or a taller one.
  bool isAtLeast(WindowHeightClass other) => index >= other.index;
}

/// The width and height classes of a window.
@immutable
class WindowSizeClass {
  /// Creates the size class of a window with the given [width] and [height]
  /// classes.
  const WindowSizeClass({required this.width, required this.height});

  /// The size class of a window of the given [size].
  WindowSizeClass.fromSize(Size size) : width = .fromWidth(size.width), height = .fromHeight(size.height);

  /// The size class of the window that encloses [context].
  ///
  /// The widget that owns [context] rebuilds whenever the window's size changes.
  static WindowSizeClass of(BuildContext context) => .fromSize(MediaQuery.sizeOf(context));

  /// How much room the window has across.
  final WindowWidthClass width;

  /// How much room the window has from top to bottom.
  final WindowHeightClass height;
}
