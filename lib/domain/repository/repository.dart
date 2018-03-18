import 'dart:async';
import '../domain.dart';

abstract class AbsAlbumRepository {
  Future<List<Album>> fetch();
}