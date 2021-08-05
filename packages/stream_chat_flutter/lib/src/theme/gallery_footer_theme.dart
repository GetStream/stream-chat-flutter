import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// Overrides the default style of [GalleryFooter] descendants.
///
/// See also:
///
///  * [GalleryFooterThemeData], which is used to configure this theme.
class GalleryFooterTheme extends InheritedTheme {
  /// Creates an [GalleryFooterTheme].
  ///
  /// The [data] parameter must not be null.
  const GalleryFooterTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final GalleryFooterThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [GalleryFooterTheme] widget, then
  /// [StreamChatThemeData.galleryFooterTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ImageFooterTheme theme = ImageFooterTheme.of(context);
  /// ```
  static GalleryFooterThemeData of(BuildContext context) {
    final imageFooterTheme =
        context.dependOnInheritedWidgetOfExactType<GalleryFooterTheme>();
    return imageFooterTheme?.data ??
        StreamChatTheme.of(context).galleryFooterTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      GalleryFooterTheme(data: data, child: child);

  @override
  bool updateShouldNotify(GalleryFooterTheme oldWidget) =>
      data != oldWidget.data;
}

/// A style that overrides the default appearance of [GalleryFooter]s when used
/// with [GalleryFooterTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.galleryFooterTheme].
///
/// See also:
///
/// * [GalleryFooterTheme], the theme which is configured with this class.
/// * [StreamChatThemeData.galleryFooterTheme], which can be used to override
/// the default style for [GalleryFooter]s below the overall [StreamChatTheme].
class GalleryFooterThemeData with Diagnosticable {
  /// Creates an [GalleryFooterThemeData].
  const GalleryFooterThemeData({
    this.backgroundColor,
    this.shareIconColor,
    this.titleTextStyle,
    this.gridIconButtonColor,
    this.bottomSheetBarrierColor,
    this.bottomSheetBackgroundColor,
    this.bottomSheetPhotosTextStyle,
    this.bottomSheetCloseIconColor,
  });

  /// The background color for the [GalleryFooter] widget.
  ///
  /// Defaults to [ColorTheme.barsBg].
  final Color? backgroundColor;

  /// The color for the "share" icon.
  ///
  /// Defaults to [ColorTheme.textHighEmphasis].
  final Color? shareIconColor;

  /// The [TextStyle] to use for the [GalleryFooter] title text.
  ///
  /// Defaults to [TextTheme.headlineBold].
  final TextStyle? titleTextStyle;

  /// The color to use for the "grid" icon.
  ///
  /// Defaults to [ColorTheme.textHighEmphasis].
  final Color? gridIconButtonColor;

  /// The color to use behind the bottom sheet.
  ///
  /// Defaults to [ColorTheme.overlay].
  final Color? bottomSheetBarrierColor;

  /// The background color to use for the bottom sheet.
  ///
  /// Defaults to [ColorTheme.barsBg].
  final Color? bottomSheetBackgroundColor;

  /// The [TextStyle] to use for the "photos" text in the bottom sheet.
  ///
  /// Defaults to [TextTheme.headlineBold].
  final TextStyle? bottomSheetPhotosTextStyle;

  /// The color to use for the "close" icon.
  ///
  /// Defaults to [ColorTheme.textHighEmphasis].
  final Color? bottomSheetCloseIconColor;

