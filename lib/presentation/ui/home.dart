import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'dart:core';
import 'dart:async';

import 'package:zetory/presentation/view_model/view_model.dart';
import 'package:zetory/presentation/ui/photo_viewer.dart';

import 'package:zetory/presentation/ui/album_viewer.dart';
import 'package:zetory/presentation/presenter/presenter.dart';

import 'package:zetory/data/data.dart' show ProductFlavor;

import 'package:zetory/presentation/ui/loading_widget.dart';
import 'package:zetory/presentation/ui/images.dart' as images;

const double _kPadding = 4.0;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AbsLoader<List<AlbumInfo>, Null> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final GetAlbumsPresenter _getAlbumsPresenter = PresenterFactory().getAlbumsPresenter(productFlavor: ProductFlavor.production);

  int get _count => _getAlbumsPresenter.presentableResult == null ? 0 : _getAlbumsPresenter.presentableResult.length;

  @override
  void initState() {
    super.initState();
    _getAlbumsPresenter.setUiView(this);

    if (_shouldReloadData()) {
      _reloadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldReloadData()) {
      final albums = _getAlbumsPresenter.presentableResult;
      return Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _handleRefresh,
            child: ListView.builder(
                key: PageStorageKey('albums'),
                itemCount: _count,
                itemBuilder: (BuildContext context, int position) {
                  return _AlbumItemWidget(album: albums[position]);
                })
          ),
          );
    } else {
      final Size screenSize = MediaQuery.of(context).size;
      final double logoWidth = math.min(math.max(screenSize.width * 0.75, 300.0), 400.0);
      final double factor = logoWidth / 300.0;

      return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Container(
                width: screenSize.width,
                height: screenSize.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 60.0 * factor),
                      child: _buildLogo(300.0 * factor, 125.0 * factor),
                    ),
                    LoadingWidget(
                      shouldComplete: () => false,
                      animationType: LoadingAnimationType.line,
                    ),
                  ],
                ),
              ),
            ],
          ));
//      return Scaffold(
//        backgroundColor: Colors.white,
//        body: Center(
//          child: CircularProgressIndicator(),
//        ),
//      );
    }
  }

  @override
  void onLoadError(Exception e) {
    setState(() {
      _showError(e);
    });
  }

  @override
  void onLoadStarted(Null params) {
    setState(() {
      _getAlbumsPresenter.onLoadStarted(params);
    });
  }

  @override
  void onLoadStop() {
    setState(() {});
  }

  @override
  void onLoadSuccess(List<AlbumInfo> result) {
    setState(() {

    });
  }

  Widget _buildLogo(double width, double height) {
    return Container(
      child: Image(
        image: AssetImage(images.kLogo),
        width: width,
        height: height,
      ),
    );
  }

  bool _shouldReloadData() {
    return !_getAlbumsPresenter.isLoading && 
        (_getAlbumsPresenter.presentableResult == null || _getAlbumsPresenter.presentableResult.isEmpty);
  }
  
  Future<Null> _reloadData() {
    // delay for show loading for long time
    // using this for test only
    return Future.delayed(Duration(seconds: 3), () {
      _getAlbumsPresenter.onLoadStarted(null);
    });
  }

  Future<Null> _handleRefresh() {
    return _reloadData();
  }

  _showError(Exception e) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text("Error"),
              content: Text("${e?.toString()}"),
              actions: <Widget>[
                CupertinoDialogAction(
                    child: const Text('OK'),
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                    }),
              ],
            ));
  }
}

class _AlbumItemWidget extends StatelessWidget {
  const _AlbumItemWidget({
    @required this.album,
    Key key,
  }) : super(key: key);

  final AlbumInfo album;

  @override
  Widget build(BuildContext context) {
    album.medias.sort((a, b) {
      if (a.showAt == b.showAt) {
        if (a.width / a.height > b.width / b.height) {
          return 0;
        } else {
          return 1;
        }
      } else {
        return (a.showAt - b.showAt).sign.round();
      }
    });

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(_kPadding),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(_kPadding),
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: NetworkImage(this.album.icon), fit: BoxFit.cover),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  Text(
                    this.album.name,
                    style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      '2018/03/06',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: _kPadding, right: _kPadding),
              child: Text(
                this.album.caption,
                style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
        Padding(
            padding: const EdgeInsets.only(top: _kPadding),
            child: _AlbumItemMediaWidget(album: this.album, medias: List<MediaInfo>.from(this.album.medias))),
      ],
    );
  }
}

class _AlbumItemMediaWidget extends StatelessWidget {
  const _AlbumItemMediaWidget({@required this.album, @required this.medias, Key key}) : super(key: key);

  final List<MediaInfo> medias;
  final AlbumInfo album;

  int get _getItemCount {
    return medias == null ? 0 : medias.length;
  }

