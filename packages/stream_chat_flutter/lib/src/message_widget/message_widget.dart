import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stream_chat_flutter/src/bottom_sheets/edit_message_sheet.dart';
import 'package:stream_chat_flutter/src/context_menu_items/context_menu_items.dart';
import 'package:stream_chat_flutter/src/dialogs/delete_message_dialog.dart';
import 'package:stream_chat_flutter/src/dialogs/message_dialog.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/image_group.dart';
import 'package:stream_chat_flutter/src/message_actions_modal/message_actions_modal.dart';
import 'package:stream_chat_flutter/src/message_widget/message_reactions_modal.dart';
import 'package:stream_chat_flutter/src/message_widget/message_widget_content.dart';
import 'package:stream_chat_flutter/src/platform_widgets/platform_widget_builder.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Widget builder for building attachments
typedef AttachmentBuilder = Widget Function(
  BuildContext,
  Message,
  List<Attachment>,
);

/// Callback for when quoted message is tapped
typedef OnQuotedMessageTap = void Function(String?);

/// The display behaviour of a widget
enum DisplayWidget {
  /// Hides the widget replacing its space with a spacer
  hide,

  /// Hides the widget not replacing its space
  gone,

  /// Shows the widget normally
  show,
}

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_widget.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_widget_paint.png)
///
/// It shows a message with reactions, replies and user avatar.
///
/// Usually you don't use this widget as it's the default message widget used by
/// [MessageListView].
///
/// The widget components render the ui based on the first ancestor of type
/// [StreamChatTheme].
/// Modify it to change the widget appearance.
class MessageWidget extends StatefulWidget {
  ///
  MessageWidget({
    Key? key,
    required this.message,
    required this.messageTheme,
    this.reverse = false,
    this.translateUserAvatar = true,
    this.shape,
    this.attachmentShape,
    this.borderSide,
    this.attachmentBorderSide,
    this.borderRadiusGeometry,
    this.attachmentBorderRadiusGeometry,
    this.onMentionTap,
    this.onMessageTap,
    this.showReactionPickerIndicator = false,
    this.showUserAvatar = DisplayWidget.show,
    this.showSendingIndicator = true,
    this.showThreadReplyIndicator = false,
    this.showInChannelIndicator = false,
    this.onReplyTap,
    this.onThreadTap,
    this.showUsername = true,
    this.showTimestamp = true,
    this.showReactions = true,
    this.showDeleteMessage = true,
    this.showEditMessage = true,
    this.showReplyMessage = true,
    this.showThreadReplyMessage = true,
    this.showResendMessage = true,
    this.showCopyMessage = true,
    this.showFlagButton = true,
    this.showPinButton = true,
    this.showPinHighlight = true,
    this.onUserAvatarTap,
    this.onLinkTap,
    this.onMessageActions,
    this.onShowMessage,
    this.userAvatarBuilder,
    this.editMessageInputBuilder,
    this.textBuilder,
    this.bottomRowBuilder,
    this.deletedBottomRowBuilder,
    this.onReturnAction,
    this.customAttachmentBuilders,
    this.padding,
    this.textPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    this.attachmentPadding = EdgeInsets.zero,
    @Deprecated('''
    allRead is now deprecated and it will be removed in future releases. 
    The MessageWidget now listens for read events on its own.
    ''') this.allRead = false,
    @Deprecated('''
    readList is now deprecated and it will be removed in future releases. 
    The MessageWidget now listens for read events on its own.
    ''') this.readList,
    this.onQuotedMessageTap,
    this.customActions = const [],
    this.onAttachmentTap,
    this.usernameBuilder,
  })  : attachmentBuilders = {
          'image': (context, message, attachments) {
            final border = RoundedRectangleBorder(
              borderRadius: attachmentBorderRadiusGeometry ?? BorderRadius.zero,
            );

            final mediaQueryData = MediaQuery.of(context);
            if (attachments.length > 1) {
              return Padding(
                padding: attachmentPadding,
                child: WrapAttachmentWidget(
                  attachmentWidget: Material(
                    color: messageTheme.messageBackgroundColor,
                    child: ImageGroup(
                      size: Size(
                        mediaQueryData.size.width * 0.8,
                        mediaQueryData.size.height * 0.3,
                      ),
                      images: attachments,
                      message: message,
                      messageTheme: messageTheme,
                      onShowMessage: onShowMessage,
                      onReturnAction: onReturnAction,
                      onAttachmentTap: onAttachmentTap,
                    ),
                  ),
                  attachmentShape: border,
                  reverse: reverse,
                ),
              );
            }

            return WrapAttachmentWidget(
              attachmentWidget: ContextMenuRegion(
                onItemSelected: (item) {
                  item.onSelected?.call();
                },
                menuItems: [
                  DownloadMenuItem(
                    title: context.translations.downloadLabel,
                    attachment: attachments[0],
                  ),
                ],
                child: ImageAttachment(
                  attachment: attachments[0],
                  message: message,
                  messageTheme: messageTheme,
                  size: Size(
                    mediaQueryData.size.width * 0.8,
                    mediaQueryData.size.height * 0.3,
                  ),
                  onShowMessage: onShowMessage,
                  onReturnAction: onReturnAction,
                  onAttachmentTap: onAttachmentTap != null
                      ? () {
                          onAttachmentTap.call(message, attachments[0]);
                        }
                      : null,
                ),
              ),
              attachmentShape: border,
              reverse: reverse,
            );
          },
          'video': (context, message, attachments) {
            final border = RoundedRectangleBorder(
              borderRadius: attachmentBorderRadiusGeometry ?? BorderRadius.zero,
            );

            return WrapAttachmentWidget(
              attachmentWidget: ContextMenuRegion(
                onItemSelected: (item) {
                  item.onSelected?.call();
                },
                menuItems: [
                  DownloadMenuItem(
                    title: context.translations.downloadLabel,
                    attachment: attachments[0],
                  ),
                ],
                child: Column(
                  children: attachments.map((attachment) {
                    final mediaQueryData = MediaQuery.of(context);
                    return VideoAttachment(
                      attachment: attachment,
                      messageTheme: messageTheme,
                      size: Size(
                        mediaQueryData.size.width * 0.8,
                        mediaQueryData.size.height * 0.3,
                      ),
                      message: message,
                      onShowMessage: onShowMessage,
                      onReturnAction: onReturnAction,
                      onAttachmentTap: onAttachmentTap != null
                          ? () {
                              onAttachmentTap(message, attachment);
                            }
                          : null,
                    );
                  }).toList(),
                ),
              ),
              attachmentShape: border,
              reverse: reverse,
            );
          },
          'giphy': (context, message, attachments) {
            final border = RoundedRectangleBorder(
              borderRadius: attachmentBorderRadiusGeometry ?? BorderRadius.zero,
            );

            return WrapAttachmentWidget(
              attachmentWidget: ContextMenuRegion(
                onItemSelected: (item) {
                  item.onSelected?.call();
                },
                menuItems: [
                  DownloadMenuItem(
                    title: context.translations.downloadLabel,
                    attachment: attachments[0],
                  ),
                ],
                child: Column(
                  children: attachments.map((attachment) {
                    final mediaQueryData = MediaQuery.of(context);
                    return GiphyAttachment(
                      attachment: attachment,
                      message: message,
                      size: Size(
                        mediaQueryData.size.width * 0.8,
                        mediaQueryData.size.height * 0.3,
                      ),
                      onShowMessage: onShowMessage,
                      onReturnAction: onReturnAction,
                      onAttachmentTap: onAttachmentTap != null
                          ? () {
                              onAttachmentTap(message, attachment);
                            }
                          : null,
                    );
                  }).toList(),
                ),
              ),
              attachmentShape: border,
              reverse: reverse,
            );
          },
          'file': (context, message, attachments) {
            final border = RoundedRectangleBorder(
              side: attachmentBorderSide ??
                  BorderSide(
                    color: StreamChatTheme.of(context).colorTheme.borders,
                  ),
              borderRadius: attachmentBorderRadiusGeometry ?? BorderRadius.zero,
            );

            return Column(
              children: attachments
                  .map<Widget>((attachment) {
                    final mediaQueryData = MediaQuery.of(context);
                    return WrapAttachmentWidget(
                      attachmentWidget: FileAttachment(
                        message: message,
                        attachment: attachment,
                        size: Size(
                          mediaQueryData.size.width * 0.8,
                          mediaQueryData.size.height * 0.3,
                        ),
                        onAttachmentTap: onAttachmentTap != null
                            ? () {
                                onAttachmentTap(message, attachment);
                              }
                            : null,
                      ),
                      attachmentShape: border,
                      reverse: reverse,
                    );
                  })
                  .insertBetween(SizedBox(
                    height: attachmentPadding.vertical / 2,
                  ))
                  .toList(),
            );
          },
        }..addAll(customAttachmentBuilders ?? {}),
        super(key: key);

