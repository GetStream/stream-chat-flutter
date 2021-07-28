import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// Overrides the default style of [GalleryHeader] descendants.
///
/// See also:
///
///  * [GalleryHeaderThemeData], which is used to configure this theme.
class GalleryHeaderTheme extends InheritedTheme {
  /// Creates a [GalleryHeaderTheme].
  ///
  /// The [data] parameter must not be null.
  const GalleryHeaderTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final GalleryHeaderThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [GalleryHeaderTheme] widget, then
  /// [StreamChatThemeData.galleryHeaderTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ImageHeaderTheme theme = ImageHeaderTheme.of(context);
  /// ```
  static GalleryHeaderThemeData of(BuildContext context) {
    final galleryHeaderTheme =
        context.dependOnInheritedWidgetOfExactType<GalleryHeaderTheme>();
    return galleryHeaderTheme?.data ??
        StreamChatTheme.of(context).galleryHeaderTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      GalleryHeaderTheme(data: data, child: child);

  @override
  bool updateShouldNotify(GalleryHeaderTheme oldWidget) =>
      data != oldWidget.data;
}

/// A style that overrides the default appearance of [GalleryHeader]s when used
/// with [GalleryHeaderTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.galleryHeaderTheme].
///
/// See also:
///
/// * [GalleryHeaderTheme], the theme which is configured with this class.
/// * [StreamChatThemeData.galleryHeaderTheme], which can be used to override
/// the default style for [GalleryHeader]s below the overall [StreamChatTheme].
class GalleryHeaderThemeData with Diagnosticable {
  /// Creates an [GalleryHeaderThemeData].
  const GalleryHeaderThemeData({
    this.closeButtonColor,
    this.backgroundColor,
    this.iconMenuPointColor,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.bottomSheetBarrierColor,
  });

  /// The color of the "close" button.
  ///
  /// Defaults to [ColorTheme.textHighEmphasis].
  final Color? closeButtonColor;

  /// The background color of the [GalleryHeader] widget.
  ///
  /// Defaults to [ChannelHeaderTheme.color].
  final Color? backgroundColor;

  /// Defaults to [ColorTheme.textHighEmphasis].
  final Color? iconMenuPointColor;

  /// The [TextStyle] to use for the [GalleryHeader] title text.
  ///
  /// Defaults to [TextTheme.headlineBold].
  final TextStyle? titleTextStyle;

  /// The [TextStyle] to use for the [GalleryHeader] subtitle text.
  ///
  /// Defaults to [ChannelPreviewTheme.subtitleStyle].
  final TextStyle? subtitleTextStyle;

  ///
  final Color? bottomSheetBarrierColor;

  /// Copies this [GalleryHeaderThemeData] to another.
  GalleryHeaderThemeData copyWith({
    Color? closeButtonColor,
    Color? backgroundColor,
    Color? iconMenuPointColor,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    Color? bottomSheetBarrierColor,
  }) =>
      GalleryHeaderThemeData(
        closeButtonColor: closeButtonColor ?? this.closeButtonColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        iconMenuPointColor: iconMenuPointColor ?? this.iconMenuPointColor,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
        subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
        bottomSheetBarrierColor:
            bottomSheetBarrierColor ?? this.bottomSheetBarrierColor,
      );

  /// Linearly interpolate between two [GalleryHeader] themes.
  ///
  /// All the properties must be non-null.
  GalleryHeaderThemeData lerp(
    GalleryHeaderThemeData a,
    GalleryHeaderThemeData b,
    double t,
  ) =>
      GalleryHeaderThemeData(
        closeButtonColor: Color.lerp(a.closeButtonColor, b.closeButtonColor, t),
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        iconMenuPointColor:
            Color.lerp(a.iconMenuPointColor, b.iconMenuPointColor, t),
        titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
        subtitleTextStyle:
            TextStyle.lerp(a.subtitleTextStyle, b.subtitleTextStyle, t),
        bottomSheetBarrierColor:
            Color.lerp(a.bottomSheetBarrierColor, b.bottomSheetBarrierColor, t),
      );

  /// Merges one [GalleryHeaderThemeData] with the another
  GalleryHeaderThemeData merge(GalleryHeaderThemeData? other) {
    if (other == null) return this;
    return copyWith(
      closeButtonColor: other.closeButtonColor,
      backgroundColor: other.backgroundColor,
      iconMenuPointColor: other.iconMenuPointColor,
      titleTextStyle: other.titleTextStyle,
      subtitleTextStyle: other.subtitleTextStyle,
      bottomSheetBarrierColor: other.bottomSheetBarrierColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GalleryHeaderThemeData &&
          runtimeType == other.runtimeType &&
          closeButtonColor == other.closeButtonColor &&
          backgroundColor == other.backgroundColor &&
          iconMenuPointColor == other.iconMenuPointColor &&
          titleTextStyle == other.titleTextStyle &&
          subtitleTextStyle == other.subtitleTextStyle &&
          bottomSheetBarrierColor == other.bottomSheetBarrierColor;

  @override
  int get hashCode =>
      closeButtonColor.hashCode ^
      backgroundColor.hashCode ^
      iconMenuPointColor.hashCode ^
      titleTextStyle.hashCode ^
      subtitleTextStyle.hashCode ^
      bottomSheetBarrierColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('closeButtonColor', closeButtonColor))
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(ColorProperty('iconMenuPointColor', iconMenuPointColor))
      ..add(DiagnosticsProperty('titleTextStyle', titleTextStyle))
      ..add(DiagnosticsProperty('subtitleTextStyle', subtitleTextStyle))
      ..add(ColorProperty('bottomSheetBarrierColor', bottomSheetBarrierColor));
  }
}
