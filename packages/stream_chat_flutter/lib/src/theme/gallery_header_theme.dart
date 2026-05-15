import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// {@template galleryHeaderTheme}
/// Overrides the default style of [StreamGalleryHeader] descendants.
///
/// See also:
///
///  * [StreamGalleryHeaderThemeData], which is used to configure this theme.
/// {@endtemplate}
class StreamGalleryHeaderTheme extends InheritedTheme {
  /// Creates a [StreamGalleryHeaderTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamGalleryHeaderTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamGalleryHeaderThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamGalleryHeaderTheme] widget, then
  /// [StreamChatThemeData.galleryHeaderTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ImageHeaderTheme theme = ImageHeaderTheme.of(context);
  /// ```
  static StreamGalleryHeaderThemeData of(BuildContext context) {
    final galleryHeaderTheme =
        context.dependOnInheritedWidgetOfExactType<StreamGalleryHeaderTheme>();
    return galleryHeaderTheme?.data ??
        StreamChatTheme.of(context).galleryHeaderTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamGalleryHeaderTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamGalleryHeaderTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@template galleryHeaderThemeData}
/// A style that overrides the default appearance of [StreamGalleryHeader]s
/// when used with [StreamGalleryHeaderTheme] or with the overall
/// [StreamChatTheme]'s [StreamChatThemeData.galleryHeaderTheme].
///
/// See also:
///
/// * [StreamGalleryHeaderTheme], the theme which is configured with this class.
/// * [StreamChatThemeData.galleryHeaderTheme], which can be used to override
/// the default style for [StreamGalleryHeader]s below the overall
/// [StreamChatTheme].
/// {@endtemplate}
class StreamGalleryHeaderThemeData with Diagnosticable {
  /// Creates an [StreamGalleryHeaderThemeData].
  const StreamGalleryHeaderThemeData({
    this.closeButtonColor,
    this.backgroundColor,
    this.iconMenuPointColor,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.bottomSheetBarrierColor,
  });

  /// The color of the "close" button.
  ///
  /// Defaults to [StreamColorTheme.textHighEmphasis].
  final Color? closeButtonColor;

  /// The background color of the [StreamGalleryHeader] widget.
  ///
  /// Defaults to [ChannelHeaderTheme.color].
  final Color? backgroundColor;

  /// Defaults to [StreamColorTheme.textHighEmphasis].
  final Color? iconMenuPointColor;

  /// The [TextStyle] to use for the [StreamGalleryHeader] title text.
  ///
  /// Defaults to [StreamTextTheme.headlineBold].
  final TextStyle? titleTextStyle;

  /// The [TextStyle] to use for the [StreamGalleryHeader] subtitle text.
  ///
  /// Defaults to [ChannelPreviewTheme.subtitleStyle].
  final TextStyle? subtitleTextStyle;

  ///
  final Color? bottomSheetBarrierColor;

  /// Copies this [StreamGalleryHeaderThemeData] to another.
  StreamGalleryHeaderThemeData copyWith({
    Color? closeButtonColor,
    Color? backgroundColor,
    Color? iconMenuPointColor,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    Color? bottomSheetBarrierColor,
  }) {
    return StreamGalleryHeaderThemeData(
      closeButtonColor: closeButtonColor ?? this.closeButtonColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      iconMenuPointColor: iconMenuPointColor ?? this.iconMenuPointColor,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
      bottomSheetBarrierColor:
          bottomSheetBarrierColor ?? this.bottomSheetBarrierColor,
    );
  }

  /// Linearly interpolate between two [StreamGalleryHeader] themes.
  ///
  /// All the properties must be non-null.
  StreamGalleryHeaderThemeData lerp(
    StreamGalleryHeaderThemeData a,
    StreamGalleryHeaderThemeData b,
    double t,
  ) {
    return StreamGalleryHeaderThemeData(
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
  }

  /// Merges one [StreamGalleryHeaderThemeData] with the another
  StreamGalleryHeaderThemeData merge(StreamGalleryHeaderThemeData? other) {
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
      other is StreamGalleryHeaderThemeData &&
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
