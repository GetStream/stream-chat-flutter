import 'package:flutter/material.dart';

/// Lays [child] out in a box at least [kMinInteractiveDimension] square,
/// centered, when the theme asks for padded tap targets.
///
/// The SDK's default buttons get this padding from Material, and layouts such
/// as the composer's bottom-aligned input row rely on it to center a small
/// button against a taller text field. Custom buttons that size to their
/// visual height need it too, or they sink to the bottom of such rows.
Widget padToTapTarget(BuildContext context, Widget child) {
  if (Theme.of(context).materialTapTargetSize != MaterialTapTargetSize.padded) return child;

  return ConstrainedBox(
    constraints: const BoxConstraints(minWidth: kMinInteractiveDimension, minHeight: kMinInteractiveDimension),
    child: Center(widthFactor: 1, heightFactor: 1, child: child),
  );
}
