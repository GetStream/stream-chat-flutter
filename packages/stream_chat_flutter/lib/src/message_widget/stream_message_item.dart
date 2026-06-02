import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/platform_widget_builder/src/platform_widget_builder.dart';
import 'package:stream_chat_flutter/src/context_menu/context_menu.dart';
import 'package:stream_chat_flutter/src/context_menu/context_menu_region.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_content.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// A chat message widget that renders a single message with its attachments,
/// reactions, and interaction callbacks.
///
/// [StreamMessageItem] displays a single [Message] within a chat message
/// list. It handles the complete message layout including the author avatar,
/// message content (text, attachments, polls, quoted messages), reactions,
/// thread indicators, and user interaction gestures such as tap, long-press,
/// and context menus.
///
/// On mobile platforms, a long-press opens the [StreamMessageActionsModal]
/// with available actions (reply, edit, delete, pin, etc.). On desktop and
/// web, those same actions appear in a right-click context menu.
///
/// This widget delegates rendering to either a custom builder registered via
/// [StreamComponentFactory], or [DefaultStreamMessageItem] when no custom builder
/// is provided. Register a custom builder through [StreamChatConfigurationData]
/// to fully replace the default message layout while still receiving the same
/// [StreamMessageItemProps].
///
/// {@tool snippet}
///
/// Display a message with default settings:
///
/// ```dart
/// StreamMessageItem(
///   message: message,
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// Customise interaction callbacks:
///
/// ```dart
/// StreamMessageItem(
///   message: message,
///   onMessageTap: (msg) => print('Tapped: ${msg.id}'),
///   onThreadTap: (parent, threadMsg) => Navigator.push(...),
///   onUserAvatarTap: (user) => showProfile(user),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [StreamMessageItemProps], which holds every configurable property.
///  * [DefaultStreamMessageItem], the default implementation used when no custom
///    builder is registered.
///  * [StreamMessageActionsModal], the modal shown on long-press (mobile).
///  * [StreamMessageListView], which hosts a scrollable list of these widgets.
class StreamMessageItem extends StatelessWidget {
  /// Creates a chat message widget.
  ///
  /// The [message] is required. All other parameters are optional and have
  /// sensible defaults resolved from the ambient theme and message data.
  StreamMessageItem({
    super.key,
    required Message message,
    EdgeInsetsGeometry? padding,
    double? spacing,
    Color? backgroundColor,
    double maxWidth = 264,
    bool swipeToReply = false,
    void Function(Message)? onMessageTap,
    void Function(Message)? onMessageLongPress,
    void Function(User)? onUserAvatarTap,
    void Function(Message message, String url)? onMessageLinkTap,
    void Function(User user)? onUserMentionTap,
    void Function(Message parentMessage, Message? threadMessage)? onThreadTap,
    void Function(Message)? onViewInChannelTap,
    void Function(Message)? onReplyTap,
    void Function(Message)? onReactionsTap,
    void Function(Message quotedMessage)? onQuotedMessageTap,
    Comparator<ReactionGroup>? reactionSorting,
    MessageActionsBuilder? actionsBuilder,
    void Function(BuildContext, Message)? onMessageActions,
    void Function(BuildContext, Message)? onBouncedErrorMessageActions,
    void Function(Message)? onEditMessageTap,
    List<StreamAttachmentWidgetBuilder>? attachmentBuilders,
  }) : props = .new(
         message: message,
         padding: padding,
         spacing: spacing,
         backgroundColor: backgroundColor,
         maxWidth: maxWidth,
         swipeToReply: swipeToReply,
         onMessageTap: onMessageTap,
         onMessageLongPress: onMessageLongPress,
         onUserAvatarTap: onUserAvatarTap,
         onMessageLinkTap: onMessageLinkTap,
         onUserMentionTap: onUserMentionTap,
         onThreadTap: onThreadTap,
         onViewInChannelTap: onViewInChannelTap,
         onReplyTap: onReplyTap,
         onReactionsTap: onReactionsTap,
         onQuotedMessageTap: onQuotedMessageTap,
         reactionSorting: reactionSorting,
         actionsBuilder: actionsBuilder,
         onMessageActions: onMessageActions,
         onBouncedErrorMessageActions: onBouncedErrorMessageActions,
         onEditMessageTap: onEditMessageTap,
         attachmentBuilders: attachmentBuilders,
       );

  /// Creates a chat message widget from pre-built [props].
  const StreamMessageItem.fromProps({super.key, required this.props});

  /// The properties that configure this message widget.
  final StreamMessageItemProps props;

