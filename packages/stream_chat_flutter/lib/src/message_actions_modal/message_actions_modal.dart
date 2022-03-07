import 'dart:ui';

import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:stream_chat_flutter/src/bottom_sheets/edit_message_sheet.dart';
import 'package:stream_chat_flutter/src/dialogs/delete_message_dialog.dart';
import 'package:stream_chat_flutter/src/dialogs/message_dialog.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/message_actions_modal/mam_widgets.dart';
import 'package:stream_chat_flutter/src/platform_widgets/platform_widget_builder.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Constructs a modal with actions for a message
class MessageActionsModal extends StatefulWidget {
  /// Constructor for creating a [MessageActionsModal] widget
  const MessageActionsModal({
    Key? key,
    required this.message,
    required this.messageWidget,
    required this.messageTheme,
    this.showReactions = true,
    this.showDeleteMessage = true,
    this.showEditMessage = true,
    this.onReplyTap,
    this.onThreadReplyTap,
    this.showCopyMessage = true,
    this.showReplyMessage = true,
    this.showResendMessage = true,
    this.showThreadReplyMessage = true,
    this.showFlagButton = true,
    this.showPinButton = true,
    this.editMessageInputBuilder,
    this.reverse = false,
    this.customActions = const [],
    this.onCopyTap,
  }) : super(key: key);

  /// Widget that shows the message
  final Widget messageWidget;

  /// Builder for edit message
  final Widget Function(BuildContext, Message)? editMessageInputBuilder;

  /// Callback for when thread reply is tapped
  final OnMessageTap? onThreadReplyTap;

  /// Callback for when reply is tapped
  final OnMessageTap? onReplyTap;

  /// Message in focus for actions
  final Message message;

  /// [MessageThemeData] for message
  final MessageThemeData messageTheme;

  /// Flag for showing reactions
  final bool showReactions;

  /// Callback when copy is tapped
  final OnMessageTap? onCopyTap;

  /// Callback when delete is tapped
  final bool showDeleteMessage;

  /// Flag for showing copy action
  final bool showCopyMessage;

  /// Flag for showing edit action
  final bool showEditMessage;

  /// Flag for showing resend action
  final bool showResendMessage;

  /// Flag for showing reply action
  final bool showReplyMessage;

  /// Flag for showing thread reply action
  final bool showThreadReplyMessage;

  /// Flag for showing flag action
  final bool showFlagButton;

  /// Flag for showing pin action
  final bool showPinButton;

  /// Flag for reversing message
  final bool reverse;

  /// List of custom actions
  final List<MessageAction> customActions;

  @override
  _MessageActionsModalState createState() => _MessageActionsModalState();
}

class _MessageActionsModalState extends State<MessageActionsModal> {
  bool _showActions = true;

  @override
  Widget build(BuildContext context) => _showMessageOptionsModal();

