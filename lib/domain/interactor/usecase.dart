import 'dart:async';
import 'package:rxdart/rxdart.dart';

typedef void StreamSuccess<Result>(Result data);
typedef void StreamError(Exception e);
typedef void StreamCompleted();
typedef void StreamDispose();

abstract class UseCase<Result, Params> {
  StreamSubscription<Result> _subscriptions;

  StreamDispose _onDispose;

  Future<Result> buildUseCase(Params params);

  execute(
      StreamSuccess<Result> onSuccess,
      Params params, {
        StreamDispose onDispose,
        StreamError onError,
        StreamCompleted onCompleted,
        bool cancelOnError
      }) {
    final Future<Result> future = this.buildUseCase(params);
    this._onDispose = onDispose;
    _subscriptions = Stream.fromFuture(future).listen((data) {
      print("DataReceived: " + data.toString());
      if (onSuccess != null) {
        onSuccess(data);
      }
    }, onDone: () {
      print("Task Done");
      if (onCompleted != null) {
        onCompleted();
      }
    }, onError: (error) {
      print("Some Error");
    }, cancelOnError: cancelOnError);
  }

  dispose() {
    _subscriptions?.cancel();
    if (_onDispose != null) {
      _onDispose();
    }
  }
}


abstract class BlocUseCase<Result, Params> {

  final _results = PublishSubject<Result>();
  Future<Result> buildUseCase(Params params);

  void execute(Params params) {
    final Future<Result> future = this.buildUseCase(params);
  }

  void dispose() {

  }
}