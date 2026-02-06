import 'dart:math' as math;
import 'dart:ui' as ui show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const _kDefaultGradient = LinearGradient(
  colors: [
    Color(0xFF000000),
    Color(0xFF000000),
  ],
);

const _kTransparentGradient = LinearGradient(
  colors: [
    Color(0x00000000),
    Color(0x00000000),
  ],
);

/// {@template gradientBoxBorder}
/// A border that draws a gradient instead of a solid color.
/// {@endtemplate}
class GradientBoxBorder extends BoxBorder {
  /// {@macro gradientBoxBorder}
  const GradientBoxBorder({
    this.gradient = _kDefaultGradient,
    this.width = 1.0,
    this.style = BorderStyle.solid,
    this.strokeAlign = strokeAlignInside,
  }) : assert(width >= 0.0, 'The width must be greater than or equal to zero.');

  /// A hairline default gradient border that is not rendered.
  static const GradientBoxBorder none = GradientBoxBorder(
    width: 0,
    style: BorderStyle.none,
  );

  /// The gradient to use in the border.
  final Gradient gradient;

  /// The width of the border, in logical pixels.
  ///
  /// Setting width to 0.0 will result in a hairline border. This means that
  /// the border will have the width of one physical pixel. Hairline
  /// rendering takes shortcuts when the path overlaps a pixel more than once.
  /// This means that it will render faster than otherwise, but it might
  /// double-hit pixels, giving it a slightly darker/lighter result.
  ///
  /// To omit the border entirely, set the [style] to [BorderStyle.none].
  final double width;

  /// The style of the border.
  ///
  /// To omit a side, set [style] to [BorderStyle.none]. This skips
  /// painting the border, but the border still has a [width].
  final BorderStyle style;

  /// The relative position of the stroke on a [BorderSide] in an
  /// [OutlinedBorder] or [Border].
  ///
  /// Values typically range from -1.0 ([strokeAlignInside], inside border,
  /// default) to 1.0 ([strokeAlignOutside], outside border), without any
  /// bound constraints (e.g., a value of -2.0 is not typical, but allowed).
  /// A value of 0 ([strokeAlignCenter]) will center the border on the edge
  /// of the widget.
  ///
  /// When set to [strokeAlignInside], the stroke is drawn completely inside
  /// the widget. For [strokeAlignCenter] and [strokeAlignOutside], a property
  /// such as [Container.clipBehavior] can be used in an outside widget to clip
  /// it. If [Container.decoration] has a border, the container may incorporate
  /// [width] as additional padding:
  /// - [strokeAlignInside] provides padding with full [width].
  /// - [strokeAlignCenter] provides padding with half [width].
  /// - [strokeAlignOutside] provides zero padding, as stroke is drawn entirely
  ///   outside.
  ///
  /// This property is not honored by [toPaint] (because the [Paint] object
  /// cannot represent it); it is intended that classes that use [BorderSide]
  /// objects implement this property when painting borders by suitably
  /// inflating or deflating their regions.
  ///
  /// {@tool dartpad}
  /// This example shows an animation of how [strokeAlign] affects the drawing
  /// when applied to borders of various shapes.
  ///
  /// ** See code in examples/api/lib/painting/borders/border_side.stroke_align.0.dart **
  /// {@end-tool}
  final double strokeAlign;

  /// The border is drawn fully inside of the border path.
  ///
  /// This is a constant for use with [strokeAlign].
  ///
  /// This is the default value for [strokeAlign].
  static const double strokeAlignInside = -1;

  /// The border is drawn on the center of the border path, with half of the
  /// [BorderSide.width] on the inside, and the other half on the outside of
  /// the path.
  ///
  /// This is a constant for use with [strokeAlign].
  static const double strokeAlignCenter = 0;

  /// The border is drawn on the outside of the border path.
  ///
  /// This is a constant for use with [strokeAlign].
  static const double strokeAlignOutside = 1;

  /// Whether the two given [GradientBoxBorder]s can be merged using
  /// [GradientBoxBorder.merge].
  ///
  /// Two sides can be merged if one or both are zero-width with
  /// [GradientBoxBorder.none], or if they both have the same gradient and style
  bool canMerge(GradientBoxBorder b) {
    if ((style == BorderStyle.none && width == 0.0) || (b.style == BorderStyle.none && b.width == 0.0)) {
      return true;
    }
    return style == b.style && gradient == b.gradient;
  }

  /// Creates a [GradientBoxBorder] that represents the addition of the two
  /// given [GradientBoxBorder]s.
  ///
  /// It is only valid to call this if [canMerge] returns true for the two
  /// borders.
  ///
  /// If one of the border is zero-width with [BorderStyle.none], then the other
  /// border is return as-is. If both of the border are zero-width with
  /// [BorderStyle.none], then [GradientBoxBorder.none] is returned.
  GradientBoxBorder merge(GradientBoxBorder b) {
    assert(canMerge(b), '');
    final aIsNone = style == BorderStyle.none && width == 0.0;
    final bIsNone = b.style == BorderStyle.none && b.width == 0.0;
    if (aIsNone && bIsNone) return GradientBoxBorder.none;
    if (aIsNone) return b;
    if (bIsNone) return this;

    assert(gradient == b.gradient, '');
    assert(style == b.style, '');
    return GradientBoxBorder(
      gradient: gradient, // == b.gradient
      width: width + b.width,
      strokeAlign: math.max(strokeAlign, b.strokeAlign),
      style: style, // == b.style
    );
  }

