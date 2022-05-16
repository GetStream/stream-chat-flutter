import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// {@macro user_list_view_theme}
@Deprecated("Use 'StreamUserListViewTheme' instead")
typedef UserListViewTheme = StreamUserListViewTheme;

/// {@template user_list_view_theme}
/// Overrides the default style of [UserListView] descendants.
///
/// See also:
///
///  * [StreamUserListViewThemeData], which is used to configure this theme.
/// {@endtemplate}
class StreamUserListViewTheme extends InheritedTheme {
  /// Creates a [StreamUserListViewTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamUserListViewTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The configuration of this theme.
  final StreamUserListViewThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamUserListViewTheme] widget, then
  /// [StreamChatThemeData.userListViewTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// UserListViewTheme theme = UserListViewTheme.of(context);
  /// ```
  static StreamUserListViewThemeData of(BuildContext context) {
    final userListViewTheme =
        context.dependOnInheritedWidgetOfExactType<StreamUserListViewTheme>();
    return userListViewTheme?.data ??
        StreamChatTheme.of(context).userListViewTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamUserListViewTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamUserListViewTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@macro user_list_view_theme_data}
@Deprecated("Use 'StreamUserListViewThemeData' instead")
typedef UserListViewThemeData = StreamUserListViewThemeData;

/// {@template user_list_view_theme_data}
/// A style that overrides the default appearance of [UserListView]s when
/// used with [StreamUserListViewTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.userListViewTheme].
///
/// See also:
///
/// * [StreamUserListViewTheme], the theme which is configured with this class.
/// * [StreamChatThemeData.userListViewTheme], which can be used to override
/// the default style for [UserListView]s below the overall
/// [StreamChatTheme].
/// {@endtemplate}
class StreamUserListViewThemeData with Diagnosticable {
  /// Creates a [StreamUserListViewThemeData].
  const StreamUserListViewThemeData({
    this.backgroundColor,
  });

  /// The color of the [ChannelListView] background.
  final Color? backgroundColor;

  /// Copies this [ChannelListViewThemeData] to another.
  StreamUserListViewThemeData copyWith({
    Color? backgroundColor,
  }) =>
      StreamUserListViewThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
      );

  /// Linearly interpolate between two [StreamUserListViewThemeData] themes.
  ///
  /// All the properties must be non-null.
  StreamUserListViewThemeData lerp(
    StreamUserListViewThemeData a,
    StreamUserListViewThemeData b,
    double t,
  ) =>
      StreamUserListViewThemeData(
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      );

  /// Merges one [StreamUserListViewThemeData] with another.
  StreamUserListViewThemeData merge(StreamUserListViewThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamUserListViewThemeData &&
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
