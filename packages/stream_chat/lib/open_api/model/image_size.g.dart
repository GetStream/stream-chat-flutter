// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_size.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageSize _$ImageSizeFromJson(Map<String, dynamic> json) => ImageSize(
  crop: json['crop'] as String?,
  height: (json['height'] as num?)?.toInt(),
  resize: json['resize'] as String?,
  width: (json['width'] as num?)?.toInt(),
);

Map<String, dynamic> _$ImageSizeToJson(ImageSize instance) => <String, dynamic>{
  'crop': instance.crop,
  'height': instance.height,
  'resize': instance.resize,
  'width': instance.width,
};
