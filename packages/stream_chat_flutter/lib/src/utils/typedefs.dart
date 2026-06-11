import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/command_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template inProgressBuilder}
/// A widget builder for representing in-progress attachment uploads.
/// {@endtemplate}
typedef InProgressBuilder = Widget Function(BuildContext, int, int);

/// {@template failedBuilder}
/// A widget builder for representing failed attachment uploads.
/// {@endtemplate}
typedef FailedBuilder = Widget Function(BuildContext, String);

/// {@template preparingBuilder}
/// A widget builder for representing pre-upload attachment state.
/// {@endtemplate}
typedef PreparingBuilder = WidgetBuilder;

/// {@template onAttachmentTap}
/// The action to perform when the attachment is tapped or clicked.
/// {@endtemplate}
typedef OnAttachmentTap = VoidCallback;

/// {@template showMessageCallback}
/// The action to perform when "show message" is tapped
/// {@endtemplate}
typedef ShowMessageCallback = void Function(Message message, Channel channel);

/// {@template showMessageCallback}
/// The action to perform when "reply message" is tapped
/// {@endtemplate}
typedef ReplyMessageCallback = void Function(Message message);

/// {@template onImageGroupAttachmentTap}
/// The action to perform when a specific image attachment in an [ImageGroup]
/// is tapped or clicked.
/// {@endtemplate}
typedef OnImageGroupAttachmentTap =
    void Function(
      Message message,
      Attachment attachment,
    );

/// {@template onUserAvatarPress}
/// The action to perform when a user's avatar is tapped, clicked, or
/// long-pressed.
/// {@endtemplate}
typedef OnUserAvatarPress = void Function(User);

/// {@template placeholderUserImage}
/// A widget builder that will build placeholder user images while loading a
/// user image.
/// {@endtemplate}
typedef PlaceholderUserImage = Widget Function(BuildContext, User);

/// {@template editMessageInputBuilder}
/// A widget builder for building a pre-populated [MessageInput] for use in
/// editing messages.
/// {@endtemplate}
typedef EditMessageInputBuilder = Widget Function(BuildContext, Message);

/// {@template channelListHeaderTitleBuilder}
/// A widget builder for custom [ChannelListHeader] title widgets.
/// {@endtemplate}
typedef ChannelListHeaderTitleBuilder =
    Widget Function(
      BuildContext context,
      ConnectionStatus status,
      StreamChatClient client,
    );

/// {@template channelTapCallback}
/// The action to perform when a channel is tapped or clicked.
/// {@endtemplate}
typedef ChannelTapCallback = void Function(Channel, Widget?);

/// {@template channelInfoCallback}
/// The action to perform when a particular channel slidable option is tapped
/// or clicked.
/// {@endtemplate}
typedef ChannelInfoCallback = void Function(Channel);

/// {@template viewInfoCallback}
/// Callback for when 'View Info' is tapped
/// {@endtemplate}
typedef ViewInfoCallback = void Function(Channel);

/// {@template errorListener}
/// A callback that can be passed to [StreamMessageComposer.onError].
///
/// This callback should not throw.
///
/// It exists merely for error reporting, and should not be used otherwise.
/// {@endtemplate}
typedef ErrorListener =
    void Function(
      Object error,
      StackTrace? stackTrace,
    );

/// {@template attachmentThumbnailBuilder}
/// A widget builder for representing attachment thumbnails.
/// {@endtemplate}
typedef AttachmentThumbnailBuilder =
    Widget Function(
      BuildContext,
      Attachment,
    );

/// {@template mentionTileBuilder}
/// A widget builder for representing a custom mention tile.
/// {@endtemplate}
typedef MentionTileBuilder =
    Widget Function(
      BuildContext context,
      Member member,
    );

/// {@template mentionTileOverlayBuilder}
/// A widget builder for representing a custom mention tile within a
/// [UserMentionsOverlay].
/// {@endtemplate}
typedef MentionTileOverlayBuilder =
    Widget Function(
      BuildContext context,
      User user,
    );

/// A builder function for representing a custom role mention tile.
typedef MentionRoleTileBuilder =
    Widget Function(
      BuildContext context,
      Role role,
    );

/// A builder function for representing a custom user group mention tile.
typedef MentionUserGroupTileBuilder =
    Widget Function(
      BuildContext context,
      UserGroup userGroup,
    );

/// {@template userMentionTileBuilder}
/// A builder function for representing a custom user mention tile.
///
/// Use [UserMentionTile] for the default implementation.
/// {@endtemplate}
typedef UserMentionTileBuilder =
    Widget Function(
      BuildContext context,
      User user,
    );

/// {@template actionButtonBuilder}
/// A widget builder for building a custom command button.
///
/// [commandButton] is the default [CommandButton] configuration,
/// use [commandButton.copyWith] to easily customize it.
/// {@endtemplate}
typedef CommandButtonBuilder =
    Widget Function(
      BuildContext context,
      CommandButton commandButton,
    );

/// {@template quotedMessageAttachmentThumbnailBuilder}
/// A widget builder for building a custom quoted message attachment thumbnail.
/// {@endtemplate}
typedef QuotedMessageAttachmentThumbnailBuilder =
    Widget Function(
      BuildContext,
      Attachment,
    );

