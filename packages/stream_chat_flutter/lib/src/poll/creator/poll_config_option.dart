import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template pollConfigOption}
/// A card-style toggle for poll configuration options.
///
/// Renders a rounded card with a title, description, and toggle switch.
/// When the switch is enabled and [child] is provided, it is revealed
/// below the header with an animated size transition.
///
/// Can be nested — since the header is a simple [Row] rather than a tappable
/// list tile, padding from an outer [PollConfigOption] does not interfere
/// with an inner one.
/// {@endtemplate}
class PollConfigOption extends StatelessWidget {
  /// {@macro pollConfigOption}
  const PollConfigOption({
    super.key,
    this.value = false,
    required this.title,
    this.description,
    this.child,
    this.backgroundColor,
    this.contentPadding,
    this.childSpacing,
    this.onChanged,
  });

  /// Whether the toggle switch is on.
  final bool value;

  /// The primary label of the card.
  final String title;

  /// An optional short description displayed below [title].
  final String? description;

  /// Optional widget displayed below the header when [value] is true.
  final Widget? child;

  /// The background color of the card.
  ///
  /// Defaults to [StreamColorScheme.backgroundSurfaceCard].
  final Color? backgroundColor;

  /// The padding inside the card around the content.
  ///
  /// Defaults to `EdgeInsets.all(spacing.md)`. Pass [EdgeInsets.zero] for
  /// nested cards that sit inside a parent card's content padding.
  final EdgeInsetsGeometry? contentPadding;

  /// The vertical spacing between the header and [child].
  ///
  /// Defaults to `spacing.md`.
  final double? childSpacing;

  /// Called when the user toggles the switch on or off.
  ///
  /// The card passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds with the new [value].
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = StreamPollCreatorTheme.of(context);
    final defaults = _PollConfigOptionDefaults(context);

    final configOptionStyle = theme.configOptionStyle;

    final radius = context.streamRadius;

    final effectiveBackgroundColor = backgroundColor ?? configOptionStyle?.backgroundColor ?? defaults.backgroundColor;
    final effectiveContentPadding = contentPadding ?? configOptionStyle?.contentPadding ?? defaults.contentPadding;
    final effectiveChildSpacing = childSpacing ?? configOptionStyle?.childSpacing ?? defaults.childSpacing;

    return AnimatedSize(
      duration: kThemeAnimationDuration,
      alignment: Alignment.topCenter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.all(radius.xl),
        ),
        child: Padding(
          padding: effectiveContentPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: effectiveChildSpacing,
            children: [
              _PollConfigOptionHeader(
                title: title,
                description: description,
                value: value,
                onChanged: onChanged,
              ),
              if (child case final child? when value) child,
            ],
          ),
        ),
      ),
    );
  }
}

// The header row: title/description on the left, toggle switch on the right.
class _PollConfigOptionHeader extends StatelessWidget {
  const _PollConfigOptionHeader({
    required this.value,
    required this.title,
    this.description,
    this.onChanged,
  });

  final String title;
  final String? description;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    final theme = StreamPollCreatorTheme.of(context);
    final defaults = _PollConfigOptionDefaults(context);
    final configOptionStyle = theme.configOptionStyle;

    final effectiveTitleStyle = configOptionStyle?.titleTextStyle ?? defaults.titleTextStyle;
    final effectiveDescriptionStyle = configOptionStyle?.descriptionTextStyle ?? defaults.descriptionTextStyle;
    final effectiveSwitchStyle = configOptionStyle?.switchStyle ?? defaults.switchStyle;

    return Row(
      spacing: spacing.md,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            spacing: spacing.xxs,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: effectiveTitleStyle),
              if (description case final description?) Text(description, style: effectiveDescriptionStyle),
            ],
          ),
        ),
        StreamSwitch(
          value: value,
          onChanged: onChanged,
          style: effectiveSwitchStyle,
        ),
      ],
    );
  }
}

class _PollConfigOptionDefaults extends StreamPollConfigOptionStyle {
  _PollConfigOptionDefaults(this._context);

  final BuildContext _context;

  late final _colorScheme = _context.streamColorScheme;
  late final _textTheme = _context.streamTextTheme;
  late final _spacing = _context.streamSpacing;

  @override
  double get childSpacing => _spacing.md;

  @override
  Color get backgroundColor => _colorScheme.backgroundSurfaceCard;

  @override
  EdgeInsetsGeometry get contentPadding => EdgeInsets.all(_spacing.md);

  @override
  TextStyle get titleTextStyle => _textTheme.headingSm.copyWith(color: _colorScheme.textPrimary);

  @override
  TextStyle get descriptionTextStyle => _textTheme.captionDefault.copyWith(color: _colorScheme.textTertiary);
}
