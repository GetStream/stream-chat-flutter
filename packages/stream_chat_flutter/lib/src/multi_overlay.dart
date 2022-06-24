import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_portal/flutter_portal.dart';

/// {@macro multi_overlay}
@Deprecated("Use 'StreamMultiOverlay' instead")
typedef MultiOverlay = StreamMultiOverlay;

/// {@template multi_overlay}
/// Widget that renders a single overlay widget from a list of [overlayOptions]
/// It shows the first one that is visible
/// {@endtemplate}
class StreamMultiOverlay extends StatelessWidget {
  /// Constructs a new MultiOverlay widget
  /// [overlayOptions] - the list of overlay options
  /// [overlayAnchor] - the anchor relative to the overlay
  /// [childAnchor] - the anchor relative to the child
  /// [child] - the child widget
  const StreamMultiOverlay({
    super.key,
    required this.overlayOptions,
    required this.child,
    required this.overlayAnchor,
    required this.childAnchor,
  });

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

    return PortalTarget(
      anchor: Aligned(
        follower: overlayAnchor ?? Alignment.center,
        target: childAnchor ?? Alignment.center,
      ),
      visible: visibleOverlay != null,
      portalFollower: visibleOverlay?.widget,
      child: child,
    );
  }
}

/// Class that contains the parameters for building an overlay entry
class OverlayOptions {
  /// Constructs a new overlay options object
  /// [visible] - the visibility of the overlay
  /// [widget] - the widget to be displayed
  OverlayOptions({
    required this.visible,
    required this.widget,
  });

  /// the visibility of the overlay
  final bool visible;

  /// the widget to be displayed
  final Widget widget;
}
