import 'package:flutter/material.dart';
import 'package:stream_core_flutter/chat.dart';

/// Wraps [child], a Material date or time picker, in a theme of the design
/// system's colors and type.
///
/// Used as the `builder` of [showDatePicker] and [showTimePicker].
Widget buildSchedulePickerTheme(BuildContext context, Widget? child) {
  final theme = Theme.of(context);
  final colorScheme = context.streamColorScheme;
  final textTheme = context.streamTextTheme;
  final radius = context.streamRadius;

  final helpTextStyle = textTheme.captionEmphasis.copyWith(color: colorScheme.textSecondary);
  final buttonStyle = TextButton.styleFrom(
    foregroundColor: colorScheme.accentPrimary,
    textStyle: textTheme.bodyEmphasis,
  );

  Color? selectedOr(Set<WidgetState> states, Color selected, Color other) {
    if (states.contains(WidgetState.selected)) return selected;
    if (states.contains(WidgetState.disabled)) return colorScheme.textDisabled;
    return other;
  }

  final datePickerTheme = DatePickerThemeData(
    backgroundColor: colorScheme.backgroundElevation2,
    surfaceTintColor: Colors.transparent,
    headerForegroundColor: colorScheme.textSecondary,
    headerHelpStyle: helpTextStyle,
    subHeaderForegroundColor: colorScheme.textSecondary,
    dividerColor: colorScheme.borderDefault,
    weekdayStyle: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.textPrimary),
    dayForegroundColor: WidgetStateProperty.resolveWith(
      (states) => selectedOr(states, colorScheme.textOnAccent, colorScheme.textPrimary),
    ),
    dayBackgroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected) ? colorScheme.accentPrimary : null,
    ),
    todayForegroundColor: WidgetStateProperty.resolveWith(
      (states) => selectedOr(states, colorScheme.textOnAccent, colorScheme.accentPrimary),
    ),
    todayBackgroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected) ? colorScheme.accentPrimary : null,
    ),
    todayBorder: BorderSide(color: colorScheme.accentPrimary),
    yearForegroundColor: WidgetStateProperty.resolveWith(
      (states) => selectedOr(states, colorScheme.textOnAccent, colorScheme.textSecondary),
    ),
    yearBackgroundColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.selected) ? colorScheme.accentPrimary : null,
    ),
    // State colors (enabled, focused, error) come from the color scheme below.
    inputDecorationTheme: InputDecorationThemeData(
      border: OutlineInputBorder(borderRadius: BorderRadius.all(radius.lg)),
    ),
    cancelButtonStyle: buttonStyle,
    confirmButtonStyle: buttonStyle,
  );

  final timePickerTheme = TimePickerThemeData(
    backgroundColor: colorScheme.backgroundElevation2,
    helpTextStyle: helpTextStyle,
    hourMinuteColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return colorScheme.backgroundSelected;
      return colorScheme.backgroundSurfaceSubtle;
    }),
    hourMinuteTextColor: colorScheme.textPrimary,
    dayPeriodColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return colorScheme.backgroundSelected;
      return Colors.transparent;
    }),
    dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return colorScheme.textPrimary;
      return colorScheme.textSecondary;
    }),
    dayPeriodBorderSide: BorderSide(color: colorScheme.borderDefault),
    dialBackgroundColor: colorScheme.backgroundSurfaceSubtle,
    dialHandColor: colorScheme.accentPrimary,
    dialTextColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) return colorScheme.textOnAccent;
      return colorScheme.textPrimary;
    }),
    entryModeIconColor: colorScheme.textSecondary,
    timeSelectorSeparatorColor: WidgetStatePropertyAll(colorScheme.textPrimary),
    cancelButtonStyle: buttonStyle,
    confirmButtonStyle: buttonStyle,
  );

  final pickerTheme = theme.copyWith(
    // Covers the slots the picker themes have no field for: the input fields'
    // border, label and focus states, the time picker's error text, and ink.
    colorScheme: theme.colorScheme.copyWith(
      primary: colorScheme.accentPrimary,
      onPrimary: colorScheme.textOnAccent,
      primaryContainer: colorScheme.backgroundSelected,
      onPrimaryContainer: colorScheme.textPrimary,
      error: colorScheme.accentError,
      surface: colorScheme.backgroundElevation2,
      onSurface: colorScheme.textPrimary,
      onSurfaceVariant: colorScheme.textSecondary,
      outline: colorScheme.borderDefault,
      outlineVariant: colorScheme.borderDefault,
    ),
    // The typed text of the input fields takes its color from here.
    textTheme: theme.textTheme.apply(
      bodyColor: colorScheme.textPrimary,
      displayColor: colorScheme.textPrimary,
    ),
    // Without this the fields keep the app's own cursor and selection colors.
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colorScheme.accentPrimary,
      selectionColor: colorScheme.accentPrimary.withValues(alpha: 0.4),
      selectionHandleColor: colorScheme.accentPrimary,
    ),
    datePickerTheme: datePickerTheme,
    timePickerTheme: timePickerTheme,
  );

  return Theme(data: pickerTheme, child: child!);
}
