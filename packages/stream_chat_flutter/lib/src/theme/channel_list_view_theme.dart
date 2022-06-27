import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// {@macro channelListViewTheme}
@Deprecated("Use 'StreamChannelListViewTheme' instead")
typedef ChannelListViewTheme = StreamChannelListViewTheme;

/// {@template channelListViewTheme}
/// Overrides the default style of [ChannelListView] descendants.
///
/// See also:
///
///  * [StreamChannelListViewThemeData], which is used to configure this theme.
/// {@endtemplate}
class StreamChannelListViewTheme extends InheritedTheme {
  /// Creates a [StreamChannelListViewTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamChannelListViewTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamChannelListViewThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamChannelListViewTheme] widget, then
  /// [StreamChatThemeData.channelListViewTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// ChannelListViewTheme theme = ChannelListViewTheme.of(context);
  /// ```
  static StreamChannelListViewThemeData of(BuildContext context) {
    final channelListViewTheme = context
        .dependOnInheritedWidgetOfExactType<StreamChannelListViewTheme>();
    return channelListViewTheme?.data ??
        StreamChatTheme.of(context).channelListViewTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamChannelListViewTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamChannelListViewTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@macro channelListViewThemeData}
@Deprecated("Use 'StreamChannelListViewThemeData' instead")
typedef ChannelListViewThemeData = StreamChannelListViewThemeData;

/// {@template channelListViewThemeData}
/// A style that overrides the default appearance of [ChannelListView]s when
/// used with [StreamChannelListViewTheme]
/// or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.channelListViewTheme].
///
/// See also:
///
/// * [StreamChannelListViewTheme], the theme
/// which is configured with this class.
/// * [StreamChatThemeData.channelListViewTheme], which can be used to override
/// the default style for [ChannelListView]s below the overall
/// [StreamChatTheme].
/// {@endtemplate}
class StreamChannelListViewThemeData with Diagnosticable {
  /// Creates a [StreamChannelListViewThemeData].
  const StreamChannelListViewThemeData({
    this.backgroundColor,
  });

  /// The color of the [ChannelListView] background.
  final Color? backgroundColor;

  /// Copies this [StreamChannelListViewThemeData] to another.
  StreamChannelListViewThemeData copyWith({
    Color? backgroundColor,
  }) {
    return StreamChannelListViewThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  /// Linearly interpolate between two [StreamChannelListViewThemeData] themes.
  ///
  /// All the properties must be non-null.
  StreamChannelListViewThemeData lerp(
    StreamChannelListViewThemeData a,
    StreamChannelListViewThemeData b,
    double t,
  ) {
    return StreamChannelListViewThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
    );
  }

  /// Merges one [StreamChannelListViewThemeData] with another.
  StreamChannelListViewThemeData merge(StreamChannelListViewThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamChannelListViewThemeData &&
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
