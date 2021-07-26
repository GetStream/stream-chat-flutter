import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// Overrides the default style of [MessageListView] descendants.
///
/// See also:
///
///  * [MessageListViewThemeData], which is used to configure this theme.
class MessageListViewTheme extends InheritedTheme {
  /// Creates a [MessageListViewTheme].
  ///
  /// The [data] parameter must not be null.
  const MessageListViewTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final MessageListViewThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [MessageListViewTheme] widget, then
  /// [StreamChatThemeData.messageListViewTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// MessageListViewTheme theme = MessageListViewTheme.of(context);
  /// ```
  static MessageListViewThemeData of(BuildContext context) {
    final messageListViewTheme =
    context.dependOnInheritedWidgetOfExactType<MessageListViewTheme>();
    return messageListViewTheme?.data ??
        StreamChatTheme.of(context).messageListViewTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      MessageListViewTheme(data: data, child: child);

  @override
  bool updateShouldNotify(MessageListViewTheme oldWidget) =>
      data != oldWidget.data;
}

/// A style that overrides the default appearance of [MessageListView]s when
/// used with [MessageListViewTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.messageListViewTheme].
///
/// See also:
///
/// * [MessageListViewTheme], the theme which is configured with this class.
/// * [StreamChatThemeData.messageListViewTheme], which can be used to override
/// the default style for [MessageListView]s below the overall
/// [StreamChatTheme].
class MessageListViewThemeData with Diagnosticable {
  /// Creates a [MessageListViewThemeData].
  const MessageListViewThemeData({
    this.backgroundColor,
  });

  /// The color of the [MessageListView] background.
  final Color? backgroundColor;

  /// Copies this [MessageListViewThemeData] to another.
  MessageListViewThemeData copyWith({
    Color? backgroundColor,
  }) =>
      MessageListViewThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
      );

  /// Linearly interpolate between two [MessageListView] themes.
  ///
  /// All the properties must be non-null.
  MessageListViewThemeData lerp(
      MessageListViewThemeData a,
      MessageListViewThemeData b,
      double t,
      ) =>
      MessageListViewThemeData(
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      );

  /// Merges one [MessageListViewThemeData] with another.
  MessageListViewThemeData merge(MessageListViewThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MessageListViewThemeData &&
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
