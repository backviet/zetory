export 'get_albums_presenter.dart';
export 'presenter_factory.dart';

abstract class AbsPresenter {
  void resume() {}

  void pause() {}

  void destroy() {}
}

abstract class AbsLoader<Result, Params> {
  void onLoadStarted(Params params);

  void onLoadCompleted() {}

  void onLoadSuccess(Result result);

  void onLoadError(Exception e);

  void onLoadStop();
}

abstract class AbsLoaderPresenter<Result, PresentableResult, Params> extends AbsLoader<Result, Params> with AbsPresenter {

  AbsLoader<PresentableResult, Params> uiView;

  void setUiView(AbsLoader<PresentableResult, Params> presenterView) {
    this.uiView = presenterView;
  }
}

