// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String,
    role: json['role'] as String? ?? '',
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    lastActive: json['last_active'] == null
        ? null
        : DateTime.parse(json['last_active'] as String),
    online: json['online'] as bool? ?? false,
    extraData: json['extra_data'] as Map<String, dynamic>,
    banned: json['banned'] as bool? ?? false,
    teams:
        (json['teams'] as List<dynamic>?)?.map((e) => e as String).toList() ??
            [],
  );
}

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('role', readonly(instance.role));
  writeNotNull('teams', readonly(instance.teams));
  writeNotNull('created_at', readonly(instance.createdAt));
  writeNotNull('updated_at', readonly(instance.updatedAt));
  writeNotNull('last_active', readonly(instance.lastActive));
  writeNotNull('online', readonly(instance.online));
  writeNotNull('banned', readonly(instance.banned));
  val['extra_data'] = instance.extraData;
  return val;
}
