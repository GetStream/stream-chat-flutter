import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// Overrides the default style of [ChannelListView] descendants.
///
/// See also:
///
///  * [ChannelListViewThemeData], which is used to configure this theme.
class ChannelListViewTheme extends InheritedTheme {
  /// Creates a [ChannelListViewTheme].
  ///
  /// The [data] parameter must not be null.
  const ChannelListViewTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final ChannelListViewThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [ChannelListViewTheme] widget, then
  /// [StreamChatThemeData.channelListViewTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ChannelListViewTheme theme = ChannelListViewTheme.of(context);
  /// ```
  static ChannelListViewThemeData of(BuildContext context) {
    final channelListViewTheme =
        context.dependOnInheritedWidgetOfExactType<ChannelListViewTheme>();
    return channelListViewTheme?.data ??
        StreamChatTheme.of(context).channelListViewTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      ChannelListViewTheme(data: data, child: child);

  @override
  bool updateShouldNotify(ChannelListViewTheme oldWidget) =>
      data != oldWidget.data;
}

/// A style that overrides the default appearance of [ChannelListView]s when
/// used with [ChannelListViewTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.channelListViewTheme].
///
/// See also:
///
/// * [ChannelListViewTheme], the theme which is configured with this class.
/// * [StreamChatThemeData.channelListViewTheme], which can be used to override
/// the default style for [ChannelListView]s below the overall
/// [StreamChatTheme].
class ChannelListViewThemeData with Diagnosticable {
  /// Creates a [ChannelListViewThemeData].
  const ChannelListViewThemeData({
    this.backgroundColor,
  });

  /// The color of the [ChannelListView] background.
  final Color? backgroundColor;

  /// Copies this [ChannelListViewThemeData] to another.
  ChannelListViewThemeData copyWith({
    Color? backgroundColor,
  }) =>
      ChannelListViewThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
      );

  /// Linearly interpolate between two [ChannelListViewThemeData] themes.
  ///
  /// All the properties must be non-null.
  ChannelListViewThemeData lerp(
    ChannelListViewThemeData a,
    ChannelListViewThemeData b,
    double t,
  ) =>
      ChannelListViewThemeData(
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      );

  /// Merges one [ChannelListViewThemeData] with another.
  ChannelListViewThemeData merge(ChannelListViewThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelListViewThemeData &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor;

  @override
  int get hashCode => backgroundColor.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
  }
}