  @override
  Widget build(BuildContext context) {
    final builder = context.chatComponentBuilder<StreamMessageItemProps>();
    if (builder != null) return builder(context, props);
    return DefaultStreamMessageItem(props: props);
  }
}

/// Properties for configuring a [StreamMessageItem].
///
/// This class holds every configuration option for a chat message widget,
/// allowing them to be passed through the [StreamComponentFactory] when a
/// custom builder is registered.
///
/// Visual properties such as [padding], [spacing], and [backgroundColor]
/// override the corresponding values from [StreamMessageItemThemeData] when
/// non-null. When left null, the theme values are used instead.
///
/// See also:
///
///  * [StreamMessageItem], which uses these properties.
///  * [DefaultStreamMessageItem], the default implementation.
class StreamMessageItemProps {
  /// Creates properties for a chat message widget.
  const StreamMessageItemProps({
    required this.message,
    this.padding,
    this.spacing,
    this.backgroundColor,
    this.maxWidth = 272,
    this.swipeToReply = false,
    this.onMessageTap,
    this.onMessageLongPress,
    this.onUserAvatarTap,
    this.onMessageLinkTap,
    this.onUserMentionTap,
    this.onThreadTap,
    this.onViewInChannelTap,
    this.onReplyTap,
    this.onReactionsTap,
    this.onQuotedMessageTap,
    this.reactionSorting,
    this.actionsBuilder,
    this.onMessageActions,
    this.onBouncedErrorMessageActions,
    this.onEditMessageTap,
    this.attachmentBuilders,
  });

  /// The message to display.
  final Message message;

  /// Outer padding around the entire message item.
  ///
  /// When non-null, takes precedence over the theme value from
  /// [StreamMessageItemThemeData.padding].
  ///
  /// When null (the default), the padding is determined by the theme.
  final EdgeInsetsGeometry? padding;

  /// Horizontal spacing between the leading avatar and the content.
  ///
  /// When non-null, takes precedence over the theme value from
  /// [StreamMessageItemThemeData.spacing].
  ///
  /// When null (the default), the spacing is determined by the theme.
  final double? spacing;

  /// Background color for the entire message item row.
  ///
  /// When non-null, takes precedence over the theme value from
  /// [StreamMessageItemThemeData.backgroundColor].
  ///
  /// When null (the default), the background color is determined by the theme.
  final Color? backgroundColor;

  /// Maximum width of the message content column, in logical pixels.
  ///
  /// The content uses at most this width while still respecting the parent
  /// [Flex] constraints. Use [double.infinity] to impose no cap from this
  /// widget. Defaults to `264` when not specified.
  final double maxWidth;

  /// Whether swiping the message triggers a quoted-reply action.
  ///
  /// When true, the message can be swiped from left to right to initiate a
  /// reply. The swipe direction and reply icon position are always
  /// start-to-end (left to right in LTR layouts), regardless of whether the
  /// message belongs to the current user or another participant.
  /// On completion, [onReplyTap] is invoked with the message.
  ///
  /// Swipe is disabled for deleted messages and messages in a failed state.
  ///
  /// Defaults to false.
  final bool swipeToReply;

  /// Called when the message is tapped.
  ///
  /// If null, no tap gesture is registered on mobile. On desktop and web,
  /// tap behaviour is unaffected because interactions are driven by the
  /// context menu instead.
  final void Function(Message message)? onMessageTap;

  /// Called when the message is long-pressed.
  ///
  /// If null, the default long-press behaviour is used, which opens the
  /// [StreamMessageActionsModal] on mobile. Provide this callback to
  /// override that behaviour entirely.
  final void Function(Message message)? onMessageLongPress;

  /// Called when the author's avatar is tapped.
  ///
  /// If null, tapping the avatar has no effect. A common use is to navigate
  /// to the user's profile screen.
  final void Function(User user)? onUserAvatarTap;

  /// Called when a link is tapped in the message text.
  ///
  /// Receives the [Message] containing the link and the tapped URL string.
  /// If null, the default link handling behaviour is used.
  final void Function(Message message, String url)? onMessageLinkTap;

  /// Called when a `@mention` is tapped in the message text.
  ///
  /// Receives the mentioned [User] resolved from the message's
  /// [Message.mentionedUsers] list. If null, tapping a mention has no effect.
  final void Function(User user)? onUserMentionTap;

