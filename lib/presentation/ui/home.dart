import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';
import 'dart:core';
import 'dart:async';

import '../view_model/view_model.dart';
import 'photo_viewer.dart';

import 'package:my_album/presentation/ui/album_viewer.dart';
import '../presenter/presenter.dart';

import 'package:my_album/data/data.dart' show ProductFlavor;

const double _kPadding = 4.0;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with AbsLoader<List<AlbumInfo>, void> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  GetAlbumsPresenter _getAlbumsPresenter;
  bool _isLoading = false;
  List<AlbumInfo> _albums;

  int get _count => _albums == null ? 0 : _albums.length;

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    return completer.future.then((_) {
      onLoadStarted(null);
    });
  }

  @override
  void initState() {
    super.initState();
    _getAlbumsPresenter = new PresenterFactory().getAlbumsPresenter(productFlavor: ProductFlavor.production);
    _albums = null;

    _getAlbumsPresenter.setUiView(this);

    _isLoading = true;
    _getAlbumsPresenter.onLoadStarted(null);

//    new Future.delayed(new Duration(seconds: 5), () {
//      setState(() {
//        _getAlbumsPresenter.onLoadStarted(null);
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading) {
      return new Scaffold(
          backgroundColor: Colors.white,
          body: new RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _handleRefresh,
            child: new ListView.builder(
                key: new PageStorageKey('albums'),
                itemCount: _count,
                itemBuilder: (BuildContext context, int position) {
                  return new _AlbumItemWidget(album: _albums[position]);
                })
          ),
      );
    } else {
      return new Scaffold(
          backgroundColor: Colors.white,
          body: new Center(
            child: new CircularProgressIndicator(),
          ),
      );
    }
  }

  @override
  void onLoadError(Exception e) {
    setState(() {
      _isLoading = false;
      _showError(e);
    });
  }

  @override
  void onLoadStarted(void params) {
    setState(() {
      _isLoading = true;
    });
    _getAlbumsPresenter.onLoadStarted(params);
  }

  @override
  void onLoadStop() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoadSuccess(List<AlbumInfo> result) {
    setState(() {
      _albums = result;
      _isLoading = false;
    });
  }

  void _showError(Exception e) {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: new CupertinoAlertDialog(
        title: new Text("Error"),
        content: new Text("${e?.toString()}"),
        actions: <Widget>[
          new CupertinoDialogAction(
              child: const Text('OK'),
              isDestructiveAction: true,
              onPressed: () { Navigator.pop(context, 'OK'); }
          ),
        ],
      )
//      child: new AlertDialog(
//        title: new Text("Error"),
//        content: new Text("${e?.toString()}"),
//        actions: <Widget>[
//          new FlatButton(
//              child: const Text('OK'),
//              onPressed: () { Navigator.pop(context); }
//          )
//        ],
//      )
    );
  }

}

class _AlbumItemWidget extends StatelessWidget {
  const _AlbumItemWidget({
    @required this.album,
    Key key,
  })
      : super(key: key);

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

