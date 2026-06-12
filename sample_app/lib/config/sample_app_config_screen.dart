import 'package:flutter/material.dart';
import 'package:sample_app/config/sample_app_config.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A settings screen for configuring sample app feature flags.
class SampleAppConfigScreen extends StatelessWidget {
  const SampleAppConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.sampleAppConfig;
    final colorScheme = context.streamColorScheme;
    final spacing = context.streamSpacing;
    final icons = context.streamIcons;

    return Scaffold(
      backgroundColor: colorScheme.backgroundApp,
      appBar: StreamAppBar(title: const Text('Configuration')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: spacing.xs),

            // ── Appearance ──
            const _SectionHeader(title: 'Appearance'),
            SizedBox(height: spacing.xs),
            _SettingsCard(
              children: [
                _SegmentedRow<ThemeMode>(
                  title: 'Theme',
                  value: config.themeMode,
                  segments: const {
                    ThemeMode.system: 'System',
                    ThemeMode.light: 'Light',
                    ThemeMode.dark: 'Dark',
                  },
                  segmentIcons: const {
                    ThemeMode.system: Icons.brightness_auto_outlined,
                    ThemeMode.light: Icons.light_mode_outlined,
                    ThemeMode.dark: Icons.dark_mode_outlined,
                  },
                  onChanged: (v) => SampleAppConfig.update(context, config.copyWith(themeMode: v)),
                ),
                _SegmentedRow<SampleAppStyle>(
                  title: 'App Style',
                  value: config.appStyle,
                  segments: const {
                    SampleAppStyle.regular: 'Regular',
                    SampleAppStyle.floating: 'Floating',
                  },
                  segmentIcons: const {
                    SampleAppStyle.regular: Icons.web_asset_outlined,
                    SampleAppStyle.floating: Icons.filter_none_outlined,
                  },
                  onChanged: (v) => SampleAppConfig.update(context, config.copyWith(appStyle: v)),
                ),
                _LocaleRow(config: config),
                _SwitchRow(
                  icon: icons.reorder,
                  title: 'Force RTL',
                  subtitle: 'Right-to-left layout direction',
                  value: config.forceRtl,
                  onChanged: (v) => SampleAppConfig.update(context, config.copyWith(forceRtl: v)),
                ),
              ],
            ),

            SizedBox(height: spacing.xl),

            // ── Features ──
            const _SectionHeader(title: 'Features'),
            SizedBox(height: spacing.xs),
            _SettingsCard(
              children: [
                _SwitchRow(
                  icon: icons.bell,
                  title: 'Reminders',
                  subtitle: 'Remind me, Save for later, Edit',
                  value: config.enableReminderActions,
                  onChanged: (v) => SampleAppConfig.update(context, config.copyWith(enableReminderActions: v)),
                ),
                _SwitchRow(
                  icon: icons.delete,
                  title: 'Delete for Me',
                  subtitle: 'Delete message for current user',
                  value: config.enableDeleteForMe,
                  onChanged: (v) => SampleAppConfig.update(context, config.copyWith(enableDeleteForMe: v)),
                ),
                _SwitchRow(
                  icon: icons.info,
                  title: 'Message Info',
                  subtitle: 'Show delivery info sheet',
                  value: config.enableMessageInfo,
                  onChanged: (v) => SampleAppConfig.update(context, config.copyWith(enableMessageInfo: v)),
                ),
                _SwitchRow(
                  icon: icons.location,
                  title: 'Location Sharing',
                  subtitle: 'Attachment builder and picker',
                  value: config.enableLocationSharing,
                  onChanged: (v) => SampleAppConfig.update(context, config.copyWith(enableLocationSharing: v)),
                ),
              ],
            ),

            SizedBox(height: spacing.xl),

            // ── Chat ──
            const _SectionHeader(title: 'Chat'),
            SizedBox(height: spacing.xs),
            _SettingsCard(
              children: [
                _SwitchRow(
                  icon: icons.edit,
                  title: 'Draft Messages',
                  subtitle: 'Enable draft message saving',
                  value: config.draftMessagesEnabled,
                  onChanged: (v) => SampleAppConfig.update(context, config.copyWith(draftMessagesEnabled: v)),
                ),
                _SwitchRow(
                  icon: icons.emoji,
                  title: 'Unique Reactions',
                  subtitle: 'New reaction replaces existing',
                  value: config.enforceUniqueReactions,
                  onChanged: (v) => SampleAppConfig.update(context, config.copyWith(enforceUniqueReactions: v)),
                ),
              ],
            ),

            SizedBox(height: spacing.xl),

            // ── Reactions ──
            const _SectionHeader(title: 'Reactions'),
            SizedBox(height: spacing.xs),
            _SettingsCard(
              children: [
                _SegmentedRow<StreamReactionsType?>(
                  title: 'Reaction Type',
                  value: config.reactionType,
                  segments: const {
                    null: 'Default',
                    StreamReactionsType.segmented: 'Segmented',
                    StreamReactionsType.clustered: 'Clustered',
                  },
                  onChanged: (v) => SampleAppConfig.update(context, config.copyWith(reactionType: v)),
                ),
                _SegmentedRow<StreamReactionsPosition?>(
                  title: 'Reaction Position',
                  value: config.reactionPosition,
                  segments: const {
                    null: 'Default',
                    StreamReactionsPosition.header: 'Header',
                    StreamReactionsPosition.footer: 'Footer',
                  },
                  onChanged: (v) => SampleAppConfig.update(context, config.copyWith(reactionPosition: v)),
                ),
              ],
            ),

            SizedBox(height: spacing.xxl),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section header
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

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

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

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

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
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
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamListTile(
      leading: Icon(icon, size: 24),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: StreamSwitch(value: value, onChanged: onChanged),
      onTap: () => onChanged(!value),
    );
  }
}

