// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Read _$ReadFromJson(Map json) {
  return Read(
    lastRead: DateTime.parse(json['last_read'] as String),
    user: User.fromJson((json['user'] as Map?)?.map(
      (k, e) => MapEntry(k as String, e),
    )),
    unreadMessages: json['unread_messages'] as int,
  );
}

Map<String, dynamic> _$ReadToJson(Read instance) => <String, dynamic>{
      'last_read': instance.lastRead.toIso8601String(),
      'user': instance.user.toJson(),
      'unread_messages': instance.unreadMessages,
    };
