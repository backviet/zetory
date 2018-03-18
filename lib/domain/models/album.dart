import 'media.dart';

class Album {
  Album({
    this.name,
    this.caption,
    this.icon,
    this.created,
    this.medias,
  });

  final String name;
  final String caption;
  final String icon;
  final double created;
  final List<Media> medias;
}