import 'presenter.dart';
import 'package:zetory/data/data.dart';
import 'package:zetory/presentation/view_model/view_model.dart';
import 'package:zetory/domain/domain.dart' show GetAlbums, GetGithubUser;

class PresenterFactory {
  static final PresenterFactory _sInstance = new PresenterFactory._internal();

  factory PresenterFactory() {
    return _sInstance;
  }

  GetAlbumsPresenter _getAlbumsPresenter;
  GetUserInfoPresenter _getUserInfoPresenter;

  PresenterFactory._internal();

  GetAlbumsPresenter getAlbumsPresenter({ProductFlavor productFlavor = ProductFlavor.mock}) {
    if (_getAlbumsPresenter == null) {
      _getAlbumsPresenter = GetAlbumsPresenter(
          GetAlbums(AlbumDataRepository(productFlavor: productFlavor)),
          ViewModelWrapperFactory().albumListWrapper
      );
    }

    return _getAlbumsPresenter;
  }

  GetUserInfoPresenter getUserInfoPresenter() {
    if (_getUserInfoPresenter == null) {
      _getUserInfoPresenter = GetUserInfoPresenter(
          GetGithubUser(GithubUserRepository()),
          ViewModelWrapperFactory().githubUserWrapper
      );
    }

    return _getUserInfoPresenter;
  }
}
