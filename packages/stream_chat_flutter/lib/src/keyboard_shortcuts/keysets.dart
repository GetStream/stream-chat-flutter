import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// The "enter" keyset.
///
/// Use to quickly send a message in [StreamMessageComposer].
final enterKeySet = LogicalKeySet(
  LogicalKeyboardKey.enter,
);

/// The "escape" keyset.
///
/// Use for:
/// * Removing a reply from [StreamMessageComposer].
/// * Closing [StreamMediaGalleryPreview].
final escapeKeySet = LogicalKeySet(
  LogicalKeyboardKey.escape,
);

/// The "right arrow" keyset.
///
/// Use for navigating to the next [StreamMediaGalleryPreview] page.
final rightArrowKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowRight,
);

/// The "left arrow" keyset.
///
/// Use for navigating to the previous [StreamMediaGalleryPreview] page.
final leftArrowKeySet = LogicalKeySet(
  LogicalKeyboardKey.arrowLeft,
);