  /// Called when the thread reply indicator is tapped.
  ///
  /// [parentMessage] is the root message of the thread. When the tapped
  /// message was shown in-channel via [Message.showInChannel],
  /// [threadMessage] contains the original in-channel reply so that the
  /// caller can scroll to / highlight it inside the thread view.
  /// Otherwise [threadMessage] is null.
  ///
  /// If null, tapping the thread indicator has no effect.
  final void Function(Message parentMessage, Message? threadMessage)? onThreadTap;

  /// Called when the "View" button on the "Also sent in channel" annotation
  /// is tapped inside a thread view.
  ///
  /// Typically used to pop the thread screen and scroll to / highlight the
  /// message in the parent channel list.
  ///
  /// When null, the "View" button falls back to [onThreadTap].
  final void Function(Message message)? onViewInChannelTap;

  /// Called when the quoted-reply action is selected from the actions list.
  ///
  /// Receives the [Message] that should be quoted. Typically used to set the
  /// quoted message on the message input.
  ///
  /// If null, the quoted-reply action is still shown but has no effect.
  final void Function(Message message)? onReplyTap;

  /// Called when the reactions row beneath the message bubble is tapped.
  ///
  /// If null, the default behaviour opens a [ReactionDetailSheet] showing
  /// the full list of reactions. Provide this callback to replace that
  /// default with custom handling.
  final void Function(Message message)? onReactionsTap;

  /// Called when an inline quoted message is tapped.
  ///
  /// Receives the [Message] that was quoted. Typically used to scroll to
  /// the original message in the list.
  ///
  /// If null, tapping the quoted message has no effect.
  final void Function(Message quotedMessage)? onQuotedMessageTap;

  /// Controls how reaction groups are sorted when displayed.
  ///
  /// Defaults to [ReactionSorting.byFirstReactionAt].
  final Comparator<ReactionGroup>? reactionSorting;

  /// Allows customizing the default message actions list.
  ///
  /// Receives the [BuildContext] and the default list of
  /// [StreamContextMenuAction] items built by the widget. Return a modified
  /// list to add, remove, or reorder actions.
  final MessageActionsBuilder? actionsBuilder;

  /// Called when a normal message is long-pressed to show actions.
  ///
  /// When provided, this callback replaces the default behaviour of showing
  /// the [StreamMessageActionsModal].
  final void Function(BuildContext context, Message message)? onMessageActions;

  /// Called when a bounced-error message is long-pressed.
  ///
  /// When provided, this callback replaces the default behaviour of showing
  /// the [ModeratedMessageActionsModal].
  final void Function(BuildContext context, Message message)? onBouncedErrorMessageActions;

  /// Called when the edit-message action is selected.
  final void Function(Message message)? onEditMessageTap;

  /// Custom attachment builders for rendering message attachments.
  ///
  /// When non-null, these builders are used instead of the default ones
  /// provided by [StreamChatConfigurationData.attachmentBuilders].
  ///
  /// Custom builders are prepended to the default builder list, so they take
  /// priority for attachment types they can handle.
  final List<StreamAttachmentWidgetBuilder>? attachmentBuilders;

  /// Returns a copy of this [StreamMessageItemProps] with the given fields
  /// replaced with new values.
  StreamMessageItemProps copyWith({
    Message? message,
    EdgeInsetsGeometry? padding,
    double? spacing,
    Color? backgroundColor,
    double? maxWidth,
    bool? swipeToReply,
    void Function(Message)? onMessageTap,
    void Function(Message)? onMessageLongPress,
    void Function(User)? onUserAvatarTap,
    void Function(Message, String)? onMessageLinkTap,
    void Function(User)? onUserMentionTap,
    void Function(Message, Message?)? onThreadTap,
    void Function(Message)? onViewInChannelTap,
    void Function(Message)? onReplyTap,
    void Function(Message)? onReactionsTap,
    void Function(Message)? onQuotedMessageTap,
    Comparator<ReactionGroup>? reactionSorting,
    MessageActionsBuilder? actionsBuilder,
    void Function(BuildContext, Message)? onMessageActions,
    void Function(BuildContext, Message)? onBouncedErrorMessageActions,
    void Function(Message)? onEditMessageTap,
    List<StreamAttachmentWidgetBuilder>? attachmentBuilders,
  }) {
    return StreamMessageItemProps(
      message: message ?? this.message,
      padding: padding ?? this.padding,
      spacing: spacing ?? this.spacing,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      maxWidth: maxWidth ?? this.maxWidth,
      swipeToReply: swipeToReply ?? this.swipeToReply,
      onMessageTap: onMessageTap ?? this.onMessageTap,
      onMessageLongPress: onMessageLongPress ?? this.onMessageLongPress,
      onUserAvatarTap: onUserAvatarTap ?? this.onUserAvatarTap,
      onMessageLinkTap: onMessageLinkTap ?? this.onMessageLinkTap,
      onUserMentionTap: onUserMentionTap ?? this.onUserMentionTap,
      onThreadTap: onThreadTap ?? this.onThreadTap,
      onViewInChannelTap: onViewInChannelTap ?? this.onViewInChannelTap,
      onReplyTap: onReplyTap ?? this.onReplyTap,
      onReactionsTap: onReactionsTap ?? this.onReactionsTap,
      onQuotedMessageTap: onQuotedMessageTap ?? this.onQuotedMessageTap,
      reactionSorting: reactionSorting ?? this.reactionSorting,
      actionsBuilder: actionsBuilder ?? this.actionsBuilder,
      onMessageActions: onMessageActions ?? this.onMessageActions,
      onBouncedErrorMessageActions: onBouncedErrorMessageActions ?? this.onBouncedErrorMessageActions,
      onEditMessageTap: onEditMessageTap ?? this.onEditMessageTap,
      attachmentBuilders: attachmentBuilders ?? this.attachmentBuilders,
    );
  }
}

