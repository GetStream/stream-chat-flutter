import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_reminder_response.freezed.dart';

/// The outcome of deleting the reminder on a message.
@freezed
class DeleteReminderResponse with _$DeleteReminderResponse {
  /// Creates a new [DeleteReminderResponse].
  const DeleteReminderResponse({
    required this.duration,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;
}
