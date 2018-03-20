import '../view_model.dart';
import 'package:zetory/domain/domain.dart';

class ViewModelWrapperFactory {
  static final ViewModelWrapperFactory _instance = new ViewModelWrapperFactory._internal();

  factory ViewModelWrapperFactory() {
    return _instance;
  }

  ViewModelWrapperFactory._internal() {
    this._mediaViewModelWrapper = new MediaViewModelWrapper();
    this._mediaListWrapper = new ListWrapper(_mediaViewModelWrapper);
    this._albumViewModelWrapper = new AlbumViewModelWrapper(_mediaListWrapper);
    this._albumListWrapper = new ListWrapper(_albumViewModelWrapper);
  }

  AlbumViewModelWrapper get albumViewModelWrapper => _albumViewModelWrapper;
  MediaViewModelWrapper get mediaViewModelWrapper => _mediaViewModelWrapper;
  ListWrapper<Media, MediaInfo> get mediaListWrapper => _mediaListWrapper;
  ListWrapper<Album, AlbumInfo> get albumListWrapper => _albumListWrapper;

  AlbumViewModelWrapper _albumViewModelWrapper;
  MediaViewModelWrapper _mediaViewModelWrapper;
  ListWrapper<Media, MediaInfo> _mediaListWrapper;
  ListWrapper<Album, AlbumInfo> _albumListWrapper;
}

class AlbumViewModelWrapper extends AbsWrapper<Album, AlbumInfo> {

  AlbumViewModelWrapper(this.mediaListWrapper) : assert(mediaListWrapper != null);

  final ListWrapper<Media, MediaInfo> mediaListWrapper;

  @override
  AlbumInfo transform(Album input) {
    if (input == null) {
      return null;
    }

    return new AlbumInfo(
        caption: input.caption,
        name: input.name,
        created: input.created,
        icon: input.icon,
        medias: mediaListWrapper.transform(input.medias)
    );
  }

}

class MediaViewModelWrapper extends AbsWrapper<Media, MediaInfo> {

  @override
  MediaInfo transform(Media input) {
    if (input == null) {
      return null;
    }

    return new MediaInfo(
        type: input.type,
        showAt: input.showAt,
        image: input.image,
        width: input.width,
        height: input.height
    );
  }

}