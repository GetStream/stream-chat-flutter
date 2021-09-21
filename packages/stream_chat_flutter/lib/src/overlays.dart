import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_portal/flutter_portal.dart';

/// Class that contains the parameters for building a portal entry
class PortalOptions {
  /// Constructs a new portal options object
  /// [visible] - the visibility of the portal
  /// [widget] - the widget to be displayed
  PortalOptions({
    required this.visible,
    required this.widget,
  });

  /// the visibility of the portal
  final bool visible;

  /// the widget to be displayed
  final Widget widget;
}

/// Widget that renders a single portal widget from a list of [portalOptions]
/// It shows the first one that is visible
class MultiPortal extends StatelessWidget {
  /// Constructs a new MultiPortal widget
  /// [portalOptions] - the list of portal options
  /// [portalAnchor] - the anchor relative to the portal
  /// [childAnchor] - the anchor relative to the child
  /// [child] - the child widget
  const MultiPortal({
    Key? key,
    required this.portalOptions,
    required this.child,
    required this.portalAnchor,
    required this.childAnchor,
  }) : super(key: key);

  /// The list of portal options
  final List<PortalOptions> portalOptions;

  /// The child widget
  final Widget child;

  /// The anchor relative to the portal
  final Alignment? portalAnchor;

  /// The anchor relative to the child
  final Alignment? childAnchor;

  @override
  Widget build(BuildContext context) {
    final visibleOverlay =
        portalOptions.firstWhereOrNull((element) => element.visible);

    return PortalEntry(
      childAnchor: childAnchor,
      portalAnchor: portalAnchor,
      visible: visibleOverlay != null,
      portal: visibleOverlay?.widget,
      child: child,
    );
  }
}
