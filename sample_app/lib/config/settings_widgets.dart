import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;

    return Padding(
      padding: EdgeInsets.only(left: spacing.xxs),
      child: Text(
        title.toUpperCase(),
        style: textTheme.captionEmphasis.copyWith(
          color: colorScheme.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Settings card — canonical DS pattern with foregroundDecoration for borders
// ---------------------------------------------------------------------------

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final radius = context.streamRadius;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.backgroundSurfaceCard,
        borderRadius: BorderRadius.all(radius.lg),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(radius.lg),
        border: Border.all(color: colorScheme.borderSubtle),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i < children.length - 1) Divider(height: 1, color: colorScheme.borderSubtle),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Switch row — plain icon, DS list tile + switch
// ---------------------------------------------------------------------------

class SettingsSwitchRow extends StatelessWidget {
  const SettingsSwitchRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;

  /// Called when the switch is toggled. Pass `null` to disable the row.
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;

    return StreamListTile(
      enabled: enabled,
      leading: Icon(icon, size: 24),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: StreamSwitch(value: value, onChanged: onChanged),
      onTap: enabled ? () => onChanged!(!value) : null,
    );
  }
}

// ---------------------------------------------------------------------------
// Segmented row
// ---------------------------------------------------------------------------

class SettingsSegmentedRow<T> extends StatelessWidget {
  const SettingsSegmentedRow({
    super.key,
    required this.title,
    required this.value,
    required this.segments,
    required this.onChanged,
    this.segmentIcons,
  });

  final String title;
  final T value;
  final Map<T, String> segments;
  final ValueChanged<T> onChanged;
  final Map<T, IconData>? segmentIcons;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;
    final radius = context.streamRadius;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: spacing.xs,
        children: [
          Text(title, style: textTheme.bodyDefault.copyWith(color: colorScheme.textPrimary)),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<T>(
              showSelectedIcon: false,
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(textTheme.captionEmphasis),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) return colorScheme.textOnAccent;
                  return colorScheme.textPrimary;
                }),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) return colorScheme.accentPrimary;
                  return colorScheme.backgroundSurfaceSubtle;
                }),
                side: WidgetStatePropertyAll(BorderSide(color: colorScheme.borderDefault)),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.all(radius.md)),
                ),
                padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
              ),
              segments: [
                for (final entry in segments.entries)
                  ButtonSegment(
                    value: entry.key,
                    label: Text(entry.value),
                    icon: segmentIcons?[entry.key] != null ? Icon(segmentIcons![entry.key], size: 16) : null,
                  ),
              ],
              selected: {value},
              onSelectionChanged: (selected) => onChanged(selected.first),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Value row — DS list tile showing the current value, tapped to change it
// ---------------------------------------------------------------------------

class SettingsValueRow extends StatelessWidget {
  const SettingsValueRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;

  /// Called when the row is tapped. Pass `null` to disable the row.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;

    return StreamListTile(
      enabled: onTap != null,
      leading: Icon(icon, size: 24),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: spacing.xxs,
        children: [
          Text(value, style: textTheme.captionEmphasis.copyWith(color: colorScheme.textTertiary)),
          Icon(context.streamIcons.chevronRight, size: 20, color: colorScheme.textTertiary),
        ],
      ),
      onTap: onTap,
    );
  }
}