/// The default implementation of [StreamMessageItem].
///
/// Composes a full message row with an author avatar, content bubble,
/// header annotations, footer metadata, and platform-adaptive interaction
/// handling (tap and long-press on mobile, right-click context menu on
/// desktop and web).
///
/// Message actions can be customised through
/// [StreamMessageItemProps.actionsBuilder].
///
/// See also:
///
///  * [StreamMessageItem], the public API widget.
///  * [StreamMessageItemProps], which configures this widget.
///  * [StreamMessageItemTheme], provides theme data to this widget.
class DefaultStreamMessageItem extends StatelessWidget {
  /// Creates a default chat message widget with the given [props].
  const DefaultStreamMessageItem({super.key, required this.props});

  /// The properties that configure this widget.
  final StreamMessageItemProps props;

  @override
  Widget build(BuildContext context) {
    final message = props.message;

    final placement = StreamMessageLayout.of(context);
    final theme = core.StreamMessageItemTheme.of(context);
    final defaults = _StreamMessageItemDefaults(
      context,
      isPinned: message.pinned,
      isEdited: message.messageTextUpdatedAt != null,
      isBouncedWithError: message.isBouncedWithError,
      state: message.state,
    );

    final resolve = core.StreamMessageLayoutResolver(placement, [theme, defaults]);

    final effectivePadding = props.padding ?? theme.padding ?? defaults.padding;
    final effectiveSpacing = props.spacing ?? theme.spacing ?? defaults.spacing;
    final effectiveBackgroundColor = props.backgroundColor ?? theme.backgroundColor ?? defaults.backgroundColor;
    final effectiveAvatarVisibility = resolve((theme) => theme?.avatarVisibility);
    final effectiveAnnotationVisibility = resolve((theme) => theme?.annotationVisibility);
    final effectiveErrorBadgeVisibility = resolve((theme) => theme?.errorBadgeVisibility);
    final effectiveMetadataVisibility = resolve((theme) => theme?.metadataVisibility);
    final effectiveRepliesVisibility = resolve((theme) => theme?.repliesVisibility);

    final leadingWidget = effectiveAvatarVisibility.apply(
      StreamMessageLeading(message: message),
    );

    final headerWidget = effectiveAnnotationVisibility.apply(
      StreamMessageHeader(
        message: message,
        onViewChannelTap: switch (props.onViewInChannelTap) {
          final onTap? => () => onTap(message),
          _ => () => _onViewThread(context, message),
        },
      ),
    );

    final footerWidget = effectiveMetadataVisibility.apply(
      StreamMessageFooter(message: message),
    );

    Widget? repliesWidget;
    if (message.replyCount case final replyCount? when replyCount > 0) {
      repliesWidget = effectiveRepliesVisibility.apply(
        core.StreamMessageReplies(
          maxAvatars: 3,
          onTap: () => _onViewThread(context, message),
          showConnector: placement.contentKind != .jumbomoji,
          label: Text('$replyCount replies'),
          avatars: message.threadParticipants?.map(
            (user) => StreamUserAvatar(user: user, showOnlineIndicator: false),
          ),
        ),
      );
    }

    final errorBadgeWidget = effectiveErrorBadgeVisibility.apply(
      core.StreamErrorBadge(size: core.StreamErrorBadgeSize.sm),
    );

    final contentWidget = StreamMessageContent(
      message: message,
      header: headerWidget,
      errorBadge: errorBadgeWidget,
      footer: footerWidget,
      replies: repliesWidget,
      attachmentBuilders: props.attachmentBuilders,
      reactionSorting: props.reactionSorting,
      onQuotedMessageTap: props.onQuotedMessageTap,
      onLinkTap: (_, href, __) {
        if (href == null) return;
        if (props.onMessageLinkTap case final onTap?) return onTap(message, href);
        return launchURL(context, href).ignore();
      },
      onMentionTap: switch (props.onUserMentionTap) {
        final onTap? => (_, id) {
          final user = message.mentionedUsers.firstWhereOrNull((u) => u.id == id);
          if (user != null) onTap(user);
        },
        _ => null,
      },
      onReactionsTap: switch (props.onReactionsTap) {
        final onReactionsTap? => () => onReactionsTap(message),
        _ => () => _showMessageReactionsModal(context, message),
      },
    );

    Widget result = Material(
      animateColor: true,
      color: effectiveBackgroundColor,
      child: PlatformWidgetBuilder(
        mobile: (context, child) => InkWell(
          // Disable splash and highlight effects for the message row.
          splashFactory: NoSplash.splashFactory,
          overlayColor: .all(core.StreamColors.transparent),
          onTap: switch (props.onMessageTap) {
            final onMessageTap? => () => onMessageTap(message),
            _ => null,
          },
          onLongPress: switch (props.onMessageLongPress) {
            final onMessageLongPress? => () => onMessageLongPress(message),
            _ when message.state.isDeleted => null,
            _ when message.state.isOutgoing => null,
            _ => () => _onMessageLongPressed(context, message),
          },
          child: child,
        ),
        desktopOrWeb: (context, child) {
          final messageState = message.state;

          // If the message is deleted or not yet sent, we don't want to
          // show any context menu actions.
          if (messageState.isDeleted || messageState.isOutgoing) return child;

          final channel = StreamChannel.of(context).channel;
          final menuItems = _buildDesktopOrWebActions(context, message);
          if (menuItems.isEmpty) return MouseRegion(child: child);

          return ContextMenuRegion(
            onSelected: (result) {
              if (result is! MessageAction) return;
              return _onActionTap(context, channel, result).ignore();
            },
            menuBuilder: (_, anchor) => ContextMenu(
              anchor: anchor,
              menuItems: menuItems,
            ),
            child: MouseRegion(child: child),
          );
        },
        child: Align(
          alignment: StreamMessageLayout.alignmentDirectionalOf(context),
          child: Padding(
            padding: effectivePadding,
            child: Row(
              mainAxisSize: .min,
              spacing: effectiveSpacing,
              crossAxisAlignment: .end,
              children: [
                ?leadingWidget,
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: props.maxWidth),
                    child: contentWidget,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (props.swipeToReply && props.onReplyTap != null && !message.isDeleted && !message.state.isFailed) {
      result = _SwipeToReplyWrapper(
        message: message,
        onReplyTap: props.onReplyTap!,
        child: result,
      );
    }

    return result;
  }

  // Builds the action list for a bounced (moderation-error) message.
  List<StreamContextMenuAction> _buildBouncedErrorMessageActions({
    required BuildContext context,
    required Message message,
  }) {
    return StreamMessageActionsBuilder.buildBouncedErrorActions(
      context: context,
      message: message,
    );
  }

  // Builds the standard action list, applying the custom actionsBuilder if set.
  List<Widget> _buildMessageActions({
    required BuildContext context,
    required Message message,
    required Channel channel,
    OwnUser? currentUser,
  }) {
    final actions = StreamMessageActionsBuilder.buildActions(
      context: context,
      message: message,
      channel: channel,
      currentUser: currentUser,
    );

    if (props.actionsBuilder case final builder?) {
      return builder(context, actions);
    }

    return StreamContextMenuAction.partitioned(items: actions);
  }

  // Dispatches to bounced-error or normal actions for desktop/web.
  List<Widget> _buildDesktopOrWebActions(
    BuildContext context,
    Message message,
  ) {
    if (message.isBouncedWithError) {
      return _buildBouncedErrorMessageDesktopOrWebActions(context, message);
    }

    return _buildMessageDesktopOrWebActions(context, message);
  }

  // Builds partitioned bounced-error actions for the desktop/web context menu.
  List<Widget> _buildBouncedErrorMessageDesktopOrWebActions(
    BuildContext context,
    Message message,
  ) {
    final actions = StreamMessageActionsBuilder.buildBouncedErrorActions(
      context: context,
      message: message,
    );

    return StreamContextMenuAction.partitioned(items: actions);
  }

  // Builds normal actions + reaction picker for the desktop/web context menu.
  List<Widget> _buildMessageDesktopOrWebActions(
    BuildContext context,
    Message message,
  ) {
    final channel = StreamChannel.of(context).channel;
    final currentUser = channel.client.state.currentUser;
    final showPicker = channel.canSendReaction;

    final actions = _buildMessageActions(
      context: context,
      message: message,
      channel: channel,
      currentUser: currentUser,
    );

    void onReactionPicked(Reaction reaction) {
      final action = SelectReaction(message: message, reaction: reaction);
      return Navigator.pop(context, action); // Pop the modal with the selected reaction action
    }

    return [
      if (showPicker) StreamMessageReactionPicker(message: message, onReactionPicked: onReactionPicked),
      ...actions,
    ];
  }

  // Opens the reaction detail sheet and handles the returned action.
  Future<void> _showMessageReactionsModal(
    BuildContext context,
    Message message,
  ) async {
    final channel = StreamChannel.of(context).channel;

    final action = await ReactionDetailSheet.show(
      context: context,
      message: message,
    );

    if (action is! MessageAction) return;
    return _onActionTap(context, channel, action).ignore();
  }

  // Resolves the thread parent (fetching if shown in-channel) and invokes
  // the onThreadTap callback with both the parent and the original message.
  Future<void> _onViewThread(
    BuildContext context,
    Message message,
  ) async {
    try {
      if (message.showInChannel case true) {
        final streamChannel = StreamChannel.of(context);
        final parentMessage = await streamChannel.getMessage(message.parentId!);
        return props.onThreadTap?.call(parentMessage, message);
      }
      return props.onThreadTap?.call(message, null);
    } catch (e, stk) {
      debugPrint('Error while fetching message: $e, $stk');
    }
  }

  // Routes a long-press to bounced-error or normal actions handler.
  Future<void> _onMessageLongPressed(
    BuildContext context,
    Message message,
  ) {
    if (message.isBouncedWithError) {
      return _onBouncedErrorMessageActions(context, message);
    }

    return _onMessageActions(context, message);
  }

  // Delegates to the custom callback or falls back to the default dialog.
  Future<void> _onBouncedErrorMessageActions(
    BuildContext context,
    Message message,
  ) async {
    if (props.onBouncedErrorMessageActions case final onActions?) {
      return onActions(context, message);
    }

    return _showBouncedErrorMessageActionsDialog(context, message);
  }

  // Shows the ModeratedMessageActionsModal for a bounced-error message.
  Future<void> _showBouncedErrorMessageActionsDialog(
    BuildContext context,
    Message message,
  ) async {
    final channel = StreamChannel.of(context).channel;

    final actions = _buildBouncedErrorMessageActions(
      context: context,
      message: message,
    );

    final action = await showStreamDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => ModeratedMessageActionsModal(
        message: message,
        messageActions: actions,
      ),
    );

    if (action is! MessageAction) return;
    return _onActionTap(context, channel, action).ignore();
  }

  // Delegates to the custom callback or falls back to the default modal.
  Future<void> _onMessageActions(
    BuildContext context,
    Message message,
  ) async {
    if (props.onMessageActions case final onActions?) {
      return onActions(context, message);
    }

    return _showMessageActionModalDialog(context, message);
  }

  // Shows the StreamMessageActionsModal with a reaction picker and actions.
  Future<void> _showMessageActionModalDialog(
    BuildContext context,
    Message message,
  ) async {
    final channel = StreamChannel.of(context).channel;
    final currentUser = channel.client.state.currentUser;
    final showPicker = channel.canSendReaction;

    final actions = _buildMessageActions(
      context: context,
      message: message,
      channel: channel,
      currentUser: currentUser,
    );

    final layout = StreamMessageLayout.of(context);
    final theme = core.StreamMessageItemTheme.of(context);
    final defaults = _StreamMessageItemDefaults(
      context,
      isPinned: message.pinned,
      isEdited: message.messageTextUpdatedAt != null,
      state: message.state,
    );

    final resolve = core.StreamMessageLayoutResolver(layout, [theme, defaults]);
    final avatarVisibility = resolve((theme) => theme?.avatarVisibility);

    var leadingInset = 0.0;
    if (avatarVisibility != core.StreamVisibility.gone) {
      final effectiveAvatarSize = theme.avatarSize ?? defaults.avatarSize;
      final effectiveSpacing = props.spacing ?? theme.spacing ?? defaults.spacing;
      leadingInset = effectiveAvatarSize.value + effectiveSpacing;
    }

    final action = await showStreamDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => StreamChatConfiguration(
        data: StreamChatConfiguration.of(context),
        child: StreamMessageLayout(
          data: layout,
          child: StreamMessageActionsModal(
            message: message,
            messageActions: actions,
            showReactionPicker: showPicker,
            leadingInset: leadingInset,
            messageWidget: StreamChannel(
              channel: channel,
              child: StreamMessageItem(
                key: const Key('MessageItem'),
                message: message.trimmed,
                padding: EdgeInsets.zero,
                backgroundColor: core.StreamColors.transparent,
              ),
            ),
          ),
        ),
      ),
    );

    if (action is! MessageAction) return;
    return _onActionTap(context, channel, action).ignore();
  }

  // Dispatches a MessageAction to the appropriate channel or callback handler.
  Future<void> _onActionTap(
    BuildContext context,
    Channel channel,
    MessageAction action,
  ) async => switch (action) {
    SelectReaction() => _selectReaction(context, action.message, channel, action.reaction),
    CopyMessage() => _copyMessage(action.message, channel),
    DeleteMessage() => _maybeDeleteMessage(context, action.message, channel),
    HardDeleteMessage() => channel.deleteMessage(action.message, hard: true),
    EditMessage() => props.onEditMessageTap?.call(action.message),
    FlagMessage() => _maybeFlagMessage(context, action.message, channel),
    MarkUnread() => channel.markUnread(action.message.id),
    MuteUser() => channel.client.muteUser(action.user.id),
    UnmuteUser() => channel.client.unmuteUser(action.user.id),
    BlockUser() => channel.client.blockUser(action.user.id),
    UnblockUser() => channel.client.unblockUser(action.user.id),
    PinMessage() => channel.pinMessage(action.message),
    UnpinMessage() => channel.unpinMessage(action.message),
    ResendMessage() => channel.retryMessage(action.message),
    QuotedReply() => props.onReplyTap?.call(action.message),
    ThreadReply() => props.onThreadTap?.call(action.message, null),
  };

  // Copies the message text (with mentions replaced) to the clipboard.
  Future<void> _copyMessage(
    Message message,
    Channel channel,
  ) async {
    final presentableMessage = message.replaceMentions(linkify: false);

    final messageText = presentableMessage.text;
    if (messageText == null || messageText.isEmpty) return;

    return Clipboard.setData(ClipboardData(text: messageText));
  }

  // Shows a confirmation dialog before deleting the message.
  Future<EmptyResponse?> _maybeDeleteMessage(
    BuildContext context,
    Message message,
    Channel channel,
  ) async {
    final confirmDelete = await showStreamDialog<bool>(
      context: context,
      builder: (context) => StreamMessageActionConfirmationModal(
        title: Text(context.translations.deleteMessageLabel),
        content: Text(context.translations.deleteMessageQuestion),
        cancelActionTitle: Text(context.translations.cancelLabel),
        confirmActionTitle: Text(context.translations.deleteLabel),
        isDestructiveAction: true,
      ),
    );

    if (confirmDelete != true) return null;

    return channel.deleteMessage(message);
  }

  // Shows a confirmation dialog before flagging the message.
  Future<EmptyResponse?> _maybeFlagMessage(
    BuildContext context,
    Message message,
    Channel channel,
  ) async {
    final confirmFlag = await showStreamDialog<bool>(
      context: context,
      builder: (context) => StreamMessageActionConfirmationModal(
        title: Text(context.translations.flagMessageLabel),
        content: Text(context.translations.flagMessageQuestion),
        cancelActionTitle: Text(context.translations.cancelLabel),
        confirmActionTitle: Text(context.translations.flagLabel),
        isDestructiveAction: true,
      ),
    );

    if (confirmFlag != true) return null;

    final messageId = message.id;
    return channel.client.flagMessage(messageId);
  }

  // Toggles a reaction: removes it if already present, otherwise sends it.
  Future<Object> _selectReaction(
    BuildContext context,
    Message message,
    Channel channel,
    Reaction reaction,
  ) {
    final ownReactions = [...?message.ownReactions];
    final shouldDelete = ownReactions.any((it) => it.type == reaction.type);

    if (shouldDelete) {
      return channel.deleteReaction(message, reaction);
    }

    final configurations = StreamChatConfiguration.of(context);
    final enforceUnique = configurations.enforceUniqueReactions;

    return channel.sendReaction(
      message,
      reaction,
      enforceUnique: enforceUnique,
    );
  }
}

// Truncates long message text for display in the actions modal preview.
extension on Message {
  // Returns a copy with text and nested content truncated to 100 characters.
  Message get trimmed {
    final trimmedText = switch (text) {
      final text? when text.length > 100 => '${text.substring(0, 100)}...',
      _ => text,
    };

    return copyWith(
      text: trimmedText,
      poll: poll?.trimmed,
      quotedMessage: quotedMessage?.trimmed,
    );
  }
}

// Truncates long poll names for display in the actions modal preview.
extension on Poll {
  // Returns a copy with name truncated to 100 characters.
  Poll get trimmed {
    final trimmedName = switch (name) {
      final name when name.length > 100 => '${name.substring(0, 100)}...',
      _ => name,
    };

    return copyWith(name: trimmedName);
  }
}

class _SwipeToReplyWrapper extends StatelessWidget {
  const _SwipeToReplyWrapper({
    required this.message,
    required this.onReplyTap,
    required this.child,
  });

  final Message message;
  final void Function(Message) onReplyTap;
  final Widget child;

  static const _swipeThreshold = 0.2;

  @override
  Widget build(BuildContext context) {
    return Swipeable(
      key: ValueKey('swipe-${message.id}'),
      direction: SwipeDirection.startToEnd,
      swipeThreshold: _swipeThreshold,
      onSwiped: (_) => onReplyTap(message),
      backgroundBuilder: (context, details) {
        final colorScheme = context.streamColorScheme;
        final textDirection = Directionality.of(context);

        final progress = math.min(details.progress, _swipeThreshold) / _swipeThreshold;
        final offset = Offset.lerp(
          const Offset(-24, 0).directional(textDirection),
          const Offset(12, 0).directional(textDirection),
          progress,
        )!;

        return Align(
          alignment: AlignmentDirectional.centerStart,
          child: Transform.translate(
            offset: offset,
            child: Opacity(
              opacity: progress,
              child: SizedBox.square(
                dimension: 32,
                child: CustomPaint(
                  painter: AnimatedCircleBorderPainter(
                    progress: progress,
                    color: colorScheme.backgroundSurface,
                  ),
                  child: Center(
                    child: Icon(
                      context.streamIcons.reply,
                      color: colorScheme.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}

// Built-in fallback theme values for [DefaultStreamMessageItem].
//
// Used when neither the explicit props nor the ambient
// [StreamMessageItemThemeData] provide a value for a given property.
class _StreamMessageItemDefaults extends core.StreamMessageItemThemeData {
  _StreamMessageItemDefaults(
    this._context, {
    this.isPinned = false,
    this.isEdited = false,
    this.isBouncedWithError = false,
    required MessageState state,
  }) : _messageState = state;

  final bool isPinned;
  final bool isEdited;
  final bool isBouncedWithError;

  final BuildContext _context;
  final MessageState _messageState;

  late final core.StreamSpacing _spacing = _context.streamSpacing;
  late final core.StreamColorScheme _colorScheme = _context.streamColorScheme;

  @override
  double get spacing => _spacing.xs;

  @override
  StreamAvatarSize get avatarSize => .md;

  @override
  EdgeInsetsGeometry get padding => .symmetric(horizontal: _spacing.md);

  @override
  Color? get backgroundColor {
    if (isPinned && !_messageState.isDeleted) return _colorScheme.backgroundHighlight;
    return core.StreamColors.transparent;
  }

  @override
  core.StreamMessageLayoutVisibility get avatarVisibility => .resolveWith(
    (placement) => switch ((placement.channelKind, placement.alignment, placement.stackPosition)) {
      (.direct, _, _) || (_, .end, _) => .gone,
      (_, _, .top || .middle) => .hidden,
      (_, _, .single || .bottom) => .visible,
    },
  );

  @override
  core.StreamMessageLayoutVisibility get annotationVisibility => .all(.visible);

  @override
  core.StreamMessageLayoutVisibility get errorBadgeVisibility => .all(
    _messageState.isFailed || isBouncedWithError ? .visible : .gone,
  );

  @override
  core.StreamMessageLayoutVisibility get metadataVisibility {
    if (isEdited) return .all(.visible);
    return .resolveWith(
      (placement) => switch (placement.stackPosition) {
        .single || .bottom => .visible,
        _ => .gone,
      },
    );
  }

  @override
  core.StreamMessageLayoutVisibility get repliesVisibility => .resolveWith(
    (layout) => switch (layout.listKind) {
      .thread => .gone,
      .channel => .visible,
    },
  );
}
