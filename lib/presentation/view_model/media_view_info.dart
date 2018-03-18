import 'package:meta/meta.dart';

class MediaInfo {
  MediaInfo({
    this.type = "photo",
    @required this.showAt,
    @required this.image,
    @required this.width,
    @required this.height,
  });

  final String type;
  final double showAt;
  final String image;
  final double width;
  final double height;

}
