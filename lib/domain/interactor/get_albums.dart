import 'dart:async';

import 'usecase.dart';
import 'package:zetory/domain/models/models.dart' show Album;

import 'package:zetory/domain/repository/repository.dart' show AbsAlbumRepository;

class GetAlbums extends UseCase<List<Album>, Null> {

  GetAlbums(this._repository);

  final AbsAlbumRepository _repository;

  @override
  Future<List<Album>> buildUseCase(Null params) {
    return _repository.fetch();
  }
}