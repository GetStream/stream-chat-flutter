import 'package:flutter/material.dart';

/// A widget that sizes its child to a fraction of the total available space.
class FlexibleFractionallySizedBox extends StatelessWidget {
  /// Creates a widget that sizes its child to a fraction of the total available
  /// space.
  ///
  /// If non-null, the [widthFactor] and [heightFactor] arguments must be
  /// non-negative.
  const FlexibleFractionallySizedBox({
    super.key,
    this.alignment = Alignment.center,
    this.widthFactor,
    this.heightFactor,
    this.child,
  })  : assert(widthFactor == null || widthFactor >= 0.0, ''),
        assert(heightFactor == null || heightFactor >= 0.0, '');

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// If non-null, the fraction of the incoming width given to the child.
  ///
  /// If non-null, the child is given a tight width constraint that is the max
  /// incoming width constraint multiplied by this factor.
  ///
  /// If null, the incoming width constraints are passed to the child
  /// unmodified.
  final double? widthFactor;

  /// If non-null, the fraction of the incoming height given to the child.
  ///
  /// If non-null, the child is given a tight height constraint that is the max
  /// incoming height constraint multiplied by this factor.
  ///
  /// If null, the incoming height constraints are passed to the child
  /// unmodified.
  final double? heightFactor;

  /// How to align the child.
  ///
  /// The x and y values of the alignment control the horizontal and vertical
  /// alignment, respectively. An x value of -1.0 means that the left edge of
  /// the child is aligned with the left edge of the parent whereas an x value
  /// of 1.0 means that the right edge of the child is aligned with the right
  /// edge of the parent. Other values interpolate (and extrapolate) linearly.
  /// For example, a value of 0.0 means that the center of the child is aligned
  /// with the center of the parent.
  ///
  /// Defaults to [Alignment.center].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var maxWidth = constraints.maxWidth;
        if (widthFactor case final widthFactor?) {
          final width = maxWidth * widthFactor;
          maxWidth = width;
        }

        var maxHeight = constraints.maxHeight;
        if (heightFactor case final heightFactor?) {
          final height = maxHeight * heightFactor;
          maxHeight = height;
        }

        return UnconstrainedBox(
          alignment: alignment,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