    return new Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(_kPadding),
          child: new Row(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(_kPadding),
                child: new Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        image: new NetworkImage(this.album.icon),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  new Text(
                    this.album.name,
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: new Text(
                      '2018/03/06',
                      style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        new Row(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: _kPadding, right: _kPadding),
              child: new Text(
                this.album.caption,
                style: new TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
        new Padding(
            padding: const EdgeInsets.only(top: _kPadding),
            child: new _AlbumItemMediaWidget(
                album: this.album,
                medias: new List<MediaInfo>.from(this.album.medias))),
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

  double _calculateHeight(
      {@required double width,
      @required double height,
      @required double targetWidth,
      @required double maxHeight}) {
    final targetHeight = min((height / width) * targetWidth, maxHeight);
    return targetHeight;
  }

  Widget _buildItem(String url, double width, double height,
      {BoxFit fit = BoxFit.none, bool more = false}) {
    if (!more) {
      return new Container(
        child: new Image.network(
          url,
          width: width,
          height: height,
          fit: fit,
        ),

      );
    } else {
      return new Stack(
        children: <Widget>[
          new Container(
            child: new Image.network(
              url,
              width: width,
              height: height,
              fit: fit,
            ),
          ),
          new Container(
              color: Colors.black54,
              width: width,
              height: height,
              child: new Center(
                child: new Text(
                  "+${medias.length}",
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.white),
                ),
              ))
        ],
      );
    }
  }

  void _onMediaTap(BuildContext context, AlbumInfo album, int position) {
    Navigator.push(context, new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new AlbumViewer(album: album);
//          return new AlbumGridViewer(album: album);
//          return new Scaffold(
//            body: new AlbumListViewer(album: album, initPosition: position,)
//          );
        }
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double maxWidth = screenSize.width;
    final double maxHeight = maxWidth;
    final count = _getItemCount;
    if (count == 1) {
      final double width = maxWidth;
      final MediaInfo photo = medias[0];
      return new SizedBox(
          width: width,
          child: new Hero(
            tag: photo.image,
            child: new GestureDetector(
              onTap: () => PhotoViewer.onShowPhoto(context, photo),
              child: _buildItem(
                  photo.image,
                  width,
                  _calculateHeight(
                      width: photo.width,
                      height: photo.height,
                      targetWidth: width,
                      maxHeight: maxHeight)),
            ),
          )
      );
    } else if (count == 2) {
      final double width = maxWidth / 2 - _kPadding / 2;

      return new SizedBox(
        width: maxWidth,
        height: maxHeight,
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              new InkWell(
                  onTap: () => _onMediaTap(context, this.album, 0),
                  child: new Container(
                    padding: const EdgeInsets.only(right: _kPadding / 2),
                    child: _buildItem(medias[0].image, width, maxHeight,
                        fit: BoxFit.cover),
                  )),
              new InkWell(
                  onTap: () => _onMediaTap(context, this.album, 1),
                  child: new Container(
                    padding: const EdgeInsets.only(left: _kPadding / 2),
                    child: _buildItem(medias[1].image, width, maxHeight,
                        fit: BoxFit.cover),
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
      final double footerWidth = (maxWidth  - (list2.length - 1) * _kPadding) / list2.length;
      final double footerHeight = footerWidth;
      final double headerWidth = (maxWidth  - (list1.length - 1) * _kPadding) / list1.length;
      final double headerHeight =
          (list1.length == 1 ? maxHeight - footerHeight : headerWidth) -
              _kPadding;
      final double boxWidth = maxWidth;
      final double boxHeight = footerHeight + headerHeight + _kPadding;

      final List<Widget> headerWidgets = <Widget> [
        new InkWell(
            onTap: () => _onMediaTap(context, this.album, 0),
            child: _buildItem(list1[0].image, headerWidth, headerHeight, fit: BoxFit.cover)
        ),
      ];
      if (list1.length == 2) {
        headerWidgets.add(new InkWell(
            onTap: () => _onMediaTap(context, this.album, 1),
            child: new Container(
              padding: const EdgeInsets.only(left: _kPadding),
              child: _buildItem(list1[1].image, headerWidth, maxHeight, fit: BoxFit.cover),
            )
        ));
      }

      final List<Widget> footerWidgets = <Widget> [
        new InkWell(
            onTap: () => _onMediaTap(context, this.album, list1.length),
            child: _buildItem(list2[0].image, footerWidth, footerHeight, fit: BoxFit.cover)
        ),
      ];

      for (int i = 1; i < list2.length; i++) {
        final int position = i + list1.length;
        footerWidgets.add(new InkWell(
            onTap: () => _onMediaTap(context, this.album, position),
            child: new Container(
              padding: const EdgeInsets.only(left: _kPadding),
              child: _buildItem(list2[i].image, footerWidth, footerHeight, fit: BoxFit.cover, more: i == 2 && count > 5),
            )
        ));
      }

      return new SizedBox(
          width: boxWidth,
          height: boxHeight,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new SizedBox(
                height: headerHeight,
                width: boxWidth,
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: headerWidgets
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: _kPadding),
                child: new SizedBox(
                  height: footerHeight,
                  width: boxWidth,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: footerWidgets
                  ),
                ),
              )
            ],
          ));
    }
  }
}
