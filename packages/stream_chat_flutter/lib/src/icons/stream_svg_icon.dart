import 'package:flutter/material.dart';
import 'package:svg_icon_widget/svg_icon_widget.dart';

part 'stream_svg_icon.g.dart';

/// {@template StreamSvgIconData}
/// A class that holds the data for a [StreamSvgIcon].
/// {@endtemplate}
typedef StreamSvgIconData = SvgIconData;

/// {@template StreamSvgIcon}
/// Icon set of stream chat
/// {@endtemplate}
class StreamSvgIcon extends StatelessWidget {
  /// Creates a [StreamSvgIcon].
  const StreamSvgIcon({
    super.key,
    this.icon,
    this.color,
    this.size,
    this.textDirection,
    this.semanticLabel,
    this.applyTextScaling,
  });

  /// The icon to display.
  ///
  /// The icon can be null, in which case the widget will render as an empty
  /// space of the specified [size].
  final StreamSvgIconData? icon;

  /// The size of the icon in logical pixels.
  ///
  /// Icons occupy a square with width and height equal to size.
  ///
  /// Defaults to the nearest [IconTheme]'s [IconThemeData.size].
  ///
  /// If this [Icon] is being placed inside an [IconButton], then use
  /// [IconButton.iconSize] instead, so that the [IconButton] can make the
  /// splash area the appropriate size as well. The [IconButton] uses an
  /// [IconTheme] to pass down the size to the [Icon].
  final double? size;

  /// The color to use when drawing the icon.
  ///
  /// Defaults to the nearest [IconTheme]'s [IconThemeData.color].
  ///
  /// The color (whether specified explicitly here or obtained from the
  /// [IconTheme]) will be further adjusted by the nearest [IconTheme]'s
  /// [IconThemeData.opacity].
  ///
  /// {@tool snippet}
  /// Typically, a Material Design color will be used, as follows:
  ///
  /// ```dart
  /// StreamSvgIcon(
  ///   icon: 'reload.svg',
  ///   color: Colors.blue.shade400,
  /// )
  /// ```
  /// {@end-tool}
  final Color? color;

  /// The text direction to use for rendering the icon.
  ///
  /// If this is null, the ambient [Directionality] is used instead.
  ///
  /// Some icons follow the reading direction. For example, "back" buttons point
  /// left in left-to-right environments and right in right-to-left
  /// environments. Such icons have their [SvgIconData.matchTextDirection] field
  /// set to true, and the [SvgIcon] widget uses the [textDirection] to
  /// determine the orientation in which to draw the icon.
  ///
  /// This property has no effect if the [icon]'s
  /// [SvgIconData.matchTextDirection] field is false, but for consistency a
  /// text direction value must always be specified, either directly using this
  /// property or using [Directionality].
  final TextDirection? textDirection;

  /// Whether to scale the size of this widget using the ambient [MediaQuery]'s
  /// [TextScaler].
  ///
  /// This is specially useful when you have an icon associated with a text, as
  /// scaling the text without scaling the icon would result in a confusing
  /// interface.
  ///
  /// Defaults to the nearest [IconTheme]'s
  /// [IconThemeData.applyTextScaling].
  final bool? applyTextScaling;

  /// Semantic label for the icon.
  ///
  /// Announced by assistive technologies (e.g TalkBack/VoiceOver).
  /// This label does not show in the UI.
  ///
  ///  * [SemanticsProperties.label], which is set to [semanticLabel] in the
  ///    underlying	 [Semantics] widget.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SvgIcon(
      icon,
      size: size,
      color: color,
      textDirection: textDirection,
      applyTextScaling: applyTextScaling,
      semanticLabel: semanticLabel,
    );
  }
}
