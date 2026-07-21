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
/// * Closing [StreamFullScreenMedia].
final escapeKeySet = LogicalKeySet(
  LogicalKeyboardKey.escape,
);

/// The "right arrow" keyset.
///
/// Use for navigating to the next [StreamFullScreenMedia] item.
final rightArrowKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowRight,
);

/// The "left arrow" keyset.
///
/// Use for navigating to the previous [StreamFullScreenMedia] item.
final leftArrowKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowLeft,
);
