import 'package:flutter/widgets.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

import '../../stream_chat_flutter.dart';

part 'stream_scheduled_message_list_item_theme.g.theme.dart';

/// Applies a scheduled message list item theme to descendant
/// [StreamScheduledMessageListItem] widgets.
///
/// Values set here override [StreamChatThemeData.scheduledMessageListItemTheme]
/// for the subtree.
///
/// {@tool snippet}
///
/// Shows the send time of every scheduled message in blue:
///
/// ```dart
/// StreamScheduledMessageListItemTheme(
///   data: StreamScheduledMessageListItemThemeData(
///     sendTimeStyle: TextStyle(color: Colors.blue),
///   ),
///   child: const StreamScheduledMessageListView(),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamScheduledMessageListItemThemeData], which describes the theme.
///  * [StreamScheduledMessageListItem], which this theme styles.
class StreamScheduledMessageListItemTheme extends InheritedTheme {
  /// Creates a scheduled message list item theme that controls descendant
  /// widgets.
  const StreamScheduledMessageListItemTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The scheduled message list item theme data for descendant widgets.
  final StreamScheduledMessageListItemThemeData data;

  /// The [StreamScheduledMessageListItemThemeData] merged from local and
  /// global themes.
  ///
  /// Local values from the nearest [StreamScheduledMessageListItemTheme]
  /// ancestor take precedence over global values from [StreamChatTheme.of].
  static StreamScheduledMessageListItemThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamScheduledMessageListItemTheme>();
    return StreamChatTheme.of(context).scheduledMessageListItemTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StreamScheduledMessageListItemTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(StreamScheduledMessageListItemTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for customizing [StreamScheduledMessageListItem] widgets.
///
/// {@tool snippet}
///
/// Scheduled message rows styled app-wide:
///
/// ```dart
/// StreamChatThemeData(
///   scheduledMessageListItemTheme: StreamScheduledMessageListItemThemeData(
///     backgroundColor: WidgetStatePropertyAll(Colors.white),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamScheduledMessageListItem], which uses this theme data.
///  * [StreamScheduledMessageListItemTheme], which overrides the theme in a
///    widget subtree.
@themeGen
@immutable
class StreamScheduledMessageListItemThemeData with _$StreamScheduledMessageListItemThemeData {
  /// Creates a scheduled message list item theme with optional style
  /// overrides.
  const StreamScheduledMessageListItemThemeData({
    this.backgroundColor,
    this.padding,
    this.sendTimeStyle,
    this.failedSendTimeStyle,
    this.sendTimeFormatter,
    this.titleStyle,
    this.messagePreviewStyle,
    this.messagePreviewTextTheme,
    this.statusStyle,
    this.failedStatusStyle,
  });

  /// The background color of the row.
  ///
  /// This color is resolved from [WidgetState]s. Falls back to
  /// [StreamColorScheme.backgroundApp], tinted with
  /// [StreamColorScheme.backgroundSelected] when selected.
  final WidgetStateProperty<Color?>? backgroundColor;

  /// The padding around the content of the row.
  ///
  /// Falls back to [StreamSpacing.md] at the sides and [StreamSpacing.sm] at
  /// the top and bottom.
  final EdgeInsetsGeometry? padding;

  /// The text style of the send time.
  ///
  /// Falls back to [StreamTextTheme.captionDefault] with
  /// [StreamColorScheme.textTertiary].
  final TextStyle? sendTimeStyle;

  /// The text style of the send time of a message that failed.
  ///
  /// Falls back to [StreamTextTheme.captionDefault] with
  /// [StreamColorScheme.textDisabled].
  final TextStyle? failedSendTimeStyle;

  /// The formatter of the send time.
  ///
  /// It formats the whole line, such as "Send Wed, Oct 21 at 8:00 AM". Falls
  /// back to [Translations.scheduledMessageSendAtText].
  final DateFormatter? sendTimeFormatter;

  /// The text style for the name of the channel the message is sent to.
  ///
  /// Falls back to [StreamTextTheme.captionEmphasis] with
  /// [StreamColorScheme.textTertiary].
  final TextStyle? titleStyle;

  /// The text style for the preview of the message.
  ///
  /// Falls back to [StreamTextTheme.bodyDefault] with
  /// [StreamColorScheme.textPrimary].
  final TextStyle? messagePreviewStyle;

  /// The theme for styling parts of the message preview differently from the
  /// rest.
  ///
  /// Takes precedence over an enclosing [StreamMessagePreviewTextTheme] and
  /// the app-wide one. Icons default to a size of 20.
  final StreamMessagePreviewTextThemeData? messagePreviewTextTheme;

  /// The text style for the state of a message being sent.
  ///
  /// Falls back to [StreamTextTheme.captionDefault] with
  /// [StreamColorScheme.textTertiary].
  final TextStyle? statusStyle;

  /// The text style for why a message could not be sent.
  ///
  /// Its color also tints the warning icon. Falls back to
  /// [StreamTextTheme.captionDefault] with [StreamColorScheme.accentError].
  final TextStyle? failedStatusStyle;

  /// Linearly interpolates between two
  /// [StreamScheduledMessageListItemThemeData] objects.
  static StreamScheduledMessageListItemThemeData? lerp(
    StreamScheduledMessageListItemThemeData? a,
    StreamScheduledMessageListItemThemeData? b,
    double t,
  ) => _$StreamScheduledMessageListItemThemeData.lerp(a, b, t);
}
