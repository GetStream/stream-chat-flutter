// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageUpdate _$MessageUpdateFromJson(Map<String, dynamic> json) =>
    MessageUpdate(
      changeSet: json['change_set'] == null
          ? null
          : MessageChangeSet.fromJson(
              json['change_set'] as Map<String, dynamic>,
            ),
      oldText: json['old_text'] as String?,
    );

Map<String, dynamic> _$MessageUpdateToJson(MessageUpdate instance) =>
    <String, dynamic>{
      'change_set': instance.changeSet?.toJson(),
      'old_text': instance.oldText,
    };
