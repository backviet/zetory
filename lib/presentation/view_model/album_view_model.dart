import 'package:meta/meta.dart';
import 'media_view_info.dart';

class AlbumInfo {
  AlbumInfo({
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
  final List<MediaInfo> medias;

}
