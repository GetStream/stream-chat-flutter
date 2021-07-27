import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/theme/avatar_theme.dart';
import 'package:stream_chat_flutter/src/theme/themes.dart';

/// Overrides the default style of [ChannelHeader] descendants.
///
/// See also:
///
///  * [ChannelHeaderThemeData], which is used to configure this theme.
class ChannelHeaderTheme extends InheritedTheme {
  /// Creates a [ChannelHeaderTheme].
  ///
  /// The [data] parameter must not be null.
  const ChannelHeaderTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final ChannelHeaderThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [ChannelHeaderTheme] widget, then
  /// [StreamChatThemeData.channelTheme.channelHeaderTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = ChannelHeaderTheme.of(context);
  /// ```
  static ChannelHeaderThemeData of(BuildContext context) {
    final channelHeaderTheme =
        context.dependOnInheritedWidgetOfExactType<ChannelHeaderTheme>();
    return channelHeaderTheme?.data ??
        StreamChatTheme.of(context).channelTheme.channelHeaderTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      ChannelHeaderTheme(data: data, child: child);

  @override
  bool updateShouldNotify(ChannelHeaderTheme oldWidget) =>
      data != oldWidget.data;
}

/// A style that overrides the default appearance of [ChannelHeader]s when used
/// with [ChannelHeaderTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.channelHeaderTheme].
///
/// See also:
///
/// * [ChannelHeaderTheme], the theme which is configured with this class.
/// * [StreamChatThemeData.channelHeaderTheme], which can be used to override
/// the default style for [ChannelHeader]s below the overall [StreamChatTheme].
class ChannelHeaderThemeData with Diagnosticable {
  /// Creates a [ChannelHeaderThemeData]
  const ChannelHeaderThemeData({
    this.titleStyle,
    this.subtitleStyle,
    this.avatarTheme,
    this.color,
  });

  /// Theme for title
  final TextStyle? titleStyle;

  /// Theme for subtitle
  final TextStyle? subtitleStyle;

  /// Theme for avatar
  final AvatarThemeData? avatarTheme;

  /// Color for [ChannelHeaderThemeData]
  final Color? color;

  /// Copy with theme
  ChannelHeaderThemeData copyWith({
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    AvatarThemeData? avatarTheme,
    Color? color,
  }) =>
      ChannelHeaderThemeData(
        titleStyle: titleStyle ?? this.titleStyle,
        subtitleStyle: subtitleStyle ?? this.subtitleStyle,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        color: color ?? this.color,
      );

  /// Linearly interpolate between two [ChannelHeaderThemeData].
  ///
  /// All the properties must be non-null.
  ChannelHeaderThemeData lerp(
    ChannelHeaderThemeData a,
    ChannelHeaderThemeData b,
    double t,
  ) =>
      ChannelHeaderThemeData(
        titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
        subtitleStyle: TextStyle.lerp(a.subtitleStyle, b.subtitleStyle, t),
        avatarTheme:
            const AvatarThemeData().lerp(a.avatarTheme!, b.avatarTheme!, t),
        color: Color.lerp(a.color, b.color, t),
      );

  /// Merge with other [ChannelHeaderThemeData]
  ChannelHeaderThemeData merge(ChannelHeaderThemeData? other) {
    if (other == null) return this;
    return copyWith(
      titleStyle: titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
      subtitleStyle:
          subtitleStyle?.merge(other.subtitleStyle) ?? other.subtitleStyle,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      color: other.color,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelHeaderThemeData &&
          runtimeType == other.runtimeType &&
          titleStyle == other.titleStyle &&
          subtitleStyle == other.subtitleStyle &&
          avatarTheme == other.avatarTheme &&
          color == other.color;

  @override
  int get hashCode =>
      titleStyle.hashCode ^
      subtitleStyle.hashCode ^
      avatarTheme.hashCode ^
      color.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('title', titleStyle))
      ..add(DiagnosticsProperty('subtitle', subtitleStyle))
      ..add(DiagnosticsProperty('avatarTheme', avatarTheme))
      ..add(ColorProperty('color', color));
  }
}
