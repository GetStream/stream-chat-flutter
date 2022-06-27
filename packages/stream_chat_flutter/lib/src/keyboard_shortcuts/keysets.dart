import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The "enter" keyset.
///
/// Use to quickly send a message in [StreamMessageInput].
final enterKeySet = LogicalKeySet(
  LogicalKeyboardKey.enter,
);

/// The "escape" keyset.
///
/// Use for:
/// * Removing a reply from [StreamMessageInput].
/// * Closing [FullScreenMediaDesktop].
final escapeKeySet = LogicalKeySet(
  LogicalKeyboardKey.escape,
);

/// The "right arrow" keyset.
///
/// Use for navigating to the next [FullScreenMediaDesktop] item.
final rightArrowKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowRight,
);

/// The "left arrow" keyset.
///
/// Use for navigating to the previous [FullScreenMediaDesktop] item.
final leftArrowKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowLeft,
);
