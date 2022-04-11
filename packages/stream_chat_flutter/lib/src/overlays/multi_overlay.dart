import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_portal/flutter_portal.dart';

/// {@macro streamMultiOverlay}
@Deprecated("Use 'StreamMultiOverlay' instead")
typedef MultiOverlay = StreamMultiOverlay;

/// {@template streamMultiOverlay}
/// Renders a single overlay widget from a list of [overlayOptions].
///
/// It shows the first one that is visible.
/// {@endtemplate}
class StreamMultiOverlay extends StatelessWidget {
  /// {@macro streamMultiOverlay}
  const StreamMultiOverlay({
    Key? key,
    required this.overlayOptions,
    required this.child,
    required this.overlayAnchor,
    required this.childAnchor,
  }) : super(key: key);

  /// The list of overlay options
  final List<OverlayOptions> overlayOptions;

  /// The child widget
  final Widget child;

  /// The anchor relative to the overlay
  final Alignment? overlayAnchor;

  /// The anchor relative to the child
  final Alignment? childAnchor;

  @override
  Widget build(BuildContext context) {
    final visibleOverlay =
        overlayOptions.firstWhereOrNull((element) => element.visible);

    return PortalEntry(
      childAnchor: childAnchor,
      portalAnchor: overlayAnchor,
      visible: visibleOverlay != null,
      portal: visibleOverlay?.widget,
      child: child,
    );
  }
}

/// {@template overlayOptions}
/// Defines the parameters for building an overlay entry.
/// {@endtemplate}
class OverlayOptions {
  /// {@macro overlayOptions}
  OverlayOptions({
    required this.visible,
    required this.widget,
  });

  /// The visibility of the overlay
  final bool visible;

  /// The widget to be displayed
  final Widget widget;
}
