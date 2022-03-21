import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// {@macro message_list_view_theme}
@Deprecated("Use 'StreamMessageListViewTheme' instead")
typedef MessageListViewTheme = StreamMessageListViewTheme;

/// {@template message_list_view_theme}
/// Overrides the default style of [MessageListView] descendants.
///
/// See also:
///
///  * [StreamMessageListViewThemeData], which is used to configure this theme.
/// {@endtemplate}
class StreamMessageListViewTheme extends InheritedTheme {
  /// Creates a [StreamMessageListViewTheme].
  ///
  /// The [data] parameter must not be null.
  const StreamMessageListViewTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  /// The configuration of this theme.
  final StreamMessageListViewThemeData data;

  /// The closest instance of this class that encloses the given context.
  ///
  /// If there is no enclosing [StreamMessageListViewTheme] widget, then
  /// [StreamChatThemeData.messageListViewTheme] is used.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// MessageListViewTheme theme = MessageListViewTheme.of(context);
  /// ```
  static StreamMessageListViewThemeData of(BuildContext context) {
    final messageListViewTheme = context
        .dependOnInheritedWidgetOfExactType<StreamMessageListViewTheme>();
    return messageListViewTheme?.data ??
        StreamChatTheme.of(context).messageListViewTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) =>
      StreamMessageListViewTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamMessageListViewTheme oldWidget) =>
      data != oldWidget.data;
}

/// {@macro message_list_view_theme_data}
@Deprecated("Use 'StreamMessageListViewThemeData' instead")
typedef MessageListViewThemeData = StreamMessageListViewThemeData;

/// {@template message_list_view_theme_data}
/// A style that overrides the default appearance of [MessageListView]s when
/// used with [StreamMessageListViewTheme] or with the overall [StreamChatTheme]'s
/// [StreamChatThemeData.messageListViewTheme].
///
/// See also:
///
/// * [StreamMessageListViewTheme], the theme which is configured with this class.
/// * [StreamChatThemeData.messageListViewTheme], which can be used to override
/// the default style for [MessageListView]s below the overall
/// [StreamChatTheme].
/// {@endtemplate}
class StreamMessageListViewThemeData with Diagnosticable {
  /// Creates a [StreamMessageListViewThemeData].
  const StreamMessageListViewThemeData({
    this.backgroundColor,
    this.backgroundImage,
  });

  /// The color of the [MessageListView] background.
  final Color? backgroundColor;

  /// The image of the [MessageListView] background.
  final DecorationImage? backgroundImage;

  /// Copies this [StreamMessageListViewThemeData] to another.
  StreamMessageListViewThemeData copyWith({
    Color? backgroundColor,
    DecorationImage? backgroundImage,
  }) =>
      StreamMessageListViewThemeData(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        backgroundImage: backgroundImage ?? this.backgroundImage,
      );

  /// Linearly interpolate between two [MessageListView] themes.
  ///
  /// All the properties must be non-null.
  StreamMessageListViewThemeData lerp(
    StreamMessageListViewThemeData a,
    StreamMessageListViewThemeData b,
    double t,
  ) =>
      StreamMessageListViewThemeData(
        backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
        backgroundImage: t < 0.5 ? a.backgroundImage : b.backgroundImage,
      );

  /// Merges one [StreamMessageListViewThemeData] with another.
  StreamMessageListViewThemeData merge(StreamMessageListViewThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      backgroundImage: other.backgroundImage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamMessageListViewThemeData &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          backgroundImage == other.backgroundImage;

  @override
  int get hashCode => backgroundColor.hashCode + backgroundImage.hashCode;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('backgroundColor', backgroundColor))
      ..add(
        DiagnosticsProperty<DecorationImage>(
          'backgroundImage',
          backgroundImage,
          defaultValue: null,
        ),
      );
  }
}
