import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'sample_app_config.dart';
import 'settings_widgets.dart';

/// Whether dynamic color extraction is supported on the current platform.
///
/// The `dynamic_color` package only supports Android, macOS, Windows, and
/// Linux; iOS and web always resolve to `null`.
final bool _dynamicColorSupported = !kIsWeb && !Platform.isIOS;

/// A settings screen for configuring sample app feature flags.
class SampleAppConfigScreen extends StatelessWidget {
  const SampleAppConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.sampleAppConfig;
    final colorScheme = context.streamColorScheme;
    final spacing = context.streamSpacing;
    final icons = context.streamIcons;

    return StreamScaffold(
      backgroundColor: colorScheme.backgroundApp,
      appBar: StreamAppBar(title: const Text('Configuration')),
      body: Builder(
        builder: (context) {
          final topInset = MediaQuery.paddingOf(context).top;
          final content = SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: spacing.md) + EdgeInsets.only(top: topInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: spacing.xs),

                // ── Appearance ──
                const SettingsSectionHeader(title: 'Appearance'),
                SizedBox(height: spacing.xs),
                SettingsCard(
                  children: [
                    SettingsSegmentedRow<ThemeMode>(
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
                    _SurfaceStyleRows(config: config),
                    SettingsSwitchRow(
                      icon: Icons.palette_outlined,
                      title: 'Dynamic Color',
                      subtitle: _dynamicColorSupported
                          ? 'Theme colors derived from the device wallpaper/accent'
                          : 'Only supported on Android, macOS, Windows, and Linux',
                      value: _dynamicColorSupported && config.enableDynamicColor,
                      onChanged: _dynamicColorSupported
                          ? (v) => SampleAppConfig.update(context, config.copyWith(enableDynamicColor: v))
                          : null,
                    ),
                    _LocaleRow(config: config),
                    SettingsSwitchRow(
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
                const SettingsSectionHeader(title: 'Features'),
                SizedBox(height: spacing.xs),
                SettingsCard(
                  children: [
                    SettingsSwitchRow(
                      icon: icons.bell,
                      title: 'Reminders',
                      subtitle: 'Remind me, Save for later, Edit',
                      value: config.enableReminderActions,
                      onChanged: (v) => SampleAppConfig.update(context, config.copyWith(enableReminderActions: v)),
                    ),
                    SettingsSwitchRow(
                      icon: icons.delete,
                      title: 'Delete for Me',
                      subtitle: 'Delete message for current user',
                      value: config.enableDeleteForMe,
                      onChanged: (v) => SampleAppConfig.update(context, config.copyWith(enableDeleteForMe: v)),
                    ),
                    SettingsSwitchRow(
                      icon: icons.info,
                      title: 'Message Info',
                      subtitle: 'Show delivery info sheet',
                      value: config.enableMessageInfo,
                      onChanged: (v) => SampleAppConfig.update(context, config.copyWith(enableMessageInfo: v)),
                    ),
                    SettingsSwitchRow(
                      icon: icons.translate,
                      title: 'Message Translation',
                      subtitle: 'Show translations, annotate them, and translate on request',
                      value: config.enableMessageTranslation,
                      onChanged: (v) => SampleAppConfig.update(context, config.copyWith(enableMessageTranslation: v)),
                    ),
                    SettingsSwitchRow(
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
                const SettingsSectionHeader(title: 'Chat'),
                SizedBox(height: spacing.xs),
                SettingsCard(
                  children: [
                    SettingsSwitchRow(
                      icon: icons.edit,
                      title: 'Draft Messages',
                      subtitle: 'Enable draft message saving',
                      value: config.draftMessagesEnabled,
                      onChanged: (v) => SampleAppConfig.update(context, config.copyWith(draftMessagesEnabled: v)),
                    ),
                    SettingsSwitchRow(
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
                const SettingsSectionHeader(title: 'Reactions'),
                SizedBox(height: spacing.xs),
                SettingsCard(
                  children: [
                    SettingsSegmentedRow<StreamReactionsType?>(
                      title: 'Reaction Type',
                      value: config.reactionType,
                      segments: const {
                        null: 'Default',
                        StreamReactionsType.segmented: 'Segmented',
                        StreamReactionsType.clustered: 'Clustered',
                      },
                      onChanged: (v) => SampleAppConfig.update(context, config.copyWith(reactionType: v)),
                    ),
                    SettingsSegmentedRow<StreamReactionsPosition?>(
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
          );

          return SafeArea(top: false, bottom: false, child: content);
        },
      ),
    );
  }
}

// The app-wide surface style, plus the per-component overrides folded behind a
// disclosure so they don't crowd the section until they're wanted.
class _SurfaceStyleRows extends StatefulWidget {
  const _SurfaceStyleRows({required this.config});

  final SampleAppConfigData config;

  @override
  State<_SurfaceStyleRows> createState() => _SurfaceStyleRowsState();
}

class _SurfaceStyleRowsState extends State<_SurfaceStyleRows> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final colorScheme = context.streamColorScheme;
    final icons = context.streamIcons;

    final overrides = <_SurfaceOverride>[
      _SurfaceOverride('App Bar', config.appBarSurfaceStyle, (v) => config.copyWith(appBarSurfaceStyle: v)),
      _SurfaceOverride(
        'Bottom App Bar',
        config.bottomAppBarSurfaceStyle,
        (v) => config.copyWith(bottomAppBarSurfaceStyle: v),
      ),
      _SurfaceOverride(
        'Bottom Nav Bar',
        config.bottomNavBarSurfaceStyle,
        (v) => config.copyWith(bottomNavBarSurfaceStyle: v),
      ),
      _SurfaceOverride('Composer', config.composerSurfaceStyle, (v) => config.copyWith(composerSurfaceStyle: v)),
      // These two go through the SDK's own header themes rather than
      // StreamAppBarTheme — a different resolution path worth exercising.
      _SurfaceOverride(
        'Channel Header',
        config.channelHeaderSurfaceStyle,
        (v) => config.copyWith(channelHeaderSurfaceStyle: v),
      ),
      _SurfaceOverride(
        'Thread Header',
        config.threadHeaderSurfaceStyle,
        (v) => config.copyWith(threadHeaderSurfaceStyle: v),
      ),
    ];

    final pinned = overrides.where((it) => it.value != null).length;

    Widget divider() => Divider(height: 1, color: colorScheme.borderSubtle);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SettingsSegmentedRow<StreamSurfaceStyle>(
          title: 'Surface Style',
          value: config.surfaceStyle,
          segments: const {
            StreamSurfaceStyle.regular: 'Regular',
            StreamSurfaceStyle.floating: 'Floating',
          },
          segmentIcons: const {
            StreamSurfaceStyle.regular: Icons.web_asset_outlined,
            StreamSurfaceStyle.floating: Icons.filter_none_outlined,
          },
          onChanged: (v) => SampleAppConfig.update(context, config.copyWith(surfaceStyle: v)),
        ),
        divider(),
        StreamListTile(
          leading: Icon(icons.sidebar, size: 24),
          title: const Text('Per-component overrides'),
          subtitle: Text(
            switch (pinned) {
              0 => 'Every component follows the app style',
              _ => '$pinned of ${overrides.length} pinned away from the app style',
            },
          ),
          trailing: Icon(_expanded ? icons.chevronUp : icons.chevronDown, size: 20),
          onTap: () => setState(() => _expanded = !_expanded),
        ),
        if (_expanded)
          for (final override in overrides) ...[
            divider(),
            SettingsSegmentedRow<StreamSurfaceStyle?>(
              title: override.title,
              value: override.value,
              segments: _componentSurfaceSegments,
              onChanged: (v) => SampleAppConfig.update(context, override.apply(v)),
            ),
          ],
        if (_expanded && pinned > 0) ...[
          divider(),
          StreamListTile(
            leading: Icon(icons.refresh, size: 24),
            title: const Text('Clear overrides'),
            subtitle: const Text('Return every component to the app style'),
            onTap: () => SampleAppConfig.update(
              context,
              config.copyWith(
                appBarSurfaceStyle: null,
                bottomAppBarSurfaceStyle: null,
                bottomNavBarSurfaceStyle: null,
                composerSurfaceStyle: null,
                channelHeaderSurfaceStyle: null,
                threadHeaderSurfaceStyle: null,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// One row in the per-component override list.
class _SurfaceOverride {
  const _SurfaceOverride(this.title, this.value, this.apply);

  final String title;
  final StreamSurfaceStyle? value;
  final SampleAppConfigData Function(StreamSurfaceStyle? value) apply;
}

// Segments for a per-component override: null inherits the app-wide surface
// style, the others pin the component.
const _componentSurfaceSegments = <StreamSurfaceStyle?, String>{
  null: 'Auto',
  StreamSurfaceStyle.regular: 'Regular',
  StreamSurfaceStyle.floating: 'Floating',
};

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

    final items = [
      const _LocaleOption(label: 'System', code: null),
      ...supportedLocales.map(
        (l) => _LocaleOption(
          label: _localeLabels[l.languageCode] ?? l.languageCode,
          code: l.languageCode,
        ),
      ),
    ];

    showStreamSheet<void>(
      context: context,
      isDismissible: true,
      builder: (sheetContext, scrollController) => Column(
        children: [
          StreamSheetHeader(title: const Text('Select Language')),
          Expanded(
            child: ListView.separated(
              controller: scrollController,
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
    );
  }
}

class _LocaleOption {
  const _LocaleOption({required this.label, required this.code});

  final String label;
  final String? code;
}
