import 'package:meta/meta.dart';

import 'media.dart';

import 'package:json_annotation/json_annotation.dart';
part 'album.g.dart';

@JsonSerializable()
class AlbumEntity extends Object with _$AlbumEntitySerializerMixin {
  AlbumEntity({
    @required this.name,
    @required this.caption,
    @required this.icon,
    @required this.created,
    @required this.medias,
  });

  final String name;
  final String caption;
  final String icon;
  final double created;
  final List<MediaEntity> medias;

  factory AlbumEntity.fromJson(Map<String, dynamic> json) => _$AlbumEntityFromJson(json);

  @override
  String toString() {
    return '''
      name: ${name}, caption: ${caption}, icon: ${icon}, created: ${created}, medias: ${medias.map((media) => media.toString())}
    ''';
  }

  static List<AlbumEntity> listFromJson(Map<String, dynamic> albumsMap) {
    final List<AlbumEntity> albums = (albumsMap['albums'] as List)
        ?.map((e) => e == null ? null : new AlbumEntity.fromJson(e as Map<String, dynamic>))
        ?.toList();

    return albums;
  }

}