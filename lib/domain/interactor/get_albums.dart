import 'dart:async';

import 'usecase.dart';
import '../models/model.dart' show Album;

import '../repository/repository.dart' show AbsAlbumRepository;

class GetAlbums extends UseCase<List<Album>, void> {

  GetAlbums(this._repository);

  final AbsAlbumRepository _repository;

  @override
  Future<List<Album>> buildUseCase(void params) {
    return _repository.fetch();
  }
}