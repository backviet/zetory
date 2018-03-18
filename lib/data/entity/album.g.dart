// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

AlbumEntity _$AlbumEntityFromJson(Map<String, dynamic> json) => new AlbumEntity(
    name: json['name'] as String,
    caption: json['caption'] as String,
    icon: json['icon'] as String,
    created: (json['created'] as num)?.toDouble(),
    medias: (json['medias'] as List)
        ?.map((e) => e == null
            ? null
            : new MediaEntity.fromJson(e as Map<String, dynamic>))
        ?.toList());

abstract class _$AlbumEntitySerializerMixin {
  String get name;
  String get caption;
  String get icon;
  double get created;
  List<MediaEntity> get medias;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'caption': caption,
        'icon': icon,
        'created': created,
        'medias': medias
      };
}
