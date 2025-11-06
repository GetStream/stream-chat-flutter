// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connect_user_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$ConnectUserDetailsToJson(ConnectUserDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      if (instance.name case final value?) 'name': value,
      if (instance.image case final value?) 'image': value,
      if (instance.language case final value?) 'language': value,
      if (instance.invisible case final value?) 'invisible': value,
      if (instance.privacySettings?.toJson() case final value?)
        'privacy_settings': value,
      if (instance.extraData case final value?) 'extra_data': value,
    };
