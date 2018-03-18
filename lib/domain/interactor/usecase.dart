import 'dart:async';

typedef void StreamSuccess<T>(T data);
typedef void StreamError(Exception e);
typedef void StreamCompleted();
typedef void StreamDispose();

abstract class UseCase<T, Params> {

  StreamSubscription<T> _subscriptions;

//  StreamSuccess<T> _onSuccess;
//  StreamError _onError;
//  StreamCompleted _onCompleted;
  StreamDispose _onDispose;


  Future<T> buildUseCase(Params params);

  void execute(StreamSuccess<T> onSuccess, Params params, {StreamDispose onDispose, StreamError onError, StreamCompleted onCompleted, bool cancelOnError}) {
    final Future<T> future = this.buildUseCase(params);
    this._onDispose = onDispose;
    _subscriptions = future.asStream().listen(
        onSuccess,
        onError: onError,
        onDone: onCompleted,
        cancelOnError: cancelOnError
    );
  }

  void dispose() {
    _subscriptions?.cancel();
    if (_onDispose != null) {
      _onDispose();
    }
  }
}