  double _calculateHeight({@required double width, @required double height, @required double targetWidth, @required double maxHeight}) {
    final targetHeight = math.min((height / width) * targetWidth, maxHeight);
    return targetHeight;
  }

  Widget _buildItem(String url, double width, double height, {BoxFit fit = BoxFit.none, bool more = false}) {
    if (!more) {
      return Container(
        child: Image.network(
          url,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    } else {
      return Stack(
        children: <Widget>[
          Container(
            child: Image.network(
              url,
              width: width,
              height: height,
              fit: fit,
            ),
          ),
          Container(
              color: Colors.black54,
              width: width,
              height: height,
              child: Center(
                child: Text(
                  "+${medias.length}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.white),
                ),
              ))
        ],
      );
    }
  }

  void _onMediaTap(BuildContext context, AlbumInfo album, int position) {
    Navigator.push(context, MaterialPageRoute<Null>(builder: (BuildContext context) {
      return AlbumViewer(album: album);
//          return AlbumGridViewer(album: album);
//          return Scaffold(
//            body: AlbumListViewer(album: album, initPosition: position,)
//          );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final List<MediaInfo> medias = List.from(this.medias);
    final Size screenSize = MediaQuery.of(context).size;
    final double maxWidth = screenSize.width;
    final double maxHeight = maxWidth;
    final count = _getItemCount;
    if (count == 1) {
      final double width = maxWidth;
      final MediaInfo photo = medias[0];
      return SizedBox(
          width: width,
          child: Hero(
            tag: photo.image,
            child: GestureDetector(
              onTap: () => PhotoViewer.onShowPhoto(context, photo),
              child: _buildItem(
                  photo.image, width, _calculateHeight(width: photo.width, height: photo.height, targetWidth: width, maxHeight: maxHeight)),
            ),
          ));
    } else if (count == 2) {
      final double width = maxWidth / 2 - _kPadding / 2;

      return SizedBox(
        width: maxWidth,
        height: maxHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
                onTap: () => _onMediaTap(context, this.album, 0),
                child: Container(
                  padding: const EdgeInsets.only(right: _kPadding / 2),
                  child: _buildItem(medias[0].image, width, maxHeight, fit: BoxFit.cover),
                )),
            InkWell(
                onTap: () => _onMediaTap(context, this.album, 1),
                child: Container(
                  padding: const EdgeInsets.only(left: _kPadding / 2),
                  child: _buildItem(medias[1].image, width, maxHeight, fit: BoxFit.cover),
                )),
          ],
        ),
      );
    } else {
      final List<MediaInfo> list1 = [medias.removeAt(0)];
      if (count >= 5) {
        list1.add(medias.removeAt(0));
      }
      final List<MediaInfo> list2 = [medias.removeAt(0)];
      while (list2.length < 3 && medias.length > 0) {
        list2.add(medias.removeAt(0));
      }
      final double footerWidth = (maxWidth - (list2.length - 1) * _kPadding) / list2.length;
      final double footerHeight = footerWidth;
      final double headerWidth = (maxWidth - (list1.length - 1) * _kPadding) / list1.length;
      final double headerHeight = (list1.length == 1 ? maxHeight - footerHeight : headerWidth) - _kPadding;
      final double boxWidth = maxWidth;
      final double boxHeight = footerHeight + headerHeight + _kPadding;

      final List<Widget> headerWidgets = <Widget>[
        InkWell(onTap: () => _onMediaTap(context, this.album, 0), child: _buildItem(list1[0].image, headerWidth, headerHeight, fit: BoxFit.cover)),
      ];
      if (list1.length == 2) {
        headerWidgets.add(InkWell(
            onTap: () => _onMediaTap(context, this.album, 1),
            child: Container(
              padding: const EdgeInsets.only(left: _kPadding),
              child: _buildItem(list1[1].image, headerWidth, maxHeight, fit: BoxFit.cover),
            )));
      }

      final List<Widget> footerWidgets = <Widget>[
        InkWell(
            onTap: () => _onMediaTap(context, this.album, list1.length),
            child: _buildItem(list2[0].image, footerWidth, footerHeight, fit: BoxFit.cover)),
      ];

      for (int i = 1; i < list2.length; i++) {
        final int position = i + list1.length;
        footerWidgets.add(InkWell(
            onTap: () => _onMediaTap(context, this.album, position),
            child: Container(
              padding: const EdgeInsets.only(left: _kPadding),
              child: _buildItem(list2[i].image, footerWidth, footerHeight, fit: BoxFit.cover, more: i == 2 && count > 5),
            )));
      }

      return SizedBox(
          width: boxWidth,
          height: boxHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: headerHeight,
                width: boxWidth,
                child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: headerWidgets),
              ),
              Padding(
                padding: const EdgeInsets.only(top: _kPadding),
                child: SizedBox(
                  height: footerHeight,
                  width: boxWidth,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: footerWidgets),
                ),
              )
            ],
          ));
    }
  }
}
