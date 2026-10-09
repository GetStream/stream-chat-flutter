import 'package:freezed_annotation/freezed_annotation.dart';

import '../message_reminder.dart';

part 'create_reminder_response.freezed.dart';

/// The outcome of creating a reminder on a message.
@freezed
class CreateReminderResponse with _$CreateReminderResponse {
  /// Creates a new [CreateReminderResponse].
  const CreateReminderResponse({
    required this.duration,
    required this.reminder,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The reminder that was created.
  @override
  final MessageReminder reminder;
}
