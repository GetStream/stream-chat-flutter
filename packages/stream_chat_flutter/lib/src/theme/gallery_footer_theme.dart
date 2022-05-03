import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// {@macro gallery_footer_theme}
@Deprecated("Use 'StreamGalleryFooterTheme' instead")
typedef GalleryFooterTheme = StreamGalleryFooterTheme;

/// {@template gallery_footer_theme}
/// Overrides the default style of [GalleryFooter] descendants.
///
/// See also:
///
///  * [StreamGalleryFooterThemeData], which is used to configure this theme.
/// {@endtemplate}
class StreamGalleryFooterTheme extends InheritedTheme {
  /// Creates an [StreamGalleryFooterTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamGalleryFooterTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final StreamGalleryFooterThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamGalleryFooterTheme] widget, then
  /// [StreamChatThemeData.galleryFooterTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ImageFooterTheme theme = ImageFooterTheme.of(context);
  /// ```
  static StreamGalleryFooterThemeData of(BuildContext context) {
    final imageFooterTheme =
        context.dependOnInheritedWidgetOfExactType<StreamGalleryFooterTheme>();
    return imageFooterTheme?.data ??
        StreamChatTheme.of(context).galleryFooterTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamGalleryFooterTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamGalleryFooterTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@macro gallery_footer_theme_data}
@Deprecated("Use 'StreamGalleryFooterThemeData' instead")
typedef GalleryFooterThemeData = StreamGalleryFooterThemeData;

/// {@template gallery_footer_theme_data}
/// A style that overrides the default appearance of [GalleryFooter]s when used
/// with [StreamGalleryFooterTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.galleryFooterTheme].
///
/// See also:
///
/// * [StreamGalleryFooterTheme], the theme which is configured with this class.
/// * [StreamChatThemeData.galleryFooterTheme], which can be used to override
/// the default style for [GalleryFooter]s below the overall [StreamChatTheme].
/// {@endtemplate}
class StreamGalleryFooterThemeData with Diagnosticable {
  /// Creates an [StreamGalleryFooterThemeData].
  const StreamGalleryFooterThemeData({
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

  /// Copies this [StreamGalleryFooterThemeData] to another.
  StreamGalleryFooterThemeData copyWith({
    Color? backgroundColor,
    Color? shareIconColor,
    TextStyle? titleTextStyle,
    Color? gridIconButtonColor,
    Color? bottomSheetBarrierColor,
    Color? bottomSheetBackgroundColor,
    TextStyle? bottomSheetPhotosTextStyle,
    Color? bottomSheetCloseIconColor,
  }) =>
      StreamGalleryFooterThemeData(
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
  StreamGalleryFooterThemeData lerp(
    StreamGalleryFooterThemeData a,
    StreamGalleryFooterThemeData b,
    double t,
  ) =>
      StreamGalleryFooterThemeData(
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        shareIconColor: Color.lerp(a.shareIconColor, b.shareIconColor, t),
        titleTextStyle: TextStyle.lerp(a.titleTextStyle, b.titleTextStyle, t),
        gridIconButtonColor:
            Color.lerp(a.gridIconButtonColor, b.gridIconButtonColor, t),
        bottomSheetBarrierColor:
            Color.lerp(a.bottomSheetBarrierColor, b.bottomSheetBarrierColor, t),
        bottomSheetBackgroundColor: Color.lerp(
          a.bottomSheetBackgroundColor,
          b.bottomSheetBackgroundColor,
          t,
        ),
        bottomSheetPhotosTextStyle: TextStyle.lerp(
          a.bottomSheetPhotosTextStyle,
          b.bottomSheetPhotosTextStyle,
          t,
        ),
        bottomSheetCloseIconColor: Color.lerp(
          a.bottomSheetCloseIconColor,
          b.bottomSheetCloseIconColor,
          t,
        ),
      );

  /// Merges one [StreamGalleryFooterThemeData] with another.
  StreamGalleryFooterThemeData merge(StreamGalleryFooterThemeData? other) {
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
      other is StreamGalleryFooterThemeData &&
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
        'bottomSheetBackgroundColor',
        bottomSheetBackgroundColor,
      ))
      ..add(DiagnosticsProperty(
        'bottomSheetPhotosTextStyle',
        bottomSheetPhotosTextStyle,
      ))
      ..add(ColorProperty(
        'bottomSheetCloseIconColor',
        bottomSheetCloseIconColor,
      ));
  }
}
