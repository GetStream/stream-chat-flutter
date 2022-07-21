// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'stream_chat_analytics_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

StreamChatAnalyticsEvent _$StreamChatAnalyticsEventFromJson(
    Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'channelListView':
      return StreamChannelListViewEventModel.fromJson(json);
    case 'channelListTileClick':
      return StreamChannelListTileClickEventModel.fromJson(json);
    case 'channelListTileAvatarClick':
      return StreamChannelListTileAvatarClickEventModel.fromJson(json);
    case 'messageInputFocus':
      return StreamMessageInputFocusEventModel.fromJson(json);
    case 'messageInputTypingStarted':
      return StreamMessageInputTypingStartedEventModel.fromJson(json);
    case 'messageInputSendButtonClick':
      return StreamMessageInputSendButtonClickEventModel.fromJson(json);
    case 'messageInputAttachmentButtonClick':
      return StreamMessageInputAttachmentButtonClickEventModel.fromJson(json);
    case 'messageInputCommandButtonClick':
      return StreamMessageInputCommandButtonClickEventModel.fromJson(json);
    case 'messageInputAttachmentActionClick':
      return StreamMessageInputAttachmentActionClickEventModel.fromJson(json);
    case 'channelHeaderBackButtonClick':
      return StreamChannelHeaderBackButtonClickEventModel.fromJson(json);
    case 'channelHeaderAvatarClick':
      return StreamChannelHeaderAvatarClickEventModel.fromJson(json);
    case 'messageListView':
      return StreamMessageListViewEventModel.fromJson(json);
    case 'messageListScrollToBottomClick':
      return StreamMessageListScrollToBottomClickEventModel.fromJson(json);
    case 'messageMentionClick':
      return StreamMessageMentionClickEventModel.fromJson(json);
    case 'messageUrlClick':
      return StreamMessageUrlClickEventModel.fromJson(json);
    case 'messageActionsTrigger':
      return StreamMessageActionsTriggerEventModel.fromJson(json);
    case 'messageReactionClick':
      return StreamMessageReactionClickEventModel.fromJson(json);
    case 'messageActionClick':
      return StreamMessageActionClickEventModel.fromJson(json);
    case 'messageAttachmentClick':
      return StreamMessageAttachmentClickEventModel.fromJson(json);
    case 'attachmentFullScreenView':
      return StreamAttachmentFullScreenViewEventModel.fromJson(json);
    case 'attachmentFullScreenShareButtonClick':
      return StreamAttachmentFullScreenShareButtonClickEventModel.fromJson(
          json);
    case 'attachmentFullScreenGridButtonClick':
      return StreamAttachmentFullScreenGridButtonClickEventModel.fromJson(json);
    case 'attachmentFullScreenCloseButtonClick':
      return StreamAttachmentFullScreenCloseButtonClickEventModel.fromJson(
          json);
    case 'attachmentFullScreenActionsMenuClick':
      return StreamAttachmentFullScreenActionsMenuClickEventModel.fromJson(
          json);
    case 'attachmentFullScreenActionItemClick':
      return StreamAttachmentFullScreenActionItemClickEventModel.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json,
          'runtimeType',
          'StreamChatAnalyticsEvent',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$StreamChatAnalyticsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreamChatAnalyticsEventCopyWith<$Res> {
  factory $StreamChatAnalyticsEventCopyWith(StreamChatAnalyticsEvent value,
          $Res Function(StreamChatAnalyticsEvent) then) =
      _$StreamChatAnalyticsEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements $StreamChatAnalyticsEventCopyWith<$Res> {
  _$StreamChatAnalyticsEventCopyWithImpl(this._value, this._then);

  final StreamChatAnalyticsEvent _value;
  // ignore: unused_field
  final $Res Function(StreamChatAnalyticsEvent) _then;
}

/// @nodoc
abstract class _$$StreamChannelListViewEventModelCopyWith<$Res> {
  factory _$$StreamChannelListViewEventModelCopyWith(
          _$StreamChannelListViewEventModel value,
          $Res Function(_$StreamChannelListViewEventModel) then) =
      __$$StreamChannelListViewEventModelCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StreamChannelListViewEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamChannelListViewEventModelCopyWith<$Res> {
  __$$StreamChannelListViewEventModelCopyWithImpl(
      _$StreamChannelListViewEventModel _value,
      $Res Function(_$StreamChannelListViewEventModel) _then)
      : super(_value, (v) => _then(v as _$StreamChannelListViewEventModel));

  @override
  _$StreamChannelListViewEventModel get _value =>
      super._value as _$StreamChannelListViewEventModel;
}

/// @nodoc
@JsonSerializable()
class _$StreamChannelListViewEventModel
    implements StreamChannelListViewEventModel {
  const _$StreamChannelListViewEventModel({final String? $type})
      : $type = $type ?? 'channelListView';

  factory _$StreamChannelListViewEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamChannelListViewEventModelFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.channelListView()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamChannelListViewEventModel);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return channelListView();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return channelListView?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (channelListView != null) {
      return channelListView();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return channelListView(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return channelListView?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (channelListView != null) {
      return channelListView(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamChannelListViewEventModelToJson(
      this,
    );
  }
}

abstract class StreamChannelListViewEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamChannelListViewEventModel() =
      _$StreamChannelListViewEventModel;

  factory StreamChannelListViewEventModel.fromJson(Map<String, dynamic> json) =
      _$StreamChannelListViewEventModel.fromJson;
}

/// @nodoc
abstract class _$$StreamChannelListTileClickEventModelCopyWith<$Res> {
  factory _$$StreamChannelListTileClickEventModelCopyWith(
          _$StreamChannelListTileClickEventModel value,
          $Res Function(_$StreamChannelListTileClickEventModel) then) =
      __$$StreamChannelListTileClickEventModelCopyWithImpl<$Res>;
  $Res call({String channelId, int unreadMessageCount});
}

/// @nodoc
class __$$StreamChannelListTileClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamChannelListTileClickEventModelCopyWith<$Res> {
  __$$StreamChannelListTileClickEventModelCopyWithImpl(
      _$StreamChannelListTileClickEventModel _value,
      $Res Function(_$StreamChannelListTileClickEventModel) _then)
      : super(
            _value, (v) => _then(v as _$StreamChannelListTileClickEventModel));

  @override
  _$StreamChannelListTileClickEventModel get _value =>
      super._value as _$StreamChannelListTileClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? unreadMessageCount = freezed,
  }) {
    return _then(_$StreamChannelListTileClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      unreadMessageCount: unreadMessageCount == freezed
          ? _value.unreadMessageCount
          : unreadMessageCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamChannelListTileClickEventModel
    implements StreamChannelListTileClickEventModel {
  const _$StreamChannelListTileClickEventModel(
      {required this.channelId,
      required this.unreadMessageCount,
      final String? $type})
      : $type = $type ?? 'channelListTileClick';

  factory _$StreamChannelListTileClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamChannelListTileClickEventModelFromJson(json);

  /// The id of the channel that was clicked
  @override
  final String channelId;

  /// The number of unread messages at the moment
  @override
  final int unreadMessageCount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.channelListTileClick(channelId: $channelId, unreadMessageCount: $unreadMessageCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamChannelListTileClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality()
                .equals(other.unreadMessageCount, unreadMessageCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(unreadMessageCount));

  @JsonKey(ignore: true)
  @override
  _$$StreamChannelListTileClickEventModelCopyWith<
          _$StreamChannelListTileClickEventModel>
      get copyWith => __$$StreamChannelListTileClickEventModelCopyWithImpl<
          _$StreamChannelListTileClickEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return channelListTileClick(channelId, unreadMessageCount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return channelListTileClick?.call(channelId, unreadMessageCount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (channelListTileClick != null) {
      return channelListTileClick(channelId, unreadMessageCount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return channelListTileClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return channelListTileClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (channelListTileClick != null) {
      return channelListTileClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamChannelListTileClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamChannelListTileClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamChannelListTileClickEventModel(
          {required final String channelId,
          required final int unreadMessageCount}) =
      _$StreamChannelListTileClickEventModel;

  factory StreamChannelListTileClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamChannelListTileClickEventModel.fromJson;

  /// The id of the channel that was clicked
  String get channelId;

  /// The number of unread messages at the moment
  int get unreadMessageCount;
  @JsonKey(ignore: true)
  _$$StreamChannelListTileClickEventModelCopyWith<
          _$StreamChannelListTileClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamChannelListTileAvatarClickEventModelCopyWith<$Res> {
  factory _$$StreamChannelListTileAvatarClickEventModelCopyWith(
          _$StreamChannelListTileAvatarClickEventModel value,
          $Res Function(_$StreamChannelListTileAvatarClickEventModel) then) =
      __$$StreamChannelListTileAvatarClickEventModelCopyWithImpl<$Res>;
  $Res call({String channelId, int unreadMessageCount});
}

/// @nodoc
class __$$StreamChannelListTileAvatarClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamChannelListTileAvatarClickEventModelCopyWith<$Res> {
  __$$StreamChannelListTileAvatarClickEventModelCopyWithImpl(
      _$StreamChannelListTileAvatarClickEventModel _value,
      $Res Function(_$StreamChannelListTileAvatarClickEventModel) _then)
      : super(_value,
            (v) => _then(v as _$StreamChannelListTileAvatarClickEventModel));

  @override
  _$StreamChannelListTileAvatarClickEventModel get _value =>
      super._value as _$StreamChannelListTileAvatarClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? unreadMessageCount = freezed,
  }) {
    return _then(_$StreamChannelListTileAvatarClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      unreadMessageCount: unreadMessageCount == freezed
          ? _value.unreadMessageCount
          : unreadMessageCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamChannelListTileAvatarClickEventModel
    implements StreamChannelListTileAvatarClickEventModel {
  const _$StreamChannelListTileAvatarClickEventModel(
      {required this.channelId,
      required this.unreadMessageCount,
      final String? $type})
      : $type = $type ?? 'channelListTileAvatarClick';

  factory _$StreamChannelListTileAvatarClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamChannelListTileAvatarClickEventModelFromJson(json);

  /// The id of the channel that was clicked
  @override
  final String channelId;

  /// The number of unread messages at the moment
  @override
  final int unreadMessageCount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.channelListTileAvatarClick(channelId: $channelId, unreadMessageCount: $unreadMessageCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamChannelListTileAvatarClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality()
                .equals(other.unreadMessageCount, unreadMessageCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(unreadMessageCount));

  @JsonKey(ignore: true)
  @override
  _$$StreamChannelListTileAvatarClickEventModelCopyWith<
          _$StreamChannelListTileAvatarClickEventModel>
      get copyWith =>
          __$$StreamChannelListTileAvatarClickEventModelCopyWithImpl<
              _$StreamChannelListTileAvatarClickEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return channelListTileAvatarClick(channelId, unreadMessageCount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return channelListTileAvatarClick?.call(channelId, unreadMessageCount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (channelListTileAvatarClick != null) {
      return channelListTileAvatarClick(channelId, unreadMessageCount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return channelListTileAvatarClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return channelListTileAvatarClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (channelListTileAvatarClick != null) {
      return channelListTileAvatarClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamChannelListTileAvatarClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamChannelListTileAvatarClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamChannelListTileAvatarClickEventModel(
          {required final String channelId,
          required final int unreadMessageCount}) =
      _$StreamChannelListTileAvatarClickEventModel;

  factory StreamChannelListTileAvatarClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamChannelListTileAvatarClickEventModel.fromJson;

  /// The id of the channel that was clicked
  String get channelId;

  /// The number of unread messages at the moment
  int get unreadMessageCount;
  @JsonKey(ignore: true)
  _$$StreamChannelListTileAvatarClickEventModelCopyWith<
          _$StreamChannelListTileAvatarClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamMessageInputFocusEventModelCopyWith<$Res> {
  factory _$$StreamMessageInputFocusEventModelCopyWith(
          _$StreamMessageInputFocusEventModel value,
          $Res Function(_$StreamMessageInputFocusEventModel) then) =
      __$$StreamMessageInputFocusEventModelCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StreamMessageInputFocusEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageInputFocusEventModelCopyWith<$Res> {
  __$$StreamMessageInputFocusEventModelCopyWithImpl(
      _$StreamMessageInputFocusEventModel _value,
      $Res Function(_$StreamMessageInputFocusEventModel) _then)
      : super(_value, (v) => _then(v as _$StreamMessageInputFocusEventModel));

  @override
  _$StreamMessageInputFocusEventModel get _value =>
      super._value as _$StreamMessageInputFocusEventModel;
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageInputFocusEventModel
    implements StreamMessageInputFocusEventModel {
  const _$StreamMessageInputFocusEventModel({final String? $type})
      : $type = $type ?? 'messageInputFocus';

  factory _$StreamMessageInputFocusEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageInputFocusEventModelFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageInputFocus()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageInputFocusEventModel);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputFocus();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputFocus?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageInputFocus != null) {
      return messageInputFocus();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputFocus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputFocus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageInputFocus != null) {
      return messageInputFocus(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageInputFocusEventModelToJson(
      this,
    );
  }
}

abstract class StreamMessageInputFocusEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageInputFocusEventModel() =
      _$StreamMessageInputFocusEventModel;

  factory StreamMessageInputFocusEventModel.fromJson(
      Map<String, dynamic> json) = _$StreamMessageInputFocusEventModel.fromJson;
}

/// @nodoc
abstract class _$$StreamMessageInputTypingStartedEventModelCopyWith<$Res> {
  factory _$$StreamMessageInputTypingStartedEventModelCopyWith(
          _$StreamMessageInputTypingStartedEventModel value,
          $Res Function(_$StreamMessageInputTypingStartedEventModel) then) =
      __$$StreamMessageInputTypingStartedEventModelCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StreamMessageInputTypingStartedEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageInputTypingStartedEventModelCopyWith<$Res> {
  __$$StreamMessageInputTypingStartedEventModelCopyWithImpl(
      _$StreamMessageInputTypingStartedEventModel _value,
      $Res Function(_$StreamMessageInputTypingStartedEventModel) _then)
      : super(_value,
            (v) => _then(v as _$StreamMessageInputTypingStartedEventModel));

  @override
  _$StreamMessageInputTypingStartedEventModel get _value =>
      super._value as _$StreamMessageInputTypingStartedEventModel;
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageInputTypingStartedEventModel
    implements StreamMessageInputTypingStartedEventModel {
  const _$StreamMessageInputTypingStartedEventModel({final String? $type})
      : $type = $type ?? 'messageInputTypingStarted';

  factory _$StreamMessageInputTypingStartedEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageInputTypingStartedEventModelFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageInputTypingStarted()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageInputTypingStartedEventModel);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputTypingStarted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputTypingStarted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageInputTypingStarted != null) {
      return messageInputTypingStarted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputTypingStarted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputTypingStarted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageInputTypingStarted != null) {
      return messageInputTypingStarted(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageInputTypingStartedEventModelToJson(
      this,
    );
  }
}

abstract class StreamMessageInputTypingStartedEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageInputTypingStartedEventModel() =
      _$StreamMessageInputTypingStartedEventModel;

  factory StreamMessageInputTypingStartedEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageInputTypingStartedEventModel.fromJson;
}

/// @nodoc
abstract class _$$StreamMessageInputSendButtonClickEventModelCopyWith<$Res> {
  factory _$$StreamMessageInputSendButtonClickEventModelCopyWith(
          _$StreamMessageInputSendButtonClickEventModel value,
          $Res Function(_$StreamMessageInputSendButtonClickEventModel) then) =
      __$$StreamMessageInputSendButtonClickEventModelCopyWithImpl<$Res>;
  $Res call(
      {bool hasText,
      bool hasAttachments,
      bool hasMentions,
      bool hasCustomCommands});
}

/// @nodoc
class __$$StreamMessageInputSendButtonClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageInputSendButtonClickEventModelCopyWith<$Res> {
  __$$StreamMessageInputSendButtonClickEventModelCopyWithImpl(
      _$StreamMessageInputSendButtonClickEventModel _value,
      $Res Function(_$StreamMessageInputSendButtonClickEventModel) _then)
      : super(_value,
            (v) => _then(v as _$StreamMessageInputSendButtonClickEventModel));

  @override
  _$StreamMessageInputSendButtonClickEventModel get _value =>
      super._value as _$StreamMessageInputSendButtonClickEventModel;

  @override
  $Res call({
    Object? hasText = freezed,
    Object? hasAttachments = freezed,
    Object? hasMentions = freezed,
    Object? hasCustomCommands = freezed,
  }) {
    return _then(_$StreamMessageInputSendButtonClickEventModel(
      hasText: hasText == freezed
          ? _value.hasText
          : hasText // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAttachments: hasAttachments == freezed
          ? _value.hasAttachments
          : hasAttachments // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMentions: hasMentions == freezed
          ? _value.hasMentions
          : hasMentions // ignore: cast_nullable_to_non_nullable
              as bool,
      hasCustomCommands: hasCustomCommands == freezed
          ? _value.hasCustomCommands
          : hasCustomCommands // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageInputSendButtonClickEventModel
    implements StreamMessageInputSendButtonClickEventModel {
  const _$StreamMessageInputSendButtonClickEventModel(
      {required this.hasText,
      required this.hasAttachments,
      required this.hasMentions,
      required this.hasCustomCommands,
      final String? $type})
      : $type = $type ?? 'messageInputSendButtonClick';

  factory _$StreamMessageInputSendButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageInputSendButtonClickEventModelFromJson(json);

  /// Does the message being sent have text?
  @override
  final bool hasText;

  /// Does the message being sent have attachments?
  @override
  final bool hasAttachments;

  /// Does the message being sent have user mentions?
  @override
  final bool hasMentions;

  /// Does the message being sent have custom commands?
  @override
  final bool hasCustomCommands;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageInputSendButtonClick(hasText: $hasText, hasAttachments: $hasAttachments, hasMentions: $hasMentions, hasCustomCommands: $hasCustomCommands)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageInputSendButtonClickEventModel &&
            const DeepCollectionEquality().equals(other.hasText, hasText) &&
            const DeepCollectionEquality()
                .equals(other.hasAttachments, hasAttachments) &&
            const DeepCollectionEquality()
                .equals(other.hasMentions, hasMentions) &&
            const DeepCollectionEquality()
                .equals(other.hasCustomCommands, hasCustomCommands));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(hasText),
      const DeepCollectionEquality().hash(hasAttachments),
      const DeepCollectionEquality().hash(hasMentions),
      const DeepCollectionEquality().hash(hasCustomCommands));

  @JsonKey(ignore: true)
  @override
  _$$StreamMessageInputSendButtonClickEventModelCopyWith<
          _$StreamMessageInputSendButtonClickEventModel>
      get copyWith =>
          __$$StreamMessageInputSendButtonClickEventModelCopyWithImpl<
              _$StreamMessageInputSendButtonClickEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputSendButtonClick(
        hasText, hasAttachments, hasMentions, hasCustomCommands);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputSendButtonClick?.call(
        hasText, hasAttachments, hasMentions, hasCustomCommands);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageInputSendButtonClick != null) {
      return messageInputSendButtonClick(
          hasText, hasAttachments, hasMentions, hasCustomCommands);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputSendButtonClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputSendButtonClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageInputSendButtonClick != null) {
      return messageInputSendButtonClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageInputSendButtonClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamMessageInputSendButtonClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageInputSendButtonClickEventModel(
          {required final bool hasText,
          required final bool hasAttachments,
          required final bool hasMentions,
          required final bool hasCustomCommands}) =
      _$StreamMessageInputSendButtonClickEventModel;

  factory StreamMessageInputSendButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageInputSendButtonClickEventModel.fromJson;

  /// Does the message being sent have text?
  bool get hasText;

  /// Does the message being sent have attachments?
  bool get hasAttachments;

  /// Does the message being sent have user mentions?
  bool get hasMentions;

  /// Does the message being sent have custom commands?
  bool get hasCustomCommands;
  @JsonKey(ignore: true)
  _$$StreamMessageInputSendButtonClickEventModelCopyWith<
          _$StreamMessageInputSendButtonClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamMessageInputAttachmentButtonClickEventModelCopyWith<
    $Res> {
  factory _$$StreamMessageInputAttachmentButtonClickEventModelCopyWith(
          _$StreamMessageInputAttachmentButtonClickEventModel value,
          $Res Function(_$StreamMessageInputAttachmentButtonClickEventModel)
              then) =
      __$$StreamMessageInputAttachmentButtonClickEventModelCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StreamMessageInputAttachmentButtonClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements
        _$$StreamMessageInputAttachmentButtonClickEventModelCopyWith<$Res> {
  __$$StreamMessageInputAttachmentButtonClickEventModelCopyWithImpl(
      _$StreamMessageInputAttachmentButtonClickEventModel _value,
      $Res Function(_$StreamMessageInputAttachmentButtonClickEventModel) _then)
      : super(
            _value,
            (v) => _then(
                v as _$StreamMessageInputAttachmentButtonClickEventModel));

  @override
  _$StreamMessageInputAttachmentButtonClickEventModel get _value =>
      super._value as _$StreamMessageInputAttachmentButtonClickEventModel;
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageInputAttachmentButtonClickEventModel
    implements StreamMessageInputAttachmentButtonClickEventModel {
  const _$StreamMessageInputAttachmentButtonClickEventModel(
      {final String? $type})
      : $type = $type ?? 'messageInputAttachmentButtonClick';

  factory _$StreamMessageInputAttachmentButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageInputAttachmentButtonClickEventModelFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageInputAttachmentButtonClick()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageInputAttachmentButtonClickEventModel);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputAttachmentButtonClick();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputAttachmentButtonClick?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageInputAttachmentButtonClick != null) {
      return messageInputAttachmentButtonClick();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputAttachmentButtonClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputAttachmentButtonClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageInputAttachmentButtonClick != null) {
      return messageInputAttachmentButtonClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageInputAttachmentButtonClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamMessageInputAttachmentButtonClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageInputAttachmentButtonClickEventModel() =
      _$StreamMessageInputAttachmentButtonClickEventModel;

  factory StreamMessageInputAttachmentButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageInputAttachmentButtonClickEventModel.fromJson;
}

/// @nodoc
abstract class _$$StreamMessageInputCommandButtonClickEventModelCopyWith<$Res> {
  factory _$$StreamMessageInputCommandButtonClickEventModelCopyWith(
          _$StreamMessageInputCommandButtonClickEventModel value,
          $Res Function(_$StreamMessageInputCommandButtonClickEventModel)
              then) =
      __$$StreamMessageInputCommandButtonClickEventModelCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StreamMessageInputCommandButtonClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageInputCommandButtonClickEventModelCopyWith<$Res> {
  __$$StreamMessageInputCommandButtonClickEventModelCopyWithImpl(
      _$StreamMessageInputCommandButtonClickEventModel _value,
      $Res Function(_$StreamMessageInputCommandButtonClickEventModel) _then)
      : super(
            _value,
            (v) =>
                _then(v as _$StreamMessageInputCommandButtonClickEventModel));

  @override
  _$StreamMessageInputCommandButtonClickEventModel get _value =>
      super._value as _$StreamMessageInputCommandButtonClickEventModel;
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageInputCommandButtonClickEventModel
    implements StreamMessageInputCommandButtonClickEventModel {
  const _$StreamMessageInputCommandButtonClickEventModel({final String? $type})
      : $type = $type ?? 'messageInputCommandButtonClick';

  factory _$StreamMessageInputCommandButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageInputCommandButtonClickEventModelFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageInputCommandButtonClick()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageInputCommandButtonClickEventModel);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputCommandButtonClick();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputCommandButtonClick?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageInputCommandButtonClick != null) {
      return messageInputCommandButtonClick();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputCommandButtonClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputCommandButtonClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageInputCommandButtonClick != null) {
      return messageInputCommandButtonClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageInputCommandButtonClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamMessageInputCommandButtonClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageInputCommandButtonClickEventModel() =
      _$StreamMessageInputCommandButtonClickEventModel;

  factory StreamMessageInputCommandButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageInputCommandButtonClickEventModel.fromJson;
}

/// @nodoc
abstract class _$$StreamMessageInputAttachmentActionClickEventModelCopyWith<
    $Res> {
  factory _$$StreamMessageInputAttachmentActionClickEventModelCopyWith(
          _$StreamMessageInputAttachmentActionClickEventModel value,
          $Res Function(_$StreamMessageInputAttachmentActionClickEventModel)
              then) =
      __$$StreamMessageInputAttachmentActionClickEventModelCopyWithImpl<$Res>;
  $Res call({StreamMessageInputAttachmentActionType targetActionType});
}

/// @nodoc
class __$$StreamMessageInputAttachmentActionClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements
        _$$StreamMessageInputAttachmentActionClickEventModelCopyWith<$Res> {
  __$$StreamMessageInputAttachmentActionClickEventModelCopyWithImpl(
      _$StreamMessageInputAttachmentActionClickEventModel _value,
      $Res Function(_$StreamMessageInputAttachmentActionClickEventModel) _then)
      : super(
            _value,
            (v) => _then(
                v as _$StreamMessageInputAttachmentActionClickEventModel));

  @override
  _$StreamMessageInputAttachmentActionClickEventModel get _value =>
      super._value as _$StreamMessageInputAttachmentActionClickEventModel;

  @override
  $Res call({
    Object? targetActionType = freezed,
  }) {
    return _then(_$StreamMessageInputAttachmentActionClickEventModel(
      targetActionType: targetActionType == freezed
          ? _value.targetActionType
          : targetActionType // ignore: cast_nullable_to_non_nullable
              as StreamMessageInputAttachmentActionType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageInputAttachmentActionClickEventModel
    implements StreamMessageInputAttachmentActionClickEventModel {
  const _$StreamMessageInputAttachmentActionClickEventModel(
      {required this.targetActionType, final String? $type})
      : $type = $type ?? 'messageInputAttachmentActionClick';

  factory _$StreamMessageInputAttachmentActionClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageInputAttachmentActionClickEventModelFromJson(json);

  @override
  final StreamMessageInputAttachmentActionType targetActionType;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageInputAttachmentActionClick(targetActionType: $targetActionType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageInputAttachmentActionClickEventModel &&
            const DeepCollectionEquality()
                .equals(other.targetActionType, targetActionType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(targetActionType));

  @JsonKey(ignore: true)
  @override
  _$$StreamMessageInputAttachmentActionClickEventModelCopyWith<
          _$StreamMessageInputAttachmentActionClickEventModel>
      get copyWith =>
          __$$StreamMessageInputAttachmentActionClickEventModelCopyWithImpl<
                  _$StreamMessageInputAttachmentActionClickEventModel>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputAttachmentActionClick(targetActionType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputAttachmentActionClick?.call(targetActionType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageInputAttachmentActionClick != null) {
      return messageInputAttachmentActionClick(targetActionType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputAttachmentActionClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageInputAttachmentActionClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageInputAttachmentActionClick != null) {
      return messageInputAttachmentActionClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageInputAttachmentActionClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamMessageInputAttachmentActionClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageInputAttachmentActionClickEventModel(
          {required final StreamMessageInputAttachmentActionType
              targetActionType}) =
      _$StreamMessageInputAttachmentActionClickEventModel;

  factory StreamMessageInputAttachmentActionClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageInputAttachmentActionClickEventModel.fromJson;

  StreamMessageInputAttachmentActionType get targetActionType;
  @JsonKey(ignore: true)
  _$$StreamMessageInputAttachmentActionClickEventModelCopyWith<
          _$StreamMessageInputAttachmentActionClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamChannelHeaderBackButtonClickEventModelCopyWith<$Res> {
  factory _$$StreamChannelHeaderBackButtonClickEventModelCopyWith(
          _$StreamChannelHeaderBackButtonClickEventModel value,
          $Res Function(_$StreamChannelHeaderBackButtonClickEventModel) then) =
      __$$StreamChannelHeaderBackButtonClickEventModelCopyWithImpl<$Res>;
  $Res call({String channelId, int unreadMessageCount});
}

/// @nodoc
class __$$StreamChannelHeaderBackButtonClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamChannelHeaderBackButtonClickEventModelCopyWith<$Res> {
  __$$StreamChannelHeaderBackButtonClickEventModelCopyWithImpl(
      _$StreamChannelHeaderBackButtonClickEventModel _value,
      $Res Function(_$StreamChannelHeaderBackButtonClickEventModel) _then)
      : super(_value,
            (v) => _then(v as _$StreamChannelHeaderBackButtonClickEventModel));

  @override
  _$StreamChannelHeaderBackButtonClickEventModel get _value =>
      super._value as _$StreamChannelHeaderBackButtonClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? unreadMessageCount = freezed,
  }) {
    return _then(_$StreamChannelHeaderBackButtonClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      unreadMessageCount: unreadMessageCount == freezed
          ? _value.unreadMessageCount
          : unreadMessageCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamChannelHeaderBackButtonClickEventModel
    implements StreamChannelHeaderBackButtonClickEventModel {
  const _$StreamChannelHeaderBackButtonClickEventModel(
      {required this.channelId,
      required this.unreadMessageCount,
      final String? $type})
      : $type = $type ?? 'channelHeaderBackButtonClick';

  factory _$StreamChannelHeaderBackButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamChannelHeaderBackButtonClickEventModelFromJson(json);

  /// id of the channel on which back button was pressed
  @override
  final String channelId;

  /// the number of unread messages visible on the back button when
  /// it was pressed
  @override
  final int unreadMessageCount;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.channelHeaderBackButtonClick(channelId: $channelId, unreadMessageCount: $unreadMessageCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamChannelHeaderBackButtonClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality()
                .equals(other.unreadMessageCount, unreadMessageCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(unreadMessageCount));

  @JsonKey(ignore: true)
  @override
  _$$StreamChannelHeaderBackButtonClickEventModelCopyWith<
          _$StreamChannelHeaderBackButtonClickEventModel>
      get copyWith =>
          __$$StreamChannelHeaderBackButtonClickEventModelCopyWithImpl<
              _$StreamChannelHeaderBackButtonClickEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return channelHeaderBackButtonClick(channelId, unreadMessageCount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return channelHeaderBackButtonClick?.call(channelId, unreadMessageCount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (channelHeaderBackButtonClick != null) {
      return channelHeaderBackButtonClick(channelId, unreadMessageCount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return channelHeaderBackButtonClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return channelHeaderBackButtonClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (channelHeaderBackButtonClick != null) {
      return channelHeaderBackButtonClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamChannelHeaderBackButtonClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamChannelHeaderBackButtonClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamChannelHeaderBackButtonClickEventModel(
          {required final String channelId,
          required final int unreadMessageCount}) =
      _$StreamChannelHeaderBackButtonClickEventModel;

  factory StreamChannelHeaderBackButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamChannelHeaderBackButtonClickEventModel.fromJson;

  /// id of the channel on which back button was pressed
  String get channelId;

  /// the number of unread messages visible on the back button when
  /// it was pressed
  int get unreadMessageCount;
  @JsonKey(ignore: true)
  _$$StreamChannelHeaderBackButtonClickEventModelCopyWith<
          _$StreamChannelHeaderBackButtonClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamChannelHeaderAvatarClickEventModelCopyWith<$Res> {
  factory _$$StreamChannelHeaderAvatarClickEventModelCopyWith(
          _$StreamChannelHeaderAvatarClickEventModel value,
          $Res Function(_$StreamChannelHeaderAvatarClickEventModel) then) =
      __$$StreamChannelHeaderAvatarClickEventModelCopyWithImpl<$Res>;
  $Res call({String channelId});
}

/// @nodoc
class __$$StreamChannelHeaderAvatarClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamChannelHeaderAvatarClickEventModelCopyWith<$Res> {
  __$$StreamChannelHeaderAvatarClickEventModelCopyWithImpl(
      _$StreamChannelHeaderAvatarClickEventModel _value,
      $Res Function(_$StreamChannelHeaderAvatarClickEventModel) _then)
      : super(_value,
            (v) => _then(v as _$StreamChannelHeaderAvatarClickEventModel));

  @override
  _$StreamChannelHeaderAvatarClickEventModel get _value =>
      super._value as _$StreamChannelHeaderAvatarClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
  }) {
    return _then(_$StreamChannelHeaderAvatarClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamChannelHeaderAvatarClickEventModel
    implements StreamChannelHeaderAvatarClickEventModel {
  const _$StreamChannelHeaderAvatarClickEventModel(
      {required this.channelId, final String? $type})
      : $type = $type ?? 'channelHeaderAvatarClick';

  factory _$StreamChannelHeaderAvatarClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamChannelHeaderAvatarClickEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.channelHeaderAvatarClick(channelId: $channelId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamChannelHeaderAvatarClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(channelId));

  @JsonKey(ignore: true)
  @override
  _$$StreamChannelHeaderAvatarClickEventModelCopyWith<
          _$StreamChannelHeaderAvatarClickEventModel>
      get copyWith => __$$StreamChannelHeaderAvatarClickEventModelCopyWithImpl<
          _$StreamChannelHeaderAvatarClickEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return channelHeaderAvatarClick(channelId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return channelHeaderAvatarClick?.call(channelId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (channelHeaderAvatarClick != null) {
      return channelHeaderAvatarClick(channelId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return channelHeaderAvatarClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return channelHeaderAvatarClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (channelHeaderAvatarClick != null) {
      return channelHeaderAvatarClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamChannelHeaderAvatarClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamChannelHeaderAvatarClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamChannelHeaderAvatarClickEventModel(
          {required final String channelId}) =
      _$StreamChannelHeaderAvatarClickEventModel;

  factory StreamChannelHeaderAvatarClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamChannelHeaderAvatarClickEventModel.fromJson;

  /// id of the channel
  String get channelId;
  @JsonKey(ignore: true)
  _$$StreamChannelHeaderAvatarClickEventModelCopyWith<
          _$StreamChannelHeaderAvatarClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamMessageListViewEventModelCopyWith<$Res> {
  factory _$$StreamMessageListViewEventModelCopyWith(
          _$StreamMessageListViewEventModel value,
          $Res Function(_$StreamMessageListViewEventModel) then) =
      __$$StreamMessageListViewEventModelCopyWithImpl<$Res>;
  $Res call({String channelId});
}

/// @nodoc
class __$$StreamMessageListViewEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageListViewEventModelCopyWith<$Res> {
  __$$StreamMessageListViewEventModelCopyWithImpl(
      _$StreamMessageListViewEventModel _value,
      $Res Function(_$StreamMessageListViewEventModel) _then)
      : super(_value, (v) => _then(v as _$StreamMessageListViewEventModel));

  @override
  _$StreamMessageListViewEventModel get _value =>
      super._value as _$StreamMessageListViewEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
  }) {
    return _then(_$StreamMessageListViewEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageListViewEventModel
    implements StreamMessageListViewEventModel {
  const _$StreamMessageListViewEventModel(
      {required this.channelId, final String? $type})
      : $type = $type ?? 'messageListView';

  factory _$StreamMessageListViewEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageListViewEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageListView(channelId: $channelId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageListViewEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(channelId));

  @JsonKey(ignore: true)
  @override
  _$$StreamMessageListViewEventModelCopyWith<_$StreamMessageListViewEventModel>
      get copyWith => __$$StreamMessageListViewEventModelCopyWithImpl<
          _$StreamMessageListViewEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return messageListView(channelId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageListView?.call(channelId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageListView != null) {
      return messageListView(channelId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return messageListView(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageListView?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageListView != null) {
      return messageListView(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageListViewEventModelToJson(
      this,
    );
  }
}

abstract class StreamMessageListViewEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageListViewEventModel(
      {required final String channelId}) = _$StreamMessageListViewEventModel;

  factory StreamMessageListViewEventModel.fromJson(Map<String, dynamic> json) =
      _$StreamMessageListViewEventModel.fromJson;

  /// id of the channel
  String get channelId;
  @JsonKey(ignore: true)
  _$$StreamMessageListViewEventModelCopyWith<_$StreamMessageListViewEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamMessageListScrollToBottomClickEventModelCopyWith<$Res> {
  factory _$$StreamMessageListScrollToBottomClickEventModelCopyWith(
          _$StreamMessageListScrollToBottomClickEventModel value,
          $Res Function(_$StreamMessageListScrollToBottomClickEventModel)
              then) =
      __$$StreamMessageListScrollToBottomClickEventModelCopyWithImpl<$Res>;
  $Res call({String channelId});
}

/// @nodoc
class __$$StreamMessageListScrollToBottomClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageListScrollToBottomClickEventModelCopyWith<$Res> {
  __$$StreamMessageListScrollToBottomClickEventModelCopyWithImpl(
      _$StreamMessageListScrollToBottomClickEventModel _value,
      $Res Function(_$StreamMessageListScrollToBottomClickEventModel) _then)
      : super(
            _value,
            (v) =>
                _then(v as _$StreamMessageListScrollToBottomClickEventModel));

  @override
  _$StreamMessageListScrollToBottomClickEventModel get _value =>
      super._value as _$StreamMessageListScrollToBottomClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
  }) {
    return _then(_$StreamMessageListScrollToBottomClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageListScrollToBottomClickEventModel
    implements StreamMessageListScrollToBottomClickEventModel {
  const _$StreamMessageListScrollToBottomClickEventModel(
      {required this.channelId, final String? $type})
      : $type = $type ?? 'messageListScrollToBottomClick';

  factory _$StreamMessageListScrollToBottomClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageListScrollToBottomClickEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageListScrollToBottomClick(channelId: $channelId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageListScrollToBottomClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(channelId));

  @JsonKey(ignore: true)
  @override
  _$$StreamMessageListScrollToBottomClickEventModelCopyWith<
          _$StreamMessageListScrollToBottomClickEventModel>
      get copyWith =>
          __$$StreamMessageListScrollToBottomClickEventModelCopyWithImpl<
                  _$StreamMessageListScrollToBottomClickEventModel>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return messageListScrollToBottomClick(channelId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageListScrollToBottomClick?.call(channelId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageListScrollToBottomClick != null) {
      return messageListScrollToBottomClick(channelId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return messageListScrollToBottomClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageListScrollToBottomClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageListScrollToBottomClick != null) {
      return messageListScrollToBottomClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageListScrollToBottomClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamMessageListScrollToBottomClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageListScrollToBottomClickEventModel(
          {required final String channelId}) =
      _$StreamMessageListScrollToBottomClickEventModel;

  factory StreamMessageListScrollToBottomClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageListScrollToBottomClickEventModel.fromJson;

  /// id of the channel
  String get channelId;
  @JsonKey(ignore: true)
  _$$StreamMessageListScrollToBottomClickEventModelCopyWith<
          _$StreamMessageListScrollToBottomClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamMessageMentionClickEventModelCopyWith<$Res> {
  factory _$$StreamMessageMentionClickEventModelCopyWith(
          _$StreamMessageMentionClickEventModel value,
          $Res Function(_$StreamMessageMentionClickEventModel) then) =
      __$$StreamMessageMentionClickEventModelCopyWithImpl<$Res>;
  $Res call(
      {String channelId,
      String messageId,
      String mentionedUserId,
      String? quotedMessageId,
      String? parentMessageId});
}

/// @nodoc
class __$$StreamMessageMentionClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageMentionClickEventModelCopyWith<$Res> {
  __$$StreamMessageMentionClickEventModelCopyWithImpl(
      _$StreamMessageMentionClickEventModel _value,
      $Res Function(_$StreamMessageMentionClickEventModel) _then)
      : super(_value, (v) => _then(v as _$StreamMessageMentionClickEventModel));

  @override
  _$StreamMessageMentionClickEventModel get _value =>
      super._value as _$StreamMessageMentionClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? messageId = freezed,
    Object? mentionedUserId = freezed,
    Object? quotedMessageId = freezed,
    Object? parentMessageId = freezed,
  }) {
    return _then(_$StreamMessageMentionClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: messageId == freezed
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      mentionedUserId: mentionedUserId == freezed
          ? _value.mentionedUserId
          : mentionedUserId // ignore: cast_nullable_to_non_nullable
              as String,
      quotedMessageId: quotedMessageId == freezed
          ? _value.quotedMessageId
          : quotedMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentMessageId: parentMessageId == freezed
          ? _value.parentMessageId
          : parentMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageMentionClickEventModel
    implements StreamMessageMentionClickEventModel {
  const _$StreamMessageMentionClickEventModel(
      {required this.channelId,
      required this.messageId,
      required this.mentionedUserId,
      this.quotedMessageId,
      this.parentMessageId,
      final String? $type})
      : $type = $type ?? 'messageMentionClick';

  factory _$StreamMessageMentionClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageMentionClickEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  /// id of the message
  @override
  final String messageId;

  /// id of the mentioned user
  @override
  final String mentionedUserId;

  /// id of the message to which this message is a direct reply
  @override
  final String? quotedMessageId;

  /// id of the parent message in this thread
  @override
  final String? parentMessageId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageMentionClick(channelId: $channelId, messageId: $messageId, mentionedUserId: $mentionedUserId, quotedMessageId: $quotedMessageId, parentMessageId: $parentMessageId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageMentionClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality().equals(other.messageId, messageId) &&
            const DeepCollectionEquality()
                .equals(other.mentionedUserId, mentionedUserId) &&
            const DeepCollectionEquality()
                .equals(other.quotedMessageId, quotedMessageId) &&
            const DeepCollectionEquality()
                .equals(other.parentMessageId, parentMessageId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(messageId),
      const DeepCollectionEquality().hash(mentionedUserId),
      const DeepCollectionEquality().hash(quotedMessageId),
      const DeepCollectionEquality().hash(parentMessageId));

  @JsonKey(ignore: true)
  @override
  _$$StreamMessageMentionClickEventModelCopyWith<
          _$StreamMessageMentionClickEventModel>
      get copyWith => __$$StreamMessageMentionClickEventModelCopyWithImpl<
          _$StreamMessageMentionClickEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return messageMentionClick(channelId, messageId, mentionedUserId,
        quotedMessageId, parentMessageId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageMentionClick?.call(channelId, messageId, mentionedUserId,
        quotedMessageId, parentMessageId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageMentionClick != null) {
      return messageMentionClick(channelId, messageId, mentionedUserId,
          quotedMessageId, parentMessageId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return messageMentionClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageMentionClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageMentionClick != null) {
      return messageMentionClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageMentionClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamMessageMentionClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageMentionClickEventModel(
      {required final String channelId,
      required final String messageId,
      required final String mentionedUserId,
      final String? quotedMessageId,
      final String? parentMessageId}) = _$StreamMessageMentionClickEventModel;

  factory StreamMessageMentionClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageMentionClickEventModel.fromJson;

  /// id of the channel
  String get channelId;

  /// id of the message
  String get messageId;

  /// id of the mentioned user
  String get mentionedUserId;

  /// id of the message to which this message is a direct reply
  String? get quotedMessageId;

  /// id of the parent message in this thread
  String? get parentMessageId;
  @JsonKey(ignore: true)
  _$$StreamMessageMentionClickEventModelCopyWith<
          _$StreamMessageMentionClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamMessageUrlClickEventModelCopyWith<$Res> {
  factory _$$StreamMessageUrlClickEventModelCopyWith(
          _$StreamMessageUrlClickEventModel value,
          $Res Function(_$StreamMessageUrlClickEventModel) then) =
      __$$StreamMessageUrlClickEventModelCopyWithImpl<$Res>;
  $Res call(
      {String channelId,
      String messageId,
      String? quotedMessageId,
      String? parentMessageId});
}

/// @nodoc
class __$$StreamMessageUrlClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageUrlClickEventModelCopyWith<$Res> {
  __$$StreamMessageUrlClickEventModelCopyWithImpl(
      _$StreamMessageUrlClickEventModel _value,
      $Res Function(_$StreamMessageUrlClickEventModel) _then)
      : super(_value, (v) => _then(v as _$StreamMessageUrlClickEventModel));

  @override
  _$StreamMessageUrlClickEventModel get _value =>
      super._value as _$StreamMessageUrlClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? messageId = freezed,
    Object? quotedMessageId = freezed,
    Object? parentMessageId = freezed,
  }) {
    return _then(_$StreamMessageUrlClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: messageId == freezed
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      quotedMessageId: quotedMessageId == freezed
          ? _value.quotedMessageId
          : quotedMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentMessageId: parentMessageId == freezed
          ? _value.parentMessageId
          : parentMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageUrlClickEventModel
    implements StreamMessageUrlClickEventModel {
  const _$StreamMessageUrlClickEventModel(
      {required this.channelId,
      required this.messageId,
      this.quotedMessageId,
      this.parentMessageId,
      final String? $type})
      : $type = $type ?? 'messageUrlClick';

  factory _$StreamMessageUrlClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageUrlClickEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  /// id of the message
  @override
  final String messageId;

  /// id of the message to which this message is a direct reply
  @override
  final String? quotedMessageId;

  /// id of the parent message in this thread
  @override
  final String? parentMessageId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageUrlClick(channelId: $channelId, messageId: $messageId, quotedMessageId: $quotedMessageId, parentMessageId: $parentMessageId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageUrlClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality().equals(other.messageId, messageId) &&
            const DeepCollectionEquality()
                .equals(other.quotedMessageId, quotedMessageId) &&
            const DeepCollectionEquality()
                .equals(other.parentMessageId, parentMessageId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(messageId),
      const DeepCollectionEquality().hash(quotedMessageId),
      const DeepCollectionEquality().hash(parentMessageId));

  @JsonKey(ignore: true)
  @override
  _$$StreamMessageUrlClickEventModelCopyWith<_$StreamMessageUrlClickEventModel>
      get copyWith => __$$StreamMessageUrlClickEventModelCopyWithImpl<
          _$StreamMessageUrlClickEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return messageUrlClick(
        channelId, messageId, quotedMessageId, parentMessageId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageUrlClick?.call(
        channelId, messageId, quotedMessageId, parentMessageId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageUrlClick != null) {
      return messageUrlClick(
          channelId, messageId, quotedMessageId, parentMessageId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return messageUrlClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageUrlClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageUrlClick != null) {
      return messageUrlClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageUrlClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamMessageUrlClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageUrlClickEventModel(
      {required final String channelId,
      required final String messageId,
      final String? quotedMessageId,
      final String? parentMessageId}) = _$StreamMessageUrlClickEventModel;

  factory StreamMessageUrlClickEventModel.fromJson(Map<String, dynamic> json) =
      _$StreamMessageUrlClickEventModel.fromJson;

  /// id of the channel
  String get channelId;

  /// id of the message
  String get messageId;

  /// id of the message to which this message is a direct reply
  String? get quotedMessageId;

  /// id of the parent message in this thread
  String? get parentMessageId;
  @JsonKey(ignore: true)
  _$$StreamMessageUrlClickEventModelCopyWith<_$StreamMessageUrlClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamMessageActionsTriggerEventModelCopyWith<$Res> {
  factory _$$StreamMessageActionsTriggerEventModelCopyWith(
          _$StreamMessageActionsTriggerEventModel value,
          $Res Function(_$StreamMessageActionsTriggerEventModel) then) =
      __$$StreamMessageActionsTriggerEventModelCopyWithImpl<$Res>;
  $Res call(
      {String channelId,
      String messageId,
      String? quotedMessageId,
      String? parentMessageId});
}

/// @nodoc
class __$$StreamMessageActionsTriggerEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageActionsTriggerEventModelCopyWith<$Res> {
  __$$StreamMessageActionsTriggerEventModelCopyWithImpl(
      _$StreamMessageActionsTriggerEventModel _value,
      $Res Function(_$StreamMessageActionsTriggerEventModel) _then)
      : super(
            _value, (v) => _then(v as _$StreamMessageActionsTriggerEventModel));

  @override
  _$StreamMessageActionsTriggerEventModel get _value =>
      super._value as _$StreamMessageActionsTriggerEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? messageId = freezed,
    Object? quotedMessageId = freezed,
    Object? parentMessageId = freezed,
  }) {
    return _then(_$StreamMessageActionsTriggerEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: messageId == freezed
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      quotedMessageId: quotedMessageId == freezed
          ? _value.quotedMessageId
          : quotedMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentMessageId: parentMessageId == freezed
          ? _value.parentMessageId
          : parentMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageActionsTriggerEventModel
    implements StreamMessageActionsTriggerEventModel {
  const _$StreamMessageActionsTriggerEventModel(
      {required this.channelId,
      required this.messageId,
      this.quotedMessageId,
      this.parentMessageId,
      final String? $type})
      : $type = $type ?? 'messageActionsTrigger';

  factory _$StreamMessageActionsTriggerEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageActionsTriggerEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  /// id of the message
  @override
  final String messageId;

  /// id of the message to which this message is a direct reply
  @override
  final String? quotedMessageId;

  /// id of the parent message in this thread
  @override
  final String? parentMessageId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageActionsTrigger(channelId: $channelId, messageId: $messageId, quotedMessageId: $quotedMessageId, parentMessageId: $parentMessageId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageActionsTriggerEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality().equals(other.messageId, messageId) &&
            const DeepCollectionEquality()
                .equals(other.quotedMessageId, quotedMessageId) &&
            const DeepCollectionEquality()
                .equals(other.parentMessageId, parentMessageId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(messageId),
      const DeepCollectionEquality().hash(quotedMessageId),
      const DeepCollectionEquality().hash(parentMessageId));

  @JsonKey(ignore: true)
  @override
  _$$StreamMessageActionsTriggerEventModelCopyWith<
          _$StreamMessageActionsTriggerEventModel>
      get copyWith => __$$StreamMessageActionsTriggerEventModelCopyWithImpl<
          _$StreamMessageActionsTriggerEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return messageActionsTrigger(
        channelId, messageId, quotedMessageId, parentMessageId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageActionsTrigger?.call(
        channelId, messageId, quotedMessageId, parentMessageId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageActionsTrigger != null) {
      return messageActionsTrigger(
          channelId, messageId, quotedMessageId, parentMessageId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return messageActionsTrigger(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageActionsTrigger?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageActionsTrigger != null) {
      return messageActionsTrigger(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageActionsTriggerEventModelToJson(
      this,
    );
  }
}

abstract class StreamMessageActionsTriggerEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageActionsTriggerEventModel(
      {required final String channelId,
      required final String messageId,
      final String? quotedMessageId,
      final String? parentMessageId}) = _$StreamMessageActionsTriggerEventModel;

  factory StreamMessageActionsTriggerEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageActionsTriggerEventModel.fromJson;

  /// id of the channel
  String get channelId;

  /// id of the message
  String get messageId;

  /// id of the message to which this message is a direct reply
  String? get quotedMessageId;

  /// id of the parent message in this thread
  String? get parentMessageId;
  @JsonKey(ignore: true)
  _$$StreamMessageActionsTriggerEventModelCopyWith<
          _$StreamMessageActionsTriggerEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamMessageReactionClickEventModelCopyWith<$Res> {
  factory _$$StreamMessageReactionClickEventModelCopyWith(
          _$StreamMessageReactionClickEventModel value,
          $Res Function(_$StreamMessageReactionClickEventModel) then) =
      __$$StreamMessageReactionClickEventModelCopyWithImpl<$Res>;
  $Res call(
      {String channelId,
      String messageId,
      String? quotedMessageId,
      String? parentMessageId,
      String reactionType});
}

/// @nodoc
class __$$StreamMessageReactionClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageReactionClickEventModelCopyWith<$Res> {
  __$$StreamMessageReactionClickEventModelCopyWithImpl(
      _$StreamMessageReactionClickEventModel _value,
      $Res Function(_$StreamMessageReactionClickEventModel) _then)
      : super(
            _value, (v) => _then(v as _$StreamMessageReactionClickEventModel));

  @override
  _$StreamMessageReactionClickEventModel get _value =>
      super._value as _$StreamMessageReactionClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? messageId = freezed,
    Object? quotedMessageId = freezed,
    Object? parentMessageId = freezed,
    Object? reactionType = freezed,
  }) {
    return _then(_$StreamMessageReactionClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: messageId == freezed
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      quotedMessageId: quotedMessageId == freezed
          ? _value.quotedMessageId
          : quotedMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentMessageId: parentMessageId == freezed
          ? _value.parentMessageId
          : parentMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      reactionType: reactionType == freezed
          ? _value.reactionType
          : reactionType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageReactionClickEventModel
    implements StreamMessageReactionClickEventModel {
  const _$StreamMessageReactionClickEventModel(
      {required this.channelId,
      required this.messageId,
      this.quotedMessageId,
      this.parentMessageId,
      required this.reactionType,
      final String? $type})
      : $type = $type ?? 'messageReactionClick';

  factory _$StreamMessageReactionClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageReactionClickEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  /// id of the message
  @override
  final String messageId;

  /// id of the message to which this message is a direct reply
  @override
  final String? quotedMessageId;

  /// id of the parent message in this thread
  @override
  final String? parentMessageId;

  /// the type of reaction that was selected
  @override
  final String reactionType;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageReactionClick(channelId: $channelId, messageId: $messageId, quotedMessageId: $quotedMessageId, parentMessageId: $parentMessageId, reactionType: $reactionType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageReactionClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality().equals(other.messageId, messageId) &&
            const DeepCollectionEquality()
                .equals(other.quotedMessageId, quotedMessageId) &&
            const DeepCollectionEquality()
                .equals(other.parentMessageId, parentMessageId) &&
            const DeepCollectionEquality()
                .equals(other.reactionType, reactionType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(messageId),
      const DeepCollectionEquality().hash(quotedMessageId),
      const DeepCollectionEquality().hash(parentMessageId),
      const DeepCollectionEquality().hash(reactionType));

  @JsonKey(ignore: true)
  @override
  _$$StreamMessageReactionClickEventModelCopyWith<
          _$StreamMessageReactionClickEventModel>
      get copyWith => __$$StreamMessageReactionClickEventModelCopyWithImpl<
          _$StreamMessageReactionClickEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return messageReactionClick(
        channelId, messageId, quotedMessageId, parentMessageId, reactionType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageReactionClick?.call(
        channelId, messageId, quotedMessageId, parentMessageId, reactionType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageReactionClick != null) {
      return messageReactionClick(
          channelId, messageId, quotedMessageId, parentMessageId, reactionType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return messageReactionClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageReactionClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageReactionClick != null) {
      return messageReactionClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageReactionClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamMessageReactionClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageReactionClickEventModel(
          {required final String channelId,
          required final String messageId,
          final String? quotedMessageId,
          final String? parentMessageId,
          required final String reactionType}) =
      _$StreamMessageReactionClickEventModel;

  factory StreamMessageReactionClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageReactionClickEventModel.fromJson;

  /// id of the channel
  String get channelId;

  /// id of the message
  String get messageId;

  /// id of the message to which this message is a direct reply
  String? get quotedMessageId;

  /// id of the parent message in this thread
  String? get parentMessageId;

  /// the type of reaction that was selected
  String get reactionType;
  @JsonKey(ignore: true)
  _$$StreamMessageReactionClickEventModelCopyWith<
          _$StreamMessageReactionClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamMessageActionClickEventModelCopyWith<$Res> {
  factory _$$StreamMessageActionClickEventModelCopyWith(
          _$StreamMessageActionClickEventModel value,
          $Res Function(_$StreamMessageActionClickEventModel) then) =
      __$$StreamMessageActionClickEventModelCopyWithImpl<$Res>;
  $Res call(
      {String channelId,
      String messageId,
      String? quotedMessageId,
      String? parentMessageId,
      StreamMessageActionType actionType});
}

/// @nodoc
class __$$StreamMessageActionClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageActionClickEventModelCopyWith<$Res> {
  __$$StreamMessageActionClickEventModelCopyWithImpl(
      _$StreamMessageActionClickEventModel _value,
      $Res Function(_$StreamMessageActionClickEventModel) _then)
      : super(_value, (v) => _then(v as _$StreamMessageActionClickEventModel));

  @override
  _$StreamMessageActionClickEventModel get _value =>
      super._value as _$StreamMessageActionClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? messageId = freezed,
    Object? quotedMessageId = freezed,
    Object? parentMessageId = freezed,
    Object? actionType = freezed,
  }) {
    return _then(_$StreamMessageActionClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: messageId == freezed
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      quotedMessageId: quotedMessageId == freezed
          ? _value.quotedMessageId
          : quotedMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentMessageId: parentMessageId == freezed
          ? _value.parentMessageId
          : parentMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      actionType: actionType == freezed
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as StreamMessageActionType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageActionClickEventModel
    implements StreamMessageActionClickEventModel {
  const _$StreamMessageActionClickEventModel(
      {required this.channelId,
      required this.messageId,
      this.quotedMessageId,
      this.parentMessageId,
      required this.actionType,
      final String? $type})
      : $type = $type ?? 'messageActionClick';

  factory _$StreamMessageActionClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageActionClickEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  /// id of the message
  @override
  final String messageId;

  /// id of the message to which this message is a direct reply
  @override
  final String? quotedMessageId;

  /// id of the parent message in this thread
  @override
  final String? parentMessageId;

  /// the type of action that was selected
  @override
  final StreamMessageActionType actionType;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageActionClick(channelId: $channelId, messageId: $messageId, quotedMessageId: $quotedMessageId, parentMessageId: $parentMessageId, actionType: $actionType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageActionClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality().equals(other.messageId, messageId) &&
            const DeepCollectionEquality()
                .equals(other.quotedMessageId, quotedMessageId) &&
            const DeepCollectionEquality()
                .equals(other.parentMessageId, parentMessageId) &&
            const DeepCollectionEquality()
                .equals(other.actionType, actionType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(messageId),
      const DeepCollectionEquality().hash(quotedMessageId),
      const DeepCollectionEquality().hash(parentMessageId),
      const DeepCollectionEquality().hash(actionType));

  @JsonKey(ignore: true)
  @override
  _$$StreamMessageActionClickEventModelCopyWith<
          _$StreamMessageActionClickEventModel>
      get copyWith => __$$StreamMessageActionClickEventModelCopyWithImpl<
          _$StreamMessageActionClickEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return messageActionClick(
        channelId, messageId, quotedMessageId, parentMessageId, actionType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageActionClick?.call(
        channelId, messageId, quotedMessageId, parentMessageId, actionType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageActionClick != null) {
      return messageActionClick(
          channelId, messageId, quotedMessageId, parentMessageId, actionType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return messageActionClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageActionClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageActionClick != null) {
      return messageActionClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageActionClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamMessageActionClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageActionClickEventModel(
          {required final String channelId,
          required final String messageId,
          final String? quotedMessageId,
          final String? parentMessageId,
          required final StreamMessageActionType actionType}) =
      _$StreamMessageActionClickEventModel;

  factory StreamMessageActionClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageActionClickEventModel.fromJson;

  /// id of the channel
  String get channelId;

  /// id of the message
  String get messageId;

  /// id of the message to which this message is a direct reply
  String? get quotedMessageId;

  /// id of the parent message in this thread
  String? get parentMessageId;

  /// the type of action that was selected
  StreamMessageActionType get actionType;
  @JsonKey(ignore: true)
  _$$StreamMessageActionClickEventModelCopyWith<
          _$StreamMessageActionClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamMessageAttachmentClickEventModelCopyWith<$Res> {
  factory _$$StreamMessageAttachmentClickEventModelCopyWith(
          _$StreamMessageAttachmentClickEventModel value,
          $Res Function(_$StreamMessageAttachmentClickEventModel) then) =
      __$$StreamMessageAttachmentClickEventModelCopyWithImpl<$Res>;
  $Res call(
      {String channelId,
      String messageId,
      String? quotedMessageId,
      String? parentMessageId,
      String attachmentId,
      String attachmentType});
}

/// @nodoc
class __$$StreamMessageAttachmentClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamMessageAttachmentClickEventModelCopyWith<$Res> {
  __$$StreamMessageAttachmentClickEventModelCopyWithImpl(
      _$StreamMessageAttachmentClickEventModel _value,
      $Res Function(_$StreamMessageAttachmentClickEventModel) _then)
      : super(_value,
            (v) => _then(v as _$StreamMessageAttachmentClickEventModel));

  @override
  _$StreamMessageAttachmentClickEventModel get _value =>
      super._value as _$StreamMessageAttachmentClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? messageId = freezed,
    Object? quotedMessageId = freezed,
    Object? parentMessageId = freezed,
    Object? attachmentId = freezed,
    Object? attachmentType = freezed,
  }) {
    return _then(_$StreamMessageAttachmentClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: messageId == freezed
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      quotedMessageId: quotedMessageId == freezed
          ? _value.quotedMessageId
          : quotedMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      parentMessageId: parentMessageId == freezed
          ? _value.parentMessageId
          : parentMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
      attachmentId: attachmentId == freezed
          ? _value.attachmentId
          : attachmentId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentType: attachmentType == freezed
          ? _value.attachmentType
          : attachmentType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamMessageAttachmentClickEventModel
    implements StreamMessageAttachmentClickEventModel {
  const _$StreamMessageAttachmentClickEventModel(
      {required this.channelId,
      required this.messageId,
      this.quotedMessageId,
      this.parentMessageId,
      required this.attachmentId,
      required this.attachmentType,
      final String? $type})
      : $type = $type ?? 'messageAttachmentClick';

  factory _$StreamMessageAttachmentClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamMessageAttachmentClickEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  /// id of the message
  @override
  final String messageId;

  /// id of the message to which this message is a direct reply
  @override
  final String? quotedMessageId;

  /// id of the parent message in this thread
  @override
  final String? parentMessageId;

  /// the id of the attachment
  @override
  final String attachmentId;

  /// the type of the attachment
  @override
  final String attachmentType;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.messageAttachmentClick(channelId: $channelId, messageId: $messageId, quotedMessageId: $quotedMessageId, parentMessageId: $parentMessageId, attachmentId: $attachmentId, attachmentType: $attachmentType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamMessageAttachmentClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality().equals(other.messageId, messageId) &&
            const DeepCollectionEquality()
                .equals(other.quotedMessageId, quotedMessageId) &&
            const DeepCollectionEquality()
                .equals(other.parentMessageId, parentMessageId) &&
            const DeepCollectionEquality()
                .equals(other.attachmentId, attachmentId) &&
            const DeepCollectionEquality()
                .equals(other.attachmentType, attachmentType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(messageId),
      const DeepCollectionEquality().hash(quotedMessageId),
      const DeepCollectionEquality().hash(parentMessageId),
      const DeepCollectionEquality().hash(attachmentId),
      const DeepCollectionEquality().hash(attachmentType));

  @JsonKey(ignore: true)
  @override
  _$$StreamMessageAttachmentClickEventModelCopyWith<
          _$StreamMessageAttachmentClickEventModel>
      get copyWith => __$$StreamMessageAttachmentClickEventModelCopyWithImpl<
          _$StreamMessageAttachmentClickEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return messageAttachmentClick(channelId, messageId, quotedMessageId,
        parentMessageId, attachmentId, attachmentType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageAttachmentClick?.call(channelId, messageId, quotedMessageId,
        parentMessageId, attachmentId, attachmentType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageAttachmentClick != null) {
      return messageAttachmentClick(channelId, messageId, quotedMessageId,
          parentMessageId, attachmentId, attachmentType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return messageAttachmentClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return messageAttachmentClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (messageAttachmentClick != null) {
      return messageAttachmentClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamMessageAttachmentClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamMessageAttachmentClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamMessageAttachmentClickEventModel(
          {required final String channelId,
          required final String messageId,
          final String? quotedMessageId,
          final String? parentMessageId,
          required final String attachmentId,
          required final String attachmentType}) =
      _$StreamMessageAttachmentClickEventModel;

  factory StreamMessageAttachmentClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamMessageAttachmentClickEventModel.fromJson;

  /// id of the channel
  String get channelId;

  /// id of the message
  String get messageId;

  /// id of the message to which this message is a direct reply
  String? get quotedMessageId;

  /// id of the parent message in this thread
  String? get parentMessageId;

  /// the id of the attachment
  String get attachmentId;

  /// the type of the attachment
  String get attachmentType;
  @JsonKey(ignore: true)
  _$$StreamMessageAttachmentClickEventModelCopyWith<
          _$StreamMessageAttachmentClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamAttachmentFullScreenViewEventModelCopyWith<$Res> {
  factory _$$StreamAttachmentFullScreenViewEventModelCopyWith(
          _$StreamAttachmentFullScreenViewEventModel value,
          $Res Function(_$StreamAttachmentFullScreenViewEventModel) then) =
      __$$StreamAttachmentFullScreenViewEventModelCopyWithImpl<$Res>;
  $Res call(
      {String channelId,
      String messageId,
      String attachmentId,
      String attachmentType});
}

/// @nodoc
class __$$StreamAttachmentFullScreenViewEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements _$$StreamAttachmentFullScreenViewEventModelCopyWith<$Res> {
  __$$StreamAttachmentFullScreenViewEventModelCopyWithImpl(
      _$StreamAttachmentFullScreenViewEventModel _value,
      $Res Function(_$StreamAttachmentFullScreenViewEventModel) _then)
      : super(_value,
            (v) => _then(v as _$StreamAttachmentFullScreenViewEventModel));

  @override
  _$StreamAttachmentFullScreenViewEventModel get _value =>
      super._value as _$StreamAttachmentFullScreenViewEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? messageId = freezed,
    Object? attachmentId = freezed,
    Object? attachmentType = freezed,
  }) {
    return _then(_$StreamAttachmentFullScreenViewEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: messageId == freezed
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentId: attachmentId == freezed
          ? _value.attachmentId
          : attachmentId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentType: attachmentType == freezed
          ? _value.attachmentType
          : attachmentType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamAttachmentFullScreenViewEventModel
    implements StreamAttachmentFullScreenViewEventModel {
  const _$StreamAttachmentFullScreenViewEventModel(
      {required this.channelId,
      required this.messageId,
      required this.attachmentId,
      required this.attachmentType,
      final String? $type})
      : $type = $type ?? 'attachmentFullScreenView';

  factory _$StreamAttachmentFullScreenViewEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamAttachmentFullScreenViewEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  /// id of the message
  @override
  final String messageId;

  /// the id of the attachment
  @override
  final String attachmentId;

  /// the type of the attachment
  @override
  final String attachmentType;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.attachmentFullScreenView(channelId: $channelId, messageId: $messageId, attachmentId: $attachmentId, attachmentType: $attachmentType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamAttachmentFullScreenViewEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality().equals(other.messageId, messageId) &&
            const DeepCollectionEquality()
                .equals(other.attachmentId, attachmentId) &&
            const DeepCollectionEquality()
                .equals(other.attachmentType, attachmentType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(messageId),
      const DeepCollectionEquality().hash(attachmentId),
      const DeepCollectionEquality().hash(attachmentType));

  @JsonKey(ignore: true)
  @override
  _$$StreamAttachmentFullScreenViewEventModelCopyWith<
          _$StreamAttachmentFullScreenViewEventModel>
      get copyWith => __$$StreamAttachmentFullScreenViewEventModelCopyWithImpl<
          _$StreamAttachmentFullScreenViewEventModel>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenView(
        channelId, messageId, attachmentId, attachmentType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenView?.call(
        channelId, messageId, attachmentId, attachmentType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (attachmentFullScreenView != null) {
      return attachmentFullScreenView(
          channelId, messageId, attachmentId, attachmentType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenView(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenView?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (attachmentFullScreenView != null) {
      return attachmentFullScreenView(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamAttachmentFullScreenViewEventModelToJson(
      this,
    );
  }
}

abstract class StreamAttachmentFullScreenViewEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamAttachmentFullScreenViewEventModel(
          {required final String channelId,
          required final String messageId,
          required final String attachmentId,
          required final String attachmentType}) =
      _$StreamAttachmentFullScreenViewEventModel;

  factory StreamAttachmentFullScreenViewEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamAttachmentFullScreenViewEventModel.fromJson;

  /// id of the channel
  String get channelId;

  /// id of the message
  String get messageId;

  /// the id of the attachment
  String get attachmentId;

  /// the type of the attachment
  String get attachmentType;
  @JsonKey(ignore: true)
  _$$StreamAttachmentFullScreenViewEventModelCopyWith<
          _$StreamAttachmentFullScreenViewEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamAttachmentFullScreenShareButtonClickEventModelCopyWith<
    $Res> {
  factory _$$StreamAttachmentFullScreenShareButtonClickEventModelCopyWith(
          _$StreamAttachmentFullScreenShareButtonClickEventModel value,
          $Res Function(_$StreamAttachmentFullScreenShareButtonClickEventModel)
              then) =
      __$$StreamAttachmentFullScreenShareButtonClickEventModelCopyWithImpl<
          $Res>;
  $Res call(
      {String channelId,
      String messageId,
      String attachmentId,
      String attachmentType});
}

/// @nodoc
class __$$StreamAttachmentFullScreenShareButtonClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements
        _$$StreamAttachmentFullScreenShareButtonClickEventModelCopyWith<$Res> {
  __$$StreamAttachmentFullScreenShareButtonClickEventModelCopyWithImpl(
      _$StreamAttachmentFullScreenShareButtonClickEventModel _value,
      $Res Function(_$StreamAttachmentFullScreenShareButtonClickEventModel)
          _then)
      : super(
            _value,
            (v) => _then(
                v as _$StreamAttachmentFullScreenShareButtonClickEventModel));

  @override
  _$StreamAttachmentFullScreenShareButtonClickEventModel get _value =>
      super._value as _$StreamAttachmentFullScreenShareButtonClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? messageId = freezed,
    Object? attachmentId = freezed,
    Object? attachmentType = freezed,
  }) {
    return _then(_$StreamAttachmentFullScreenShareButtonClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: messageId == freezed
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentId: attachmentId == freezed
          ? _value.attachmentId
          : attachmentId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentType: attachmentType == freezed
          ? _value.attachmentType
          : attachmentType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamAttachmentFullScreenShareButtonClickEventModel
    implements StreamAttachmentFullScreenShareButtonClickEventModel {
  const _$StreamAttachmentFullScreenShareButtonClickEventModel(
      {required this.channelId,
      required this.messageId,
      required this.attachmentId,
      required this.attachmentType,
      final String? $type})
      : $type = $type ?? 'attachmentFullScreenShareButtonClick';

  factory _$StreamAttachmentFullScreenShareButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamAttachmentFullScreenShareButtonClickEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  /// id of the message
  @override
  final String messageId;

  /// the id of the attachment
  @override
  final String attachmentId;

  /// the type of the attachment
  @override
  final String attachmentType;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.attachmentFullScreenShareButtonClick(channelId: $channelId, messageId: $messageId, attachmentId: $attachmentId, attachmentType: $attachmentType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamAttachmentFullScreenShareButtonClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality().equals(other.messageId, messageId) &&
            const DeepCollectionEquality()
                .equals(other.attachmentId, attachmentId) &&
            const DeepCollectionEquality()
                .equals(other.attachmentType, attachmentType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(messageId),
      const DeepCollectionEquality().hash(attachmentId),
      const DeepCollectionEquality().hash(attachmentType));

  @JsonKey(ignore: true)
  @override
  _$$StreamAttachmentFullScreenShareButtonClickEventModelCopyWith<
          _$StreamAttachmentFullScreenShareButtonClickEventModel>
      get copyWith =>
          __$$StreamAttachmentFullScreenShareButtonClickEventModelCopyWithImpl<
                  _$StreamAttachmentFullScreenShareButtonClickEventModel>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenShareButtonClick(
        channelId, messageId, attachmentId, attachmentType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenShareButtonClick?.call(
        channelId, messageId, attachmentId, attachmentType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (attachmentFullScreenShareButtonClick != null) {
      return attachmentFullScreenShareButtonClick(
          channelId, messageId, attachmentId, attachmentType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenShareButtonClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenShareButtonClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (attachmentFullScreenShareButtonClick != null) {
      return attachmentFullScreenShareButtonClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamAttachmentFullScreenShareButtonClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamAttachmentFullScreenShareButtonClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamAttachmentFullScreenShareButtonClickEventModel(
          {required final String channelId,
          required final String messageId,
          required final String attachmentId,
          required final String attachmentType}) =
      _$StreamAttachmentFullScreenShareButtonClickEventModel;

  factory StreamAttachmentFullScreenShareButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamAttachmentFullScreenShareButtonClickEventModel.fromJson;

  /// id of the channel
  String get channelId;

  /// id of the message
  String get messageId;

  /// the id of the attachment
  String get attachmentId;

  /// the type of the attachment
  String get attachmentType;
  @JsonKey(ignore: true)
  _$$StreamAttachmentFullScreenShareButtonClickEventModelCopyWith<
          _$StreamAttachmentFullScreenShareButtonClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamAttachmentFullScreenGridButtonClickEventModelCopyWith<
    $Res> {
  factory _$$StreamAttachmentFullScreenGridButtonClickEventModelCopyWith(
          _$StreamAttachmentFullScreenGridButtonClickEventModel value,
          $Res Function(_$StreamAttachmentFullScreenGridButtonClickEventModel)
              then) =
      __$$StreamAttachmentFullScreenGridButtonClickEventModelCopyWithImpl<$Res>;
  $Res call(
      {String channelId,
      String messageId,
      String attachmentId,
      String attachmentType});
}

/// @nodoc
class __$$StreamAttachmentFullScreenGridButtonClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements
        _$$StreamAttachmentFullScreenGridButtonClickEventModelCopyWith<$Res> {
  __$$StreamAttachmentFullScreenGridButtonClickEventModelCopyWithImpl(
      _$StreamAttachmentFullScreenGridButtonClickEventModel _value,
      $Res Function(_$StreamAttachmentFullScreenGridButtonClickEventModel)
          _then)
      : super(
            _value,
            (v) => _then(
                v as _$StreamAttachmentFullScreenGridButtonClickEventModel));

  @override
  _$StreamAttachmentFullScreenGridButtonClickEventModel get _value =>
      super._value as _$StreamAttachmentFullScreenGridButtonClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? messageId = freezed,
    Object? attachmentId = freezed,
    Object? attachmentType = freezed,
  }) {
    return _then(_$StreamAttachmentFullScreenGridButtonClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: messageId == freezed
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentId: attachmentId == freezed
          ? _value.attachmentId
          : attachmentId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentType: attachmentType == freezed
          ? _value.attachmentType
          : attachmentType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamAttachmentFullScreenGridButtonClickEventModel
    implements StreamAttachmentFullScreenGridButtonClickEventModel {
  const _$StreamAttachmentFullScreenGridButtonClickEventModel(
      {required this.channelId,
      required this.messageId,
      required this.attachmentId,
      required this.attachmentType,
      final String? $type})
      : $type = $type ?? 'attachmentFullScreenGridButtonClick';

  factory _$StreamAttachmentFullScreenGridButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamAttachmentFullScreenGridButtonClickEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  /// id of the message
  @override
  final String messageId;

  /// the id of the attachment
  @override
  final String attachmentId;

  /// the type of the attachment
  @override
  final String attachmentType;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.attachmentFullScreenGridButtonClick(channelId: $channelId, messageId: $messageId, attachmentId: $attachmentId, attachmentType: $attachmentType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamAttachmentFullScreenGridButtonClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality().equals(other.messageId, messageId) &&
            const DeepCollectionEquality()
                .equals(other.attachmentId, attachmentId) &&
            const DeepCollectionEquality()
                .equals(other.attachmentType, attachmentType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(messageId),
      const DeepCollectionEquality().hash(attachmentId),
      const DeepCollectionEquality().hash(attachmentType));

  @JsonKey(ignore: true)
  @override
  _$$StreamAttachmentFullScreenGridButtonClickEventModelCopyWith<
          _$StreamAttachmentFullScreenGridButtonClickEventModel>
      get copyWith =>
          __$$StreamAttachmentFullScreenGridButtonClickEventModelCopyWithImpl<
                  _$StreamAttachmentFullScreenGridButtonClickEventModel>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenGridButtonClick(
        channelId, messageId, attachmentId, attachmentType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenGridButtonClick?.call(
        channelId, messageId, attachmentId, attachmentType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (attachmentFullScreenGridButtonClick != null) {
      return attachmentFullScreenGridButtonClick(
          channelId, messageId, attachmentId, attachmentType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenGridButtonClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenGridButtonClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (attachmentFullScreenGridButtonClick != null) {
      return attachmentFullScreenGridButtonClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamAttachmentFullScreenGridButtonClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamAttachmentFullScreenGridButtonClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamAttachmentFullScreenGridButtonClickEventModel(
          {required final String channelId,
          required final String messageId,
          required final String attachmentId,
          required final String attachmentType}) =
      _$StreamAttachmentFullScreenGridButtonClickEventModel;

  factory StreamAttachmentFullScreenGridButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamAttachmentFullScreenGridButtonClickEventModel.fromJson;

  /// id of the channel
  String get channelId;

  /// id of the message
  String get messageId;

  /// the id of the attachment
  String get attachmentId;

  /// the type of the attachment
  String get attachmentType;
  @JsonKey(ignore: true)
  _$$StreamAttachmentFullScreenGridButtonClickEventModelCopyWith<
          _$StreamAttachmentFullScreenGridButtonClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamAttachmentFullScreenCloseButtonClickEventModelCopyWith<
    $Res> {
  factory _$$StreamAttachmentFullScreenCloseButtonClickEventModelCopyWith(
          _$StreamAttachmentFullScreenCloseButtonClickEventModel value,
          $Res Function(_$StreamAttachmentFullScreenCloseButtonClickEventModel)
              then) =
      __$$StreamAttachmentFullScreenCloseButtonClickEventModelCopyWithImpl<
          $Res>;
  $Res call(
      {String channelId,
      String messageId,
      String attachmentId,
      String attachmentType});
}

/// @nodoc
class __$$StreamAttachmentFullScreenCloseButtonClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements
        _$$StreamAttachmentFullScreenCloseButtonClickEventModelCopyWith<$Res> {
  __$$StreamAttachmentFullScreenCloseButtonClickEventModelCopyWithImpl(
      _$StreamAttachmentFullScreenCloseButtonClickEventModel _value,
      $Res Function(_$StreamAttachmentFullScreenCloseButtonClickEventModel)
          _then)
      : super(
            _value,
            (v) => _then(
                v as _$StreamAttachmentFullScreenCloseButtonClickEventModel));

  @override
  _$StreamAttachmentFullScreenCloseButtonClickEventModel get _value =>
      super._value as _$StreamAttachmentFullScreenCloseButtonClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? messageId = freezed,
    Object? attachmentId = freezed,
    Object? attachmentType = freezed,
  }) {
    return _then(_$StreamAttachmentFullScreenCloseButtonClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: messageId == freezed
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentId: attachmentId == freezed
          ? _value.attachmentId
          : attachmentId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentType: attachmentType == freezed
          ? _value.attachmentType
          : attachmentType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamAttachmentFullScreenCloseButtonClickEventModel
    implements StreamAttachmentFullScreenCloseButtonClickEventModel {
  const _$StreamAttachmentFullScreenCloseButtonClickEventModel(
      {required this.channelId,
      required this.messageId,
      required this.attachmentId,
      required this.attachmentType,
      final String? $type})
      : $type = $type ?? 'attachmentFullScreenCloseButtonClick';

  factory _$StreamAttachmentFullScreenCloseButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamAttachmentFullScreenCloseButtonClickEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  /// id of the message
  @override
  final String messageId;

  /// the id of the attachment
  @override
  final String attachmentId;

  /// the type of the attachment
  @override
  final String attachmentType;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.attachmentFullScreenCloseButtonClick(channelId: $channelId, messageId: $messageId, attachmentId: $attachmentId, attachmentType: $attachmentType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamAttachmentFullScreenCloseButtonClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality().equals(other.messageId, messageId) &&
            const DeepCollectionEquality()
                .equals(other.attachmentId, attachmentId) &&
            const DeepCollectionEquality()
                .equals(other.attachmentType, attachmentType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(messageId),
      const DeepCollectionEquality().hash(attachmentId),
      const DeepCollectionEquality().hash(attachmentType));

  @JsonKey(ignore: true)
  @override
  _$$StreamAttachmentFullScreenCloseButtonClickEventModelCopyWith<
          _$StreamAttachmentFullScreenCloseButtonClickEventModel>
      get copyWith =>
          __$$StreamAttachmentFullScreenCloseButtonClickEventModelCopyWithImpl<
                  _$StreamAttachmentFullScreenCloseButtonClickEventModel>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenCloseButtonClick(
        channelId, messageId, attachmentId, attachmentType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenCloseButtonClick?.call(
        channelId, messageId, attachmentId, attachmentType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (attachmentFullScreenCloseButtonClick != null) {
      return attachmentFullScreenCloseButtonClick(
          channelId, messageId, attachmentId, attachmentType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenCloseButtonClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenCloseButtonClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (attachmentFullScreenCloseButtonClick != null) {
      return attachmentFullScreenCloseButtonClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamAttachmentFullScreenCloseButtonClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamAttachmentFullScreenCloseButtonClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamAttachmentFullScreenCloseButtonClickEventModel(
          {required final String channelId,
          required final String messageId,
          required final String attachmentId,
          required final String attachmentType}) =
      _$StreamAttachmentFullScreenCloseButtonClickEventModel;

  factory StreamAttachmentFullScreenCloseButtonClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamAttachmentFullScreenCloseButtonClickEventModel.fromJson;

  /// id of the channel
  String get channelId;

  /// id of the message
  String get messageId;

  /// the id of the attachment
  String get attachmentId;

  /// the type of the attachment
  String get attachmentType;
  @JsonKey(ignore: true)
  _$$StreamAttachmentFullScreenCloseButtonClickEventModelCopyWith<
          _$StreamAttachmentFullScreenCloseButtonClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamAttachmentFullScreenActionsMenuClickEventModelCopyWith<
    $Res> {
  factory _$$StreamAttachmentFullScreenActionsMenuClickEventModelCopyWith(
          _$StreamAttachmentFullScreenActionsMenuClickEventModel value,
          $Res Function(_$StreamAttachmentFullScreenActionsMenuClickEventModel)
              then) =
      __$$StreamAttachmentFullScreenActionsMenuClickEventModelCopyWithImpl<
          $Res>;
  $Res call(
      {String channelId,
      String messageId,
      String attachmentId,
      String attachmentType});
}

/// @nodoc
class __$$StreamAttachmentFullScreenActionsMenuClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements
        _$$StreamAttachmentFullScreenActionsMenuClickEventModelCopyWith<$Res> {
  __$$StreamAttachmentFullScreenActionsMenuClickEventModelCopyWithImpl(
      _$StreamAttachmentFullScreenActionsMenuClickEventModel _value,
      $Res Function(_$StreamAttachmentFullScreenActionsMenuClickEventModel)
          _then)
      : super(
            _value,
            (v) => _then(
                v as _$StreamAttachmentFullScreenActionsMenuClickEventModel));

  @override
  _$StreamAttachmentFullScreenActionsMenuClickEventModel get _value =>
      super._value as _$StreamAttachmentFullScreenActionsMenuClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? messageId = freezed,
    Object? attachmentId = freezed,
    Object? attachmentType = freezed,
  }) {
    return _then(_$StreamAttachmentFullScreenActionsMenuClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: messageId == freezed
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentId: attachmentId == freezed
          ? _value.attachmentId
          : attachmentId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentType: attachmentType == freezed
          ? _value.attachmentType
          : attachmentType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamAttachmentFullScreenActionsMenuClickEventModel
    implements StreamAttachmentFullScreenActionsMenuClickEventModel {
  const _$StreamAttachmentFullScreenActionsMenuClickEventModel(
      {required this.channelId,
      required this.messageId,
      required this.attachmentId,
      required this.attachmentType,
      final String? $type})
      : $type = $type ?? 'attachmentFullScreenActionsMenuClick';

  factory _$StreamAttachmentFullScreenActionsMenuClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamAttachmentFullScreenActionsMenuClickEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  /// id of the message
  @override
  final String messageId;

  /// the id of the attachment
  @override
  final String attachmentId;

  /// the type of the attachment
  @override
  final String attachmentType;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.attachmentFullScreenActionsMenuClick(channelId: $channelId, messageId: $messageId, attachmentId: $attachmentId, attachmentType: $attachmentType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamAttachmentFullScreenActionsMenuClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality().equals(other.messageId, messageId) &&
            const DeepCollectionEquality()
                .equals(other.attachmentId, attachmentId) &&
            const DeepCollectionEquality()
                .equals(other.attachmentType, attachmentType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(messageId),
      const DeepCollectionEquality().hash(attachmentId),
      const DeepCollectionEquality().hash(attachmentType));

  @JsonKey(ignore: true)
  @override
  _$$StreamAttachmentFullScreenActionsMenuClickEventModelCopyWith<
          _$StreamAttachmentFullScreenActionsMenuClickEventModel>
      get copyWith =>
          __$$StreamAttachmentFullScreenActionsMenuClickEventModelCopyWithImpl<
                  _$StreamAttachmentFullScreenActionsMenuClickEventModel>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenActionsMenuClick(
        channelId, messageId, attachmentId, attachmentType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenActionsMenuClick?.call(
        channelId, messageId, attachmentId, attachmentType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (attachmentFullScreenActionsMenuClick != null) {
      return attachmentFullScreenActionsMenuClick(
          channelId, messageId, attachmentId, attachmentType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenActionsMenuClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenActionsMenuClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (attachmentFullScreenActionsMenuClick != null) {
      return attachmentFullScreenActionsMenuClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamAttachmentFullScreenActionsMenuClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamAttachmentFullScreenActionsMenuClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamAttachmentFullScreenActionsMenuClickEventModel(
          {required final String channelId,
          required final String messageId,
          required final String attachmentId,
          required final String attachmentType}) =
      _$StreamAttachmentFullScreenActionsMenuClickEventModel;

  factory StreamAttachmentFullScreenActionsMenuClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamAttachmentFullScreenActionsMenuClickEventModel.fromJson;

  /// id of the channel
  String get channelId;

  /// id of the message
  String get messageId;

  /// the id of the attachment
  String get attachmentId;

  /// the type of the attachment
  String get attachmentType;
  @JsonKey(ignore: true)
  _$$StreamAttachmentFullScreenActionsMenuClickEventModelCopyWith<
          _$StreamAttachmentFullScreenActionsMenuClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreamAttachmentFullScreenActionItemClickEventModelCopyWith<
    $Res> {
  factory _$$StreamAttachmentFullScreenActionItemClickEventModelCopyWith(
          _$StreamAttachmentFullScreenActionItemClickEventModel value,
          $Res Function(_$StreamAttachmentFullScreenActionItemClickEventModel)
              then) =
      __$$StreamAttachmentFullScreenActionItemClickEventModelCopyWithImpl<$Res>;
  $Res call(
      {String channelId,
      String messageId,
      String attachmentId,
      String attachmentType,
      StreamAttachmentFullScreenActionType actionType});
}

/// @nodoc
class __$$StreamAttachmentFullScreenActionItemClickEventModelCopyWithImpl<$Res>
    extends _$StreamChatAnalyticsEventCopyWithImpl<$Res>
    implements
        _$$StreamAttachmentFullScreenActionItemClickEventModelCopyWith<$Res> {
  __$$StreamAttachmentFullScreenActionItemClickEventModelCopyWithImpl(
      _$StreamAttachmentFullScreenActionItemClickEventModel _value,
      $Res Function(_$StreamAttachmentFullScreenActionItemClickEventModel)
          _then)
      : super(
            _value,
            (v) => _then(
                v as _$StreamAttachmentFullScreenActionItemClickEventModel));

  @override
  _$StreamAttachmentFullScreenActionItemClickEventModel get _value =>
      super._value as _$StreamAttachmentFullScreenActionItemClickEventModel;

  @override
  $Res call({
    Object? channelId = freezed,
    Object? messageId = freezed,
    Object? attachmentId = freezed,
    Object? attachmentType = freezed,
    Object? actionType = freezed,
  }) {
    return _then(_$StreamAttachmentFullScreenActionItemClickEventModel(
      channelId: channelId == freezed
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: messageId == freezed
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentId: attachmentId == freezed
          ? _value.attachmentId
          : attachmentId // ignore: cast_nullable_to_non_nullable
              as String,
      attachmentType: attachmentType == freezed
          ? _value.attachmentType
          : attachmentType // ignore: cast_nullable_to_non_nullable
              as String,
      actionType: actionType == freezed
          ? _value.actionType
          : actionType // ignore: cast_nullable_to_non_nullable
              as StreamAttachmentFullScreenActionType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamAttachmentFullScreenActionItemClickEventModel
    implements StreamAttachmentFullScreenActionItemClickEventModel {
  const _$StreamAttachmentFullScreenActionItemClickEventModel(
      {required this.channelId,
      required this.messageId,
      required this.attachmentId,
      required this.attachmentType,
      required this.actionType,
      final String? $type})
      : $type = $type ?? 'attachmentFullScreenActionItemClick';

  factory _$StreamAttachmentFullScreenActionItemClickEventModel.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamAttachmentFullScreenActionItemClickEventModelFromJson(json);

  /// id of the channel
  @override
  final String channelId;

  /// id of the message
  @override
  final String messageId;

  /// the id of the attachment
  @override
  final String attachmentId;

  /// the type of the attachment
  @override
  final String attachmentType;

  /// the type of action that was selected
  @override
  final StreamAttachmentFullScreenActionType actionType;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreamChatAnalyticsEvent.attachmentFullScreenActionItemClick(channelId: $channelId, messageId: $messageId, attachmentId: $attachmentId, attachmentType: $attachmentType, actionType: $actionType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamAttachmentFullScreenActionItemClickEventModel &&
            const DeepCollectionEquality().equals(other.channelId, channelId) &&
            const DeepCollectionEquality().equals(other.messageId, messageId) &&
            const DeepCollectionEquality()
                .equals(other.attachmentId, attachmentId) &&
            const DeepCollectionEquality()
                .equals(other.attachmentType, attachmentType) &&
            const DeepCollectionEquality()
                .equals(other.actionType, actionType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(channelId),
      const DeepCollectionEquality().hash(messageId),
      const DeepCollectionEquality().hash(attachmentId),
      const DeepCollectionEquality().hash(attachmentType),
      const DeepCollectionEquality().hash(actionType));

  @JsonKey(ignore: true)
  @override
  _$$StreamAttachmentFullScreenActionItemClickEventModelCopyWith<
          _$StreamAttachmentFullScreenActionItemClickEventModel>
      get copyWith =>
          __$$StreamAttachmentFullScreenActionItemClickEventModelCopyWithImpl<
                  _$StreamAttachmentFullScreenActionItemClickEventModel>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() channelListView,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelListTileAvatarClick,
    required TResult Function() messageInputFocus,
    required TResult Function() messageInputTypingStarted,
    required TResult Function(bool hasText, bool hasAttachments,
            bool hasMentions, bool hasCustomCommands)
        messageInputSendButtonClick,
    required TResult Function() messageInputAttachmentButtonClick,
    required TResult Function() messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionType targetActionType)
        messageInputAttachmentActionClick,
    required TResult Function(String channelId, int unreadMessageCount)
        channelHeaderBackButtonClick,
    required TResult Function(String channelId) channelHeaderAvatarClick,
    required TResult Function(String channelId) messageListView,
    required TResult Function(String channelId) messageListScrollToBottomClick,
    required TResult Function(
            String channelId,
            String messageId,
            String mentionedUserId,
            String? quotedMessageId,
            String? parentMessageId)
        messageMentionClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageUrlClick,
    required TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)
        messageActionsTrigger,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)
        messageReactionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)
        messageActionClick,
    required TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)
        messageAttachmentClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenView,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenShareButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenGridButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(String channelId, String messageId,
            String attachmentId, String attachmentType)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenActionItemClick(
        channelId, messageId, attachmentId, attachmentType, actionType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenActionItemClick?.call(
        channelId, messageId, attachmentId, attachmentType, actionType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? channelListView,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelListTileAvatarClick,
    TResult Function()? messageInputFocus,
    TResult Function()? messageInputTypingStarted,
    TResult Function(bool hasText, bool hasAttachments, bool hasMentions,
            bool hasCustomCommands)?
        messageInputSendButtonClick,
    TResult Function()? messageInputAttachmentButtonClick,
    TResult Function()? messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionType targetActionType)?
        messageInputAttachmentActionClick,
    TResult Function(String channelId, int unreadMessageCount)?
        channelHeaderBackButtonClick,
    TResult Function(String channelId)? channelHeaderAvatarClick,
    TResult Function(String channelId)? messageListView,
    TResult Function(String channelId)? messageListScrollToBottomClick,
    TResult Function(String channelId, String messageId, String mentionedUserId,
            String? quotedMessageId, String? parentMessageId)?
        messageMentionClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageUrlClick,
    TResult Function(String channelId, String messageId,
            String? quotedMessageId, String? parentMessageId)?
        messageActionsTrigger,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String reactionType)?
        messageReactionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            StreamMessageActionType actionType)?
        messageActionClick,
    TResult Function(
            String channelId,
            String messageId,
            String? quotedMessageId,
            String? parentMessageId,
            String attachmentId,
            String attachmentType)?
        messageAttachmentClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenView,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenShareButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenGridButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(String channelId, String messageId, String attachmentId,
            String attachmentType)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(
            String channelId,
            String messageId,
            String attachmentId,
            String attachmentType,
            StreamAttachmentFullScreenActionType actionType)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (attachmentFullScreenActionItemClick != null) {
      return attachmentFullScreenActionItemClick(
          channelId, messageId, attachmentId, attachmentType, actionType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StreamChannelListViewEventModel value)
        channelListView,
    required TResult Function(StreamChannelListTileClickEventModel value)
        channelListTileClick,
    required TResult Function(StreamChannelListTileAvatarClickEventModel value)
        channelListTileAvatarClick,
    required TResult Function(StreamMessageInputFocusEventModel value)
        messageInputFocus,
    required TResult Function(StreamMessageInputTypingStartedEventModel value)
        messageInputTypingStarted,
    required TResult Function(StreamMessageInputSendButtonClickEventModel value)
        messageInputSendButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentButtonClickEventModel value)
        messageInputAttachmentButtonClick,
    required TResult Function(
            StreamMessageInputCommandButtonClickEventModel value)
        messageInputCommandButtonClick,
    required TResult Function(
            StreamMessageInputAttachmentActionClickEventModel value)
        messageInputAttachmentActionClick,
    required TResult Function(
            StreamChannelHeaderBackButtonClickEventModel value)
        channelHeaderBackButtonClick,
    required TResult Function(StreamChannelHeaderAvatarClickEventModel value)
        channelHeaderAvatarClick,
    required TResult Function(StreamMessageListViewEventModel value)
        messageListView,
    required TResult Function(
            StreamMessageListScrollToBottomClickEventModel value)
        messageListScrollToBottomClick,
    required TResult Function(StreamMessageMentionClickEventModel value)
        messageMentionClick,
    required TResult Function(StreamMessageUrlClickEventModel value)
        messageUrlClick,
    required TResult Function(StreamMessageActionsTriggerEventModel value)
        messageActionsTrigger,
    required TResult Function(StreamMessageReactionClickEventModel value)
        messageReactionClick,
    required TResult Function(StreamMessageActionClickEventModel value)
        messageActionClick,
    required TResult Function(StreamMessageAttachmentClickEventModel value)
        messageAttachmentClick,
    required TResult Function(StreamAttachmentFullScreenViewEventModel value)
        attachmentFullScreenView,
    required TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)
        attachmentFullScreenShareButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenGridButtonClickEventModel value)
        attachmentFullScreenGridButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)
        attachmentFullScreenCloseButtonClick,
    required TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)
        attachmentFullScreenActionsMenuClick,
    required TResult Function(
            StreamAttachmentFullScreenActionItemClickEventModel value)
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenActionItemClick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
  }) {
    return attachmentFullScreenActionItemClick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StreamChannelListViewEventModel value)? channelListView,
    TResult Function(StreamChannelListTileClickEventModel value)?
        channelListTileClick,
    TResult Function(StreamChannelListTileAvatarClickEventModel value)?
        channelListTileAvatarClick,
    TResult Function(StreamMessageInputFocusEventModel value)?
        messageInputFocus,
    TResult Function(StreamMessageInputTypingStartedEventModel value)?
        messageInputTypingStarted,
    TResult Function(StreamMessageInputSendButtonClickEventModel value)?
        messageInputSendButtonClick,
    TResult Function(StreamMessageInputAttachmentButtonClickEventModel value)?
        messageInputAttachmentButtonClick,
    TResult Function(StreamMessageInputCommandButtonClickEventModel value)?
        messageInputCommandButtonClick,
    TResult Function(StreamMessageInputAttachmentActionClickEventModel value)?
        messageInputAttachmentActionClick,
    TResult Function(StreamChannelHeaderBackButtonClickEventModel value)?
        channelHeaderBackButtonClick,
    TResult Function(StreamChannelHeaderAvatarClickEventModel value)?
        channelHeaderAvatarClick,
    TResult Function(StreamMessageListViewEventModel value)? messageListView,
    TResult Function(StreamMessageListScrollToBottomClickEventModel value)?
        messageListScrollToBottomClick,
    TResult Function(StreamMessageMentionClickEventModel value)?
        messageMentionClick,
    TResult Function(StreamMessageUrlClickEventModel value)? messageUrlClick,
    TResult Function(StreamMessageActionsTriggerEventModel value)?
        messageActionsTrigger,
    TResult Function(StreamMessageReactionClickEventModel value)?
        messageReactionClick,
    TResult Function(StreamMessageActionClickEventModel value)?
        messageActionClick,
    TResult Function(StreamMessageAttachmentClickEventModel value)?
        messageAttachmentClick,
    TResult Function(StreamAttachmentFullScreenViewEventModel value)?
        attachmentFullScreenView,
    TResult Function(
            StreamAttachmentFullScreenShareButtonClickEventModel value)?
        attachmentFullScreenShareButtonClick,
    TResult Function(StreamAttachmentFullScreenGridButtonClickEventModel value)?
        attachmentFullScreenGridButtonClick,
    TResult Function(
            StreamAttachmentFullScreenCloseButtonClickEventModel value)?
        attachmentFullScreenCloseButtonClick,
    TResult Function(
            StreamAttachmentFullScreenActionsMenuClickEventModel value)?
        attachmentFullScreenActionsMenuClick,
    TResult Function(StreamAttachmentFullScreenActionItemClickEventModel value)?
        attachmentFullScreenActionItemClick,
    required TResult orElse(),
  }) {
    if (attachmentFullScreenActionItemClick != null) {
      return attachmentFullScreenActionItemClick(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamAttachmentFullScreenActionItemClickEventModelToJson(
      this,
    );
  }
}

abstract class StreamAttachmentFullScreenActionItemClickEventModel
    implements StreamChatAnalyticsEvent {
  const factory StreamAttachmentFullScreenActionItemClickEventModel(
          {required final String channelId,
          required final String messageId,
          required final String attachmentId,
          required final String attachmentType,
          required final StreamAttachmentFullScreenActionType actionType}) =
      _$StreamAttachmentFullScreenActionItemClickEventModel;

  factory StreamAttachmentFullScreenActionItemClickEventModel.fromJson(
          Map<String, dynamic> json) =
      _$StreamAttachmentFullScreenActionItemClickEventModel.fromJson;

  /// id of the channel
  String get channelId;

  /// id of the message
  String get messageId;

  /// the id of the attachment
  String get attachmentId;

  /// the type of the attachment
  String get attachmentType;

  /// the type of action that was selected
  StreamAttachmentFullScreenActionType get actionType;
  @JsonKey(ignore: true)
  _$$StreamAttachmentFullScreenActionItemClickEventModelCopyWith<
          _$StreamAttachmentFullScreenActionItemClickEventModel>
      get copyWith => throw _privateConstructorUsedError;
}
