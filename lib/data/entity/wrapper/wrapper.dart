import '../entity.dart';
import 'package:zetory/domain/domain.dart';

class EtityWrapperFactory {
  static final EtityWrapperFactory _instance = new EtityWrapperFactory._internal();

  factory EtityWrapperFactory() {
    return _instance;
  }

  EtityWrapperFactory._internal() {
    this._mediaEntityWrapper = new MediaEntityWrapper();
    this._mediaListWrapper = new ListWrapper(_mediaEntityWrapper);
    this._albumEntityWrapper = new AlbumEntityWrapper(_mediaListWrapper);
    this._albumListWrapper = new ListWrapper(_albumEntityWrapper);
  }

  AlbumEntityWrapper get albumEntityWrapper => _albumEntityWrapper;
  MediaEntityWrapper get mediaEntityWrapper => _mediaEntityWrapper;
  ListWrapper<MediaEntity, Media> get mediaListWrapper => _mediaListWrapper;
  ListWrapper<AlbumEntity, Album> get albumListWrapper => _albumListWrapper;

  AlbumEntityWrapper _albumEntityWrapper;
  MediaEntityWrapper _mediaEntityWrapper;
  ListWrapper<MediaEntity, Media> _mediaListWrapper;
  ListWrapper<AlbumEntity, Album> _albumListWrapper;
}

class AlbumEntityWrapper extends AbsWrapper<AlbumEntity, Album> {

  AlbumEntityWrapper(this.mediaListWrapper) : assert(mediaListWrapper != null);

  final ListWrapper<MediaEntity, Media> mediaListWrapper;

  @override
  Album transform(AlbumEntity input) {
    if (input == null) {
      return null;
    }

    return new Album(
      caption: input.caption,
      name: input.name,
      created: input.created,
      icon: input.icon,
      medias: mediaListWrapper.transform(input.medias)
    );
  }

}

class MediaEntityWrapper extends AbsWrapper<MediaEntity, Media> {

  @override
  Media transform(MediaEntity input) {
    if (input == null) {
      return null;
    }

    return new Media(
        type: input.type,
        showAt: input.showAt,
        image: input.image,
        width: input.width,
        height: input.height
    );
  }

}