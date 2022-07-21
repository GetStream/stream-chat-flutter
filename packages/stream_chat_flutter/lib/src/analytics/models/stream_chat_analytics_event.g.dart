// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_chat_analytics_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StreamChannelListViewEventModel _$$StreamChannelListViewEventModelFromJson(
        Map<String, dynamic> json) =>
    _$StreamChannelListViewEventModel(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$StreamChannelListViewEventModelToJson(
        _$StreamChannelListViewEventModel instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$StreamChannelListTileClickEventModel
    _$$StreamChannelListTileClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamChannelListTileClickEventModel(
          channelId: json['channelId'] as String,
          unreadMessageCount: json['unreadMessageCount'] as int,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamChannelListTileClickEventModelToJson(
        _$StreamChannelListTileClickEventModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'unreadMessageCount': instance.unreadMessageCount,
      'runtimeType': instance.$type,
    };

_$StreamChannelListTileAvatarClickEventModel
    _$$StreamChannelListTileAvatarClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamChannelListTileAvatarClickEventModel(
          channelId: json['channelId'] as String,
          unreadMessageCount: json['unreadMessageCount'] as int,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamChannelListTileAvatarClickEventModelToJson(
        _$StreamChannelListTileAvatarClickEventModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'unreadMessageCount': instance.unreadMessageCount,
      'runtimeType': instance.$type,
    };

_$StreamMessageInputFocusEventModel
    _$$StreamMessageInputFocusEventModelFromJson(Map<String, dynamic> json) =>
        _$StreamMessageInputFocusEventModel(
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamMessageInputFocusEventModelToJson(
        _$StreamMessageInputFocusEventModel instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$StreamMessageInputTypingStartedEventModel
    _$$StreamMessageInputTypingStartedEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamMessageInputTypingStartedEventModel(
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamMessageInputTypingStartedEventModelToJson(
        _$StreamMessageInputTypingStartedEventModel instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$StreamMessageInputSendButtonClickEventModel
    _$$StreamMessageInputSendButtonClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamMessageInputSendButtonClickEventModel(
          hasText: json['hasText'] as bool,
          hasAttachments: json['hasAttachments'] as bool,
          hasMentions: json['hasMentions'] as bool,
          hasCustomCommands: json['hasCustomCommands'] as bool,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamMessageInputSendButtonClickEventModelToJson(
        _$StreamMessageInputSendButtonClickEventModel instance) =>
    <String, dynamic>{
      'hasText': instance.hasText,
      'hasAttachments': instance.hasAttachments,
      'hasMentions': instance.hasMentions,
      'hasCustomCommands': instance.hasCustomCommands,
      'runtimeType': instance.$type,
    };

_$StreamMessageInputAttachmentButtonClickEventModel
    _$$StreamMessageInputAttachmentButtonClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamMessageInputAttachmentButtonClickEventModel(
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamMessageInputAttachmentButtonClickEventModelToJson(
        _$StreamMessageInputAttachmentButtonClickEventModel instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$StreamMessageInputCommandButtonClickEventModel
    _$$StreamMessageInputCommandButtonClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamMessageInputCommandButtonClickEventModel(
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamMessageInputCommandButtonClickEventModelToJson(
        _$StreamMessageInputCommandButtonClickEventModel instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$StreamMessageInputAttachmentActionClickEventModel
    _$$StreamMessageInputAttachmentActionClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamMessageInputAttachmentActionClickEventModel(
          targetActionType: $enumDecode(
              _$StreamMessageInputAttachmentActionTypeEnumMap,
              json['targetActionType']),
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamMessageInputAttachmentActionClickEventModelToJson(
        _$StreamMessageInputAttachmentActionClickEventModel instance) =>
    <String, dynamic>{
      'targetActionType': _$StreamMessageInputAttachmentActionTypeEnumMap[
          instance.targetActionType],
      'runtimeType': instance.$type,
    };

const _$StreamMessageInputAttachmentActionTypeEnumMap = {
  StreamMessageInputAttachmentActionType.gallery: 'gallery',
  StreamMessageInputAttachmentActionType.filePicker: 'filePicker',
  StreamMessageInputAttachmentActionType.capturePhoto: 'capturePhoto',
  StreamMessageInputAttachmentActionType.captureVideo: 'captureVideo',
};

_$StreamChannelHeaderBackButtonClickEventModel
    _$$StreamChannelHeaderBackButtonClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamChannelHeaderBackButtonClickEventModel(
          channelId: json['channelId'] as String,
          unreadMessageCount: json['unreadMessageCount'] as int,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamChannelHeaderBackButtonClickEventModelToJson(
        _$StreamChannelHeaderBackButtonClickEventModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'unreadMessageCount': instance.unreadMessageCount,
      'runtimeType': instance.$type,
    };

_$StreamChannelHeaderAvatarClickEventModel
    _$$StreamChannelHeaderAvatarClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamChannelHeaderAvatarClickEventModel(
          channelId: json['channelId'] as String,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamChannelHeaderAvatarClickEventModelToJson(
        _$StreamChannelHeaderAvatarClickEventModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'runtimeType': instance.$type,
    };

_$StreamMessageListViewEventModel _$$StreamMessageListViewEventModelFromJson(
        Map<String, dynamic> json) =>
    _$StreamMessageListViewEventModel(
      channelId: json['channelId'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$StreamMessageListViewEventModelToJson(
        _$StreamMessageListViewEventModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'runtimeType': instance.$type,
    };

_$StreamMessageListScrollToBottomClickEventModel
    _$$StreamMessageListScrollToBottomClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamMessageListScrollToBottomClickEventModel(
          channelId: json['channelId'] as String,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamMessageListScrollToBottomClickEventModelToJson(
        _$StreamMessageListScrollToBottomClickEventModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'runtimeType': instance.$type,
    };

_$StreamMessageMentionClickEventModel
    _$$StreamMessageMentionClickEventModelFromJson(Map<String, dynamic> json) =>
        _$StreamMessageMentionClickEventModel(
          channelId: json['channelId'] as String,
          messageId: json['messageId'] as String,
          mentionedUserId: json['mentionedUserId'] as String,
          quotedMessageId: json['quotedMessageId'] as String?,
          parentMessageId: json['parentMessageId'] as String?,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamMessageMentionClickEventModelToJson(
        _$StreamMessageMentionClickEventModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'messageId': instance.messageId,
      'mentionedUserId': instance.mentionedUserId,
      'quotedMessageId': instance.quotedMessageId,
      'parentMessageId': instance.parentMessageId,
      'runtimeType': instance.$type,
    };

_$StreamMessageUrlClickEventModel _$$StreamMessageUrlClickEventModelFromJson(
        Map<String, dynamic> json) =>
    _$StreamMessageUrlClickEventModel(
      channelId: json['channelId'] as String,
      messageId: json['messageId'] as String,
      quotedMessageId: json['quotedMessageId'] as String?,
      parentMessageId: json['parentMessageId'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$StreamMessageUrlClickEventModelToJson(
        _$StreamMessageUrlClickEventModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'messageId': instance.messageId,
      'quotedMessageId': instance.quotedMessageId,
      'parentMessageId': instance.parentMessageId,
      'runtimeType': instance.$type,
    };

_$StreamMessageActionsTriggerEventModel
    _$$StreamMessageActionsTriggerEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamMessageActionsTriggerEventModel(
          channelId: json['channelId'] as String,
          messageId: json['messageId'] as String,
          quotedMessageId: json['quotedMessageId'] as String?,
          parentMessageId: json['parentMessageId'] as String?,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamMessageActionsTriggerEventModelToJson(
        _$StreamMessageActionsTriggerEventModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'messageId': instance.messageId,
      'quotedMessageId': instance.quotedMessageId,
      'parentMessageId': instance.parentMessageId,
      'runtimeType': instance.$type,
    };

_$StreamMessageReactionClickEventModel
    _$$StreamMessageReactionClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamMessageReactionClickEventModel(
          channelId: json['channelId'] as String,
          messageId: json['messageId'] as String,
          quotedMessageId: json['quotedMessageId'] as String?,
          parentMessageId: json['parentMessageId'] as String?,
          reactionType: json['reactionType'] as String,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamMessageReactionClickEventModelToJson(
        _$StreamMessageReactionClickEventModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'messageId': instance.messageId,
      'quotedMessageId': instance.quotedMessageId,
      'parentMessageId': instance.parentMessageId,
      'reactionType': instance.reactionType,
      'runtimeType': instance.$type,
    };

_$StreamMessageActionClickEventModel
    _$$StreamMessageActionClickEventModelFromJson(Map<String, dynamic> json) =>
        _$StreamMessageActionClickEventModel(
          channelId: json['channelId'] as String,
          messageId: json['messageId'] as String,
          quotedMessageId: json['quotedMessageId'] as String?,
          parentMessageId: json['parentMessageId'] as String?,
          actionType:
              $enumDecode(_$StreamMessageActionTypeEnumMap, json['actionType']),
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamMessageActionClickEventModelToJson(
        _$StreamMessageActionClickEventModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'messageId': instance.messageId,
      'quotedMessageId': instance.quotedMessageId,
      'parentMessageId': instance.parentMessageId,
      'actionType': _$StreamMessageActionTypeEnumMap[instance.actionType],
      'runtimeType': instance.$type,
    };

const _$StreamMessageActionTypeEnumMap = {
  StreamMessageActionType.reply: 'reply',
  StreamMessageActionType.threadReply: 'threadReply',
  StreamMessageActionType.flag: 'flag',
  StreamMessageActionType.pin: 'pin',
  StreamMessageActionType.unpin: 'unpin',
  StreamMessageActionType.delete: 'delete',
};

_$StreamMessageAttachmentClickEventModel
    _$$StreamMessageAttachmentClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamMessageAttachmentClickEventModel(
          channelId: json['channelId'] as String,
          messageId: json['messageId'] as String,
          quotedMessageId: json['quotedMessageId'] as String?,
          parentMessageId: json['parentMessageId'] as String?,
          attachmentId: json['attachmentId'] as String,
          attachmentType: json['attachmentType'] as String,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamMessageAttachmentClickEventModelToJson(
        _$StreamMessageAttachmentClickEventModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'messageId': instance.messageId,
      'quotedMessageId': instance.quotedMessageId,
      'parentMessageId': instance.parentMessageId,
      'attachmentId': instance.attachmentId,
      'attachmentType': instance.attachmentType,
      'runtimeType': instance.$type,
    };

_$StreamAttachmentFullScreenViewEventModel
    _$$StreamAttachmentFullScreenViewEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamAttachmentFullScreenViewEventModel(
          channelId: json['channelId'] as String,
          messageId: json['messageId'] as String,
          attachmentId: json['attachmentId'] as String,
          attachmentType: json['attachmentType'] as String,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$StreamAttachmentFullScreenViewEventModelToJson(
        _$StreamAttachmentFullScreenViewEventModel instance) =>
    <String, dynamic>{
      'channelId': instance.channelId,
      'messageId': instance.messageId,
      'attachmentId': instance.attachmentId,
      'attachmentType': instance.attachmentType,
      'runtimeType': instance.$type,
    };

_$StreamAttachmentFullScreenShareButtonClickEventModel
    _$$StreamAttachmentFullScreenShareButtonClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamAttachmentFullScreenShareButtonClickEventModel(
          channelId: json['channelId'] as String,
          messageId: json['messageId'] as String,
          attachmentId: json['attachmentId'] as String,
          attachmentType: json['attachmentType'] as String,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic>
    _$$StreamAttachmentFullScreenShareButtonClickEventModelToJson(
            _$StreamAttachmentFullScreenShareButtonClickEventModel instance) =>
        <String, dynamic>{
          'channelId': instance.channelId,
          'messageId': instance.messageId,
          'attachmentId': instance.attachmentId,
          'attachmentType': instance.attachmentType,
          'runtimeType': instance.$type,
        };

_$StreamAttachmentFullScreenGridButtonClickEventModel
    _$$StreamAttachmentFullScreenGridButtonClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamAttachmentFullScreenGridButtonClickEventModel(
          channelId: json['channelId'] as String,
          messageId: json['messageId'] as String,
          attachmentId: json['attachmentId'] as String,
          attachmentType: json['attachmentType'] as String,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic>
    _$$StreamAttachmentFullScreenGridButtonClickEventModelToJson(
            _$StreamAttachmentFullScreenGridButtonClickEventModel instance) =>
        <String, dynamic>{
          'channelId': instance.channelId,
          'messageId': instance.messageId,
          'attachmentId': instance.attachmentId,
          'attachmentType': instance.attachmentType,
          'runtimeType': instance.$type,
        };

_$StreamAttachmentFullScreenCloseButtonClickEventModel
    _$$StreamAttachmentFullScreenCloseButtonClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamAttachmentFullScreenCloseButtonClickEventModel(
          channelId: json['channelId'] as String,
          messageId: json['messageId'] as String,
          attachmentId: json['attachmentId'] as String,
          attachmentType: json['attachmentType'] as String,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic>
    _$$StreamAttachmentFullScreenCloseButtonClickEventModelToJson(
            _$StreamAttachmentFullScreenCloseButtonClickEventModel instance) =>
        <String, dynamic>{
          'channelId': instance.channelId,
          'messageId': instance.messageId,
          'attachmentId': instance.attachmentId,
          'attachmentType': instance.attachmentType,
          'runtimeType': instance.$type,
        };

_$StreamAttachmentFullScreenActionsMenuClickEventModel
    _$$StreamAttachmentFullScreenActionsMenuClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamAttachmentFullScreenActionsMenuClickEventModel(
          channelId: json['channelId'] as String,
          messageId: json['messageId'] as String,
          attachmentId: json['attachmentId'] as String,
          attachmentType: json['attachmentType'] as String,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic>
    _$$StreamAttachmentFullScreenActionsMenuClickEventModelToJson(
            _$StreamAttachmentFullScreenActionsMenuClickEventModel instance) =>
        <String, dynamic>{
          'channelId': instance.channelId,
          'messageId': instance.messageId,
          'attachmentId': instance.attachmentId,
          'attachmentType': instance.attachmentType,
          'runtimeType': instance.$type,
        };

_$StreamAttachmentFullScreenActionItemClickEventModel
    _$$StreamAttachmentFullScreenActionItemClickEventModelFromJson(
            Map<String, dynamic> json) =>
        _$StreamAttachmentFullScreenActionItemClickEventModel(
          channelId: json['channelId'] as String,
          messageId: json['messageId'] as String,
          attachmentId: json['attachmentId'] as String,
          attachmentType: json['attachmentType'] as String,
          actionType: $enumDecode(_$StreamAttachmentFullScreenActionTypeEnumMap,
              json['actionType']),
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic>
    _$$StreamAttachmentFullScreenActionItemClickEventModelToJson(
            _$StreamAttachmentFullScreenActionItemClickEventModel instance) =>
        <String, dynamic>{
          'channelId': instance.channelId,
          'messageId': instance.messageId,
          'attachmentId': instance.attachmentId,
          'attachmentType': instance.attachmentType,
          'actionType': _$StreamAttachmentFullScreenActionTypeEnumMap[
              instance.actionType],
          'runtimeType': instance.$type,
        };

const _$StreamAttachmentFullScreenActionTypeEnumMap = {
  StreamAttachmentFullScreenActionType.reply: 'reply',
  StreamAttachmentFullScreenActionType.showInChat: 'showInChat',
  StreamAttachmentFullScreenActionType.save: 'save',
};
