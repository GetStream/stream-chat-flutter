// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_auth_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSAuthMessage _$WSAuthMessageFromJson(Map<String, dynamic> json) =>
    WSAuthMessage(
      memberCustomInclude: (json['member_custom_include'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => WSAuthMessageProducts.fromJson(e as String))
          .toList(),
      token: json['token'] as String,
    );

Map<String, dynamic> _$WSAuthMessageToJson(WSAuthMessage instance) =>
    <String, dynamic>{
      'member_custom_include': instance.memberCustomInclude,
      'products': instance.products?.map((e) => e.toJson()).toList(),
      'token': instance.token,
    };
