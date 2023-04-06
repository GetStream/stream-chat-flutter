// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      role: json['role'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      lastActive: json['last_active'] == null
          ? null
          : DateTime.parse(json['last_active'] as String),
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
      online: json['online'] as bool? ?? false,
      banned: json['banned'] as bool? ?? false,
      banExpires: json['ban_expires'] == null
          ? null
          : DateTime.parse(json['ban_expires'] as String),
      teams:
          (json['teams'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      language: json['language'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('language', instance.language);
  val['extra_data'] = instance.extraData;
  return val;
}
