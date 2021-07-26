import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// Overrides the default style of [MessageSearchListView] descendants.
///
/// See also:
///
///  * [UserListViewThemeData], which is used to configure this theme.
class MessageSearchListViewTheme extends InheritedTheme {
  /// Creates a [UserListViewTheme].
  ///
  /// The [data] parameter must not be null.
  const MessageSearchListViewTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final MessageSearchListViewThemeData data;

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
  static MessageSearchListViewThemeData of(BuildContext context) {
    final messageSearchListViewTheme = context
        .dependOnInheritedWidgetOfExactType<MessageSearchListViewTheme>();
    return messageSearchListViewTheme?.data ??
        StreamChatTheme.of(context).messageSearchListViewTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      MessageSearchListViewTheme(data: data, child: child);

  @override
  bool updateShouldNotify(MessageSearchListViewTheme oldWidget) =>
      data != oldWidget.data;
}

/// A style that overrides the default appearance of [MessageSearchListView]s
/// when used with [MessageSearchListView] or with the overall
/// [StreamChatTheme]'s [StreamChatThemeData.messageSearchListViewTheme].
///
/// See also:
///
/// * [MessageSearchListViewTheme], the theme which is configured with this
/// class.
/// * [StreamChatThemeData.messageSearchListViewTheme], which can be used to
/// override the default style for [UserListView]s below the overall
/// [StreamChatTheme].
class MessageSearchListViewThemeData with Diagnosticable {
  /// Creates a [MessageSearchListViewThemeData].
  const MessageSearchListViewThemeData({
    this.backgroundColor,
  });

  /// The color of the [MessageSearchListView] background.
  final Color? backgroundColor;

  /// Copies this [MessageSearchListViewThemeData] to another.
  MessageSearchListViewThemeData copyWith({
    Color? backgroundColor,
  }) =>
      MessageSearchListViewThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
      );

  /// Linearly interpolate between two [UserListViewThemeData] themes.
  ///
  /// All the properties must be non-null.
  MessageSearchListViewThemeData lerp(
    MessageSearchListViewThemeData a,
    MessageSearchListViewThemeData b,
    double t,
  ) =>
      MessageSearchListViewThemeData(
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      );

  /// Merges one [MessageSearchListViewThemeData] with another.
  MessageSearchListViewThemeData merge(MessageSearchListViewThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageSearchListViewThemeData &&
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