  /// Function called on mention tap
  final void Function(User)? onMentionTap;

  /// The function called when tapping on threads
  final void Function(Message)? onThreadTap;

  /// The function called when tapping on replies
  final void Function(Message)? onReplyTap;

  /// Widget builder for edit message layout
  final Widget Function(BuildContext, Message)? editMessageInputBuilder;

  /// Widget builder for building text
  final Widget Function(BuildContext, Message)? textBuilder;

  /// Widget builder for building username
  final Widget Function(BuildContext, Message)? usernameBuilder;

  /// Function called on long press
  final void Function(BuildContext, Message)? onMessageActions;

  /// Widget builder for building a bottom row below the message
  final Widget Function(BuildContext, Message)? bottomRowBuilder;

  /// Widget builder for building a bottom row below a deleted message
  final Widget Function(BuildContext, Message)? deletedBottomRowBuilder;

  /// Widget builder for building user avatar
  final Widget Function(BuildContext, User)? userAvatarBuilder;

  /// The message
  final Message message;

  /// The message theme
  final MessageThemeData messageTheme;

  /// If true the widget will be mirrored
  final bool reverse;

  /// The shape of the message text
  final ShapeBorder? shape;

  /// The shape of an attachment
  final ShapeBorder? attachmentShape;

  /// The borderside of the message text
  final BorderSide? borderSide;

