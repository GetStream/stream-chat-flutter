import '../../../open_api/api.dart' as api;
import '../../core/models/message_reminder.dart';
import '../../core/models/response/create_reminder_response.dart';
import '../../core/models/response/delete_reminder_response.dart';
import '../../core/models/response/query_reminders_response.dart';
import '../../core/models/response/update_reminder_response.dart';
import 'channel_mapper.dart';
import 'message_mapper.dart';
import 'user_mapper.dart';

/// Maps a generated [api.CreateReminderResponse] to a [CreateReminderResponse].
extension CreateReminderResponseMapper on api.CreateReminderResponse {
  /// Converts this response into a [CreateReminderResponse].
  CreateReminderResponse toModel() => CreateReminderResponse(duration: duration, reminder: reminder.toModel());
}

/// Maps a generated [api.UpdateReminderResponse] to an [UpdateReminderResponse].
extension UpdateReminderResponseMapper on api.UpdateReminderResponse {
  /// Converts this response into an [UpdateReminderResponse].
  UpdateReminderResponse toModel() => UpdateReminderResponse(duration: duration, reminder: reminder.toModel());
}

/// Maps a generated [api.DeleteReminderResponse] to a [DeleteReminderResponse].
extension DeleteReminderResponseMapper on api.DeleteReminderResponse {
  /// Converts this response into a [DeleteReminderResponse].
  DeleteReminderResponse toModel() => DeleteReminderResponse(duration: duration);
}

/// Maps a generated [api.QueryRemindersResponse] to a [QueryRemindersResponse].
extension QueryRemindersResponseMapper on api.QueryRemindersResponse {
  /// Converts this response into a [QueryRemindersResponse].
  QueryRemindersResponse toModel() => QueryRemindersResponse(
    duration: duration,
    reminders: [for (final reminder in reminders) reminder.toModel()],
    next: next,
    prev: prev,
  );
}

/// Maps a generated [api.ReminderResponseData] to a [MessageReminder].
extension ReminderResponseDataMapper on api.ReminderResponseData {
  /// Converts this response into a [MessageReminder].
  MessageReminder toModel() => MessageReminder(
    channelCid: channelCid,
    channel: channel?.toModel(),
    messageId: messageId,
    message: message?.toModel(),
    userId: userId,
    user: user?.toModel(),
    remindAt: remindAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
