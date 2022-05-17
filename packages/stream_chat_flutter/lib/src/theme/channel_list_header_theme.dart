import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/theme/avatar_theme.dart';

/// {@macro channel_list_header_theme}
@Deprecated("Use 'StreamChannelListHeaderTheme' instead")
typedef ChannelListHeaderTheme = StreamChannelListHeaderTheme;

/// {@template channel_list_header_theme}
/// Overrides the default style of [ChannelListHeader] descendants.
///
/// See also:
///
///  * [StreamChannelListHeaderThemeData], which is used
/// to configure this theme.
/// {@endtemplate}
class StreamChannelListHeaderTheme extends InheritedTheme {
  /// Creates a [StreamChannelListHeaderTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamChannelListHeaderTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamChannelListHeaderThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamChannelListHeaderTheme] widget, then
  /// [StreamChatThemeData.channelListHeaderTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// final theme = ChannelListHeaderTheme.of(context);
  /// ```
  static StreamChannelListHeaderThemeData of(BuildContext context) {
    final channelListHeaderTheme = context
        .dependOnInheritedWidgetOfExactType<StreamChannelListHeaderTheme>();
    return channelListHeaderTheme?.data ??
        StreamChatTheme.of(context).channelListHeaderTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamChannelListHeaderTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamChannelListHeaderTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@macro channel_list_header_theme_data}
@Deprecated("Use ''StreamChannelListHeaderThemeData' instead")
typedef ChannelListHeaderThemeData = StreamChannelListHeaderThemeData;

/// {@template channel_list_header_theme_data}
/// Theme dedicated to the [ChannelListHeader]
/// {@endtemplate}
class StreamChannelListHeaderThemeData with Diagnosticable {
  /// Returns a new [StreamChannelListHeaderThemeData]
  const StreamChannelListHeaderThemeData({
    this.titleStyle,
    this.avatarTheme,
    this.color,
  });

  /// Style of the title text
  final TextStyle? titleStyle;

  /// Theme dedicated to the userAvatar
  final StreamAvatarThemeData? avatarTheme;

  /// Background color of the appbar
  final Color? color;

  /// Returns a new [StreamChannelListHeaderThemeData] replacing some of its
  /// properties
  StreamChannelListHeaderThemeData copyWith({
    TextStyle? titleStyle,
    StreamAvatarThemeData? avatarTheme,
    Color? color,
  }) =>
      StreamChannelListHeaderThemeData(
        titleStyle: titleStyle ?? this.titleStyle,
        avatarTheme: avatarTheme ?? this.avatarTheme,
        color: color ?? this.color,
      );

  /// Linearly interpolate from one [StreamChannelListHeaderThemeData]
  /// to another.
  StreamChannelListHeaderThemeData lerp(
    StreamChannelListHeaderThemeData a,
    StreamChannelListHeaderThemeData b,
    double t,
  ) =>
      StreamChannelListHeaderThemeData(
        avatarTheme: const StreamAvatarThemeData()
            .lerp(a.avatarTheme!, b.avatarTheme!, t),
        color: Color.lerp(a.color, b.color, t),
        titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
      );

  /// Merges [this] [StreamChannelListHeaderThemeData] with the [other]
  StreamChannelListHeaderThemeData merge(
    StreamChannelListHeaderThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      titleStyle: titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
      avatarTheme: avatarTheme?.merge(other.avatarTheme) ?? other.avatarTheme,
      color: other.color,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamChannelListHeaderThemeData &&
          runtimeType == other.runtimeType &&
          titleStyle == other.titleStyle &&
          avatarTheme == other.avatarTheme &&
          color == other.color;

  @override
  int get hashCode =>
      titleStyle.hashCode ^ avatarTheme.hashCode ^ color.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('titleStyle', titleStyle))
      ..add(DiagnosticsProperty('avatarTheme', avatarTheme))
      ..add(ColorProperty('color', color));
  }
}
