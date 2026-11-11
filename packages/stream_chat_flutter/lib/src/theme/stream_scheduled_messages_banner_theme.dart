import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../stream_chat_flutter.dart';

part 'stream_scheduled_messages_banner_theme.g.theme.dart';

/// An inherited theme for descendant [StreamScheduledMessagesBanner]s.
///
/// Values set here override
/// [StreamChatThemeData.scheduledMessagesBannerTheme] for the subtree.
///
/// {@tool snippet}
///
/// Shows the banner's "View all" in green:
///
/// ```dart
/// StreamScheduledMessagesBannerTheme(
///   data: StreamScheduledMessagesBannerThemeData(
///     viewAllStyle: TextStyle(color: Colors.green),
///   ),
///   child: StreamScheduledMessagesBanner(),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamScheduledMessagesBannerThemeData], which describes the theme.
///  * [StreamScheduledMessagesBanner], which this theme styles.
class StreamScheduledMessagesBannerTheme extends InheritedTheme {
  /// Creates a scheduled messages banner theme that controls descendant
  /// widgets.
  const StreamScheduledMessagesBannerTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The scheduled messages banner theme data for descendant widgets.
  final StreamScheduledMessagesBannerThemeData data;

  /// The [StreamScheduledMessagesBannerThemeData] merged from local and
  /// global themes.
  ///
  /// Local values from the nearest [StreamScheduledMessagesBannerTheme]
  /// ancestor take precedence over global values from [StreamChatTheme.of].
  static StreamScheduledMessagesBannerThemeData of(BuildContext context) {
    final local = context.dependOnInheritedWidgetOfExactType<StreamScheduledMessagesBannerTheme>();
    return StreamChatTheme.of(context).scheduledMessagesBannerTheme.merge(local?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamScheduledMessagesBannerTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamScheduledMessagesBannerTheme oldWidget) {
    return data != oldWidget.data;
  }
}

/// Theme data for customizing [StreamScheduledMessagesBanner] widgets.
///
/// {@tool snippet}
///
/// Scheduled messages banners styled app-wide:
///
/// ```dart
/// StreamChatThemeData(
///   scheduledMessagesBannerTheme: StreamScheduledMessagesBannerThemeData(
///     backgroundColor: Colors.white,
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamScheduledMessagesBanner], which uses this theme data.
///  * [StreamScheduledMessagesBannerTheme], which overrides the theme in a
///    widget subtree.
@themeGen
@immutable
class StreamScheduledMessagesBannerThemeData with _$StreamScheduledMessagesBannerThemeData {
  /// Creates a scheduled messages banner theme with optional style
  /// overrides.
  const StreamScheduledMessagesBannerThemeData({
    this.backgroundColor,
    this.side,
    this.boxShadow,
    this.padding,
    this.countStyle,
    this.viewAllStyle,
    this.iconColor,
    this.failedIconColor,
  });

  /// The background color of the banner.
  ///
  /// Falls back to [StreamColorScheme.backgroundElevation2].
  final Color? backgroundColor;

  /// The border of the banner.
  ///
  /// Falls back to a 1px [StreamColorScheme.borderDefault] border.
  final BorderSide? side;

  /// The shadow of the banner.
  ///
  /// Falls back to [StreamBoxShadow.elevation3].
  final List<BoxShadow>? boxShadow;

  /// The padding around the content of the banner.
  ///
  /// Falls back to [StreamSpacing.md] horizontally and [StreamSpacing.sm]
  /// vertically.
  final EdgeInsetsGeometry? padding;

  /// The text style of the count of scheduled messages.
  ///
  /// Falls back to [StreamTextTheme.metadataEmphasis] with
  /// [StreamColorScheme.textPrimary].
  final TextStyle? countStyle;

  /// The text style of "View all".
  ///
  /// Falls back to [StreamTextTheme.metadataDefault] with
  /// [StreamColorScheme.textLink].
  final TextStyle? viewAllStyle;

  /// The color of the icon while messages are scheduled.
  ///
  /// Falls back to [StreamColorScheme.accentPrimary].
  final Color? iconColor;

  /// The color of the icon when messages failed to send.
  ///
  /// Falls back to [StreamColorScheme.accentError].
  final Color? failedIconColor;

  /// Linearly interpolates between two
  /// [StreamScheduledMessagesBannerThemeData] objects.
  static StreamScheduledMessagesBannerThemeData? lerp(
    StreamScheduledMessagesBannerThemeData? a,
    StreamScheduledMessagesBannerThemeData? b,
    double t,
  ) => _$StreamScheduledMessagesBannerThemeData.lerp(a, b, t);
}
