import 'package:zetory/presentation/view_model/view_model.dart';
import 'package:zetory/domain/domain.dart';

class ViewModelWrapperFactory {
  static final ViewModelWrapperFactory _instance = ViewModelWrapperFactory._internal();

  factory ViewModelWrapperFactory() {
    return _instance;
  }

  ViewModelWrapperFactory._internal() {
    this._mediaViewModelWrapper = MediaViewModelWrapper();
    this._mediaListWrapper = ListWrapper(_mediaViewModelWrapper);
    this._albumViewModelWrapper = AlbumViewModelWrapper(_mediaListWrapper);
    this._albumListWrapper = ListWrapper(_albumViewModelWrapper);
    this._githubUserWrapper = GithubUserWrapper();
  }

  GithubUserWrapper get githubUserWrapper => _githubUserWrapper;
  AlbumViewModelWrapper get albumViewModelWrapper => _albumViewModelWrapper;
  MediaViewModelWrapper get mediaViewModelWrapper => _mediaViewModelWrapper;
  ListWrapper<Media, MediaInfo> get mediaListWrapper => _mediaListWrapper;
  ListWrapper<Album, AlbumInfo> get albumListWrapper => _albumListWrapper;

  GithubUserWrapper _githubUserWrapper;
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

    return AlbumInfo(
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

    return MediaInfo(
        type: input.type,
        showAt: input.showAt,
        image: input.image,
        width: input.width,
        height: input.height
    );
  }
}

class GithubUserWrapper extends AbsWrapper<GithubUser, GithubUserViewModel> {
  @override
  GithubUserViewModel transform(GithubUser input) {
    if (input == null) {
      return null;
    }

    return GithubUserViewModel(
      type: input.type,
      login: input.login,
      name: input.name,
      location: input.location,
      url: input.url,
      avatarUrl: input.avatarUrl,
      blog: input.blog,
    );
  }
}