  /// The borderside of an attachment
  final BorderSide? attachmentBorderSide;

  /// The border radius of the message text
  final BorderRadiusGeometry? borderRadiusGeometry;

  /// The border radius of an attachment
  final BorderRadiusGeometry? attachmentBorderRadiusGeometry;

  /// The padding of the widget
  final EdgeInsetsGeometry? padding;

  /// The internal padding of the message text
  final EdgeInsets textPadding;

  /// The internal padding of an attachment
  final EdgeInsetsGeometry attachmentPadding;

  /// It controls the display behaviour of the user avatar
  final DisplayWidget showUserAvatar;

  /// It controls the display behaviour of the sending indicator
  final bool showSendingIndicator;

  /// If true the widget will show the reactions
  final bool showReactions;

  ///
  final bool allRead;

  /// If true the widget will show the thread reply indicator
  final bool showThreadReplyIndicator;

  /// If true the widget will show the show in channel indicator
  final bool showInChannelIndicator;

  /// The function called when tapping on UserAvatar
  final void Function(User)? onUserAvatarTap;

  /// The function called when tapping on a link
  final void Function(String)? onLinkTap;

  /// Used in [MessageReactionsModal] and [MessageActionsModal]
  final bool showReactionPickerIndicator;

  /// List of users who read
  final List<Read>? readList;

  /// Callback when show message is tapped
  final ShowMessageCallback? onShowMessage;

  /// Handle return actions like reply message
  final ValueChanged<ReturnActionType>? onReturnAction;

  /// If true show the users username next to the timestamp of the message
  final bool showUsername;

  /// Show message timestamp
  final bool showTimestamp;

  /// Show reply action
  final bool showReplyMessage;

  /// Show thread reply action
  final bool showThreadReplyMessage;

  /// Show edit action
  final bool showEditMessage;

  /// Show copy action
  final bool showCopyMessage;

  /// Show delete action
  final bool showDeleteMessage;

  /// Show resend action
  final bool showResendMessage;

  /// Show flag action
  final bool showFlagButton;

  /// Show flag action
  final bool showPinButton;

  /// Display Pin Highlight
  final bool showPinHighlight;

  /// Builder for respective attachment types
  final Map<String, AttachmentBuilder> attachmentBuilders;

  /// Builder for respective attachment types (user facing builder)
  final Map<String, AttachmentBuilder>? customAttachmentBuilders;

  /// Center user avatar with bottom of the message
  final bool translateUserAvatar;

  /// Function called when quotedMessage is tapped
  final OnQuotedMessageTap? onQuotedMessageTap;

  /// Function called when message is tapped
  final void Function(Message)? onMessageTap;

  /// List of custom actions shown on message long tap
  final List<MessageAction> customActions;

  /// Customize onTap on attachment
  final void Function(Message message, Attachment attachment)? onAttachmentTap;

