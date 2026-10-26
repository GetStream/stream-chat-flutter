import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// The user's message reminders: saved for later, or due at a set time.
class RemindersTab extends StatefulWidget {
  const RemindersTab({super.key});

  @override
  State<RemindersTab> createState() => _RemindersTabState();
}

class _RemindersTabState extends State<RemindersTab> {
  late final _controller = StreamMessageReminderListController(client: StreamChat.of(context).client);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagedValueListView<String, MessageReminder>(
      controller: _controller,
      separatorBuilder: (_, __, ___) => const Divider(height: 1),
      itemBuilder: (context, reminders, index) => MessageReminderListTile(reminder: reminders[index]),
      emptyBuilder: (context) => const Center(child: Text('No reminders yet')),
      loadMoreErrorBuilder: (context, error) => ListTile(onTap: _controller.retry, title: Text(error.message)),
      loadMoreIndicatorBuilder: (context) => const Center(child: CircularProgressIndicator()),
      loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
      errorBuilder: (context, error) => Center(child: Text(error.message)),
    );
  }
}

/// A reminder: its message, and whether it is saved for later or due.
class MessageReminderListTile extends StatelessWidget {
  const MessageReminderListTile({super.key, required this.reminder});

  final MessageReminder reminder;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(reminder.message?.text ?? ''),
      trailing: switch (reminder.remindAt) {
        final remindAt? => TimedReminderIndicator(remindAt: remindAt),
        null => const SavedForLaterIndicator(),
      },
    );
  }
}

class SavedForLaterIndicator extends StatelessWidget {
  const SavedForLaterIndicator({super.key});

  @override
  Widget build(BuildContext context) => const Text('Saved for later');
}

class TimedReminderIndicator extends StatelessWidget {
  const TimedReminderIndicator({super.key, required this.remindAt});

  final DateTime remindAt;

  @override
  Widget build(BuildContext context) => Text(Jiffy.parseFromDateTime(remindAt.toLocal()).jm);
}
