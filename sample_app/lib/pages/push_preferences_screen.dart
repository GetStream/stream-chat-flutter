import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../config/settings_widgets.dart';
import '../widgets/search_text_field.dart';

/// A settings screen for the current user's push notification preferences:
/// what to be notified about, a temporary snooze, and recurring quiet hours.
class PushPreferencesScreen extends StatefulWidget {
  const PushPreferencesScreen({super.key});

  @override
  State<PushPreferencesScreen> createState() => _PushPreferencesScreenState();
}

class _PushPreferencesScreenState extends State<PushPreferencesScreen> {
  var _saving = false;

  Future<void> _save(PushPreferenceInput input) async {
    if (!mounted) return;
    final client = StreamChat.of(context).client;
    final messenger = StreamSnackbarMessenger.maybeOf(context);

    setState(() => _saving = true);
    try {
      await client.setPushPreferences([input]);
    } catch (error) {
      messenger?.show(StreamSnackbar(message: Text('Could not save: $error')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    final colorScheme = context.streamColorScheme;

    return StreamScaffold(
      backgroundColor: colorScheme.backgroundApp,
      appBar: StreamAppBar(title: const Text('Notifications')),
      body: StreamBuilder<PushPreference?>(
        stream: client.state.currentUserStream.map((user) => user?.pushPreferences).distinct(),
        initialData: client.state.currentUser?.pushPreferences,
        builder: (context, snapshot) => _buildContent(context, snapshot.data),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PushPreference? preferences) {
    final spacing = context.streamSpacing;
    final icons = context.streamIcons;
    final colorScheme = context.streamColorScheme;
    final enabled = !_saving;

    final schedule = preferences?.schedule;
    final disabledUntil = preferences?.disabledUntil;
    final snoozed = disabledUntil != null && disabledUntil.isAfter(DateTime.now());

    final topInset = MediaQuery.paddingOf(context).top;
    final content = SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: spacing.md) + EdgeInsets.only(top: topInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: spacing.xs),

          // ── Notify me about ──
          const SettingsSectionHeader(title: 'Notify me about'),
          SizedBox(height: spacing.xs),
          SettingsCard(
            children: [
              SettingsSegmentedRow<ChatLevel>(
                title: 'Messages',
                value: preferences?.chatLevel ?? ChatLevel.all,
                segments: const {
                  ChatLevel.all: 'All',
                  ChatLevel.directMentions: 'Mentions',
                  ChatLevel.none: 'None',
                },
                onChanged: (level) {
                  if (!enabled) return;
                  _save(PushPreferenceInput(chatLevel: level));
                },
              ),
              SettingsSegmentedRow<CallLevel>(
                title: 'Calls',
                value: preferences?.callLevel ?? CallLevel.all,
                segments: const {
                  CallLevel.all: 'All',
                  CallLevel.none: 'None',
                },
                onChanged: (level) {
                  if (!enabled) return;
                  _save(PushPreferenceInput(callLevel: level));
                },
              ),
              SettingsValueRow(
                icon: icons.bellOff,
                title: 'Snooze',
                value: snoozed ? 'Until ${_formatDateTime(context, disabledUntil)}' : 'Off',
                onTap: enabled ? () => _pickSnooze(context, snoozed: snoozed) : null,
              ),
            ],
          ),

          SizedBox(height: spacing.xl),

          // ── Quiet hours ──
          const SettingsSectionHeader(title: 'Quiet hours'),
          SizedBox(height: spacing.xs),
          SettingsCard(
            children: [
              SettingsSwitchRow(
                icon: icons.darkMode,
                title: 'Quiet hours',
                subtitle: 'Silence notifications on a schedule',
                value: schedule != null,
                onChanged: enabled ? (on) => _toggleSchedule(on: on) : null,
              ),
              if (schedule != null) ...[
                SettingsValueRow(
                  icon: icons.language,
                  title: 'Time zone',
                  value: schedule.timezone,
                  onTap: enabled ? () => _pickTimezone(context, schedule) : null,
                ),
                for (final (index, rule) in schedule.quietHours.indexed)
                  Slidable(
                    key: ValueKey(index),
                    groupTag: 'quiet-hours',
                    enabled: enabled,
                    endActionPane: ActionPane(
                      extentRatio: 0.2,
                      motion: const BehindMotion(),
                      children: [
                        CustomSlidableAction(
                          foregroundColor: colorScheme.textOnAccent,
                          backgroundColor: colorScheme.accentError,
                          onPressed: (_) => _deleteRule(schedule, index),
                          child: Icon(icons.delete, size: 20),
                        ),
                      ],
                    ),
                    child: SettingsValueRow(
                      icon: icons.clock,
                      title: '${rule.start} – ${rule.end}',
                      value: _formatDays(rule.days),
                      onTap: enabled ? () => _editRule(context, schedule, index: index) : null,
                    ),
                  ),
                if (schedule.quietHours.length < _maxQuietHoursRules)
                  StreamListTile(
                    enabled: enabled,
                    leading: Icon(icons.plus, size: 24),
                    title: const Text('Add quiet hours'),
                    onTap: () => _editRule(context, schedule),
                  ),
              ],
            ],
          ),

          SizedBox(height: spacing.xxl),
        ],
      ),
    );

    return SafeArea(
      top: false,
      bottom: false,
      // Opening one rule's swipe action closes any other that is open.
      child: SlidableAutoCloseBehavior(child: content),
    );
  }

  // ── Snooze ──

  Future<void> _pickSnooze(BuildContext context, {required bool snoozed}) async {
    final choice = await _showOptionsSheet<Duration?>(
      context,
      title: 'Snooze notifications',
      options: {
        const Duration(hours: 1): 'For 1 hour',
        const Duration(hours: 8): 'For 8 hours',
        const Duration(days: 1): 'For 1 day',
        const Duration(days: 7): 'For 1 week',
        if (snoozed) null: 'Turn off snooze',
      },
    );
    if (choice == null) return;

    final duration = choice.value;
    if (duration == null) return _save(const PushPreferenceInput(removeDisable: true));
    return _save(PushPreferenceInput(disabledUntil: DateTime.now().add(duration).toUtc()));
  }

  // ── Quiet hours ──

  Future<void> _toggleSchedule({required bool on}) async {
    if (!on) return _save(const PushPreferenceInput(removeSchedule: true));

    final timezone = await _localTimezone();
    return _save(
      PushPreferenceInput(
        schedule: PushSchedule(
          timezone: timezone,
          quietHours: const [QuietHoursRule(start: '22:00', end: '07:00')],
        ),
      ),
    );
  }

  Future<void> _pickTimezone(BuildContext context, PushSchedule schedule) async {
    // The current and the device's zones lead, so neither needs a scroll.
    final local = await _localTimezone();
    final available = await _availableTimezones();
    if (!context.mounted) return;

    final zones = {schedule.timezone, local, ...available};

    final choice = await _showOptionsSheet<String>(
      context,
      title: 'Time zone',
      selected: schedule.timezone,
      searchable: true,
      options: {for (final zone in zones) zone: zone},
    );
    if (choice == null || choice.value == schedule.timezone) return;

    return _save(
      PushPreferenceInput(
        schedule: PushSchedule(timezone: choice.value, quietHours: schedule.quietHours),
      ),
    );
  }

  Future<void> _editRule(BuildContext context, PushSchedule schedule, {int? index}) async {
    final initial = switch (index) {
      final index? => schedule.quietHours[index],
      null => const QuietHoursRule(start: '22:00', end: '07:00'),
    };

    final rule = await showStreamSheet<QuietHoursRule>(
      context: context,
      isDismissible: true,
      builder: (context, scrollController) => _QuietHoursRuleEditor(
        initialRule: initial,
        scrollController: scrollController,
      ),
    );
    if (rule == null) return;

    final rules = switch (index) {
      final index? => [...schedule.quietHours]..[index] = rule,
      null => [...schedule.quietHours, rule],
    };
    return _save(
      PushPreferenceInput(
        schedule: PushSchedule(timezone: schedule.timezone, quietHours: rules),
      ),
    );
  }

  Future<void> _deleteRule(PushSchedule schedule, int index) {
    final rules = [...schedule.quietHours]..removeAt(index);

    // A schedule needs at least one rule, so deleting the last one turns quiet
    // hours off.
    if (rules.isEmpty) return _save(const PushPreferenceInput(removeSchedule: true));

    return _save(
      PushPreferenceInput(
        schedule: PushSchedule(timezone: schedule.timezone, quietHours: rules),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Quiet-hours rule editor sheet
// ---------------------------------------------------------------------------

class _QuietHoursRuleEditor extends StatefulWidget {
  const _QuietHoursRuleEditor({
    required this.initialRule,
    required this.scrollController,
  });

  final QuietHoursRule initialRule;
  final ScrollController scrollController;

  @override
  State<_QuietHoursRuleEditor> createState() => _QuietHoursRuleEditorState();
}

class _QuietHoursRuleEditorState extends State<_QuietHoursRuleEditor> {
  late var _start = widget.initialRule.start;
  late var _end = widget.initialRule.end;
  late final _days = {...widget.initialRule.days};

  Future<void> _pickTime({required bool start}) async {
    final current = _parseTime(start ? _start : _end);
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: Theme(data: _timePickerTheme(context), child: child!),
      ),
    );
    if (picked == null) return;

    final value = _formatTime(picked);
    setState(() => start ? _start = value : _end = value);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final icons = context.streamIcons;

    final valid = _start != _end;
    final days = QuietHoursDay.values.where(_days.contains).toList();

    final helperPadding = EdgeInsets.only(left: spacing.xxs);
    void save() => Navigator.of(context).pop(
      QuietHoursRule(start: _start, end: _end, days: days),
    );

    return SafeArea(
      child: Column(
        children: [
          StreamSheetHeader(
            title: const Text('Quiet hours'),
            trailing: StreamButton.icon(
              icon: Icon(icons.checkmark),
              type: StreamButtonType.solid,
              onPressed: valid ? save : null,
            ),
          ),
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: EdgeInsets.all(spacing.md),
              children: [
                SettingsCard(
                  children: [
                    SettingsValueRow(
                      icon: icons.darkMode,
                      title: 'From',
                      value: _start,
                      onTap: () => _pickTime(start: true),
                    ),
                    SettingsValueRow(
                      icon: icons.lightMode,
                      title: 'Until',
                      value: _end,
                      subtitle: _endsNextDay(_start, _end) ? 'Next day' : null,
                      onTap: () => _pickTime(start: false),
                    ),
                  ],
                ),
                if (!valid) ...[
                  SizedBox(height: spacing.xs),
                  Padding(
                    padding: helperPadding,
                    child: Text(
                      'Start and end must differ.',
                      style: textTheme.captionDefault.copyWith(color: colorScheme.accentError),
                    ),
                  ),
                ],
                SizedBox(height: spacing.xl),
                const SettingsSectionHeader(title: 'Repeat on'),
                SizedBox(height: spacing.xs),
                Row(
                  spacing: spacing.xxs,
                  children: [
                    for (final day in QuietHoursDay.values)
                      Expanded(
                        child: StreamButton(
                          isSelected: _days.contains(day),
                          type: _days.contains(day) ? StreamButtonType.solid : StreamButtonType.outline,
                          style: _days.contains(day) ? StreamButtonStyle.primary : StreamButtonStyle.secondary,
                          size: StreamButtonSize.small,
                          onPressed: () => setState(() {
                            if (!_days.remove(day)) _days.add(day);
                          }),
                          child: Text(_dayLabels[day]![0], semanticsLabel: _dayLabels[day]),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: spacing.xs),
                Padding(
                  padding: helperPadding,
                  child: Text(
                    _formatDays(days),
                    style: textTheme.captionDefault.copyWith(color: colorScheme.textTertiary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

// The most rules a schedule can hold.
const _maxQuietHoursRules = 7;

const _dayLabels = {
  QuietHoursDay.monday: 'Mon',
  QuietHoursDay.tuesday: 'Tue',
  QuietHoursDay.wednesday: 'Wed',
  QuietHoursDay.thursday: 'Thu',
  QuietHoursDay.friday: 'Fri',
  QuietHoursDay.saturday: 'Sat',
  QuietHoursDay.sunday: 'Sun',
};

// The device's IANA time zone, or UTC if the platform can't report one.
Future<String> _localTimezone() async {
  try {
    return (await FlutterTimezone.getLocalTimezone()).identifier;
  } catch (_) {
    return 'UTC';
  }
}

// Every IANA time zone the device knows, sorted by name.
Future<List<String>> _availableTimezones() async {
  try {
    final zones = await FlutterTimezone.getAvailableTimezones();
    return [for (final zone in zones) zone.identifier]..sort();
  } catch (_) {
    return const ['UTC'];
  }
}

String _formatDays(List<QuietHoursDay> days) {
  if (days.isEmpty || days.length == QuietHoursDay.values.length) return 'Every day';
  return days.map((day) => _dayLabels[day] ?? day).join(', ');
}

String _formatDateTime(BuildContext context, DateTime dateTime) {
  final local = dateTime.toLocal();
  final time = _formatTime(TimeOfDay.fromDateTime(local));
  final now = DateTime.now();
  if (DateUtils.isSameDay(local, now)) return time;
  return '${MaterialLocalizations.of(context).formatShortMonthDay(local)}, $time';
}

TimeOfDay _parseTime(String value) {
  final [hour, minute] = value.split(':').map(int.parse).toList();
  return TimeOfDay(hour: hour % 24, minute: minute);
}

String _formatTime(TimeOfDay time) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  return '${twoDigits(time.hour)}:${twoDigits(time.minute)}';
}

// Whether a window from [start] to [end] wraps past midnight.
bool _endsNextDay(String start, String end) => end != '24:00' && end.compareTo(start) < 0;

// The design system has no time picker, so the Material one is drawn in the
// design system's colors, radius and type.
ThemeData _timePickerTheme(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = context.streamColorScheme;
  final textTheme = context.streamTextTheme;
  final radius = context.streamRadius;

  final accentContainer = colorScheme.brand.shade150;
  return theme.copyWith(
    colorScheme: theme.colorScheme.copyWith(
      primary: colorScheme.accentPrimary,
      onPrimary: colorScheme.textOnAccent,
      primaryContainer: accentContainer,
      onPrimaryContainer: colorScheme.accentPrimary,
      surface: colorScheme.backgroundElevation2,
      onSurface: colorScheme.textPrimary,
      onSurfaceVariant: colorScheme.textSecondary,
      surfaceContainerHighest: colorScheme.backgroundSurfaceSubtle,
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: colorScheme.backgroundElevation2,
      dialBackgroundColor: colorScheme.backgroundSurfaceSubtle,
      hourMinuteColor: WidgetStateColor.resolveWith(
        (states) => states.contains(WidgetState.selected) ? accentContainer : colorScheme.backgroundSurfaceSubtle,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(radius.lg)),
      helpTextStyle: textTheme.captionEmphasis.copyWith(color: colorScheme.textSecondary),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.accentPrimary,
        textStyle: textTheme.bodyEmphasis,
      ),
    ),
  );
}

// A bottom sheet listing [options] by label; resolves to the tapped option
// wrapped in a record so a null option can still be told apart from a dismiss.
// A [searchable] sheet filters the options by label as the user types.
Future<({T value})?> _showOptionsSheet<T>(
  BuildContext context, {
  required String title,
  required Map<T, String> options,
  T? selected,
  bool searchable = false,
}) {
  return showStreamSheet<({T value})>(
    context: context,
    isDismissible: true,
    builder: (sheetContext, scrollController) => _OptionsSheet<T>(
      title: title,
      options: options,
      selected: selected,
      searchable: searchable,
      scrollController: scrollController,
    ),
  );
}

class _OptionsSheet<T> extends StatefulWidget {
  const _OptionsSheet({
    required this.title,
    required this.options,
    required this.selected,
    required this.searchable,
    required this.scrollController,
  });

  final String title;
  final Map<T, String> options;
  final T? selected;
  final bool searchable;
  final ScrollController scrollController;

  @override
  State<_OptionsSheet<T>> createState() => _OptionsSheetState<T>();
}

class _OptionsSheetState<T> extends State<_OptionsSheet<T>> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final spacing = context.streamSpacing;

    final query = _query.trim().toLowerCase();
    final entries = [
      for (final entry in widget.options.entries)
        if (entry.value.toLowerCase().contains(query)) entry,
    ];

    return Column(
      children: [
        StreamSheetHeader(title: Text(widget.title)),
        if (widget.searchable)
          SearchTextField(
            controller: null,
            onChanged: (value) => setState(() => _query = value),
          ),
        Expanded(
          child: ListView.separated(
            controller: widget.scrollController,
            itemCount: entries.length,
            separatorBuilder: (_, _) => Divider(
              height: 1,
              indent: spacing.lg,
              endIndent: spacing.lg,
              color: colorScheme.borderSubtle,
            ),
            itemBuilder: (context, index) {
              final MapEntry(:key, :value) = entries[index];
              void select() => Navigator.of(context).pop((value: key));

              return StreamListTile(
                title: Text(value),
                trailing: widget.selected == null
                    ? null
                    : StreamCheckbox.circular(
                        value: key == widget.selected,
                        size: StreamCheckboxSize.sm,
                        onChanged: (_) => select(),
                      ),
                onTap: select,
              );
            },
          ),
        ),
      ],
    );
  }
}
