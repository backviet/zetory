import 'presenter.dart';
import 'package:zetory/domain/domain.dart' show Album, AbsAlbumRepository, ListWrapper, UseCase, AbsObserver, GetAlbums;
import '../view_model/view_model.dart' show AlbumInfo, AlbumViewModelWrapper;

class GetAlbumsPresenter extends AbsLoaderPresenter<List<Album>, List<AlbumInfo>, void> {

  GetAlbumsPresenter(this._useCase, this._wrapper)
      : assert(_useCase != null),
        assert(_wrapper != null);

  final ListWrapper<Album, AlbumInfo> _wrapper;
  final UseCase<List<Album>, void> _useCase;

  bool _isLoading = false;

  @override
  void onLoadError(Exception e) {
    uiView?.onLoadError(e);
  }

  @override
  void onLoadStarted(void params) {
    this._useCase.execute(onLoadSuccess, null, onError: onLoadError, onDispose: onLoadStop);
  }

  @override
  void onLoadSuccess(List<Album> result) {
    if (uiView != null) {
      final List<AlbumInfo> albums = _wrapper?.transform(result);
      uiView.onLoadSuccess(albums);
    }
  }
  @override
  void onLoadStop() {
    uiView?.onLoadStop();
  }

}