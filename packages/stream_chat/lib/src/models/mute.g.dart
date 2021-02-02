// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mute _$MuteFromJson(Map json) {
  return Mute(
    user: json['user'] == null
        ? null
        : User.fromJson((json['user'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    channel: json['channel'] == null
        ? null
        : ChannelModel.fromJson((json['channel'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$MuteToJson(Mute instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('user', readonly(instance.user));
  writeNotNull('channel', readonly(instance.channel));
  writeNotNull('created_at', readonly(instance.createdAt));
  writeNotNull('updated_at', readonly(instance.updatedAt));
  return val;
}
