import 'dart:async';

import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/conditional_parent_builder/conditional_parent_builder.dart';
import 'package:stream_chat_flutter/platform_widget_builder/platform_widget_builder.dart';
import 'package:stream_chat_flutter/src/message_action/message_action_item.dart';
import 'package:stream_chat_flutter/src/message_action/message_actions_builder.dart';
import 'package:stream_chat_flutter/src/message_modal/message_actions_modal.dart';
import 'package:stream_chat_flutter/src/message_modal/message_modal.dart';
import 'package:stream_chat_flutter/src/message_modal/message_reactions_modal.dart';

import 'package:stream_chat_flutter/src/message_widget/message_widget_content.dart';
import 'package:stream_chat_flutter/src/message_widget/reactions/my_reaction_picker.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// The display behaviour of a widget
enum DisplayWidget {
  /// Hides the widget replacing its space with a spacer
  hide,

  /// Hides the widget not replacing its space
  gone,

  /// Shows the widget normally
  show,
}

/// {@template messageWidget}
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_widget.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_widget_paint.png)
///
/// Shows a message with reactions, replies and user avatar.
///
/// Usually you don't use this widget as it's the default message widget used by
/// [MessageListView].
///
/// The widget components render the ui based on the first ancestor of type
/// [StreamChatTheme].
/// Modify it to change the widget appearance.
/// {@endtemplate}
class StreamMessageWidget extends StatefulWidget {
  /// {@macro messageWidget}
  const StreamMessageWidget({
    super.key,
    required this.message,
    required this.messageTheme,
    this.reverse = false,
    this.translateUserAvatar = true,
    this.shape,
    this.borderSide,
    this.borderRadiusGeometry,
    this.attachmentShape,
    this.onMentionTap,
    this.onMessageTap,
    this.onMessageLongPress,
    this.onReactionsTap,
    this.onReactionsHover,
    this.showReactionPicker = true,
    this.showReactionTail,
    this.showUserAvatar = DisplayWidget.show,
    this.showSendingIndicator = true,
    this.showThreadReplyIndicator = false,
    this.showInChannelIndicator = false,
    this.onReplyTap,
    this.onThreadTap,
    this.onConfirmDeleteTap,
    this.showUsername = true,
    this.showTimestamp = true,
    this.showEditedLabel = true,
    this.showReactions = true,
    this.showDeleteMessage = true,
    this.showEditMessage = true,
    this.showReplyMessage = true,
    this.showThreadReplyMessage = true,
    this.showMarkUnreadMessage = true,
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
    this.quotedMessageBuilder,
    this.editMessageInputBuilder,
    this.textBuilder,
    this.bottomRowBuilderWithDefaultWidget,
    this.attachmentBuilders,
    this.padding,
    this.textPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    this.attachmentPadding = EdgeInsets.zero,
    this.widthFactor = 0.78,
    this.onQuotedMessageTap,
    this.customActions = const [],
    this.onAttachmentTap,
    this.imageAttachmentThumbnailSize = const Size(400, 400),
    this.imageAttachmentThumbnailResizeType = 'clip',
    this.imageAttachmentThumbnailCropType = 'center',
    this.attachmentActionsModalBuilder,
  });

  /// {@template onMentionTap}
  /// Function called on mention tap
  /// {@endtemplate}
  final void Function(User)? onMentionTap;

  /// {@template onThreadTap}
  /// The function called when tapping on threads
  /// {@endtemplate}
  final void Function(Message)? onThreadTap;

  /// {@template onReplyTap}
  /// The function called when tapping on replies
  /// {@endtemplate}
  final void Function(Message)? onReplyTap;

  /// {@template onDeleteTap}
  /// The function called when delete confirmation button is tapped.
  /// {@endtemplate}
  final Future<void> Function(Message)? onConfirmDeleteTap;

  /// {@template editMessageInputBuilder}
  /// Widget builder for edit message layout
  /// {@endtemplate}
  final Widget Function(BuildContext, Message)? editMessageInputBuilder;

  /// {@template textBuilder}
  /// Widget builder for building text
  /// {@endtemplate}
  final Widget Function(BuildContext, Message)? textBuilder;

  /// {@template onMessageActions}
  /// Function called on long press
  /// {@endtemplate}
  final void Function(BuildContext, Message)? onMessageActions;

  /// {@template bottomRowBuilderWithDefaultWidget}
  /// Widget builder for building a bottom row below the message.
  /// Also contains the default bottom row widget.
  /// {@endtemplate}
  final BottomRowBuilderWithDefaultWidget? bottomRowBuilderWithDefaultWidget;

