import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'poll_card_style.g.theme.dart';

/// Visual styling for card-like surfaces used by poll widgets.
///
/// Describes the generic chrome (background color, corner radius, inner
/// padding) of a card container. Reused by
/// [StreamPollOptionsSheetThemeData] for both the question card and the
/// options card, and available for other poll surfaces that need the same
/// shape of styling.
///
/// Per-surface concerns (text styles, spacing between inner items, sub-widget
/// styles) intentionally live on the containing theme data classes rather
/// than here, to keep this style class single-purpose.
@themeGen
@immutable
class StreamPollCardStyle with _$StreamPollCardStyle {
  /// Creates poll card style properties.
  const StreamPollCardStyle({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
  });

  /// The background color of the card surface.
  ///
  /// If null, defaults to [StreamColorScheme.backgroundSurfaceCard].
  final Color? backgroundColor;

  /// The corner radius of the card surface.
  ///
  /// If null, defaults to `BorderRadius.all(StreamRadius.lg)`.
  final BorderRadiusGeometry? borderRadius;

  /// The padding inside the card around its content.
  ///
  /// If null, defaults are resolved by the consuming widget
  /// (typically based on [StreamSpacing]).
  final EdgeInsetsGeometry? padding;

  /// Linearly interpolate between two [StreamPollCardStyle] objects.
  static StreamPollCardStyle? lerp(
    StreamPollCardStyle? a,
    StreamPollCardStyle? b,
    double t,
  ) => _$StreamPollCardStyle.lerp(a, b, t);
}
