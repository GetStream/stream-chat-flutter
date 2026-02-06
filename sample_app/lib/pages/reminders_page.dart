import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/widgets/reminder_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  late final controller =
      StreamMessageReminderListController(
          client: StreamChat.of(context).client,
        )
        ..eventListener = (event) {
          if (event.type == EventType.connectionRecovered || event.type == EventType.notificationReminderDue) {
            // This will create the query filter with the updated current date
            // and time, so that the reminders list is updated with the new
            // reminders that are due.
            onFilterChanged(_currentFilter);
          }

          // Returning false as we also want the controller to handle the event.
          return false;
        };

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  var _currentFilter = MessageRemindersFilter.all;
  void onFilterChanged(MessageRemindersFilter filter) {
    setState(() => _currentFilter = filter);

    controller.filter = _currentFilter.queryFilter;
    controller.doInitialLoad();
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverToBoxAdapter(
            child: MessageRemindersFilterSelection(
              selected: _currentFilter,
              onSelected: onFilterChanged,
            ),
          ),
        ),
      ],
      body: RefreshIndicator(
        // We are doing a initial load on the controller instead of
        // refresh because refreshing will also reset the current active
        // filter, which we don't want.
        onRefresh: controller.doInitialLoad,
        child: PagedValueListView<String, MessageReminder>(
          controller: controller,
          separatorBuilder: (_, __, ___) => const Divider(height: 1),
          itemBuilder: (context, reminders, index) {
            final reminder = reminders[index];
            final theme = StreamChatTheme.of(context);

            return Slidable(
              groupTag: 'reminder-actions',
              endActionPane: ActionPane(
                extentRatio: 0.4,
                motion: const BehindMotion(),
                children: [
                  CustomSlidableAction(
                    backgroundColor: theme.colorTheme.inputBg,
                    child: StreamSvgIcon(
                      size: 24,
                      icon: StreamSvgIcons.edit,
                      color: theme.colorTheme.accentPrimary,
                    ),
                    onPressed: (_) async {
                      final rem = await showDialog<ReminderOption>(
                        context: context,
                        builder: (context) => EditReminderDialog(
                          isBookmarkReminder: reminder.remindAt == null,
                        ),
                      );

                      if (rem == null) return;
                      final client = StreamChat.of(context).client;

                      client.updateReminder(
                        reminder.messageId,
                        remindAt: rem.remindAt,
                      );
                    },
                  ),
                  CustomSlidableAction(
                    backgroundColor: theme.colorTheme.inputBg,
                    child: StreamSvgIcon(
                      size: 24,
                      icon: StreamSvgIcons.delete,
                      color: theme.colorTheme.accentError,
                    ),
                    onPressed: (context) {
                      final client = StreamChat.of(context).client;
                      final messageId = reminder.messageId;

                      client.deleteReminder(messageId).ignore();
                    },
                  ),
                ],
              ),
              child: MessageReminderListTile(
                reminder: reminder,
                onReminderTap: () {
                  final client = StreamChat.of(context).client;

                  final cid = reminder.channelCid;
                  final [type, id] = cid.split(':');
                  final channel = client.channel(type, id: id);

                  GoRouter.of(context).goNamed(
                    Routes.CHANNEL_PAGE.name,
                    pathParameters: Routes.CHANNEL_PAGE.params(channel),
                    queryParameters: switch (reminder.message) {
                      final it? => Routes.CHANNEL_PAGE.queryParams(it),
                      _ => const <String, String>{},
                    },
                  );
                },
              ),
            );
          },
          emptyBuilder: (context) {
            final chatThemeData = StreamChatTheme.of(context);
            return Center(
              child: StreamScrollViewEmptyWidget(
                emptyIcon: Icon(
                  size: 48,
                  Icons.bookmark_border_rounded,
                  color: theme.colorTheme.textLowEmphasis,
                ),
                emptyTitle: Text(
                  'No reminders yet',
                  style: chatThemeData.textTheme.headline,
                ),
              ),
            );
          },
          loadMoreErrorBuilder: (context, error) => ListTile(
            onTap: controller.retry,
            title: Text(error.message),
          ),
          loadMoreIndicatorBuilder: (context) => const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
          loadingBuilder: (context) => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          errorBuilder: (context, error) => Center(
            child: Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  size: 48,
                  Icons.bookmark_border_rounded,
                  color: theme.colorTheme.textLowEmphasis,
                ),
                Text(
                  'Error loading reminders',
                  style: theme.textTheme.headline,
                ),
                FilledButton(
                  onPressed: controller.doInitialLoad,
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorTheme.accentPrimary,
                  ),
                  child: Text(
                    'Retry loading',
                    style: theme.textTheme.body.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum MessageRemindersFilter {
  all('All'),
  overdue('Overdue'),
  upcoming('Upcoming'),
  scheduled('Scheduled'),
  savedForLater('Saved for later')
  ;

  const MessageRemindersFilter(this.label);
  final String label;

  Filter get queryFilter {
    const key = 'remind_at';
    final now = DateTime.timestamp().toIso8601String();
    return switch (this) {
      MessageRemindersFilter.all => const Filter.empty(),
      MessageRemindersFilter.overdue => Filter.lessOrEqual(key, now),
      MessageRemindersFilter.upcoming => Filter.greaterOrEqual(key, now),
      MessageRemindersFilter.scheduled => Filter.exists(key),
      MessageRemindersFilter.savedForLater => Filter.notExists(key),
    };
  }
}

class MessageRemindersFilterSelection extends StatefulWidget {
  const MessageRemindersFilterSelection({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final MessageRemindersFilter selected;
  final ValueSetter<MessageRemindersFilter> onSelected;

  @override
  State<MessageRemindersFilterSelection> createState() => _MessageRemindersFilterSelectionState();
}

class _MessageRemindersFilterSelectionState extends State<MessageRemindersFilterSelection> {
  final _filterKeys = <MessageRemindersFilter, GlobalKey>{};

  @override
  void initState() {
    super.initState();
    // Initialize keys for each filter
    for (final filter in MessageRemindersFilter.values) {
      _filterKeys[filter] = GlobalKey();
    }

    // Schedule a post-frame callback to scroll to the initial selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedFilter();
    });
  }

  @override
  void didUpdateWidget(MessageRemindersFilterSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      // Scroll when the selection changes
      _scrollToSelectedFilter();
    }
  }

  void _scrollToSelectedFilter() {
    final currentContext = _filterKeys[widget.selected]?.currentContext;
    if (currentContext == null) return;

    // Use ensureVisible for simpler, more reliable scrolling
    Scrollable.ensureVisible(
      currentContext,
      alignment: 0.5, // Center the item (0.0 is start, 1.0 is end)
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...MessageRemindersFilter.values.map((filter) {
            final isSelected = filter == widget.selected;
            return FilterChip(
              key: _filterKeys[filter],
              showCheckmark: false,
              label: Text(filter.label),
              labelStyle: theme.textTheme.footnote.copyWith(
                color: switch (isSelected) {
                  true => Colors.white,
                  false => theme.colorTheme.textHighEmphasis,
                },
              ),
              selected: isSelected,
              onSelected: (_) => widget.onSelected.call(filter),
              backgroundColor: theme.colorTheme.inputBg,
              selectedColor: theme.colorTheme.accentPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class MessageReminderListTile extends StatelessWidget {
  const MessageReminderListTile({
    super.key,
    required this.reminder,
    this.onReminderTap,
  });

  final MessageReminder reminder;
  final VoidCallback? onReminderTap;

  @override
  Widget build(BuildContext context) {
    final channel = reminder.channel;
    final channelName = channel?.formatName(currentUser: reminder.user);

    return InkWell(
      onTap: onReminderTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MessageReminderChannelName(channelName: channelName),
                MessageReminderStatus(remindAt: reminder.remindAt),
              ],
            ),
            MessageReminderMessageText(message: reminder.message),
          ],
        ),
      ),
    );
  }
}

class MessageReminderChannelName extends StatelessWidget {
  const MessageReminderChannelName({
    super.key,
    this.channelName,
  });

  final String? channelName;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return Text(
      maxLines: 1,
      '# ${channelName ?? context.translations.noTitleText}',
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.headlineBold,
    );
  }
}

class MessageReminderMessageText extends StatelessWidget {
  const MessageReminderMessageText({
    super.key,
    this.message,
  });

  final Message? message;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    return Text(
      maxLines: 2,
      message?.text ?? context.translations.noTitleText,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.body,
    );
  }
}

class MessageReminderStatus extends StatelessWidget {
  const MessageReminderStatus({super.key, this.remindAt});

  final DateTime? remindAt;

  @override
  Widget build(BuildContext context) {
    return switch (remindAt) {
      final remindAt? => TimedReminderIndicator(remindAt: remindAt),
      null => const SavedForLaterIndicator(),
    };
  }
}

class SavedForLaterIndicator extends StatelessWidget {
  const SavedForLaterIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    return Icon(
      Icons.bookmark_rounded,
      color: theme.colorTheme.accentPrimary,
    );
  }
}