/// {@template attachmentBuilder}
/// A widget builder for representing attachments.
/// {@endtemplate}
typedef AttachmentBuilder =
    Widget Function(
      BuildContext,
      Message,
      List<Attachment>,
    );

/// {@template onQuotedMessageTap}
/// The action to perform when a quoted message is tapped.
/// {@endtemplate}
typedef OnQuotedMessageTap = void Function(String?);

/// {@template onMessageTap}
/// The action to perform when a message is tapped.
/// {@endtemplate}
typedef OnMessageTap = void Function(Message);

/// {@template onMessageLongPress}
/// The action to perform when a message is long pressed.
/// {@endtemplate}
typedef OnMessageLongPress = void Function(Message);

/// {@template onReactionsTap}
/// The action to perform when a message's reactions are tapped.
/// {@endtemplate}
typedef OnReactionsTap = void Function(Message);

/// {@template onReactionsHover}
/// The action to perform when a message's reactions are hovered.
/// {@endtemplate}
// ignore: avoid_positional_boolean_parameters
typedef OnReactionsHover = void Function(bool isHovering);

/// {@template messageSearchItemTapCallback}
/// The action to perform when tapping or clicking on a user in a
/// [MessageSearchListView].
/// {@endtemplate}
typedef MessageSearchItemTapCallback = void Function(GetMessageResponse);

/// {@template messageSearchItemBuilder}
/// A widget builder used to create a custom [ListUserItem] from a [User].
/// {@endtemplate}
typedef MessageSearchItemBuilder =
    Widget Function(
      BuildContext,
      GetMessageResponse,
    );

// Legacy MessageBuilder and ParentMessageBuilder typedefs removed.
// Use StreamMessageItemBuilder from message_list_view.dart instead.

/// {@template systemMessageBuilder}
/// A widget builder for creating custom system messages.
/// {@endtemplate}
typedef SystemMessageBuilder =
    Widget Function(
      BuildContext,
      Message,
    );

/// {@template ephemeralMessageBuilder}
/// A widget builder for creating custom ephemeral messages.
/// {@endtemplate}
typedef EphemeralMessageBuilder =
    Widget Function(
      BuildContext,
      Message,
    );

/// {@template moderatedMessageBuilder}
/// A widget builder for creating custom moderated messages.
/// {@endtemplate}
typedef ModeratedMessageBuilder =
    Widget Function(
      BuildContext,
      Message,
    );

/// {@template threadBuilder}
/// A widget builder for creating custom thread UI.
/// {@endtemplate}
typedef ThreadBuilder = Widget Function(BuildContext context, Message? parent);

/// {@template threadTapCallback}
/// The action to perform when threads are tapped.
/// {@endtemplate}
typedef ThreadTapCallback = void Function(Message, Widget?);

/// {@template spacingWidgetBuilder}
/// Builds the spacing widget inserted between two adjacent messages on the
/// same calendar day in a [StreamMessageListView].
///
/// A list of [SpacingType] values describes why the gap exists — for example,
/// a sender change ([SpacingType.otherUser]), a time gap
/// ([SpacingType.timeDiff]), or messages within the same group
/// ([SpacingType.defaultSpacing]).
///
/// {@tool snippet}
///
/// Customise spacing per reason:
///
/// ```dart
/// StreamMessageListView(
///   spacingWidgetBuilder: (context, spacingTypes) {
///     if (spacingTypes.contains(SpacingType.otherUser)) {
///       return const SizedBox(height: 16);
///     } else if (spacingTypes.contains(SpacingType.timeDiff)) {
///       return const SizedBox(height: 8);
///     }
///     return const SizedBox(height: 2);
///   },
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [SpacingType], which describes each possible reason for the gap.
///  * [StreamMessageListView.spacingWidgetBuilder], where this builder is
///    provided.
/// {@endtemplate}
typedef SpacingWidgetBuilder = Widget Function(BuildContext context, List<SpacingType> spacingTypes);

/// {@template attachmentDownloader}
/// A callback for downloading an attachment asset.
/// {@endtemplate}
/// Callback to download an attachment asset
typedef AttachmentDownloader =
    Future<String> Function(
      Attachment attachment, {
      ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      bool deleteOnError,
      Options? options,
    });

/// Callback to receive the path once the attachment asset is downloaded
typedef DownloadedPathCallback = void Function(String? path);

/// {@template userTapCallback}
/// Callback called when tapping on a user
/// {@endtemplate}
typedef UserTapCallback = void Function(User, Widget?);

/// {@template rawKeyEventPredicate}
/// Callback called to react to a key event
/// {@endtemplate}
typedef KeyEventPredicate = bool Function(FocusNode, KeyEvent);

/// {@template userItemBuilder}
/// Builder used to create a custom [ListUserItem] from a [User]
/// {@endtemplate}
// ignore: avoid_positional_boolean_parameters
typedef UserItemBuilder = Widget Function(BuildContext, User, bool);

/// The action to perform when the "scroll to bottom" button is pressed
/// within a [MessageListView].
typedef OnScrollToBottom = Function(int unreadCount);

/// Widget builder for widgets that may require data from the
/// [StreamMessageComposerController].
typedef MessageRelatedBuilder =
    Widget Function(
      BuildContext context,
      StreamMessageComposerController messageComposerController,
    );

/// A function that returns true if the message is valid and can be sent.
typedef MessageValidator = bool Function(Message message);
