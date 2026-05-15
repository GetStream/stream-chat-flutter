import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

/// {@template messageListViewTheme}
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
    super.key,
    required this.data,
    required super.child,
  });

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
    final messageListViewTheme = context.dependOnInheritedWidgetOfExactType<StreamMessageListViewTheme>();
    return messageListViewTheme?.data ?? StreamChatTheme.of(context).messageListViewTheme;
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamMessageListViewTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamMessageListViewTheme oldWidget) => data != oldWidget.data;
}

/// {@template messageListViewThemeData}
/// A style that overrides the default appearance of [MessageListView]s when
/// used with [StreamMessageListViewTheme] or with
/// the overall [StreamChatTheme]'s
/// [StreamChatThemeData.messageListViewTheme].
///
/// See also:
///
/// * [StreamMessageListViewTheme], the theme
/// which is configured with this class.
/// * [StreamChatThemeData.messageListViewTheme], which can be used to override
/// the default style for [MessageListView]s below the overall
/// [StreamChatTheme].
/// {@endtemplate}
class StreamMessageListViewThemeData with Diagnosticable {
  /// Creates a [StreamMessageListViewThemeData].
  const StreamMessageListViewThemeData({
    this.backgroundColor,
    this.backgroundImage,
    this.messageHighlightColor,
  });

  /// The color of the [MessageListView] background.
  final Color? backgroundColor;

  /// The image of the [MessageListView] background.
  final DecorationImage? backgroundImage;

  /// The highlight color used when jumping to and highlighting a message.
  ///
  /// When null (the default), falls back to the color scheme's
  /// `backgroundHighlight` color.
  final Color? messageHighlightColor;

  /// Copies this [StreamMessageListViewThemeData] to another.
  StreamMessageListViewThemeData copyWith({
    Color? backgroundColor,
    DecorationImage? backgroundImage,
    Color? messageHighlightColor,
  }) {
    return StreamMessageListViewThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      messageHighlightColor: messageHighlightColor ?? this.messageHighlightColor,
    );
  }

  /// Linearly interpolate between two [MessageListView] themes.
  ///
  /// All the properties must be non-null.
  StreamMessageListViewThemeData lerp(
    StreamMessageListViewThemeData a,
    StreamMessageListViewThemeData b,
    double t,
  ) {
    return StreamMessageListViewThemeData(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      backgroundImage: t < 0.5 ? a.backgroundImage : b.backgroundImage,
      messageHighlightColor: Color.lerp(a.messageHighlightColor, b.messageHighlightColor, t),
    );
  }

  /// Merges one [StreamMessageListViewThemeData] with another.
  StreamMessageListViewThemeData merge(StreamMessageListViewThemeData? other) {
    if (other == null) return this;
    return copyWith(
      backgroundColor: other.backgroundColor,
      backgroundImage: other.backgroundImage,
      messageHighlightColor: other.messageHighlightColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamMessageListViewThemeData &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          backgroundImage == other.backgroundImage &&
          messageHighlightColor == other.messageHighlightColor;

  @override
  int get hashCode => Object.hash(backgroundColor, backgroundImage, messageHighlightColor);

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
      )
      ..add(ColorProperty('messageHighlightColor', messageHighlightColor));
  }
}
