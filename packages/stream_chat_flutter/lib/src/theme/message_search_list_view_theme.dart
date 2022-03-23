import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// {@macro message_search_list_view_theme}
@Deprecated("Use 'StreamMessageSearchListViewTheme' instead")
typedef MessageSearchListViewTheme = StreamMessageSearchListViewTheme;

/// {@template message_search_list_view_theme}
/// Overrides the default style of [MessageSearchListView] descendants.
///
/// See also:
///
///  * [UserListViewThemeData], which is used to configure this theme.
/// {@endtemplate}
class StreamMessageSearchListViewTheme extends InheritedTheme {
  /// Creates a [UserListViewTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamMessageSearchListViewTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final StreamMessageSearchListViewThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [MessageSearchListView] widget, then
  /// [StreamChatThemeData.messageSearchListViewTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// MessageSearchListViewTheme theme = MessageSearchListViewTheme.of(context);
  /// ```
  static StreamMessageSearchListViewThemeData of(BuildContext context) {
    final messageSearchListViewTheme = context
        .dependOnInheritedWidgetOfExactType<StreamMessageSearchListViewTheme>();
    return messageSearchListViewTheme?.data ??
        StreamChatTheme.of(context).messageSearchListViewTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamMessageSearchListViewTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamMessageSearchListViewTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@macro message_search_list_view_theme_data}
@Deprecated("Use 'StreamMessageSearchListViewThemeData' instead")
typedef MessageSearchListViewThemeData = StreamMessageSearchListViewThemeData;

/// {@macro message_search_list_view_theme_data}
/// A style that overrides the default appearance of [MessageSearchListView]s
/// when used with [MessageSearchListView] or with the overall
/// [StreamChatTheme]'s [StreamChatThemeData.messageSearchListViewTheme].
///
/// See also:
///
/// * [StreamMessageSearchListViewTheme], the theme
/// which is configured with this class.
/// * [StreamChatThemeData.messageSearchListViewTheme], which can be used to
/// override the default style for [UserListView]s below the overall
/// [StreamChatTheme].
/// {@endtemplate}
class StreamMessageSearchListViewThemeData with Diagnosticable {
  /// Creates a [StreamMessageSearchListViewThemeData].
  const StreamMessageSearchListViewThemeData({
    this.backgroundColor,
  });

  /// The color of the [MessageSearchListView] background.
  final Color? backgroundColor;

  /// Copies this [StreamMessageSearchListViewThemeData] to another.
  StreamMessageSearchListViewThemeData copyWith({
    Color? backgroundColor,
  }) =>
      StreamMessageSearchListViewThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
      );

  /// Linearly interpolate between two [UserListViewThemeData] themes.
  ///
  /// All the properties must be non-null.
  StreamMessageSearchListViewThemeData lerp(
    StreamMessageSearchListViewThemeData a,
    StreamMessageSearchListViewThemeData b,
    double t,
  ) =>
      StreamMessageSearchListViewThemeData(
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      );

  /// Merges one [StreamMessageSearchListViewThemeData] with another.
  StreamMessageSearchListViewThemeData merge(
    StreamMessageSearchListViewThemeData? other,
  ) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamMessageSearchListViewThemeData &&
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
