// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_read_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkReadRequest _$MarkReadRequestFromJson(Map<String, dynamic> json) =>
    MarkReadRequest(
      messageId: json['message_id'] as String?,
      threadId: json['thread_id'] as String?,
    );

Map<String, dynamic> _$MarkReadRequestToJson(MarkReadRequest instance) =>
    <String, dynamic>{
      'message_id': instance.messageId,
      'thread_id': instance.threadId,
    };
