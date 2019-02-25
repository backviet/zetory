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

import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:zetory/presentation/ui/navigation.dart';

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

  AppState _appState;


  @override
  void initState() {
    if (_appState == null) {
      _appState = new AppState();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return new StateContainer(
      state: this._appState,
      child: new _AppWidget(),
    );

  }
}

class AppState {
  AppState({
    bool useLightTheme = true,
    TargetPlatform platform = TargetPlatform.iOS,

  }) : this.useLightTheme = useLightTheme,
        this.platform = platform;

  final bool useLightTheme;
  final TargetPlatform platform;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppState &&
              runtimeType == other.runtimeType &&
              useLightTheme == other.useLightTheme;

}

class StateContainer extends InheritedWidget {
  StateContainer({
    Key key,
    @required this.state,
    @required Widget child
  }): super(key: key, child: child);

  final AppState state;

  static StateContainer of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(StateContainer);
  }

  @override
  bool updateShouldNotify(StateContainer old) => state != old.state;
}

class _AppWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);
    final state = container.state;
    return new MaterialApp(
      title: 'Zetory',
      color: Colors.grey,
      theme: (state.useLightTheme ? _kGalleryLightTheme : _kGalleryDarkTheme).copyWith(platform: state.platform),
      home: AppNavigation(),
      showPerformanceOverlay: false,
    );
  }
}

