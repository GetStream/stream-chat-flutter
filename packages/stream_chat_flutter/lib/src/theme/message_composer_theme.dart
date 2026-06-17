import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:theme_extensions_builder_annotation/theme_extensions_builder_annotation.dart';

part 'message_composer_theme.g.theme.dart';

/// The placement of the message composer — floating above the keyboard or
/// docked at the bottom edge of the screen.
///
/// When null on [StreamMessageComposerThemeData], the ambient [StreamAppStyle]
/// is used as a fallback — [StreamAppStyle.floating] maps to [floating] and
/// [StreamAppStyle.regular] maps to [docked].
///
/// See also:
///
///  * [StreamMessageComposerThemeData.location], which carries this
///    value.
///  * [StreamAppStyle], the global app-wide style that acts as fallback.
enum ComposerLocation {
  /// The composer floats above the on-screen keyboard with appropriate safe
  /// area padding.
  floating,

  /// The composer is docked at the bottom edge of the screen.
  docked,
}

/// Applies a message composer theme to descendant composer widgets.
///
/// Wrap a subtree with [StreamMessageComposerTheme] to override the composer
/// location. Access the merged theme using [StreamMessageComposerTheme.of].
///
/// {@tool snippet}
///
/// Override composer placement for a specific screen:
///
/// ```dart
/// StreamMessageComposerTheme(
///   data: StreamMessageComposerThemeData(
///     location: ComposerLocation.floating,
///   ),
///   child: StreamChannel(
///     channel: channel,
///     child: ChannelPage(),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamMessageComposerThemeData], which describes the theme data.
///  * [StreamMessageComposerThemeData.location], the setting it holds.
class StreamMessageComposerTheme extends InheritedTheme {
  /// Creates a message composer theme that controls descendant composers.
  const StreamMessageComposerTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// The message composer theme data for descendant widgets.
  final StreamMessageComposerThemeData data;

  /// Returns the [StreamMessageComposerThemeData] merged from local and global
  /// themes.
  ///
  /// Local values from the nearest [StreamMessageComposerTheme] ancestor take
  /// precedence over global values from [StreamChatTheme.of].
  ///
  /// This allows partial overrides — for example, overriding only
  /// [StreamMessageComposerThemeData.location] in a subtree while
  /// inheriting other properties from the global theme.
  static StreamMessageComposerThemeData of(BuildContext context) {
    final localTheme = context.dependOnInheritedWidgetOfExactType<StreamMessageComposerTheme>();
    return StreamChatTheme.of(context).messageComposerTheme.merge(localTheme?.data);
  }

  @override
  Widget wrap(BuildContext context, Widget child) => StreamMessageComposerTheme(data: data, child: child);

  @override
  bool updateShouldNotify(StreamMessageComposerTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for customizing the message composer placement.
///
/// All fields are nullable. When a field is null, the consuming widget falls
/// back to the ambient [StreamAppStyle].
///
/// {@tool snippet}
///
/// Override composer placement globally:
///
/// ```dart
/// StreamChatThemeData(
///   messageComposerTheme: StreamMessageComposerThemeData(
///     location: ComposerLocation.floating,
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ComposerLocation], the enum that describes the placement options.
///  * [StreamMessageComposerTheme], for overriding the theme in a subtree.
@themeGen
@immutable
class StreamMessageComposerThemeData with _$StreamMessageComposerThemeData {
  /// Creates message composer theme data with optional overrides.
  const StreamMessageComposerThemeData({this.location});

  /// The placement of the message composer.
  ///
  /// When null the value falls back to the ambient [StreamAppStyle]:
  /// [StreamAppStyle.floating] → [ComposerLocation.floating],
  /// [StreamAppStyle.regular] → [ComposerLocation.docked].
  ///
  /// Set this to override the global style for the composer only, without
  /// affecting other components.
  final ComposerLocation? location;

  /// Linearly interpolate between two [StreamMessageComposerThemeData] objects.
  static StreamMessageComposerThemeData? lerp(
    StreamMessageComposerThemeData? a,
    StreamMessageComposerThemeData? b,
    double t,
  ) => _$StreamMessageComposerThemeData.lerp(a, b, t);
}