  /// {@template userAvatarBuilder}
  /// Widget builder for building user avatar
  /// {@endtemplate}
  final Widget Function(BuildContext, User)? userAvatarBuilder;

  /// {@template quotedMessageBuilder}
  /// Widget builder for building quoted message
  /// {@endtemplate}
  final Widget Function(BuildContext, Message)? quotedMessageBuilder;

  /// {@template message}
  /// The message to display.
  /// {@endtemplate}
  final Message message;

  /// {@template messageTheme}
  /// The message theme
  /// {@endtemplate}
  final StreamMessageThemeData messageTheme;

  /// {@template reverse}
  /// If true the widget will be mirrored
  /// {@endtemplate}
  final bool reverse;

  /// {@template shape}
  /// The shape of the message text
  /// {@endtemplate}
  final ShapeBorder? shape;

  /// {@template attachmentShape}
  /// The shape of an attachment
  /// {@endtemplate}
  final ShapeBorder? attachmentShape;

  /// {@template borderSide}
  /// The borderSide of the message text
  /// {@endtemplate}
  final BorderSide? borderSide;

  /// {@template borderRadiusGeometry}
  /// The border radius of the message text
  /// {@endtemplate}
  final BorderRadiusGeometry? borderRadiusGeometry;

  /// {@template padding}
  /// The padding of the widget
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// {@template textPadding}
  /// The internal padding of the message text
  /// {@endtemplate}
  final EdgeInsets textPadding;

  /// {@template attachmentPadding}
  /// The internal padding of an attachment
  /// {@endtemplate}
  final EdgeInsetsGeometry attachmentPadding;

  /// {@template widthFactor}
  /// The percentage of the available width the message content should take
  /// {@endtemplate}
  final double widthFactor;

  /// {@template showUserAvatar}
  /// It controls the display behaviour of the user avatar
  /// {@endtemplate}
  final DisplayWidget showUserAvatar;

  /// {@template showSendingIndicator}
  /// It controls the display behaviour of the sending indicator
  /// {@endtemplate}
  final bool showSendingIndicator;

  /// {@template showReactions}
  /// If `true` the message's reactions will be shown.
  /// {@endtemplate}
  final bool showReactions;

  /// {@template showThreadReplyIndicator}
  /// If true the widget will show the thread reply indicator
  /// {@endtemplate}
  final bool showThreadReplyIndicator;

  /// {@template showInChannelIndicator}
  /// If true the widget will show the show in channel indicator
  /// {@endtemplate}
  final bool showInChannelIndicator;

  /// {@template onUserAvatarTap}
  /// The function called when tapping on UserAvatar
  /// {@endtemplate}
  final void Function(User)? onUserAvatarTap;

  /// {@template onLinkTap}
  /// The function called when tapping on a link
  /// {@endtemplate}
  final void Function(String)? onLinkTap;

  /// {@template showReactionPicker}
  /// Whether or not to show the reaction picker.
  /// Used in [StreamMessageReactionsModal] and [StreamMessageActionsModal].
  /// {@endtemplate}
  final bool showReactionPicker;

  /// {@template showReactionPickerTail}
  /// Whether or not to show the reaction picker tail.
  /// This is calculated internally in most cases and does not need to be set.
  /// {@endtemplate}
  final bool? showReactionTail;

  /// {@template onShowMessage}
  /// Callback when show message is tapped
  /// {@endtemplate}
  final ShowMessageCallback? onShowMessage;

  /// {@template showUsername}
  /// If true show the users username next to the timestamp of the message
  /// {@endtemplate}
  final bool showUsername;

  /// {@template showTimestamp}
  /// Show message timestamp
  /// {@endtemplate}
  final bool showTimestamp;

  /// {@template showTimestamp}
  /// Show edited label if message is edited
  /// {@endtemplate}
  final bool showEditedLabel;

  /// {@template showReplyMessage}
  /// Show reply action
  /// {@endtemplate}
  final bool showReplyMessage;

  /// {@template showThreadReplyMessage}
  /// Show thread reply action
  /// {@endtemplate}
  final bool showThreadReplyMessage;

  /// {@template showMarkUnreadMessage}
  /// Show mark unread action
  /// {@endtemplate}
  final bool showMarkUnreadMessage;

  /// {@template showEditMessage}
  /// Show edit action
  /// {@endtemplate}
  final bool showEditMessage;

  /// {@template showCopyMessage}
  /// Show copy action
  /// {@endtemplate}
  final bool showCopyMessage;

  /// {@template showDeleteMessage}
  /// Show delete action
  /// {@endtemplate}
  final bool showDeleteMessage;

