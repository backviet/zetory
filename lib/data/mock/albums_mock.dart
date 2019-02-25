import 'dart:async';
import 'dart:convert';
import '../entity/entity.dart';
import 'package:flutter/services.dart';

abstract class AbsAlbumMock {
  Future<List<AlbumEntity>> get();
}

class AlbumMock extends AbsAlbumMock {
  static final String _kFileDir = 'assets/files/albums.json';
  static final AlbumMock _instance = new AlbumMock._internal();

  factory AlbumMock() {
    return _instance;
  }

  AlbumMock._internal();

  Future<List<AlbumEntity>> get() async {
    final mockData = await rootBundle.loadString(_kFileDir);

    final Map<String, dynamic> albumsMap = jsonDecode(mockData);
    if (albumsMap == null) {
      return null;
    }
    return AlbumEntity.listFromJson(albumsMap);
  }
}
