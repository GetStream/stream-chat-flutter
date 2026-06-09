import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'poll_creator_theme.g.theme.dart';

/// Applies a poll creator theme to descendant [StreamPollCreatorWidget]
/// widgets.
///
/// Wrap a subtree with [StreamPollCreatorTheme] to override poll creator
/// styling. Access the merged theme using [StreamPollCreatorTheme.of].
///
/// {@tool snippet}
///
/// Override poll creator styling for a specific section:
///
/// ```dart
/// StreamPollCreatorTheme(
///   data: StreamPollCreatorThemeData(
///     headerTextStyle: TextStyle(fontWeight: FontWeight.w700),
///     configOptionStyle: StreamPollConfigOptionStyle(
///       switchStyle: StreamSwitchStyle.from(
///         selectedTrackColor: Colors.green,
///       ),
///     ),
///   ),
///   child: StreamPollCreatorWidget(controller: controller),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamPollCreatorThemeData], which describes the poll creator theme.
///  * [StreamPollCreatorWidget], the widget affected by this theme.
class StreamPollCreatorTheme extends InheritedTheme {
  /// Creates a poll creator theme that controls descendant widgets.
  const StreamPollCreatorTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The poll creator theme data for descendant widgets.
  final StreamPollCreatorThemeData data;

  /// Returns the [StreamPollCreatorThemeData] merged from local and global
  /// themes.
  ///
  /// Local values from the nearest [StreamPollCreatorTheme] ancestor take
  /// precedence over global values from [StreamChatTheme.of].
  ///
  /// This allows partial overrides — for example, overriding only
  /// [StreamPollCreatorThemeData.headerTextStyle] while inheriting other
  /// properties from the global theme.
  static StreamPollCreatorThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamPollCreatorTheme>();
    return StreamChatTheme.of(context).pollCreatorTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamPollCreatorTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamPollCreatorTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for customizing [StreamPollCreatorWidget] widgets.
///
/// {@tool snippet}
///
/// Customize poll creator appearance globally:
///
/// ```dart
/// StreamChatThemeData(
///   pollCreatorTheme: StreamPollCreatorThemeData(
///     headerTextStyle: TextStyle(fontWeight: FontWeight.w700),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamPollCreatorWidget], the widget that uses this theme data.
///  * [StreamPollCreatorTheme], for overriding theme in a widget subtree.
@themeGen
@immutable
class StreamPollCreatorThemeData with _$StreamPollCreatorThemeData {
  /// Creates poll creator theme data with optional style overrides.
  const StreamPollCreatorThemeData({
    this.sheetHeaderStyle,
    this.headerTextStyle,
    this.questionInputStyle,
    this.optionInputStyle,
    this.configOptionStyle,
  });

  /// The visual styling for the [StreamSheetHeader] rendered at the top of
  /// the [StreamPollCreatorSheet].
  ///
  /// Scoped to the sheet's header via an inner [StreamSheetHeaderTheme] so
  /// overrides here do not leak into other sheet headers on the screen.
  /// When null, the header inherits the ambient [StreamSheetHeaderTheme].
  final StreamSheetHeaderStyle? sheetHeaderStyle;

  /// The text style for section header labels (e.g. "Questions", "Options").
  ///
  /// If null, defaults to [StreamTextTheme.headingSm] with primary color.
  final TextStyle? headerTextStyle;

  /// The visual styling for the question text input.
  ///
  /// If null, the text input uses its own inherited theme defaults.
  final StreamTextInputStyle? questionInputStyle;

  /// The visual styling for the option text inputs.
  ///
  /// If null, the text input uses its own inherited theme defaults.
  final StreamTextInputStyle? optionInputStyle;

  /// The visual styling for option toggle cards (e.g. "Multiple answers",
  /// "Anonymous poll").
  final StreamPollConfigOptionStyle? configOptionStyle;

  /// Linearly interpolate between two [StreamPollCreatorThemeData] objects.
  static StreamPollCreatorThemeData? lerp(
    StreamPollCreatorThemeData? a,
    StreamPollCreatorThemeData? b,
    double t,
  ) => _$StreamPollCreatorThemeData.lerp(a, b, t);
}

/// Visual styling properties for poll creator option toggle cards.
///
/// Defines the appearance of the toggle-switch cards used for poll
/// configuration options like "Multiple answers" and "Anonymous poll",
/// including sub-component styles for the toggle switch and stepper.
///
/// See also:
///
///  * [StreamPollCreatorThemeData], which wraps this style for theming.
///  * [StreamPollCreatorWidget], which uses this styling.
@themeGen
@immutable
class StreamPollConfigOptionStyle with _$StreamPollConfigOptionStyle {
  /// Creates poll creator option card style properties.
  const StreamPollConfigOptionStyle({
    this.backgroundColor,
    this.contentPadding,
    this.childSpacing,
    this.titleTextStyle,
    this.descriptionTextStyle,
    this.switchStyle,
    this.stepperStyle,
  });

  /// The background color of the option card.
  ///
  /// If null, defaults to [StreamColorScheme.backgroundSurfaceCard].
  final Color? backgroundColor;

  /// The padding inside the card around the content.
  ///
  /// If null, defaults to `EdgeInsets.all(spacing.md)`.
  final EdgeInsetsGeometry? contentPadding;

  /// The vertical spacing between the header and the child widget.
  ///
  /// If null, defaults to `spacing.md`.
  final double? childSpacing;

  /// The text style for the option card title.
  ///
  /// If null, defaults to [StreamTextTheme.headingSm] with primary color.
  final TextStyle? titleTextStyle;

  /// The text style for the option card description.
  ///
  /// If null, defaults to [StreamTextTheme.captionDefault] with tertiary
  /// color.
  final TextStyle? descriptionTextStyle;

  /// The visual styling for the toggle switch in the card.
  ///
  /// If null, the toggle switch uses its own inherited theme defaults.
  final StreamSwitchStyle? switchStyle;

  /// The visual styling for the stepper control in the card.
  ///
  /// If null, the stepper uses its own inherited theme defaults.
  final StreamStepperStyle? stepperStyle;

  /// Linearly interpolate between two [StreamPollConfigOptionStyle]
  /// objects.
  static StreamPollConfigOptionStyle? lerp(
    StreamPollConfigOptionStyle? a,
    StreamPollConfigOptionStyle? b,
    double t,
  ) => _$StreamPollConfigOptionStyle.lerp(a, b, t);
}
