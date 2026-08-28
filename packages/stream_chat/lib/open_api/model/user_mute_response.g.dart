// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_mute_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMuteResponse _$UserMuteResponseFromJson(Map<String, dynamic> json) =>
    UserMuteResponse(
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      expires: _$JsonConverterFromJson<Object, DateTime>(
        json['expires'],
        const StreamDateTimeConverter().fromJson,
      ),
      target: json['target'] == null
          ? null
          : UserResponse.fromJson(json['target'] as Map<String, dynamic>),
      updatedAt: const StreamDateTimeConverter().fromJson(
        json['updated_at'] as Object,
      ),
      user: json['user'] == null
          ? null
          : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserMuteResponseToJson(UserMuteResponse instance) =>
    <String, dynamic>{
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'expires': _$JsonConverterToJson<Object, DateTime>(
        instance.expires,
        const StreamDateTimeConverter().toJson,
      ),
      'target': instance.target?.toJson(),
      'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
      'user': instance.user?.toJson(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
