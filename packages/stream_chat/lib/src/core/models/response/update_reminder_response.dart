import 'package:freezed_annotation/freezed_annotation.dart';

import '../message_reminder.dart';

part 'update_reminder_response.freezed.dart';

/// The outcome of updating the reminder on a message.
@freezed
class UpdateReminderResponse with _$UpdateReminderResponse {
  /// Creates a new [UpdateReminderResponse].
  const UpdateReminderResponse({
    required this.duration,
    required this.reminder,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The reminder as it is after the update.
  @override
  final MessageReminder reminder;
}
