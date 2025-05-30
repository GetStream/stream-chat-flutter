import 'package:flutter/cupertino.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

sealed class ReminderOption {
  const ReminderOption(this.remindAt);
  final DateTime? remindAt;
}

final class ScheduledReminder extends ReminderOption {
  const ScheduledReminder(super.remindAt);
}

final class BookmarkReminder extends ReminderOption {
  const BookmarkReminder() : super(null);
}

class CreateReminderDialog extends StatelessWidget {
  const CreateReminderDialog({super.key});

  static const _remindAtDurations = [
    Duration(minutes: 2),
    Duration(minutes: 5),
    Duration(minutes: 30),
    Duration(hours: 1),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return CupertinoTheme(
      data: CupertinoTheme.of(context).copyWith(
        primaryColor: theme.colorTheme.accentPrimary,
      ),
      child: CupertinoAlertDialog(
        title: const Text('Select Reminder Time'),
        content: const Text('When would you like to be reminded?'),
        actions: <Widget>[
          ..._remindAtDurations.map((duration) {
            final remindAt = Jiffy.now().addDuration(duration);
            return CupertinoDialogAction(
              onPressed: () {
                final option = ScheduledReminder(remindAt.dateTime);
                Navigator.of(context).pop(option);
              },
              child: Text(remindAt.fromNow()),
            );
          }),
        ],
      ),
    );
  }
}

class EditReminderDialog extends StatelessWidget {
  const EditReminderDialog({
    super.key,
    this.isBookmarkReminder = false,
  });

  final bool isBookmarkReminder;

  static const _remindAtDurations = [
    Duration(minutes: 2),
    Duration(minutes: 5),
    Duration(minutes: 30),
    Duration(hours: 1),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return CupertinoTheme(
      data: CupertinoTheme.of(context).copyWith(
        primaryColor: theme.colorTheme.accentPrimary,
      ),
      child: CupertinoAlertDialog(
        title: const Text('Edit Reminder Time'),
        actions: <Widget>[
          ..._remindAtDurations.map((duration) {
            final remindAt = Jiffy.now().addDuration(duration);
            return CupertinoDialogAction(
              onPressed: () {
                final option = ScheduledReminder(remindAt.dateTime);
                Navigator.of(context).pop(option);
              },
              child: Text(remindAt.fromNow()),
            );
          }),
          if (!isBookmarkReminder)
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(const BookmarkReminder());
              },
              child: const Text('Clear due date'),
            ),
        ],
      ),
    );
  }
}