  Widget _showMessageOptionsModal() {
    final mediaQueryData = MediaQuery.of(context);
    final size = mediaQueryData.size;
    final user = StreamChat.of(context).currentUser;

    final roughMaxSize = size.width * 2 / 3;
    var messageTextLength = widget.message.text!.length;
    if (widget.message.quotedMessage != null) {
      var quotedMessageLength =
          (widget.message.quotedMessage!.text?.length ?? 0) + 40;
      if (widget.message.quotedMessage!.attachments.isNotEmpty) {
        quotedMessageLength += 40;
      }
      if (quotedMessageLength > messageTextLength) {
        messageTextLength = quotedMessageLength;
      }
    }
    final roughSentenceSize = messageTextLength *
        (widget.messageTheme.messageTextStyle?.fontSize ?? 1) *
        1.2;
    final divFactor = widget.message.attachments.isNotEmpty
        ? 1
        : (roughSentenceSize == 0 ? 1 : (roughSentenceSize / roughMaxSize));

    final streamChatThemeData = StreamChatTheme.of(context);

    final numberOfReactions = streamChatThemeData.reactionIcons.length;
    final shiftFactor =
        numberOfReactions < 5 ? (5 - numberOfReactions) * 0.1 : 0.0;
    final channel = StreamChannel.of(context).channel;

    final child = Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: widget.reverse
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.showReactions &&
                  (widget.message.status == MessageSendingStatus.sent))
                Align(
                  alignment: Alignment(
                    user?.id == widget.message.user?.id
                        ? (divFactor >= 1.0
                            ? -0.2 - shiftFactor
                            : (1.2 - divFactor))
                        : (divFactor >= 1.0
                            ? shiftFactor + 0.2
                            : -(1.2 - divFactor)),
                    0,
                  ),
                  child: ReactionPicker(
                    message: widget.message,
                  ),
                ),
              const SizedBox(height: 8),
              IgnorePointer(
                child: widget.messageWidget,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.only(
                  left: widget.reverse ? 0 : 40,
                ),
                child: SizedBox(
                  width: mediaQueryData.size.width * 0.75,
                  child: Material(
                    color: streamChatThemeData.colorTheme.appBg,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.showReplyMessage &&
                            widget.message.status == MessageSendingStatus.sent)
                          ReplyButton(
                            onTap: () {
                              Navigator.of(context).pop();
                              if (widget.onReplyTap != null) {
                                widget.onReplyTap!(widget.message);
                              }
                            },
                          ),
                        if (widget.showThreadReplyMessage &&
                            (widget.message.status ==
                                MessageSendingStatus.sent) &&
                            widget.message.parentId == null)
                          ThreadReplyButton(message: widget.message),
                        if (widget.showResendMessage)
                          ResendMessageButton(
                            message: widget.message,
                            channel: channel,
                          ),
                        if (widget.showEditMessage)
                          EditMessageButton(
                            onTap: () {
                              Navigator.of(context).pop();
                              _showEditBottomSheet(context);
                            },
                          ),
                        if (widget.showCopyMessage)
                          CopyMessageButton(
                            onTap: () {
                              widget.onCopyTap?.call(widget.message);
                              Navigator.of(context).pop();
                            },
                          ),
                        if (widget.showFlagButton)
                          FlagMessageButton(
                            onTap: _showFlagDialog,
                          ),
                        if (widget.showPinButton)
                          PinMessageButton(
                            onTap: _togglePin,
                            pinned: widget.message.pinned,
                          ),
                        if (widget.showDeleteMessage)
                          PlatformWidgetBuilder(
                            mobile: (context, _) => DeleteMessageButton(
                              isDeleteFailed: widget.message.status ==
                                  MessageSendingStatus.failed_delete,
                              onTap: _showDeleteBottomSheet,
                            ),
                            desktop: (context, child) => DeleteMessageButton(
                              isDeleteFailed: widget.message.status ==
                                  MessageSendingStatus.failed_delete,
                              onTap: _showDeleteDialog,
                            ),
                            web: (context, child) => DeleteMessageButton(
                              isDeleteFailed: widget.message.status ==
                                  MessageSendingStatus.failed_delete,
                              onTap: _showDeleteDialog,
                            ),
                          ),
                        ...widget.customActions
                            .map((action) => _buildCustomAction(
                                  context,
                                  action,
                                )),
                      ].insertBetween(
                        Container(
                          height: 1,
                          color: streamChatThemeData.colorTheme.borders,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.maybePop(context),
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                color: streamChatThemeData.colorTheme.overlay,
              ),
            ),
          ),
          if (_showActions)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutBack,
              builder: (context, val, child) => Transform.scale(
                scale: val,
                child: child,
              ),
              child: child,
            ),
        ],
      ),
    );
  }

  InkWell _buildCustomAction(
    BuildContext context,
    MessageAction messageAction,
  ) {
    return InkWell(
      onTap: () => messageAction.onTap?.call(widget.message),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        child: Row(
          children: [
            messageAction.leading ?? const Offstage(),
            const SizedBox(width: 16),
            messageAction.title ?? const Offstage(),
          ],
        ),
      ),
    );
  }

  void _showFlagDialog() async {
    final client = StreamChat.of(context).client;

    final streamChatThemeData = StreamChatTheme.of(context);
    final answer = await showConfirmationBottomSheet(
      context,
      title: context.translations.flagMessageLabel,
      icon: StreamSvgIcon.flag(
        color: streamChatThemeData.colorTheme.accentError,
        size: 24,
      ),
      question: context.translations.flagMessageQuestion,
      okText: context.translations.flagLabel,
      cancelText: context.translations.cancelLabel,
    );

    final theme = streamChatThemeData;
    if (answer == true) {
      try {
        await client.flagMessage(widget.message.id);
        await showInfoBottomSheet(
          context,
          icon: StreamSvgIcon.flag(
            color: theme.colorTheme.accentError,
            size: 24,
          ),
          details: context.translations.flagMessageSuccessfulText,
          title: context.translations.flagMessageSuccessfulLabel,
          okText: context.translations.okLabel,
        );
      } catch (err) {
        if (err is StreamChatNetworkError &&
            err.errorCode == ChatErrorCode.inputError) {
          await showInfoBottomSheet(
            context,
            icon: StreamSvgIcon.flag(
              color: theme.colorTheme.accentError,
              size: 24,
            ),
            details: context.translations.flagMessageSuccessfulText,
            title: context.translations.flagMessageSuccessfulLabel,
            okText: context.translations.okLabel,
          );
        } else {
          _showErrorAlertBottomSheet();
        }
      }
    }
  }

  void _togglePin() async {
    final channel = StreamChannel.of(context).channel;

    Navigator.of(context).pop();
    try {
      if (!widget.message.pinned) {
        await channel.pinMessage(widget.message);
      } else {
        await channel.unpinMessage(widget.message);
      }
    } catch (e) {
      _showErrorAlertBottomSheet();
    }
  }

  /// Shows a "delete message" bottom sheet on mobile platforms.
  void _showDeleteBottomSheet() async {
    setState(() => _showActions = false);
    final answer = await showConfirmationBottomSheet(
      context,
      title: context.translations.deleteMessageLabel,
      icon: StreamSvgIcon.flag(
        color: StreamChatTheme.of(context).colorTheme.accentError,
        size: 24,
      ),
      question: context.translations.deleteMessageQuestion,
      okText: context.translations.deleteLabel,
      cancelText: context.translations.cancelLabel,
    );

    if (answer == true) {
      try {
        Navigator.of(context).pop();
        await StreamChannel.of(context).channel.deleteMessage(widget.message);
      } catch (err) {
        _showErrorAlertBottomSheet();
      }
    } else {
      setState(() => _showActions = true);
    }
  }

  /// Shows a "delete message" dialog on desktop platforms
  ///
  /// TODO(Groovin): consider web ⚠️
  Future<void> _showDeleteDialog() async {
    setState(() => _showActions = false);
    final answer = await showDialog(
      context: context,
      builder: (_) => const DeleteMessageDialog(),
    );
    if (answer == true) {
      try {
        Navigator.of(context).pop();
        await StreamChannel.of(context).channel.deleteMessage(widget.message);
      } catch (err) {
        showDialog(
          context: context,
          builder: (_) => const MessageDialog(),
        );
      }
    } else {
      setState(() => _showActions = true);
    }
  }

  void _showErrorAlertBottomSheet() {
    showInfoBottomSheet(
      context,
      icon: StreamSvgIcon.error(
        color: StreamChatTheme.of(context).colorTheme.accentError,
        size: 24,
      ),
      details: context.translations.operationCouldNotBeCompletedText,
      title: context.translations.somethingWentWrongError,
      okText: context.translations.okLabel,
    );
  }

  void _showEditBottomSheet(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    showModalBottomSheet(
      context: context,
      elevation: 2,
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
      backgroundColor: MessageInputTheme.of(context).inputBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => EditMessageSheet(
        message: widget.message,
        channel: channel,
      ),
    );
  }
}