  /// {@template showResendMessage}
  /// Show resend action
  /// {@endtemplate}
  final bool showResendMessage;

  /// {@template showFlagButton}
  /// Show flag action
  /// {@endtemplate}
  final bool showFlagButton;

  /// {@template showPinButton}
  /// Show pin action
  /// {@endtemplate}
  final bool showPinButton;

  /// {@template showPinHighlight}
  /// Display Pin Highlight
  /// {@endtemplate}
  final bool showPinHighlight;

  /// {@template attachmentBuilders}
  /// List of attachment builders for rendering attachment widgets pre-defined
  /// and custom attachment types.
  ///
  /// If null, the widget will create a default list of attachment builders
  /// based on the [Attachment.type] of the attachment.
  /// {@endtemplate}
  final List<StreamAttachmentWidgetBuilder>? attachmentBuilders;

  /// {@template translateUserAvatar}
  /// Center user avatar with bottom of the message
  /// {@endtemplate}
  final bool translateUserAvatar;

  /// {@macro onQuotedMessageTap}
  final OnQuotedMessageTap? onQuotedMessageTap;

  /// {@macro onMessageTap}
  final OnMessageTap? onMessageTap;

  /// {@macro onMessageLongPress}
  final OnMessageLongPress? onMessageLongPress;

  /// {@macro onReactionsTap}
  ///
  /// Note: Only used in mobile devices (iOS and Android). Do not confuse this
  /// with the tap action on the reactions picker.
  final OnReactionsTap? onReactionsTap;

  /// {@macro onReactionsHover}
  ///
  /// Note: Only used in desktop devices (web and desktop).
  final OnReactionsHover? onReactionsHover;

  /// {@template customActions}
  /// List of custom actions shown on message long tap
  /// {@endtemplate}
  final List<StreamMessageAction> customActions;

  /// {@macro onMessageWidgetAttachmentTap}
  final StreamAttachmentWidgetTapCallback? onAttachmentTap;

  /// {@macro attachmentActionsBuilder}
  final AttachmentActionsBuilder? attachmentActionsModalBuilder;

  /// Size of the image attachment thumbnail.
  final Size imageAttachmentThumbnailSize;

  /// Resize type of the image attachment thumbnail.
  ///
  /// Defaults to [crop]
  final String /*clip|crop|scale|fill*/ imageAttachmentThumbnailResizeType;

  /// Crop type of the image attachment thumbnail.
  ///
  /// Defaults to [center]
  final String /*center|top|bottom|left|right*/
      imageAttachmentThumbnailCropType;