  /// Creates a copy of [MessageWidget] with specified attributes overridden.
  MessageWidget copyWith({
    Key? key,
    void Function(User)? onMentionTap,
    void Function(Message)? onThreadTap,
    void Function(Message)? onReplyTap,
    Widget Function(BuildContext, Message)? editMessageInputBuilder,
    Widget Function(BuildContext, Message)? textBuilder,
    Widget Function(BuildContext, Message)? usernameBuilder,
    Widget Function(BuildContext, Message)? bottomRowBuilder,
    Widget Function(BuildContext, Message)? deletedBottomRowBuilder,
    void Function(BuildContext, Message)? onMessageActions,
    Message? message,
    MessageThemeData? messageTheme,
    bool? reverse,
    ShapeBorder? shape,
    ShapeBorder? attachmentShape,
    BorderSide? borderSide,
    BorderSide? attachmentBorderSide,
    BorderRadiusGeometry? borderRadiusGeometry,
    BorderRadiusGeometry? attachmentBorderRadiusGeometry,
    EdgeInsetsGeometry? padding,
    EdgeInsets? textPadding,
    EdgeInsetsGeometry? attachmentPadding,
    DisplayWidget? showUserAvatar,
    bool? showSendingIndicator,
    bool? showReactions,
    bool? allRead,
    bool? showThreadReplyIndicator,
    bool? showInChannelIndicator,
    void Function(User)? onUserAvatarTap,
    void Function(String)? onLinkTap,
    bool? showReactionPickerIndicator,
    List<Read>? readList,
    ShowMessageCallback? onShowMessage,
    ValueChanged<ReturnActionType>? onReturnAction,
    bool? showUsername,
    bool? showTimestamp,
    bool? showReplyMessage,
    bool? showThreadReplyMessage,
    bool? showEditMessage,
    bool? showCopyMessage,
    bool? showDeleteMessage,
    bool? showResendMessage,
    bool? showFlagButton,
    bool? showPinButton,
    bool? showPinHighlight,
    Map<String, AttachmentBuilder>? customAttachmentBuilders,
    bool? translateUserAvatar,
    OnQuotedMessageTap? onQuotedMessageTap,
    void Function(Message)? onMessageTap,
    List<MessageAction>? customActions,
    void Function(Message message, Attachment attachment)? onAttachmentTap,
    Widget Function(BuildContext, User)? userAvatarBuilder,
  }) =>
      MessageWidget(
        key: key ?? this.key,
        onMentionTap: onMentionTap ?? this.onMentionTap,
        onThreadTap: onThreadTap ?? this.onThreadTap,
        onReplyTap: onReplyTap ?? this.onReplyTap,
        editMessageInputBuilder:
            editMessageInputBuilder ?? this.editMessageInputBuilder,
        textBuilder: textBuilder ?? this.textBuilder,
        usernameBuilder: usernameBuilder ?? this.usernameBuilder,
        bottomRowBuilder: bottomRowBuilder ?? this.bottomRowBuilder,
        deletedBottomRowBuilder:
            deletedBottomRowBuilder ?? this.deletedBottomRowBuilder,
        onMessageActions: onMessageActions ?? this.onMessageActions,
        message: message ?? this.message,
        messageTheme: messageTheme ?? this.messageTheme,
        reverse: reverse ?? this.reverse,
        shape: shape ?? this.shape,
        attachmentShape: attachmentShape ?? this.attachmentShape,
        borderSide: borderSide ?? this.borderSide,
        attachmentBorderSide: attachmentBorderSide ?? this.attachmentBorderSide,
        borderRadiusGeometry: borderRadiusGeometry ?? this.borderRadiusGeometry,
        attachmentBorderRadiusGeometry: attachmentBorderRadiusGeometry ??
            this.attachmentBorderRadiusGeometry,
        padding: padding ?? this.padding,
        textPadding: textPadding ?? this.textPadding,
        attachmentPadding: attachmentPadding ?? this.attachmentPadding,
        showUserAvatar: showUserAvatar ?? this.showUserAvatar,
        showSendingIndicator: showSendingIndicator ?? this.showSendingIndicator,
        showReactions: showReactions ?? this.showReactions,
        showThreadReplyIndicator:
            showThreadReplyIndicator ?? this.showThreadReplyIndicator,
        showInChannelIndicator:
            showInChannelIndicator ?? this.showInChannelIndicator,
        onUserAvatarTap: onUserAvatarTap ?? this.onUserAvatarTap,
        onLinkTap: onLinkTap ?? this.onLinkTap,
        showReactionPickerIndicator:
            showReactionPickerIndicator ?? this.showReactionPickerIndicator,
        onShowMessage: onShowMessage ?? this.onShowMessage,
        onReturnAction: onReturnAction ?? this.onReturnAction,
        showUsername: showUsername ?? this.showUsername,
        showTimestamp: showTimestamp ?? this.showTimestamp,
        showReplyMessage: showReplyMessage ?? this.showReplyMessage,
        showThreadReplyMessage:
            showThreadReplyMessage ?? this.showThreadReplyMessage,
        showEditMessage: showEditMessage ?? this.showEditMessage,
        showCopyMessage: showCopyMessage ?? this.showCopyMessage,
        showDeleteMessage: showDeleteMessage ?? this.showDeleteMessage,
        showResendMessage: showResendMessage ?? this.showResendMessage,
        showFlagButton: showFlagButton ?? this.showFlagButton,
        showPinButton: showPinButton ?? this.showPinButton,
        showPinHighlight: showPinHighlight ?? this.showPinHighlight,
        customAttachmentBuilders:
            customAttachmentBuilders ?? this.customAttachmentBuilders,
        translateUserAvatar: translateUserAvatar ?? this.translateUserAvatar,
        onQuotedMessageTap: onQuotedMessageTap ?? this.onQuotedMessageTap,
        onMessageTap: onMessageTap ?? this.onMessageTap,
        customActions: customActions ?? this.customActions,
        onAttachmentTap: onAttachmentTap ?? this.onAttachmentTap,
        userAvatarBuilder: userAvatarBuilder ?? this.userAvatarBuilder,
      );

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget>
    with AutomaticKeepAliveClientMixin<MessageWidget> {
  bool get showThreadReplyIndicator => widget.showThreadReplyIndicator;

  bool get showSendingIndicator => widget.showSendingIndicator;

  bool get isDeleted => widget.message.isDeleted;

  bool get showUsername => widget.showUsername;

  bool get showTimeStamp => widget.showTimestamp;

  bool get showInChannel => widget.showInChannelIndicator;

  bool get hasQuotedMessage => widget.message.quotedMessage != null;

  bool get isSendFailed => widget.message.status == MessageSendingStatus.failed;

  bool get isUpdateFailed =>
      widget.message.status == MessageSendingStatus.failed_update;

  bool get isDeleteFailed =>
      widget.message.status == MessageSendingStatus.failed_delete;

  bool get isFailedState => isSendFailed || isUpdateFailed || isDeleteFailed;

  bool get isGiphy =>
      widget.message.attachments.any((element) => element.type == 'giphy');

  bool get isOnlyEmoji => widget.message.text?.isOnlyEmoji == true;

  bool get hasNonUrlAttachments => widget.message.attachments
      .where((it) => it.titleLink == null || it.type == 'giphy')
      .isNotEmpty;

  bool get hasUrlAttachments => widget.message.attachments
      .any((it) => it.titleLink != null && it.type != 'giphy');

  bool get showBottomRow =>
      showThreadReplyIndicator ||
      showUsername ||
      showTimeStamp ||
      showInChannel ||
      showSendingIndicator ||
      isDeleted;

  bool get isPinned => widget.message.pinned;

  bool get _shouldShowReactions =>
      widget.showReactions &&
      (widget.message.reactionCounts?.isNotEmpty == true) &&
      !widget.message.isDeleted;

  @override
  bool get wantKeepAlive => widget.message.attachments.isNotEmpty;

  late StreamChatThemeData _streamChatTheme;
  late StreamChatState _streamChat;

  @override
  void didChangeDependencies() {
    _streamChatTheme = StreamChatTheme.of(context);
    _streamChat = StreamChat.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final avatarWidth =
        widget.messageTheme.avatarTheme?.constraints.maxWidth ?? 40;
    final bottomRowPadding =
        widget.showUserAvatar != DisplayWidget.gone ? avatarWidth + 8.5 : 0.5;

    final showReactions = _shouldShowReactions;

    return ContextMenuRegion(
      onItemSelected: (item) => item.onSelected!.call(),
      menuItems: [
        // Ensure menu items don't show if message is deleted.
        if (!widget.message.isDeleted) ...[
          if (widget.onReplyTap != null)
            ReplyContextMenuItem(
              title: context.translations.replyLabel,
              onClick: () {
                widget.onReplyTap!(widget.message);
              },
            ),
          if (widget.onThreadTap != null)
            ThreadReplyMenuItem(
              title: context.translations.threadReplyLabel,
              // NEEDS REVIEW ⚠️
              onClick: () => widget.onThreadTap!(widget.message),
            ),
          PinMessageMenuItem(
            context: context,
            message: widget.message,
            pinned: widget.message.pinned,
            title: context.translations.togglePinUnpinText(
              pinned: widget.message.pinned,
            ),
          ),

          // Ensure "Copy Message" menu doesn't show if:
          // * There is no text to copy (like in the case of a message
          //   containing only an attachment)
          if (widget.message.attachments.isEmpty &&
              widget.message.text!.isNotEmpty)
            CopyMessageMenuItem(
              title: context.translations.copyMessageLabel,
              message: widget.message,
            ),
          // Ensure "Copy Message menu does show if:
          // * There are attachments
          // * There is text to copy
          if (widget.message.attachments.isNotEmpty &&
              widget.message.text!.isNotEmpty)
            CopyMessageMenuItem(
              title: context.translations.copyMessageLabel,
              message: widget.message,
            ),
          EditMessageMenuItem(
            title: context.translations.editMessageLabel,
            onClick: () {
              showModalBottomSheet(
                context: context,
                elevation: 2,
                clipBehavior: Clip.hardEdge,
                isScrollControlled: true,
                backgroundColor:
                    MessageInputTheme.of(context).inputBackgroundColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                builder: (_) => EditMessageSheet(
                  message: widget.message,
                  channel: StreamChannel.of(context).channel,
                ),
              );
            },
          ),
          if (widget.showResendMessage && (isSendFailed || isUpdateFailed))
            ResendMessageMenuItem(
              title: context.translations.toggleResendOrResendEditedMessage(
                isUpdateFailed:
                    widget.message.status == MessageSendingStatus.failed_update,
              ),
              onClick: () {
                final isUpdateFailed =
                    widget.message.status == MessageSendingStatus.failed_update;
                final channel = StreamChannel.of(context).channel;
                if (isUpdateFailed) {
                  channel.updateMessage(widget.message);
                } else {
                  channel.sendMessage(widget.message);
                }
              },
            ),
          DeleteMessageMenuItem(
            title: context.translations.deleteMessageLabel,
            onClick: () async {
              final deleted = await showDialog(
                context: context,
                builder: (_) => const DeleteMessageDialog(),
              );
              if (deleted) {
                try {
                  await StreamChannel.of(context)
                      .channel
                      .deleteMessage(widget.message);
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (_) => const MessageDialog(),
                  );
                }
              }
            },
          ),
        ],
      ],
      child: Material(
        type: widget.message.pinned && widget.showPinHighlight
            ? MaterialType.card
            : MaterialType.transparency,
        color: widget.message.pinned && widget.showPinHighlight
            ? _streamChatTheme.colorTheme.highlight
            : null,
        child: Portal(
          child: PlatformWidgetBuilder(
            mobile: (context, child) {
              return InkWell(
                onTap: () => widget.onMessageTap!(widget.message),
                onLongPress: widget.message.isDeleted && !isFailedState
                    ? null
                    : () => onLongPress(context),
                child: child,
              );
            },
            desktop: (_, child) => MouseRegion(child: child),
            web: (_, child) => MouseRegion(child: child),
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(8),
              child: FractionallySizedBox(
                alignment: widget.reverse
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                widthFactor: 0.78,
                child: MessageWidgetContent(
                  streamChatTheme: _streamChatTheme,
                  showUsername: showUsername,
                  showTimeStamp: showTimeStamp,
                  showThreadReplyIndicator: showThreadReplyIndicator,
                  showSendingIndicator: showSendingIndicator,
                  showInChannel: showInChannel,
                  isGiphy: isGiphy,
                  isOnlyEmoji: isOnlyEmoji,
                  hasUrlAttachments: hasUrlAttachments,
                  messageTheme: widget.messageTheme,
                  reverse: widget.reverse,
                  message: widget.message,
                  hasNonUrlAttachments: hasNonUrlAttachments,
                  shouldShowReactions: _shouldShowReactions,
                  hasQuotedMessage: hasQuotedMessage,
                  textPadding: widget.textPadding,
                  attachmentBuilders: widget.attachmentBuilders,
                  attachmentPadding: widget.attachmentPadding,
                  avatarWidth: avatarWidth,
                  bottomRowPadding: bottomRowPadding,
                  isFailedState: isFailedState,
                  isPinned: isPinned,
                  messageWidget: widget,
                  showBottomRow: showBottomRow,
                  showPinHighlight: widget.showPinHighlight,
                  showReactionPickerIndicator:
                      widget.showReactionPickerIndicator,
                  showReactions: showReactions,
                  showUserAvatar: widget.showUserAvatar,
                  streamChat: _streamChat,
                  translateUserAvatar: widget.translateUserAvatar,
                  deletedBottomRowBuilder: widget.deletedBottomRowBuilder,
                  onThreadTap: widget.onThreadTap,
                  shape: widget.shape,
                  borderSide: widget.borderSide,
                  borderRadiusGeometry: widget.borderRadiusGeometry,
                  textBuilder: widget.textBuilder,
                  onLinkTap: widget.onLinkTap,
                  onMentionTap: widget.onMentionTap,
                  onQuotedMessageTap: widget.onQuotedMessageTap,
                  bottomRowBuilder: widget.bottomRowBuilder,
                  onUserAvatarTap: widget.onUserAvatarTap,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onLongPress(BuildContext context) {
    if (widget.message.isEphemeral ||
        widget.message.status == MessageSendingStatus.sending) {
      return;
    }

    if (widget.onMessageActions != null) {
      widget.onMessageActions!(context, widget.message);
    } else {
      _showMessageActionModalBottomSheet(context);
    }
    return;
  }

  void _showMessageActionModalBottomSheet(BuildContext context) {
    final channel = StreamChannel.of(context).channel;

    showDialog(
      useRootNavigator: false,
      context: context,
      barrierColor: _streamChatTheme.colorTheme.overlay,
      builder: (context) => StreamChannel(
        channel: channel,
        child: MessageActionsModal(
          messageWidget: widget.copyWith(
            key: const Key('MessageWidget'),
            message: widget.message.copyWith(
              text: (widget.message.text?.length ?? 0) > 200
                  ? '${widget.message.text!.substring(0, 200)}...'
                  : widget.message.text,
            ),
            showReactions: false,
            showUsername: false,
            showTimestamp: false,
            translateUserAvatar: false,
            showSendingIndicator: false,
            padding: const EdgeInsets.all(0),
            showReactionPickerIndicator: widget.showReactions &&
                (widget.message.status == MessageSendingStatus.sent),
            showPinHighlight: false,
            showUserAvatar:
                widget.message.user!.id == channel.client.state.currentUser!.id
                    ? DisplayWidget.gone
                    : DisplayWidget.show,
          ),
          onCopyTap: (message) =>
              Clipboard.setData(ClipboardData(text: message.text)),
          messageTheme: widget.messageTheme,
          reverse: widget.reverse,
          showDeleteMessage: widget.showDeleteMessage || isDeleteFailed,
          message: widget.message,
          editMessageInputBuilder: widget.editMessageInputBuilder,
          onReplyTap: widget.onReplyTap,
          onThreadReplyTap: widget.onThreadTap,
          showResendMessage:
              widget.showResendMessage && (isSendFailed || isUpdateFailed),
          showCopyMessage: widget.showCopyMessage &&
              !isFailedState &&
              widget.message.text?.trim().isNotEmpty == true,
          showEditMessage: widget.showEditMessage &&
              !isDeleteFailed &&
              !widget.message.attachments
                  .any((element) => element.type == 'giphy'),
          showReactions: widget.showReactions,
          showReplyMessage: widget.showReplyMessage &&
              !isFailedState &&
              widget.onReplyTap != null,
          showThreadReplyMessage: widget.showThreadReplyMessage &&
              !isFailedState &&
              widget.onThreadTap != null,
          showFlagButton: widget.showFlagButton,
          showPinButton: widget.showPinButton,
          customActions: widget.customActions,
        ),
      ),
    );
  }

  void retryMessage(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    if (widget.message.status == MessageSendingStatus.failed) {
      channel.sendMessage(widget.message);
      return;
    }
    if (widget.message.status == MessageSendingStatus.failed_update) {
      channel.updateMessage(widget.message);
      return;
    }

    if (widget.message.status == MessageSendingStatus.failed_delete) {
      channel.deleteMessage(widget.message);
      return;
    }
  }
}
