import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/theme/avatar_theme.dart';
import 'package:stream_chat_flutter/src/theme/themes.dart';

/// {@macro channel_header_theme}
@Deprecated("Use 'StreamChannelHeaderTheme' instead")
typedef ChannelHeaderTheme = StreamChannelHeaderTheme;

/// {@template channel_header_theme}
/// Overrides the default style of [ChannelHeader] descendants.
///
/// See also:
///
///  * [StreamChannelHeaderThemeData], which is used to configure this theme.
/// {@endtemplate}
class StreamChannelHeaderTheme extends InheritedTheme {
  /// Creates a [StreamChannelHeaderTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamChannelHeaderTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamChannelHeaderThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamChannelHeaderTheme] widget, then
  /// [StreamChatThemeData.channelTheme.channelHeaderTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = ChannelHeaderTheme.of(context);
  /// ```
  static StreamChannelHeaderThemeData of(BuildContext context) {
    final channelHeaderTheme =
        context.dependOnInheritedWidgetOfExactType<StreamChannelHeaderTheme>();
    return channelHeaderTheme?.data ??
        StreamChatTheme.of(context).channelHeaderTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamChannelHeaderTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamChannelHeaderTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@macro channel_header_theme_data}
@Deprecated("Use 'StreamChannelHeaderThemeData' instead")
typedef ChannelHeaderThemeData = StreamChannelHeaderThemeData;

/// {@template channel_header_theme_data}
/// A style that overrides the default appearance of [ChannelHeader]s when used
/// with [StreamChannelHeaderTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.channelHeaderTheme].
///
/// See also:
///
/// * [StreamChannelHeaderTheme], the theme which is configured with this class.
/// * [StreamChatThemeData.channelHeaderTheme], which can be used to override
/// the default style for [ChannelHeader]s below the overall [StreamChatTheme].
/// {@endtemplate}
class StreamChannelHeaderThemeData with Diagnosticable {
  /// Creates a [StreamChannelHeaderThemeData]
  const StreamChannelHeaderThemeData({
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
  final StreamAvatarThemeData? avatarTheme;

  /// Color for [StreamChannelHeaderThemeData]
  final Color? color;

  /// Copy with theme
  StreamChannelHeaderThemeData copyWith({
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    StreamAvatarThemeData? avatarTheme,
    Color? color,
  }) =>
      StreamChannelHeaderThemeData(
        titleStyle: titleStyle ?? this.titleStyle,
        subtitleStyle: subtitleStyle ?? this.subtitleStyle,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        color: color ?? this.color,
      );

  /// Linearly interpolate between two [StreamChannelHeaderThemeData].
  ///
  /// All the properties must be non-null.
  StreamChannelHeaderThemeData lerp(
    StreamChannelHeaderThemeData a,
    StreamChannelHeaderThemeData b,
    double t,
  ) =>
      StreamChannelHeaderThemeData(
        titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
        subtitleStyle: TextStyle.lerp(a.subtitleStyle, b.subtitleStyle, t),
        avatarTheme: const StreamAvatarThemeData()
            .lerp(a.avatarTheme!, b.avatarTheme!, t),
        color: Color.lerp(a.color, b.color, t),
      );

  /// Merge with other [StreamChannelHeaderThemeData]
  StreamChannelHeaderThemeData merge(StreamChannelHeaderThemeData? other) {
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
      other is StreamChannelHeaderThemeData &&
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