  /// {@template copyWith}
  /// Creates a copy of [StreamMessageWidget] with specified attributes
  /// overridden.
  /// {@endtemplate}
  StreamMessageWidget copyWith({
    Key? key,
    void Function(User)? onMentionTap,
    void Function(Message)? onThreadTap,
    void Function(Message)? onReplyTap,
    Future<void> Function(Message)? onConfirmDeleteTap,
    Widget Function(BuildContext, Message)? editMessageInputBuilder,
    Widget Function(BuildContext, Message)? textBuilder,
    Widget Function(BuildContext, Message)? quotedMessageBuilder,
    BottomRowBuilderWithDefaultWidget? bottomRowBuilderWithDefaultWidget,
    void Function(BuildContext, Message)? onMessageActions,
    Message? message,
    StreamMessageThemeData? messageTheme,
    bool? reverse,
    ShapeBorder? shape,
    ShapeBorder? attachmentShape,
    BorderSide? borderSide,
    BorderRadiusGeometry? borderRadiusGeometry,
    EdgeInsetsGeometry? padding,
    EdgeInsets? textPadding,
    EdgeInsetsGeometry? attachmentPadding,
    double? widthFactor,
    DisplayWidget? showUserAvatar,
    bool? showSendingIndicator,
    bool? showReactions,
    bool? allRead,
    bool? showThreadReplyIndicator,
    bool? showInChannelIndicator,
    void Function(User)? onUserAvatarTap,
    void Function(String)? onLinkTap,
    bool? showReactionBrowser,
    bool? showReactionPicker,
    bool? showReactionTail,
    List<Read>? readList,
    ShowMessageCallback? onShowMessage,
    bool? showUsername,
    bool? showTimestamp,
    bool? showEditedLabel,
    bool? showReplyMessage,
    bool? showThreadReplyMessage,
    bool? showEditMessage,
    bool? showCopyMessage,
    bool? showDeleteMessage,
    bool? showResendMessage,
    bool? showFlagButton,
    bool? showPinButton,
    bool? showPinHighlight,
    bool? showMarkUnreadMessage,
    List<StreamAttachmentWidgetBuilder>? attachmentBuilders,
    bool? translateUserAvatar,
    OnQuotedMessageTap? onQuotedMessageTap,
    OnMessageTap? onMessageTap,
    OnMessageLongPress? onMessageLongPress,
    OnReactionsTap? onReactionsTap,
    OnReactionsHover? onReactionsHover,
    List<StreamMessageAction>? customActions,
    void Function(Message message, Attachment attachment)? onAttachmentTap,
    Widget Function(BuildContext, User)? userAvatarBuilder,
    Size? imageAttachmentThumbnailSize,
    String? imageAttachmentThumbnailResizeType,
    String? imageAttachmentThumbnailCropType,
    AttachmentActionsBuilder? attachmentActionsModalBuilder,
  }) {
    return StreamMessageWidget(
      key: key ?? this.key,
      onMentionTap: onMentionTap ?? this.onMentionTap,
      onThreadTap: onThreadTap ?? this.onThreadTap,
      onReplyTap: onReplyTap ?? this.onReplyTap,
      onConfirmDeleteTap: onConfirmDeleteTap ?? this.onConfirmDeleteTap,
      editMessageInputBuilder:
          editMessageInputBuilder ?? this.editMessageInputBuilder,
      textBuilder: textBuilder ?? this.textBuilder,
      quotedMessageBuilder: quotedMessageBuilder ?? this.quotedMessageBuilder,
      bottomRowBuilderWithDefaultWidget: bottomRowBuilderWithDefaultWidget ??
          this.bottomRowBuilderWithDefaultWidget,
      onMessageActions: onMessageActions ?? this.onMessageActions,
      message: message ?? this.message,
      messageTheme: messageTheme ?? this.messageTheme,
      reverse: reverse ?? this.reverse,
      shape: shape ?? this.shape,
      attachmentShape: attachmentShape ?? this.attachmentShape,
      borderSide: borderSide ?? this.borderSide,
      borderRadiusGeometry: borderRadiusGeometry ?? this.borderRadiusGeometry,
      padding: padding ?? this.padding,
      textPadding: textPadding ?? this.textPadding,
      attachmentPadding: attachmentPadding ?? this.attachmentPadding,
      widthFactor: widthFactor ?? this.widthFactor,
      showUserAvatar: showUserAvatar ?? this.showUserAvatar,
      showSendingIndicator: showSendingIndicator ?? this.showSendingIndicator,
      showEditedLabel: showEditedLabel ?? this.showEditedLabel,
      showReactions: showReactions ?? this.showReactions,
      showThreadReplyIndicator:
          showThreadReplyIndicator ?? this.showThreadReplyIndicator,
      showInChannelIndicator:
          showInChannelIndicator ?? this.showInChannelIndicator,
      onUserAvatarTap: onUserAvatarTap ?? this.onUserAvatarTap,
      onLinkTap: onLinkTap ?? this.onLinkTap,
      showReactionPicker: showReactionPicker ?? this.showReactionPicker,
      showReactionTail: showReactionTail ?? this.showReactionTail,
      onShowMessage: onShowMessage ?? this.onShowMessage,
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
      showMarkUnreadMessage:
          showMarkUnreadMessage ?? this.showMarkUnreadMessage,
      attachmentBuilders: attachmentBuilders ?? this.attachmentBuilders,
      translateUserAvatar: translateUserAvatar ?? this.translateUserAvatar,
      onQuotedMessageTap: onQuotedMessageTap ?? this.onQuotedMessageTap,
      onMessageTap: onMessageTap ?? this.onMessageTap,
      onMessageLongPress: onMessageLongPress ?? this.onMessageLongPress,
      onReactionsTap: onReactionsTap ?? this.onReactionsTap,
      onReactionsHover: onReactionsHover ?? this.onReactionsHover,
      customActions: customActions ?? this.customActions,
      onAttachmentTap: onAttachmentTap ?? this.onAttachmentTap,
      userAvatarBuilder: userAvatarBuilder ?? this.userAvatarBuilder,
      imageAttachmentThumbnailSize:
          imageAttachmentThumbnailSize ?? this.imageAttachmentThumbnailSize,
      imageAttachmentThumbnailResizeType: imageAttachmentThumbnailResizeType ??
          this.imageAttachmentThumbnailResizeType,
      imageAttachmentThumbnailCropType: imageAttachmentThumbnailCropType ??
          this.imageAttachmentThumbnailCropType,
      attachmentActionsModalBuilder:
          attachmentActionsModalBuilder ?? this.attachmentActionsModalBuilder,
    );
  }