/// Displays a timed reminder indicator with customized styling based on status.
class TimedReminderIndicator extends StatefulWidget {
  const TimedReminderIndicator({
    super.key,
    required this.remindAt,
  });

  final DateTime remindAt;

  @override
  State<TimedReminderIndicator> createState() => _TimedReminderIndicatorState();
}

class _TimedReminderIndicatorState extends State<TimedReminderIndicator> {
  Timer? _timer;
  late var _lastRemindAt = widget.remindAt;

  @override
  void initState() {
    super.initState();
    _scheduleNextUpdate();
  }

  @override
  void didUpdateWidget(TimedReminderIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.remindAt != _lastRemindAt) {
      _lastRemindAt = widget.remindAt;
      _resetTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    _timer?.cancel();
    _scheduleNextUpdate();
  }

  void _scheduleNextUpdate() {
    final updateInterval = _calculateUpdateInterval();
    _timer = Timer(updateInterval, _onTimerComplete);
  }

  Duration _calculateUpdateInterval() {
    final now = DateTime.now();
    final difference = _lastRemindAt.difference(now).abs();

    if (difference.inDays > 0) return const Duration(days: 1);
    if (difference.inHours > 0) return const Duration(hours: 1);
    return const Duration(minutes: 1);
  }

  void _onTimerComplete() {
    if (mounted) {
      setState(() {});
      _scheduleNextUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    final remindAtDuration = Jiffy.parseFromDateTime(_lastRemindAt);
    final isOverdue = remindAtDuration.isBefore(Jiffy.now());

    final fromNow = remindAtDuration.fromNow(withPrefixAndSuffix: false);
    final (color, label) = switch (isOverdue) {
      true => (theme.colorTheme.accentError, 'Overdue by $fromNow'),
      false => (theme.colorTheme.accentPrimary, 'Due in $fromNow'),
    };

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        label,
        style: theme.textTheme.footnoteBold.copyWith(color: Colors.white),
      ),
    );
  }
}