// ---------------------------------------------------------------------------
// Segmented row
// ---------------------------------------------------------------------------

class _SegmentedRow<T> extends StatelessWidget {
  const _SegmentedRow({
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
// Locale row
// ---------------------------------------------------------------------------

class _LocaleRow extends StatelessWidget {
  const _LocaleRow({required this.config});

  final SampleAppConfigData config;

  static const _localeLabels = <String, String>{
    'en': 'English',
    'it': 'Italiano',
    'fr': 'Fran\u00e7ais',
    'es': 'Espa\u00f1ol',
    'de': 'Deutsch',
    'pt': 'Portugu\u00eas',
    'ja': '\u65e5\u672c\u8a9e',
    'ko': '\ud55c\uad6d\uc5b4',
    'hi': '\u0939\u093f\u0928\u094d\u0926\u0940',
    'no': 'Norsk',
    'ca': 'Catal\u00e0',
  };

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final icons = context.streamIcons;
    final currentLabel = config.locale == null ? 'System' : _localeLabels[config.locale!.languageCode] ?? 'System';

    return StreamListTile(
      leading: Icon(icons.translate, size: 24),
      title: const Text('Language'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: spacing.xxs,
        children: [
          Text(currentLabel, style: textTheme.captionEmphasis.copyWith(color: colorScheme.textTertiary)),
          Icon(Icons.chevron_right_outlined, size: 20, color: colorScheme.textTertiary),
        ],
      ),
      onTap: () => _showLocalePicker(context),
    );
  }

  void _showLocalePicker(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final spacing = context.streamSpacing;
    final radius = context.streamRadius;

    final items = [
      const _LocaleOption(label: 'System', code: null),
      ...supportedLocales.map(
        (l) => _LocaleOption(
          label: _localeLabels[l.languageCode] ?? l.languageCode,
          code: l.languageCode,
        ),
      ),
    ];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.backgroundSurfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: radius.xxl),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.8,
          minChildSize: 0.3,
          builder: (context, scrollController) => SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: spacing.md, bottom: spacing.sm),
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.borderDefault,
                      borderRadius: BorderRadius.all(radius.max),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: spacing.sm),
                  child: Text(
                    'Select Language',
                    style: textTheme.headingSm.copyWith(color: colorScheme.textPrimary),
                  ),
                ),
                Divider(height: 1, color: colorScheme.borderSubtle),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(vertical: spacing.xs),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      indent: spacing.lg,
                      endIndent: spacing.lg,
                      color: colorScheme.borderSubtle,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = item.code == config.locale?.languageCode;

                      return StreamListTile(
                        title: Text(
                          item.label,
                          style: textTheme.bodyDefault.copyWith(
                            color: isSelected ? colorScheme.accentPrimary : colorScheme.textPrimary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        subtitle: switch (item.code) {
                          final code? => Text(
                            code,
                            style: textTheme.captionDefault.copyWith(color: colorScheme.textTertiary),
                          ),
                          null => null,
                        },
                        trailing: StreamCheckbox.circular(
                          value: isSelected,
                          size: StreamCheckboxSize.sm,
                          onChanged: (_) {
                            final locale = item.code != null ? Locale(item.code!) : null;
                            SampleAppConfig.update(context, config.copyWith(locale: locale));
                            Navigator.of(sheetContext).pop();
                          },
                        ),
                        onTap: () {
                          final locale = item.code != null ? Locale(item.code!) : null;
                          SampleAppConfig.update(context, config.copyWith(locale: locale));
                          Navigator.of(sheetContext).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LocaleOption {
  const _LocaleOption({required this.label, required this.code});

  final String label;
  final String? code;
}
