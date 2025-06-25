// ignore_for_file: deprecated_member_use

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/pages/thread_page.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/widgets/reminder_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({
    super.key,
    this.initialScrollIndex,
    this.initialAlignment,
    this.highlightInitialMessage = false,
  });
  final int? initialScrollIndex;
  final double? initialAlignment;
  final bool highlightInitialMessage;

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  FocusNode? _focusNode;
  final StreamMessageInputController _messageInputController =
      StreamMessageInputController();

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode!.dispose();
    super.dispose();
  }

  void _reply(Message message) {
    _messageInputController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode!.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorTheme;

    return Scaffold(
      backgroundColor: colorTheme.appBg,
      appBar: StreamChannelHeader(
        showTypingIndicator: false,
        onBackPressed: () => GoRouter.of(context).pop(),
        onImageTap: () async {
          final channel = StreamChannel.of(context).channel;
          final router = GoRouter.of(context);

          if (channel.memberCount == 2 && channel.isDistinct) {
            final currentUser = StreamChat.of(context).currentUser;
            final otherUser = channel.state!.members.firstWhereOrNull(
              (element) => element.user!.id != currentUser!.id,
            );
            if (otherUser != null) {
              router.pushNamed(
                Routes.CHAT_INFO_SCREEN.name,
                pathParameters: Routes.CHAT_INFO_SCREEN.params(channel),
                extra: otherUser.user,
              );
            }
          } else {
            GoRouter.of(context).pushNamed(
              Routes.GROUP_INFO_SCREEN.name,
              pathParameters: Routes.GROUP_INFO_SCREEN.params(channel),
            );
          }
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                StreamMessageListView(
                  initialScrollIndex: widget.initialScrollIndex,
                  initialAlignment: widget.initialAlignment,
                  highlightInitialMessage: widget.highlightInitialMessage,
                  //onMessageSwiped: _reply,
                  messageFilter: defaultFilter,
                  messageBuilder: customMessageBuilder,
                  threadBuilder: (_, parentMessage) {
                    return ThreadPage(parent: parentMessage!);
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: colorTheme.appBg.withOpacity(.9),
                    child: StreamTypingIndicator(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      style: textTheme.footnote.copyWith(
                        color: colorTheme.textLowEmphasis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamMessageInput(
            focusNode: _focusNode,
            messageInputController: _messageInputController,
            onQuotedMessageCleared: _messageInputController.clearQuotedMessage,
            enableVoiceRecording: true,
          ),
        ],
      ),
    );
  }

  Widget customMessageBuilder(
    BuildContext context,
    MessageDetails details,
    List<Message> messages,
    StreamMessageWidget defaultMessageWidget,
  ) {
    final theme = StreamChatTheme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorTheme;

    final message = details.message;
    final reminder = message.reminder;
    final channelConfig = StreamChannel.of(context).channel.config;

    final customOptions = <StreamMessageAction>[
      if (channelConfig?.userMessageReminders == true) ...[
        if (reminder != null) ...[
          StreamMessageAction(
            leading: StreamSvgIcon(
              icon: StreamSvgIcons.time,
              color: colorTheme.textLowEmphasis,
            ),
            title: const Text('Edit Reminder'),
            onTap: (message) async {
              Navigator.of(context).pop();

              final option = await showDialog<ReminderOption>(
                context: context,
                builder: (_) => EditReminderDialog(
                  isBookmarkReminder: reminder.remindAt == null,
                ),
              );

              if (option == null) return;
              final client = StreamChat.of(context).client;
              final messageId = message.id;
              final remindAt = option.remindAt;

              client.updateReminder(messageId, remindAt: remindAt).ignore();
            },
          ),
          StreamMessageAction(
            leading: StreamSvgIcon(
              icon: StreamSvgIcons.checkAll,
              color: colorTheme.textLowEmphasis,
            ),
            title: const Text('Remove from later'),
            onTap: (message) {
              Navigator.of(context).pop();

              final client = StreamChat.of(context).client;
              final messageId = message.id;

              client.deleteReminder(messageId).ignore();
            },
          ),
        ] else ...[
          StreamMessageAction(
            leading: StreamSvgIcon(
              icon: StreamSvgIcons.time,
              color: colorTheme.textLowEmphasis,
            ),
            title: const Text('Remind me'),
            onTap: (message) async {
              Navigator.of(context).pop();

              final reminder = await showDialog<ScheduledReminder>(
                context: context,
                builder: (_) => const CreateReminderDialog(),
              );

              if (reminder == null) return;
              final client = StreamChat.of(context).client;
              final messageId = message.id;
              final remindAt = reminder.remindAt;

              client.createReminder(messageId, remindAt: remindAt).ignore();
            },
          ),
          StreamMessageAction(
            leading: Icon(
              Icons.bookmark_border,
              color: colorTheme.textLowEmphasis,
            ),
            title: const Text('Save for later'),
            onTap: (message) {
              Navigator.of(context).pop();

              final client = StreamChat.of(context).client;
              final messageId = message.id;

              client.createReminder(messageId).ignore();
            },
          ),
        ],
      ]
    ];

    return Container(
      color: reminder != null ? colorTheme.accentPrimary.withOpacity(.1) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (reminder != null)
            Align(
              alignment: switch (defaultMessageWidget.reverse) {
                true => AlignmentDirectional.centerEnd,
                false => AlignmentDirectional.centerStart,
              },
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
                child: Row(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      size: 16,
                      Icons.bookmark_rounded,
                      color: colorTheme.accentPrimary,
                    ),
                    Text(
                      'Saved for later',
                      style: textTheme.footnote.copyWith(
                        color: colorTheme.accentPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          defaultMessageWidget.copyWith(
            onReplyTap: _reply,
            customActions: customOptions,
            onShowMessage: (message, channel) => GoRouter.of(context).goNamed(
              Routes.CHANNEL_PAGE.name,
              pathParameters: Routes.CHANNEL_PAGE.params(channel),
              queryParameters: Routes.CHANNEL_PAGE.queryParams(message),
            ),
            bottomRowBuilderWithDefaultWidget: (_, __, defaultWidget) {
              return defaultWidget.copyWith(
                deletedBottomRowBuilder: (context, message) {
                  return const StreamVisibleFootnote();
                },
              );
            },
          ),
          // If the message has a reminder, add some space below it.
          if (reminder != null) const SizedBox(height: 4),
        ],
      ),
    );
  }

  bool defaultFilter(Message m) {
    final currentUser = StreamChat.of(context).currentUser;
    final isMyMessage = m.user?.id == currentUser?.id;
    final isDeletedOrShadowed = m.isDeleted == true || m.shadowed == true;
    if (isDeletedOrShadowed && !isMyMessage) return false;
    return true;
  }
}