  @override
  GradientBoxBorder scale(double t) {
    return GradientBoxBorder(
      gradient: gradient,
      width: math.max(0, width * t),
      style: t <= 0.0 ? BorderStyle.none : style,
    );
  }

  @override
  bool get isUniform => true;

  @override
  BorderSide get bottom => BorderSide.none;

  @override
  BorderSide get top => BorderSide.none;

  /// Get the amount of the stroke width that lies inside of the [BorderSide].
  ///
  /// For example, this will return the [width] for a [strokeAlign] of -1, half
  /// the [width] for a [strokeAlign] of 0, and 0 for a [strokeAlign] of 1.
  double get strokeInset => width * (1 - (1 + strokeAlign) / 2);

  /// Get the amount of the stroke width that lies outside of the [BorderSide].
  ///
  /// For example, this will return 0 for a [strokeAlign] of -1, half the
  /// [width] for a [strokeAlign] of 0, and the [width] for a [strokeAlign]
  /// of 1.
  double get strokeOutset => width * (1 + strokeAlign) / 2;

  /// The offset of the stroke, taking into account the stroke alignment.
  ///
  /// For example, this will return the negative [width] of the stroke
  /// for a [strokeAlign] of -1, 0 for a [strokeAlign] of 0, and the
  /// [width] for a [strokeAlign] of -1.
  double get strokeOffset => width * strokeAlign;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(strokeInset);

  @override
  GradientBoxBorder? add(ShapeBorder other, {bool reversed = false}) {
    if (other is GradientBoxBorder && canMerge(other)) return merge(other);
    return null;
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is GradientBoxBorder) {
      return GradientBoxBorder.lerp(a, this, t);
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is GradientBoxBorder) {
      return GradientBoxBorder.lerp(this, b, t);
    }
    return super.lerpTo(b, t);
  }

  /// Linearly interpolate between two gradient borders.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static GradientBoxBorder? lerp(GradientBoxBorder? a, GradientBoxBorder? b, double t) {
    if (identical(a, b)) return a;
    if (a == null) return b!.scale(t);
    if (b == null) return a.scale(1.0 - t);

    final width = ui.lerpDouble(a.width, b.width, t)!;
    if (width < 0.0) return GradientBoxBorder.none;

    if (a.style == b.style && a.strokeAlign == b.strokeAlign) {
      return GradientBoxBorder(
        gradient: Gradient.lerp(a.gradient, b.gradient, t)!,
        width: width,
        style: a.style, // == b.style
        strokeAlign: a.strokeAlign, // == b.strokeAlign
      );
    }

    final gradientA = switch (a.style) {
      BorderStyle.solid => a.gradient,
      BorderStyle.none => _kTransparentGradient,
    };

    final gradientB = switch (b.style) {
      BorderStyle.solid => b.gradient,
      BorderStyle.none => _kTransparentGradient,
    };

    if (a.strokeAlign != b.strokeAlign) {
      return GradientBoxBorder(
        gradient: Gradient.lerp(gradientA, gradientB, t)!,
        width: width,
        strokeAlign: ui.lerpDouble(a.strokeAlign, b.strokeAlign, t)!,
      );
    }

    return GradientBoxBorder(
      gradient: Gradient.lerp(gradientA, gradientB, t)!,
      width: width,
      strokeAlign: a.strokeAlign, // == b.strokeAlign
    );
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    assert(
      shape != BoxShape.circle || borderRadius == null,
      'A borderRadius can only be given for rectangular boxes.',
    );

    if (style == BorderStyle.none) return;

    return switch (shape) {
      BoxShape.circle => _paintUniformBorderWithCircle(canvas, rect),
      BoxShape.rectangle => switch (borderRadius) {
        final radius? when radius != BorderRadius.zero => _paintUniformBorderWithRadius(canvas, rect, radius),
        _ => _paintUniformBorderWithRectangle(canvas, rect),
      },
    };
  }

  void _paintUniformBorderWithRadius(
    Canvas canvas,
    Rect rect,
    BorderRadius borderRadius,
  ) {
    assert(style != BorderStyle.none, '');

    if (width == 0) {
      return canvas.drawRRect(borderRadius.toRRect(rect), _getPaint(rect));
    }

    final borderRect = borderRadius.toRRect(rect);
    final inner = borderRect.deflate(strokeInset);
    final outer = borderRect.inflate(strokeOutset);
    canvas.drawDRRect(outer, inner, _getPaint(rect));
  }

  void _paintUniformBorderWithRectangle(Canvas canvas, Rect rect) {
    assert(style != BorderStyle.none, '');
    return canvas.drawRect(rect.inflate(strokeOffset / 2), _getPaint(rect));
  }

  void _paintUniformBorderWithCircle(Canvas canvas, Rect rect) {
    assert(style != BorderStyle.none, '');
    final radius = (rect.shortestSide + strokeOffset) / 2;
    canvas.drawCircle(rect.center, radius, _getPaint(rect));
  }

  Paint _getPaint(Rect rect) {
    return switch (style) {
      BorderStyle.solid =>
        Paint()
          ..strokeWidth = width
          ..style = PaintingStyle.stroke
          ..shader = gradient.createShader(rect),
      BorderStyle.none =>
        Paint()
          ..strokeWidth = 0.0
          ..style = PaintingStyle.stroke
          ..shader = _kTransparentGradient.createShader(rect),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is GradientBoxBorder &&
        other.gradient == gradient &&
        other.width == width &&
        other.style == style &&
        other.strokeAlign == strokeAlign;
  }

  @override
  int get hashCode => Object.hash(gradient, width, style, strokeAlign);
}
