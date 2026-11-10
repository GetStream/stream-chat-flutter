import 'package:flutter/material.dart';
import 'package:stream_core_flutter/chat.dart';

/// Wraps [child], a Material date or time picker, in a theme of the design
/// system's colors, radius and type.
///
/// Used as the `builder` of [showDatePicker] and [showTimePicker].
Widget buildSchedulePickerTheme(BuildContext context, Widget? child) {
  final theme = Theme.of(context);
  final colorScheme = context.streamColorScheme;
  final textTheme = context.streamTextTheme;
  final radius = context.streamRadius;

  final accentContainer = colorScheme.brand.shade150;
  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(radius.lg),
  );
  final helpTextStyle = textTheme.captionEmphasis.copyWith(
    color: colorScheme.textSecondary,
  );

  final pickerTheme = theme.copyWith(
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
    datePickerTheme: DatePickerThemeData(
      backgroundColor: colorScheme.backgroundElevation2,
      surfaceTintColor: Colors.transparent,
      shape: shape,
      headerHelpStyle: helpTextStyle,
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: colorScheme.backgroundElevation2,
      dialBackgroundColor: colorScheme.backgroundSurfaceSubtle,
      hourMinuteColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return accentContainer;
        return colorScheme.backgroundSurfaceSubtle;
      }),
      shape: shape,
      helpTextStyle: helpTextStyle,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.accentPrimary,
        textStyle: textTheme.bodyEmphasis,
      ),
    ),
  );

  return Theme(data: pickerTheme, child: child!);
}
