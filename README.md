# Zetory

![zetory](./pub/logo.png)

Zetory project - Power by Flutter

## Features
- Interaction with network
- `Clean Architecture` Pattern
- Database implementation by:
    * Caching list of albums data
    * Mocking with data in assets
- Implementation of PhotoViewer with `Hero` and `GestureDetector` (Zoomable Image)
- `factory` constructor pattern of Dart (as singleton in other language)
- Using `pathprovider` for creating and accessing a cached file (works in both iOS and Android)


## Preview

![ios-demo](./preview.gif)

## Dependencies

* [Flutter](https://flutter.io/)
* [json_serializable](https://github.com/dart-lang/json_serializable/blob/master/README.md)
* [path_provider](https://github.com/flutter/plugins/blob/master/packages/path_provider/README.md)
* [image_picker](https://github.com/flutter/plugins/blob/master/packages/image_picker/README.md)


## Getting Started

For help getting started with Flutter, view flutter online
[documentation](https://flutter.io/).
#### 1. [Setup Flutter](https://flutter.io/setup/)

#### 2. Clone the repo

```sh
$ git clone git@github.com:backviet/zetory.git
$ cd zetory/
```
#### 3. Run the app

```sh
$ flutter run
```

## Note 
(skip if not running on iOS)

Now Flutter has a bug with iOS debug.
```
fatal error: 'image_picker/ImagePickerPlugin.h' file not found
fatal error: 'path_provider/PathProviderPlugin.h' file not found
```
Solution:
- first: Run project in a iOS device
- Copy [ImagePickerPlugin.h](https://github.com/flutter/plugins/blob/master/packages/image_picker/ios/Classes/ImagePickerPlugin.h) into ../path/to/zetory/build/ios/Debug-iphones/image_picker/image_picker.framework/Header
- Copy [PathProviderPlugin.h](https://github.com/flutter/plugins/blob/master/packages/path_provider/ios/Classes/PathProviderPlugin.h) into ../path/to/zetory/build/ios/Debug-iphones/path_provider/pat_provider.framework/Header

## License
```
Copyright 2018 QuanLT,

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

```
