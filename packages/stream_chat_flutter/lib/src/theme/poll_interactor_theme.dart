import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/poll_option_style.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

export 'package:stream_chat_flutter/src/theme/poll_option_style.dart';

part 'poll_interactor_theme.g.theme.dart';

/// Applies a poll interactor theme to descendant [StreamPollInteractor]
/// widgets.
///
/// Wrap a subtree with [StreamPollInteractorTheme] to override poll interactor
/// styling. Access the merged theme using [StreamPollInteractorTheme.of].
///
/// {@tool snippet}
///
/// Override poll interactor styling for a specific section:
///
/// ```dart
/// StreamPollInteractorTheme(
///   data: StreamPollInteractorThemeData(
///     titleTextStyle: TextStyle(fontWeight: FontWeight.w700),
///     optionStyle: StreamPollOptionStyle(
///       progressBarStyle: StreamProgressBarStyle(
///         fillColor: Colors.green,
///       ),
///     ),
///   ),
///   child: StreamPollInteractor(poll: poll),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamPollInteractorThemeData], which describes the poll interactor
///    theme.
///  * [StreamPollInteractor], the widget affected by this theme.
class StreamPollInteractorTheme extends InheritedTheme {
  /// Creates a poll interactor theme that controls descendant widgets.
  const StreamPollInteractorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The poll interactor theme data for descendant widgets.
  final StreamPollInteractorThemeData data;

  /// Returns the [StreamPollInteractorThemeData] merged from local and global
  /// themes.
  ///
  /// Local values from the nearest [StreamPollInteractorTheme] ancestor take
  /// precedence over global values from [StreamChatTheme.of].
  ///
  /// This allows partial overrides - for example, overriding only
  /// [StreamPollInteractorThemeData.titleTextStyle] while inheriting other
  /// properties from the global theme.
  static StreamPollInteractorThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamPollInteractorTheme>();
    return StreamChatTheme.of(context).pollInteractorTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamPollInteractorTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamPollInteractorTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for customizing [StreamPollInteractor] widgets.
///
/// {@tool snippet}
///
/// Customize poll interactor appearance globally:
///
/// ```dart
/// StreamChatThemeData(
///   pollInteractorTheme: StreamPollInteractorThemeData(
///     titleTextStyle: TextStyle(fontWeight: FontWeight.w700),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamPollInteractor], the widget that uses this theme data.
///  * [StreamPollInteractorTheme], for overriding theme in a widget subtree.
@themeGen
@immutable
class StreamPollInteractorThemeData with _$StreamPollInteractorThemeData {
  /// Creates poll interactor theme data with optional style overrides.
  const StreamPollInteractorThemeData({
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.primaryActionStyle,
    this.secondaryActionStyle,
    this.optionStyle,
  });

  /// The text style for the poll question title.
  final TextStyle? titleTextStyle;

  /// The text style for the poll description or status subtitle.
  final TextStyle? subtitleTextStyle;

  /// The visual styling for the primary action button.
  final StreamButtonThemeStyle? primaryActionStyle;

  /// The visual styling for secondary action buttons.
  final StreamButtonThemeStyle? secondaryActionStyle;

  /// The visual styling for poll option rows.
  final StreamPollOptionStyle? optionStyle;

  /// Linearly interpolate between two [StreamPollInteractorThemeData] objects.
  static StreamPollInteractorThemeData? lerp(
    StreamPollInteractorThemeData? a,
    StreamPollInteractorThemeData? b,
    double t,
  ) => _$StreamPollInteractorThemeData.lerp(a, b, t);
}
