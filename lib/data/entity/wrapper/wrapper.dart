import 'package:zetory/data/entity/entity.dart';
import 'package:zetory/domain/domain.dart';

class EntityWrapperFactory {
  static final EntityWrapperFactory _instance = new EntityWrapperFactory._internal();

  factory EntityWrapperFactory() {
    return _instance;
  }

  EntityWrapperFactory._internal() {
    this._mediaEntityWrapper = new MediaEntityWrapper();
    this._mediaListWrapper = new ListWrapper(_mediaEntityWrapper);
    this._albumEntityWrapper = new AlbumEntityWrapper(_mediaListWrapper);
    this._albumListWrapper = new ListWrapper(_albumEntityWrapper);
    this._githubUserWrapper = GithubUserWrapper();
  }

  GithubUserWrapper get githubUserWrapper => _githubUserWrapper;
  AlbumEntityWrapper get albumEntityWrapper => _albumEntityWrapper;
  MediaEntityWrapper get mediaEntityWrapper => _mediaEntityWrapper;
  ListWrapper<MediaEntity, Media> get mediaListWrapper => _mediaListWrapper;
  ListWrapper<AlbumEntity, Album> get albumListWrapper => _albumListWrapper;

  AlbumEntityWrapper _albumEntityWrapper;
  MediaEntityWrapper _mediaEntityWrapper;
  ListWrapper<MediaEntity, Media> _mediaListWrapper;
  ListWrapper<AlbumEntity, Album> _albumListWrapper;

  GithubUserWrapper _githubUserWrapper;
}

class AlbumEntityWrapper extends AbsWrapper<AlbumEntity, Album> {
  AlbumEntityWrapper(this.mediaListWrapper) : assert(mediaListWrapper != null);

  final ListWrapper<MediaEntity, Media> mediaListWrapper;

  @override
  Album transform(AlbumEntity input) {
    if (input == null) {
      return null;
    }

    return Album(
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

    return Media(
        type: input.type,
        showAt: input.showAt,
        image: input.image,
        width: input.width,
        height: input.height
    );
  }
}

class GithubUserWrapper extends AbsWrapper<GithubUserEntity, GithubUser> {
  @override
  GithubUser transform(GithubUserEntity input) {
    if (input == null) {
      return null;
    }

    return GithubUser(
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