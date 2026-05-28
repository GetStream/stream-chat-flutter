import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/poll_option_votes_style.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'poll_comments_sheet_theme.g.theme.dart';

/// Applies a poll comments sheet theme to descendant
/// [StreamPollCommentsSheet] widgets.
///
/// Wrap a subtree with [StreamPollCommentsSheetTheme] to override the
/// comments sheet styling. Access the merged theme using
/// [StreamPollCommentsSheetTheme.of].
///
/// {@tool snippet}
///
/// Override comments sheet styling for a specific route:
///
/// ```dart
/// StreamPollCommentsSheetTheme(
///   data: StreamPollCommentsSheetThemeData(
///     commentStyle: StreamPollOptionVotesStyle(
///       cardStyle: StreamPollCardStyle(backgroundColor: Colors.white),
///     ),
///   ),
///   child: StreamPollCommentsSheet(poll: poll),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamPollCommentsSheetThemeData], which describes the comments
///    sheet theme.
///  * [StreamPollCommentsSheet], the widget affected by this theme.
class StreamPollCommentsSheetTheme extends InheritedTheme {
  /// Creates a poll comments sheet theme that controls descendant widgets.
  const StreamPollCommentsSheetTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The poll comments sheet theme data for descendant widgets.
  final StreamPollCommentsSheetThemeData data;

  /// Returns the [StreamPollCommentsSheetThemeData] merged from local and
  /// global themes.
  ///
  /// Local values from the nearest [StreamPollCommentsSheetTheme] ancestor
  /// take precedence over global values from [StreamChatTheme.of].
  ///
  /// This allows partial overrides — for example, overriding only
  /// [StreamPollCommentsSheetThemeData.backgroundColor] while inheriting
  /// other properties from the global theme.
  static StreamPollCommentsSheetThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamPollCommentsSheetTheme>();
    return StreamChatTheme.of(context).pollCommentsSheetTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamPollCommentsSheetTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamPollCommentsSheetTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for customizing [StreamPollCommentsSheet] widgets.
///
/// Covers the sheet surface and the per-comment card rendered for each
/// item in the paginated comment feed.
///
/// The per-comment card reuses [StreamPollOptionVotesStyle] because
/// comments (a.k.a. answers) are a flavour of poll vote on the backend.
/// Only [StreamPollOptionVotesStyle.cardStyle],
/// [StreamPollOptionVotesStyle.footerDividerColor], and
/// [StreamPollOptionVotesStyle.footerButtonStyle] are consumed by the
/// comments sheet. The other fields on that style (number / body / vote
/// count text styles, winner trophy icon) are intentionally unused here
/// and have no effect on the rendered comment card.
///
/// {@tool snippet}
///
/// Customize the comments sheet appearance globally:
///
/// ```dart
/// StreamChatThemeData(
///   pollCommentsSheetTheme: StreamPollCommentsSheetThemeData(
///     commentStyle: StreamPollOptionVotesStyle(
///       cardStyle: StreamPollCardStyle(backgroundColor: Colors.white),
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamPollCommentsSheet], the widget that uses this theme data.
///  * [StreamPollCommentsSheetTheme], for overriding theme in a widget
///    subtree.
///  * [StreamPollOptionVotesStyle], the nested style reused for the
///    per-comment card.
@themeGen
@immutable
class StreamPollCommentsSheetThemeData with _$StreamPollCommentsSheetThemeData {
  /// Creates poll comments sheet theme data with optional style overrides.
  const StreamPollCommentsSheetThemeData({
    this.backgroundColor,
    this.contentPadding,
    this.itemSpacing,
    this.sheetHeaderStyle,
    this.commentStyle,
  });

  /// The background color of the sheet surface.
  ///
  /// If null, defaults to [StreamColorScheme.backgroundApp].
  final Color? backgroundColor;

  /// The visual styling for the [StreamSheetHeader] rendered at the top of
  /// the sheet.
  ///
  /// Scoped to the sheet's header via an inner [StreamSheetHeaderTheme] so
  /// overrides here do not leak into other sheet headers on the screen.
  /// When null, the header inherits the ambient [StreamSheetHeaderTheme].
  final StreamSheetHeaderStyle? sheetHeaderStyle;

  /// The padding around the sheet's scrollable comment list.
  ///
  /// If null, defaults to `EdgeInsets.all(StreamSpacing.md)`.
  final EdgeInsetsGeometry? contentPadding;

  /// The vertical spacing between consecutive comment cards.
  ///
  /// If null, defaults to `StreamSpacing.md`.
  final double? itemSpacing;

  /// The visual styling for the per-comment card rendered as each item in
  /// the list.
  ///
  /// Controls the card chrome (background, corner radius, inner padding),
  /// the thin divider rendered above the optional "Update your comment"
  /// footer action, and the [StreamButtonThemeStyle] applied to that
  /// footer button.
  ///
  /// Other fields on [StreamPollOptionVotesStyle] (the number / body /
  /// vote count text styles and the winner trophy icon color / size) are
  /// intentionally not consumed by this sheet and have no effect on the
  /// comment card.
  ///
  /// When null, the sheet falls back to its token-backed defaults.
  final StreamPollOptionVotesStyle? commentStyle;

  /// Linearly interpolate between two [StreamPollCommentsSheetThemeData]
  /// objects.
  static StreamPollCommentsSheetThemeData? lerp(
    StreamPollCommentsSheetThemeData? a,
    StreamPollCommentsSheetThemeData? b,
    double t,
  ) => _$StreamPollCommentsSheetThemeData.lerp(a, b, t);
}
