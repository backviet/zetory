/*
 * Copyright (C) 2018, QuanLT.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:my_album/presentation/ui/home.dart';

final ThemeData _kGalleryLightTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

final ThemeData _kGalleryDarkTheme = new ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
);

class MyAlbumApp extends StatefulWidget {

  @override
  _MyAlbumAppState createState() => new _MyAlbumAppState();
}

class _MyAlbumAppState extends State<MyAlbumApp>
    with TickerProviderStateMixin {
  bool _useLightTheme = true;

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return new MaterialApp(
      title: 'MyAlbum',
      color: Colors.grey,
      theme: (_useLightTheme ? _kGalleryLightTheme : _kGalleryDarkTheme).copyWith(platform: TargetPlatform.iOS),
      home: new HomePage(),
      showPerformanceOverlay: false,
    );

  }
}

