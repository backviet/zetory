// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

MediaEntity _$MediaEntityFromJson(Map<String, dynamic> json) => new MediaEntity(
    type: (json['type'] as String) ?? "photo",
    showAt: json['show_at'] as double,
    image: json['image'] as String,
    width: (json['width'] as num)?.toDouble(),
    height: (json['height'] as num)?.toDouble());

abstract class _$MediaEntitySerializerMixin {
  String get type;
  double get showAt;
  String get image;
  double get width;
  double get height;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type,
        'show_at': showAt,
        'image': image,
        'width': width,
        'height': height
      };
}
