// ignore_for_file: deprecated_member_use, avoid_redundant_argument_values

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/pages/thread_page.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/widgets/location/location_attachment.dart';
import 'package:sample_app/widgets/location/location_detail_dialog.dart';
import 'package:sample_app/widgets/location/location_picker_dialog.dart';
import 'package:sample_app/widgets/location/location_picker_option.dart';
import 'package:sample_app/widgets/message_info_sheet.dart';
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
  final _messageInputController = StreamMessageInputController();

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

    final channel = StreamChannel.of(context).channel;
    final config = channel.config;

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
          StreamChatMessageComposer(),
          // StreamMessageInput(
          //   focusNode: _focusNode,
          //   messageInputController: _messageInputController,
          //   onQuotedMessageCleared: _messageInputController.clearQuotedMessage,
          //   enableVoiceRecording: true,
          //   allowedAttachmentPickerTypes: [
          //     ...AttachmentPickerType.values,
          //     if (config?.sharedLocations == true && channel.canShareLocation) const LocationPickerType(),
          //   ],
          //   onAttachmentPickerResult: (result) {
          //     return _onCustomAttachmentPickerResult(channel, result);
          //   },
          //   attachmentPickerOptionsBuilder: (context, defaultOptions) => [
          //     ...defaultOptions,
          //     TabbedAttachmentPickerOption(
          //       key: 'location-picker',
          //       icon: const Icon(Icons.near_me_rounded),
          //       supportedTypes: [const LocationPickerType()],
          //       isEnabled: (value) {
          //         // Enable if nothing has been selected yet.
          //         if (value.isEmpty) return true;

          //         // Otherwise, enable only if there is a location.
          //         return value.extraData['location'] != null;
          //       },
          //       optionViewBuilder: (context, controller) => LocationPicker(
          //         onLocationPicked: (locationResult) {
          //           if (locationResult == null) return Navigator.pop(context);

          //           controller.extraData = {
          //             ...controller.value.extraData,
          //             'location': locationResult,
          //           };

          //           final result = LocationPicked(location: locationResult);
          //           return Navigator.pop(context, result);
          //         },
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  bool _onCustomAttachmentPickerResult(
    Channel channel,
    StreamAttachmentPickerResult result,
  ) {
    if (result is LocationPicked) {
      _onShareLocationPicked(channel, result.location).ignore();
      return true; // Notify that the result was handled.
    }

    return false; // Notify that the result was not handled.
  }

  Future<SendMessageResponse> _onShareLocationPicked(
    Channel channel,
    LocationPickerResult result,
  ) async {
    if (result.endSharingAt case final endSharingAt?) {
      return channel.startLiveLocationSharing(
        endSharingAt: endSharingAt,
        location: result.coordinates,
      );
    }

    return channel.sendStaticLocation(location: result.coordinates);
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
    final channel = StreamChannel.of(context).channel;
    final channelConfig = channel.config;

    final currentUser = StreamChat.of(context).currentUser;
    final isSentByCurrentUser = message.user?.id == currentUser?.id;
    final canDeleteOwnMessage = channel.canDeleteOwnMessage;

    final customOptions = <StreamMessageAction>[
      if (isSentByCurrentUser && canDeleteOwnMessage)
        StreamMessageAction(
          isDestructive: true,
          title: const Text('Delete Message for Me'),
          action: DeleteMessageForMe(message: message),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.delete),
        ),
      if (channelConfig?.userMessageReminders == true) ...[
        if (reminder != null) ...[
          StreamMessageAction(
            title: const Text('Edit Reminder'),
            leading: const StreamSvgIcon(icon: StreamSvgIcons.time),
            action: EditReminder(message: message, reminder: reminder),
          ),
          StreamMessageAction(
            title: const Text('Remove from later'),
            leading: const StreamSvgIcon(icon: StreamSvgIcons.checkAll),
            action: RemoveReminder(message: message, reminder: reminder),
          ),
        ] else ...[
          StreamMessageAction(
            title: const Text('Remind me'),
            leading: const StreamSvgIcon(icon: StreamSvgIcons.time),
            action: CreateReminder(message: message),
          ),
          StreamMessageAction(
            title: const Text('Save for later'),
            leading: const Icon(Icons.bookmark_border),
            action: CreateBookmark(message: message),
          ),
        ],
      ],
      if (channelConfig?.deliveryEvents == true)
        StreamMessageAction(
          title: const Text('Message Info'),
          leading: const Icon(Icons.info_outline_rounded),
          action: ShowMessageInfo(message: message),
        ),
    ];

    final locationAttachmentBuilder = LocationAttachmentBuilder(
      onAttachmentTap: (location) => showLocationDetailDialog(
        context: context,
        location: location,
      ),
    );

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
            showEditMessage: message.sharedLocation == null,
            onCustomActionTap: (it) async => await switch (it) {
              CreateReminder() => _createReminder(it.message),
              CreateBookmark() => _createBookmark(it.message),
              EditReminder() => _editReminder(it.message, it.reminder),
              RemoveReminder() => _removeReminder(it.message, it.reminder),
              DeleteMessageForMe() => _deleteMessageForMe(it.message),
              ShowMessageInfo() => _showMessageInfo(it.message),
              _ => null,
            },
            attachmentBuilders: [locationAttachmentBuilder],
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

  Future<void> _editReminder(
    Message message,
    MessageReminder reminder,
  ) async {
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

    return client.updateReminder(messageId, remindAt: remindAt).ignore();
  }

  Future<void> _removeReminder(
    Message message,
    MessageReminder reminder,
  ) async {
    final client = StreamChat.of(context).client;
    final messageId = message.id;

    return client.deleteReminder(messageId).ignore();
  }

  Future<void> _createReminder(Message message) async {
    final reminder = await showDialog<ScheduledReminder>(
      context: context,
      builder: (_) => const CreateReminderDialog(),
    );

    if (reminder == null) return;
    final client = StreamChat.of(context).client;
    final messageId = message.id;
    final remindAt = reminder.remindAt;

    return client.createReminder(messageId, remindAt: remindAt).ignore();
  }

  Future<void> _createBookmark(Message message) async {
    final client = StreamChat.of(context).client;
    final messageId = message.id;

    return client.createReminder(messageId).ignore();
  }

  Future<void> _deleteMessageForMe(Message message) async {
    final confirmDelete = await showStreamDialog<bool>(
      context: context,
      builder: (context) => const StreamMessageActionConfirmationModal(
        isDestructiveAction: true,
        title: Text('Delete for me'),
        content: Text('Are you sure you want to delete this message for you?'),
        cancelActionTitle: Text('Cancel'),
        confirmActionTitle: Text('Delete'),
      ),
    );

    if (confirmDelete != true) return;

    final channel = StreamChannel.of(context).channel;
    return channel.deleteMessageForMe(message).ignore();
  }

  Future<void> _showMessageInfo(Message message) async {
    return MessageInfoSheet.show(context: context, message: message);
  }

  bool defaultFilter(Message m) {
    final currentUser = StreamChat.of(context).currentUser;
    final isMyMessage = m.user?.id == currentUser?.id;
    final isDeletedOrShadowed = m.isDeleted == true || m.shadowed == true;
    if (isDeletedOrShadowed && !isMyMessage) return false;
    return true;
  }
}

class ReminderMessageAction extends CustomMessageAction {
  const ReminderMessageAction({
    required super.message,
    this.reminder,
  });

  final MessageReminder? reminder;
}

final class CreateReminder extends ReminderMessageAction {
  const CreateReminder({required super.message});
}

final class CreateBookmark extends ReminderMessageAction {
  const CreateBookmark({required super.message});
}

final class EditReminder extends ReminderMessageAction {
  const EditReminder({
    required super.message,
    required this.reminder,
  }) : super(reminder: reminder);

  @override
  final MessageReminder reminder;
}

final class RemoveReminder extends ReminderMessageAction {
  const RemoveReminder({
    required super.message,
    required this.reminder,
  }) : super(reminder: reminder);

  @override
  final MessageReminder reminder;
}

final class DeleteMessageForMe extends CustomMessageAction {
  const DeleteMessageForMe({required super.message});
}

final class ShowMessageInfo extends CustomMessageAction {
  const ShowMessageInfo({required super.message});
}
