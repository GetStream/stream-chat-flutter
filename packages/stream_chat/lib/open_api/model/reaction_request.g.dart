// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReactionRequest _$ReactionRequestFromJson(Map<String, dynamic> json) =>
    ReactionRequest(
      createdAt: _$JsonConverterFromJson<Object, DateTime>(
        json['created_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      custom: json['custom'] as Map<String, dynamic>?,
      score: (json['score'] as num?)?.toInt(),
      type: json['type'] as String,
      updatedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['updated_at'],
        const StreamDateTimeConverter().fromJson,
      ),
    );

Map<String, dynamic> _$ReactionRequestToJson(ReactionRequest instance) =>
    <String, dynamic>{
      'created_at': _$JsonConverterToJson<Object, DateTime>(
        instance.createdAt,
        const StreamDateTimeConverter().toJson,
      ),
      'custom': instance.custom,
      'score': instance.score,
      'type': instance.type,
      'updated_at': _$JsonConverterToJson<Object, DateTime>(
        instance.updatedAt,
        const StreamDateTimeConverter().toJson,
      ),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