  @override
  _StreamMessageWidgetState createState() => _StreamMessageWidgetState();
}

class _StreamMessageWidgetState extends State<StreamMessageWidget>
    with AutomaticKeepAliveClientMixin<StreamMessageWidget> {
  bool get showThreadReplyIndicator => widget.showThreadReplyIndicator;

  bool get showSendingIndicator => widget.showSendingIndicator;

  bool get isDeleted => widget.message.isDeleted;

  bool get showUsername => widget.showUsername;

  bool get showTimeStamp => widget.showTimestamp;

  bool get showEditedLabel => widget.showEditedLabel;

  bool get isTextEdited => widget.message.messageTextUpdatedAt != null;

  bool get showInChannel => widget.showInChannelIndicator;

  /// {@template hasQuotedMessage}
  /// `true` if [StreamMessageWidget.quotedMessage] is not null.
  /// {@endtemplate}
  bool get hasQuotedMessage => widget.message.quotedMessage != null;

  bool get isSendFailed => widget.message.state.isSendingFailed;

  bool get isUpdateFailed => widget.message.state.isUpdatingFailed;

  bool get isDeleteFailed => widget.message.state.isDeletingFailed;

  /// {@template isFailedState}
  /// Whether the message has failed to be sent, updated, or deleted.
  /// {@endtemplate}
  bool get isFailedState => isSendFailed || isUpdateFailed || isDeleteFailed;

  /// {@template isGiphy}
  /// `true` if any of the [message]'s attachments are a giphy.
  /// {@endtemplate}
  bool get isGiphy => widget.message.attachments
      .any((element) => element.type == AttachmentType.giphy);

  /// {@template isOnlyEmoji}
  /// `true` if [message.text] contains only emoji.
  /// {@endtemplate}
  bool get isOnlyEmoji => widget.message.text?.isOnlyEmoji == true;

  /// {@template hasNonUrlAttachments}
  /// `true` if any of the [message]'s attachments are a giphy and do not
  /// have a [Attachment.titleLink].
  /// {@endtemplate}
  bool get hasNonUrlAttachments => widget.message.attachments
      .any((it) => it.type != AttachmentType.urlPreview);

  /// {@template hasPoll}
  /// `true` if the [message] contains a poll.
  /// {@endtemplate}
  bool get hasPoll => widget.message.poll != null;

  /// {@template hasUrlAttachments}
  /// `true` if any of the [message]'s attachments are a giphy with a
  /// [Attachment.titleLink].
  /// {@endtemplate}
  bool get hasUrlAttachments => widget.message.attachments
      .any((it) => it.type == AttachmentType.urlPreview);

  /// {@template showBottomRow}
  /// Show the [BottomRow] widget if any of the following are `true`:
  /// * [StreamMessageWidget.showThreadReplyIndicator]
  /// * [StreamMessageWidget.showUsername]
  /// * [StreamMessageWidget.showTimestamp]
  /// * [StreamMessageWidget.showInChannelIndicator]
  /// * [StreamMessageWidget.showSendingIndicator]
  /// * [StreamMessageWidget.message.isDeleted]
  /// {@endtemplate}
  bool get showBottomRow =>
      showThreadReplyIndicator ||
      showUsername ||
      showTimeStamp ||
      showInChannel ||
      showSendingIndicator ||
      isTextEdited;

  /// {@template isPinned}
  /// Whether [StreamMessageWidget.message] is pinned or not.
  /// {@endtemplate}
  bool get isPinned => widget.message.pinned && !widget.message.isDeleted;

  /// {@template shouldShowReactions}
  /// Should show message reactions if [StreamMessageWidget.showReactions] is
  /// `true`, if there are reactions to show, and if the message is not deleted.
  /// {@endtemplate}
  bool get shouldShowReactions =>
      widget.showReactions &&
      (widget.message.reactionCounts?.isNotEmpty == true) &&
      !widget.message.isDeleted;

  @override
  bool get wantKeepAlive => widget.message.attachments.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = StreamChatTheme.of(context);
    final streamChat = StreamChat.of(context);

    final avatarWidth =
        widget.messageTheme.avatarTheme?.constraints.maxWidth ?? 40;
    final bottomRowPadding =
        widget.showUserAvatar != DisplayWidget.gone ? avatarWidth + 8.5 : 0.5;

    return ConditionalParentBuilder(
      builder: (context, child) {
        final message = widget.message;

        // If the message is deleted or not yet sent, we don't want to show any
        // context menu actions.
        if (message.state.isDeleted || message.state.isOutgoing) return child;

        return ContextMenuArea(
          verticalPadding: 0,
          builder: (_) => _buildDesktopOrWebActions(context, message),
          child: child,
        );
      },
      child: Material(
        type: MaterialType.transparency,
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          color: isPinned && widget.showPinHighlight
              ? theme.colorTheme.highlight
              // ignore: deprecated_member_use
              : theme.colorTheme.barsBg.withOpacity(0),
          child: Portal(
            child: PlatformWidgetBuilder(
              mobile: (context, child) {
                final message = widget.message;
                return InkWell(
                  onTap: switch (widget.onMessageTap) {
                    final onTap? => () => onTap(message),
                    _ => null,
                  },
                  onLongPress: switch (widget.onMessageLongPress) {
                    final onLongPress? => () => onLongPress(message),
                    // If the message is not yet sent or deleted, we don't want
                    // to handle long press events by default.
                    _ when message.state.isDeleted => null,
                    _ when message.state.isOutgoing => null,
                    _ => () => _onMessageLongPressed(context, message),
                  },
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
                  widthFactor: widget.widthFactor,
                  child: Builder(builder: (context) {
                    return MessageWidgetContent(
                      streamChatTheme: theme,
                      showUsername: showUsername,
                      showTimeStamp: showTimeStamp,
                      showEditedLabel: showEditedLabel,
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
                      hasPoll: hasPoll,
                      hasQuotedMessage: hasQuotedMessage,
                      textPadding: widget.textPadding,
                      attachmentBuilders: widget.attachmentBuilders,
                      attachmentPadding: widget.attachmentPadding,
                      attachmentShape: widget.attachmentShape,
                      onAttachmentTap: widget.onAttachmentTap,
                      onReplyTap: widget.onReplyTap,
                      onThreadTap: widget.onThreadTap,
                      onShowMessage: widget.onShowMessage,
                      attachmentActionsModalBuilder:
                          widget.attachmentActionsModalBuilder,
                      avatarWidth: avatarWidth,
                      bottomRowPadding: bottomRowPadding,
                      isFailedState: isFailedState,
                      isPinned: isPinned,
                      messageWidget: widget,
                      showBottomRow: showBottomRow,
                      showPinHighlight: widget.showPinHighlight,
                      showReactionPickerTail: widget.showReactionTail == true,
                      showReactions: shouldShowReactions,
                      onReactionsTap: () {
                        final message = widget.message;
                        return switch (widget.onReactionsTap) {
                          final onReactionsTap? => onReactionsTap(message),
                          _ => _showMessageReactionsModal(context, message),
                        };
                      },
                      onReactionsHover: widget.onReactionsHover,
                      showUserAvatar: widget.showUserAvatar,
                      streamChat: streamChat,
                      translateUserAvatar: widget.translateUserAvatar,
                      shape: widget.shape,
                      borderSide: widget.borderSide,
                      borderRadiusGeometry: widget.borderRadiusGeometry,
                      textBuilder: widget.textBuilder,
                      quotedMessageBuilder: widget.quotedMessageBuilder,
                      onLinkTap: widget.onLinkTap,
                      onMentionTap: widget.onMentionTap,
                      onQuotedMessageTap: widget.onQuotedMessageTap,
                      bottomRowBuilderWithDefaultWidget:
                          widget.bottomRowBuilderWithDefaultWidget,
                      onUserAvatarTap: widget.onUserAvatarTap,
                      userAvatarBuilder: widget.userAvatarBuilder,
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Set<StreamMessageAction> _buildMessageActions({
    required BuildContext context,
    required Message message,
    required Channel channel,
    OwnUser? currentUser,
    List<StreamMessageAction>? customActions,
    OnMessageActionTap? onActionTap,
  }) {
    final actions = StreamMessageActionsBuilder.buildActions(
      context: context,
      message: message,
      channel: channel,
      currentUser: currentUser,
      customActions: customActions,
      onActionTap: onActionTap,
    );

    final enabledActions = <StreamMessageActionType, bool>{
      StreamMessageActionType.reply: widget.showReplyMessage,
      StreamMessageActionType.threadReply: widget.showThreadReplyMessage,
      StreamMessageActionType.markUnread: widget.showMarkUnreadMessage,
      StreamMessageActionType.retry: widget.showResendMessage,
      StreamMessageActionType.editMessage: widget.showEditMessage,
      StreamMessageActionType.copyMessage: widget.showCopyMessage,
      StreamMessageActionType.flagMessage: widget.showFlagButton,
      StreamMessageActionType.pinMessage: widget.showPinButton,
      StreamMessageActionType.deleteMessage: widget.showDeleteMessage,
    };

    return actions.removeDisabled(enabledActions);
  }

  List<Widget> _buildDesktopOrWebActions(
    BuildContext context,
    Message message,
  ) {
    final channel = StreamChannel.of(context).channel;
    final currentUser = channel.client.state.currentUser;
    final showPicker = widget.showReactionPicker && channel.canSendReaction;

    final actions = _buildMessageActions(
      context: context,
      message: message,
      channel: channel,
      currentUser: currentUser,
      customActions: widget.customActions,
      onActionTap: (message, action) async {
        final popped = await Navigator.of(context).maybePop();
        if (popped) return _handleOnActionTap(message, channel, action);
      },
    );

    return [
      if (showPicker)
        StreamMessageActionItem.custom(
          message: message,
          action: const StreamMessageAction(
            type: StreamMessageActionType.selectReaction,
          ),
          child: ReactionPickerIconList(
            message: message,
            reactionIcons: StreamChatConfiguration.of(context).reactionIcons,
            onReactionPicked: (reaction) async {
              final popped = await Navigator.of(context).maybePop();
              if (popped) {
                final configurations = StreamChatConfiguration.of(context);
                return _selectReaction(
                  message,
                  channel,
                  reaction,
                  enforceUnique: configurations.enforceUniqueReactions,
                );
              }
            },
          ),
        ),
      ...actions.map((action) {
        return StreamMessageActionItem(
          action: action,
          message: message,
        );
      }),
    ];
  }

  Future<void> _showMessageReactionsModal(
    BuildContext context,
    Message message,
  ) {
    final channel = StreamChannel.of(context).channel;
    final showPicker = widget.showReactionPicker && channel.canSendReaction;

    return showStreamMessageModal(
      context: context,
      useRootNavigator: false,
      builder: (context) => StreamMessageReactionsModal(
        message: message,
        reverse: widget.reverse,
        onUserAvatarTap: widget.onUserAvatarTap,
        showReactionPicker: showPicker,
        onReactionPicked: (reaction) async {
          final popped = await Navigator.of(context).maybePop();
          if (popped) {
            final configurations = StreamChatConfiguration.of(context);
            return _selectReaction(
              message,
              channel,
              reaction,
              enforceUnique: configurations.enforceUniqueReactions,
            );
          }
        },
        messageWidget: StreamChannel(
          channel: channel,
          child: widget.copyWith(
            key: const Key('MessageWidget'),
            message: message.trimmed,
            showReactions: false,
            showUsername: false,
            showTimestamp: false,
            translateUserAvatar: false,
            showSendingIndicator: false,
            padding: EdgeInsets.zero,
            showPinHighlight: false,
            showReactionTail: showPicker,
            showUserAvatar: switch (widget.reverse) {
              true => DisplayWidget.gone,
              false => DisplayWidget.show,
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onMessageLongPressed(
    BuildContext context,
    Message message,
  ) async {
    if (widget.onMessageActions case final onActions?) {
      return onActions(context, message);
    }

    return _showMessageActionsModal(context, message);
  }

  Future<void> _showMessageActionsModal(
    BuildContext context,
    Message message,
  ) {
    final channel = StreamChannel.of(context).channel;
    final currentUser = channel.client.state.currentUser;
    final showPicker = widget.showReactionPicker && channel.canSendReaction;

    final actions = _buildMessageActions(
      context: context,
      message: message,
      channel: channel,
      currentUser: currentUser,
      customActions: widget.customActions,
      onActionTap: (message, action) async {
        final popped = await Navigator.of(context).maybePop();
        if (popped) return _handleOnActionTap(message, channel, action);
      },
    );

    return showStreamMessageModal(
      context: context,
      useRootNavigator: false,
      builder: (context) => StreamMessageActionsModal(
        message: message,
        reverse: widget.reverse,
        messageActions: actions,
        showReactionPicker: showPicker,
        onReactionPicked: (reaction) async {
          final popped = await Navigator.of(context).maybePop();
          if (popped) {
            final configurations = StreamChatConfiguration.of(context);
            return _selectReaction(
              message,
              channel,
              reaction,
              enforceUnique: configurations.enforceUniqueReactions,
            );
          }
        },
        messageWidget: StreamChannel(
          channel: channel,
          child: widget.copyWith(
            key: const Key('MessageWidget'),
            message: message.trimmed,
            showReactions: false,
            showUsername: false,
            showTimestamp: false,
            translateUserAvatar: false,
            showSendingIndicator: false,
            padding: EdgeInsets.zero,
            showPinHighlight: false,
            showReactionTail: showPicker,
            showUserAvatar: switch (widget.reverse) {
              true => DisplayWidget.gone,
              false => DisplayWidget.show,
            },
          ),
        ),
      ),
    );
  }

  void _handleOnActionTap(
    Message message,
    Channel channel,
    StreamMessageActionType action,
  ) {
    final onTap = switch (action) {
      StreamMessageActionType.banUser => _banUser(message, channel),
      StreamMessageActionType.blockUser => _blockUser(message, channel),
      StreamMessageActionType.copyMessage => _copyMessage(message, channel),
      StreamMessageActionType.deleteMessage => _deleteMessage(message, channel),
      StreamMessageActionType.editMessage => _editMessage(message, channel),
      StreamMessageActionType.flagMessage => _flagMessage(message, channel),
      StreamMessageActionType.markUnread => _markUnread(message, channel),
      StreamMessageActionType.muteUser => _muteUser(message, channel),
      StreamMessageActionType.pinMessage => _pinMessage(message, channel),
      StreamMessageActionType.unpinMessage => _unpinMessage(message, channel),
      StreamMessageActionType.reply => _reply(message, channel),
      StreamMessageActionType.retry => _retry(message, channel),
      StreamMessageActionType.quotedReply => _quotedReply(message, channel),
      StreamMessageActionType.threadReply => _threadReply(message, channel),
      _ => null,
    };

    return onTap?.ignore();
  }

  Future<void> _banUser(Message message, Channel channel) async {
    final userId = message.user?.id;
    if (userId == null) return;
  }

  Future<void> _blockUser(Message message, Channel channel) async {
    final userId = message.user?.id;
    if (userId == null) return;

    return channel.client.blockUser(userId).ignore();
  }

  Future<void> _copyMessage(Message message, Channel channel) async {
    final presentableMessage = message.replaceMentions(linkify: false);

    final messageText = presentableMessage.text;
    if (messageText == null || messageText.isEmpty) return;

    return Clipboard.setData(ClipboardData(text: messageText)).ignore();
  }

  Future<void> _deleteMessage(Message message, Channel channel) async {
    return channel.deleteMessage(message).ignore();
  }

  Future<void> _editMessage(Message message, Channel channel) async {
    return showEditMessageSheet(
      context: context,
      channel: channel,
      message: widget.message,
      editMessageInputBuilder: widget.editMessageInputBuilder,
    ).ignore();
  }

  Future<void> _flagMessage(Message message, Channel channel) async {
    final messageId = message.id;
    return channel.client.flagMessage(messageId).ignore();
  }

  Future<void> _markUnread(Message message, Channel channel) async {
    final messageId = message.id;
    return channel.markUnread(messageId).ignore();
  }

  Future<void> _muteUser(Message message, Channel channel) async {
    final userId = message.user?.id;
    if (userId == null) return;

    return channel.client.muteUser(userId).ignore();
  }

  Future<void> _pinMessage(Message message, Channel channel) async {
    return channel.pinMessage(message).ignore();
  }

  Future<void> _unpinMessage(Message message, Channel channel) async {
    return channel.unpinMessage(message).ignore();
  }

  Future<void> _reply(Message message, Channel channel) async {
    return widget.onReplyTap?.call(message);
  }

  Future<void> _retry(Message message, Channel channel) async {
    return channel.retryMessage(message).ignore();
  }

  Future<void> _quotedReply(Message message, Channel channel) async {
    return widget.onReplyTap?.call(message);
  }

  Future<void> _threadReply(Message message, Channel channel) async {
    return widget.onThreadTap?.call(message);
  }

  Future<void> _selectReaction(
    Message message,
    Channel channel,
    Reaction reaction, {
    bool enforceUnique = false,
  }) async {
    final ownReactions = [...?message.ownReactions];
    final shouldDelete = ownReactions.any((it) => it.type == reaction.type);

    if (shouldDelete) {
      return channel.deleteReaction(message, reaction).ignore();
    }

    return channel
        .sendReaction(message, reaction.type, enforceUnique: enforceUnique)
        .ignore();
  }
}

extension on Set<StreamMessageAction> {
  Set<StreamMessageAction> removeDisabled(
    Map<StreamMessageActionType, bool> enabledActions,
  ) {
    return {...where((action) => enabledActions[action.type] ?? true)};
  }
}

extension on Message {
  Message get trimmed {
    if (text case final messageText? when messageText.length > 200) {
      return copyWith(text: '${messageText.substring(0, 200)}...');
    }

    return this;
  }
}
