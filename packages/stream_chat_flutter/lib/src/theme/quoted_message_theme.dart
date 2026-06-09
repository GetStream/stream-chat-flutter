import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'quoted_message_theme.g.theme.dart';

/// Applies a quoted-message theme to descendant [StreamQuotedMessage]
/// widgets.
///
/// Wrap a subtree with [StreamQuotedMessageTheme] to override the styling of
/// the quoted-message preview rendered inside replies. Access the merged
/// theme using [StreamQuotedMessageTheme.of].
///
/// {@tool snippet}
///
/// Override quoted-message styling for a specific section:
///
/// ```dart
/// StreamQuotedMessageTheme(
///   data: StreamQuotedMessageThemeData(
///     titleTextStyle: TextStyle(fontWeight: FontWeight.w700),
///     indicatorColor: Colors.green,
///   ),
///   child: StreamMessageListView(),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamQuotedMessageThemeData], which describes the theme data.
///  * [StreamQuotedMessage], the widget affected by this theme.
class StreamQuotedMessageTheme extends InheritedTheme {
  /// Creates a quoted-message theme that controls descendant widgets.
  const StreamQuotedMessageTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The quoted-message theme data for descendant widgets.
  final StreamQuotedMessageThemeData data;

  /// Returns the [StreamQuotedMessageThemeData] merged from local and global
  /// themes.
  ///
  /// Local values from the nearest [StreamQuotedMessageTheme] ancestor take
  /// precedence over global values from [StreamChatTheme.of].
  ///
  /// This allows partial overrides — for example, overriding only
  /// [StreamQuotedMessageThemeData.titleTextStyle] while inheriting other
  /// properties from the global theme.
  static StreamQuotedMessageThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamQuotedMessageTheme>();
    return StreamChatTheme.of(context).quotedMessageTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamQuotedMessageTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamQuotedMessageTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for customizing [StreamQuotedMessage] widgets.
///
/// All fields are nullable. When a field is null, the consuming widget falls
/// back to a default derived from the alignment-aware [StreamColorScheme]
/// and [StreamTextTheme] tokens.
///
/// {@tool snippet}
///
/// Customize quoted-message appearance globally:
///
/// ```dart
/// StreamChatThemeData(
///   quotedMessageTheme: StreamQuotedMessageThemeData(
///     titleTextStyle: TextStyle(fontWeight: FontWeight.w700),
///     padding: EdgeInsetsDirectional.all(12),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamQuotedMessage], the widget that uses this theme data.
///  * [StreamQuotedMessageTheme], for overriding theme in a widget subtree.
@themeGen
@immutable
class StreamQuotedMessageThemeData with _$StreamQuotedMessageThemeData {
  /// Creates quoted-message theme data with optional style overrides.
  const StreamQuotedMessageThemeData({
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.indicatorColor,
    this.backgroundColor,
    this.shape,
    this.side,
    this.margin,
    this.padding,
    this.thumbnailShape,
    this.thumbnailSide,
    this.thumbnailSize,
  });

  /// The text style for the quoted user's name.
  ///
  /// If null, defaults to [StreamTextTheme.metadataEmphasis] tinted with the
  /// alignment-aware text color.
  final TextStyle? titleTextStyle;

  /// The text style for the quoted message preview.
  ///
  /// If null, defaults to [StreamTextTheme.metadataDefault] tinted with the
  /// alignment-aware text color.
  final TextStyle? subtitleTextStyle;

  /// Color of the leading indicator bar.
  ///
  /// If null, the consuming widget falls back to a direction-aware default:
  /// `colorScheme.chrome.shade400` for incoming, `colorScheme.brand.shade400`
  /// for outgoing.
  final Color? indicatorColor;

  /// Background fill color of the quoted-message card.
  ///
  /// If null, the consuming widget falls back to a direction-aware default:
  /// `colorScheme.backgroundSurfaceStrong` for incoming,
  /// `colorScheme.brand.shade150` for outgoing.
  final Color? backgroundColor;

  /// Shape of the quoted-message card.
  ///
  /// Composed with [side] to draw the card's border. If null, defaults to a
  /// [RoundedSuperellipseBorder] with radius [StreamRadius.lg].
  final OutlinedBorder? shape;

  /// Border side drawn around the quoted-message card.
  ///
  /// Composed onto [shape] via [OutlinedBorder.copyWith]. If null, defaults to
  /// [BorderSide.none].
  final BorderSide? side;

  /// Outer margin applied around the quoted-message card.
  ///
  /// If null, defaults to `EdgeInsets.symmetric(horizontal: spacing.xs)`.
  final EdgeInsetsGeometry? margin;

  /// Inner padding around the indicator, text content, and optional trailing
  /// thumbnail. This is the spacing between the card edge and its contents.
  ///
  /// If null, defaults to `EdgeInsetsDirectional.only(start: spacing.sm,
  /// end: spacing.xs, top: spacing.xs, bottom: spacing.xs)`.
  final EdgeInsetsGeometry? padding;

  /// Outer shape of the trailing thumbnail.
  ///
  /// Composed with [thumbnailSide] to draw the thumbnail's border. If null,
  /// defaults to a [RoundedSuperellipseBorder] with radius [StreamRadius.md].
  final OutlinedBorder? thumbnailShape;

  /// Border side drawn around the trailing thumbnail.
  ///
  /// Composed onto [thumbnailShape] via [OutlinedBorder.copyWith]. If null,
  /// defaults to [BorderSide.none].
  final BorderSide? thumbnailSide;

  /// Dimensions of the trailing thumbnail.
  ///
  /// If null, defaults to `Size.square(40)`.
  final Size? thumbnailSize;

  /// Linearly interpolate between two [StreamQuotedMessageThemeData] objects.
  static StreamQuotedMessageThemeData? lerp(
    StreamQuotedMessageThemeData? a,
    StreamQuotedMessageThemeData? b,
    double t,
  ) => _$StreamQuotedMessageThemeData.lerp(a, b, t);
}