  /// Copies this [GalleryFooterThemeData] to another.
  GalleryFooterThemeData copyWith({
    Color? backgroundColor,
    Color? shareIconColor,
    TextStyle? titleTextStyle,
    Color? gridIconButtonColor,
    Color? bottomSheetBarrierColor,
    Color? bottomSheetBackgroundColor,
    TextStyle? bottomSheetPhotosTextStyle,
    Color? bottomSheetCloseIconColor,
  }) =>
      GalleryFooterThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        shareIconColor: shareIconColor ?? this.shareIconColor,
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
        gridIconButtonColor: gridIconButtonColor ?? this.gridIconButtonColor,
        bottomSheetBarrierColor:
            bottomSheetBarrierColor ?? this.bottomSheetBarrierColor,
        bottomSheetBackgroundColor:
            bottomSheetBackgroundColor ?? this.bottomSheetBackgroundColor,
        bottomSheetPhotosTextStyle:
            bottomSheetPhotosTextStyle ?? this.bottomSheetPhotosTextStyle,
        bottomSheetCloseIconColor:
            bottomSheetCloseIconColor ?? this.bottomSheetCloseIconColor,
      );

  /// Linearly interpolate between two [GalleryFooter] themes.
  ///
  /// All the properties must be non-null.
  GalleryFooterThemeData lerp(
    GalleryFooterThemeData a,
    GalleryFooterThemeData b,
    double t,
  ) =>
      GalleryFooterThemeData(
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        shareIconColor: Color.lerp(a.shareIconColor, b.shareIconColor, t),
        titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
        gridIconButtonColor:
            Color.lerp(a.gridIconButtonColor, b.gridIconButtonColor, t),
        bottomSheetBarrierColor:
            Color.lerp(a.bottomSheetBarrierColor, b.bottomSheetBarrierColor, t),
        bottomSheetBackgroundColor: Color.lerp(
            a.bottomSheetBackgroundColor, b.bottomSheetBackgroundColor, t),
        bottomSheetPhotosTextStyle: TextStyle.lerp(
            a.bottomSheetPhotosTextStyle, b.bottomSheetPhotosTextStyle, t),
        bottomSheetCloseIconColor: Color.lerp(
            a.bottomSheetCloseIconColor, b.bottomSheetCloseIconColor, t),
      );

  /// Merges one [GalleryFooterThemeData] with another.
  GalleryFooterThemeData merge(GalleryFooterThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      bottomSheetBarrierColor: other.bottomSheetBarrierColor,
      bottomSheetBackgroundColor: other.bottomSheetBackgroundColor,
      bottomSheetCloseIconColor: other.bottomSheetCloseIconColor,
      bottomSheetPhotosTextStyle: other.bottomSheetPhotosTextStyle,
      gridIconButtonColor: other.gridIconButtonColor,
      titleTextStyle: other.titleTextStyle,
      shareIconColor: other.shareIconColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GalleryFooterThemeData &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          shareIconColor == other.shareIconColor &&
          titleTextStyle == other.titleTextStyle &&
          gridIconButtonColor == other.gridIconButtonColor &&
          bottomSheetBarrierColor == other.bottomSheetBarrierColor &&
          bottomSheetBackgroundColor == other.bottomSheetBackgroundColor &&
          bottomSheetPhotosTextStyle == other.bottomSheetPhotosTextStyle &&
          bottomSheetCloseIconColor == other.bottomSheetCloseIconColor;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      shareIconColor.hashCode ^
      titleTextStyle.hashCode ^
      gridIconButtonColor.hashCode ^
      bottomSheetBarrierColor.hashCode ^
      bottomSheetBackgroundColor.hashCode ^
      bottomSheetPhotosTextStyle.hashCode ^
      bottomSheetCloseIconColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(ColorProperty('shareIconColor', shareIconColor))
      ..add(DiagnosticsProperty('titleTextStyle', titleTextStyle))
      ..add(ColorProperty('gridIconButtonColor', gridIconButtonColor))
      ..add(ColorProperty('bottomSheetBarrierColor', bottomSheetBarrierColor))
      ..add(ColorProperty(
          'bottomSheetBackgroundColor', bottomSheetBackgroundColor))
      ..add(DiagnosticsProperty(
          'bottomSheetPhotosTextStyle', bottomSheetPhotosTextStyle))
      ..add(ColorProperty(
          'bottomSheetCloseIconColor', bottomSheetCloseIconColor));
  }
}
