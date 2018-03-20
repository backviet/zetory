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

import 'package:zetory/presentation/ui/home.dart';

final ThemeData _kGalleryLightTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

final ThemeData _kGalleryDarkTheme = new ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
);

class ZetoryApp extends StatefulWidget {

  @override
  _ZetoryAppState createState() => new _ZetoryAppState();
}

class _ZetoryAppState extends State<ZetoryApp>
    with TickerProviderStateMixin {
  bool _useLightTheme = true;

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return new MaterialApp(
      title: 'Zetory',
      color: Colors.grey,
      theme: (_useLightTheme ? _kGalleryLightTheme : _kGalleryDarkTheme).copyWith(platform: TargetPlatform.iOS),
      home: new HomePage(),
      showPerformanceOverlay: false,
    );

  }
}

