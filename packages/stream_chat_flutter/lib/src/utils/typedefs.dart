import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/attachment_button.dart';
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

/// {@template successBuilder}
/// A widget builder for representing successful attachment uploads.
/// {@endtemplate}
typedef SuccessBuilder = WidgetBuilder;

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
typedef OnImageGroupAttachmentTap = void Function(
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
// ignore: deprecated_member_use_from_same_package
/// A widget builder for building a pre-populated [MessageInput] for use in
/// editing messages.
/// {@endtemplate}
typedef EditMessageInputBuilder = Widget Function(BuildContext, Message);

/// {@template channelListHeaderTitleBuilder}
// ignore: deprecated_member_use_from_same_package
/// A widget builder for custom [ChannelListHeader] title widgets.
/// {@endtemplate}
typedef ChannelListHeaderTitleBuilder = Widget Function(
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

/// {@template channelPreviewBuilder}
/// Builder used to create a custom [ChannelPreview] for a [Channel]
/// {@endtemplate}
typedef ChannelPreviewBuilder = Widget Function(BuildContext, Channel);

/// {@template viewInfoCallback}
/// Callback for when 'View Info' is tapped
/// {@endtemplate}
typedef ViewInfoCallback = void Function(Channel);

/// {@template attachmentActionsBuilder}
/// A widget builder for representing the actions a user can take on an
/// attachment.
///
/// [defaultActionsModal] is the default [AttachmentActionsModal] configuration.
/// Use [defaultActionsModal.copyWith] to easily customize it
/// {@endtemplate}
typedef AttachmentActionsBuilder = Widget Function(
  BuildContext context,
  Attachment attachment,
  AttachmentActionsModal defaultActionsModal,
);

/// {@template errorListener}
/// A callback that can be passed to [StreamMessageInput.onError].
///
/// This callback should not throw.
///
/// It exists merely for error reporting, and should not be used otherwise.
/// {@endtemplate}
typedef ErrorListener = void Function(
  Object error,
  StackTrace? stackTrace,
);

/// {@template attachmentLimitExceededListener}
/// A callback that can be passed to
/// [StreamMessageInput.onAttachmentLimitExceed].
///
/// This callback should not throw.
///
/// It exists merely for showing custom error, and should not be used otherwise.
/// {@endtemplate}
typedef AttachmentLimitExceedListener = void Function(
  int limit,
  String error,
);

/// {@template attachmentThumbnailBuilder}
/// A widget builder for representing attachment thumbnails.
/// {@endtemplate}
typedef AttachmentThumbnailBuilder = Widget Function(
  BuildContext,
  Attachment,
);

/// {@macro mentionTileBuilder}
/// A widget builder for representing a custom mention tile.
/// {@endtemplate}
typedef MentionTileBuilder = Widget Function(
  BuildContext context,
  Member member,
);

/// {@template mentionTileOverlayBuilder}
/// A widget builder for representing a custom mention tile within a
/// [UserMentionsOverlay].
/// {@endtemplate}
typedef MentionTileOverlayBuilder = Widget Function(
  BuildContext context,
  User user,
);

/// {@template userMentionTileBuilder}
/// A builder function for representing a custom user mention tile.
///
// ignore: deprecated_member_use_from_same_package
/// Use [UserMentionTile] for the default implementation.
/// {@endtemplate}
typedef UserMentionTileBuilder = Widget Function(
  BuildContext context,
  User user,
);

/// {@template actionButtonBuilder}
/// A widget builder for building a custom command button.
///
/// [commandButton] is the default [CommandButton] configuration,
/// use [commandButton.copyWith] to easily customize it.
/// {@endtemplate}
typedef CommandButtonBuilder = Widget Function(
  BuildContext context,
  CommandButton commandButton,
);

/// {@template actionButtonBuilder}
/// A widget builder for building a custom action button.
///
/// [attachmentButton] is the default [AttachmentButton] configuration,
/// use [attachmentButton.copyWith] to easily customize it.
/// {@endtemplate}
typedef AttachmentButtonBuilder = Widget Function(
  BuildContext context,
  AttachmentButton attachmentButton,
);

/// {@template quotedMessageAttachmentThumbnailBuilder}
/// A widget builder for building a custom quoted message attachment thumbnail.
/// {@endtemplate}
typedef QuotedMessageAttachmentThumbnailBuilder = Widget Function(
  BuildContext,
  Attachment,
);

/// {@template onMessageWidgetAttachmentTap}
/// The action to perform when an attachment in an [StreamMessageWidget]
/// is tapped or clicked.
/// {@endtemplate}
typedef OnMessageWidgetAttachmentTap = void Function(
  Message message,
  Attachment attachment,
);

/// {@template attachmentBuilder}
/// A widget builder for representing attachments.
/// {@endtemplate}
typedef AttachmentBuilder = Widget Function(
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

/// {@template messageSearchItemTapCallback}
/// The action to perform when tapping or clicking on a user in a
// ignore: deprecated_member_use_from_same_package
/// [MessageSearchListView].
/// {@endtemplate}
typedef MessageSearchItemTapCallback = void Function(GetMessageResponse);

/// {@template messageSearchItemBuilder}
/// A widget builder used to create a custom [ListUserItem] from a [User].
/// {@endtemplate}
typedef MessageSearchItemBuilder = Widget Function(
  BuildContext,
  GetMessageResponse,
);

/// {@template messageBuilder}
/// A widget builder for creating custom message UI.
///
/// [defaultMessageWidget] is the default [StreamMessageWidget] configuration.
/// Use [defaultMessageWidget.copyWith] to customize it.
/// {@endtemplate}
typedef MessageBuilder = Widget Function(
  BuildContext,
  MessageDetails,
  List<Message>,
  StreamMessageWidget defaultMessageWidget,
);

/// {@template parentMessageBuilder}
/// A widget builder for creating custom parent message UI.
///
/// [defaultMessageWidget] is the default [StreamMessageWidget] configuration.
/// Use [defaultMessageWidget.copyWith] to customize it.
/// {@endtemplate}
typedef ParentMessageBuilder = Widget Function(
  BuildContext,
  Message?,
  StreamMessageWidget defaultMessageWidget,
);

/// {@template systemMessageBuilder}
/// A widget builder for creating custom system messages.
/// {@endtemplate}
typedef SystemMessageBuilder = Widget Function(
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

/// {@template onMessageSwiped}
/// The action to perform when a message is swiped.
/// {@endtemplate}
typedef OnMessageSwiped = void Function(Message);

/// {@template spacingWidgetBuilder}
/// A widget builder for creating certain spacing after widgets.
///
/// This spacing can be in the form of any widgets you like.
///
/// A List of [SpacingType] is provided to help inform the decision of
/// what to build after the message (thread, difference in time between
/// current and last message, default spacing, etc).
///
/// Example:
/// ```dart
/// MessageListView(
///   spacingWidgetBuilder: (context, list) {
///     if(list.contains(SpacingType.defaultSpacing)) {
///       return SizedBox(height: 2.0,);
///     } else {
///       return SizedBox(height: 8.0,);
///     }
///   },
/// ),
/// ```dart
/// {@endtemplate}
typedef SpacingWidgetBuilder = Widget Function(
  BuildContext context,
  List<SpacingType> spacingTypes,
);

/// {@template attachmentDownloader}
/// A callback for downloading an attachment asset.
/// {@endtemplate}
/// Callback to download an attachment asset
typedef AttachmentDownloader = Future<String> Function(
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

/// {@template userItemBuilder}
/// Builder used to create a custom [ListUserItem] from a [User]
/// {@endtemplate}
typedef UserItemBuilder = Widget Function(BuildContext, User, bool);

/// The action to perform when the "scroll to bottom" button is pressed
/// within a [MessageListView].
typedef OnScrollToBottom = Function(int unreadCount);

/// Widget builder for widgets that may require data from the
/// [MessageInputController].
typedef MessageRelatedBuilder = Widget Function(
  BuildContext context,
  StreamMessageInputController messageInputController,
);

/// A function that returns true if the message is valid and can be sent.
typedef MessageValidator = bool Function(Message message);
