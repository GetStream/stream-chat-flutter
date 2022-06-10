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
