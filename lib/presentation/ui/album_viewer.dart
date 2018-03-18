import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../view_model/view_model.dart';
import 'photo_viewer.dart';

const double _kPadding = 4.0;
const double _kAvartarSize = 60.0;

const String _kKeyNameList = "album_list_viewer";

class AlbumViewer extends StatefulWidget {

  const AlbumViewer({
    @required this.album,
    Key key
  }) : super(key: key);

  final AlbumInfo album;

  @override
  State<StatefulWidget> createState() => new _AlbumViewerState();

}

class _AlbumViewerState extends State<AlbumViewer> {

  static const double _kSectionHeader = 40.0;

  final Map<num, List<MediaInfo>> medias = new Map();

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;
    final double maxHeight = screenSize.width / 2;

    final Widget header = new Container(
      child: new Column(
        children: <Widget>[
          new Image.network(
            widget.album.medias[0].image,
            width: screenSize.width,
            height: maxHeight,
            fit: BoxFit.cover,
          ),
          new Padding(
            padding: const EdgeInsets.only(top: _kPadding),
            child: new Container(
              width: _kAvartarSize,
              height: _kAvartarSize,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    image: new NetworkImage(widget.album.icon),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          new Container(
            padding: const EdgeInsets.all(_kPadding),
            child: new Text(
              "My Album",
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 20.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
    );

    this._refreshMedias();

    final List<num> keys = medias.keys.toList()..sort((a, b) => (a - b).sign.round());
    final List<Widget> sections = keys.map((key) => _buildSection(context, key)).toList();
    sections.insert(0, new Divider(
      color: Colors.grey,
      height: 1.0,
    ));
    sections.insert(0, header);

    return new Scaffold(
      backgroundColor: Colors.white,
      body: new SafeArea(
        top: false,
        child: new Stack(
          children: <Widget>[

            new CustomScrollView(
              key: new PageStorageKey(_kKeyNameList),
              slivers: <Widget>[
                new SliverList(
                    delegate: new SliverChildListDelegate(
                      sections
                    )
                ),
              ],
            ),
            new SafeArea(
                child: const BackButton(color: Colors.black,)
            ),
//            const BackButton(),
          ],
        ),
      ),
    );

  }

  void _refreshMedias() {
    medias.clear();
    final List<MediaInfo> list = new List.from(widget.album.medias);
    for (MediaInfo media in list) {
      if (!medias.containsKey(media.showAt)) {
        medias[media.showAt] = new List();
      }
      medias[media.showAt].add(media);
    }
  }

  Widget _buildMediaItem(MediaInfo media, double width, double height,
      {BoxFit fit = BoxFit.cover, String name, int position = null}) {
    String tag = "${media.image}" + "-${name}" + (position == null ? "" : "-pos-${position}");

    return new SizedBox(
        width: width,
        height: height,
        child: new Hero(
            tag: tag,
            child: new GestureDetector(
              //        onTap: () => _onMediaTap(context, this.album, 0),
              onTap: () => PhotoViewer.onShowPhoto(context, media, tag: tag),
              child: new Image.network(
                media.image,
                width: width,
                height: height,
                fit: fit,
              ),
            ))
    );
  }

  double _rowItemWidth(int numberItem, double maxWidth) {
    return (maxWidth - (numberItem - 1) * _kPadding) / numberItem;
  }

  Widget _buildSection(BuildContext context, num sectionKey) {
    final List<MediaInfo> sectionMedias = new List.from(this.medias[sectionKey]);

    final DateTime date = new DateTime.fromMillisecondsSinceEpoch(sectionKey.round() * 1000);
    final String dateStr = "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";

    final Widget header = new Container(
        height: _kSectionHeader,
        color: Colors.white,
        child: new Center(
          child: new Text(
            "${dateStr}",
            textAlign: TextAlign.left,
            style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black54,
                fontWeight: FontWeight.bold
            ),
          ),
        )
    );

    final Size screenSize = MediaQuery.of(context).size;
    final double row3Width = _rowItemWidth(3, screenSize.width);
    final double boxWidth = screenSize.width;

    double mediaContainerHeight = 0.0;

    List<Widget> items = new List();
    while (sectionMedias.length >= 3) {
      // 1.remove 3 items at the end of list
      List<Widget> row = new List();
      int c = 0;
      MediaInfo media = sectionMedias.removeAt(sectionMedias.length - 1);
      row.add(_buildMediaItem(media, row3Width, row3Width, fit: BoxFit.cover, name: "${sectionKey}", position: sectionMedias.length));
      while(c < 2) {
        c ++;
        media = sectionMedias.removeAt(sectionMedias.length - 1);
        row.add(new Container(
          padding: const EdgeInsets.only(left: _kPadding),
          child: _buildMediaItem(media, row3Width, row3Width, fit: BoxFit.cover, name: "${sectionKey}", position: sectionMedias.length),
        ));
      }

      // 2.create a row which contain above 3 items
      items.insert(0, new Container(
        padding: const EdgeInsets.only(top: _kPadding),
        child: new SizedBox(
          height: row3Width,
          width: boxWidth,
          child: new Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: row
          ),
        ),
      ));

      mediaContainerHeight += (row3Width + _kPadding);
    }

    while (sectionMedias.length >= 2) {
      // create 2 row if has 3 items (1 item + 2 items)
      final double row2Width = _rowItemWidth(2, screenSize.width);

      final Widget item2 = new Container(
        padding: const EdgeInsets.only(left: _kPadding),
        child: _buildMediaItem(
            sectionMedias.removeAt(sectionMedias.length - 1),
            row2Width,
            row2Width,
            fit: BoxFit.cover,
            name: "${sectionKey}",
            position: sectionMedias.length),
      );
      final Widget item1 = _buildMediaItem(
          sectionMedias.removeAt(sectionMedias.length - 1),
          row2Width,
          row2Width,
          fit: BoxFit.cover,
          name: "${sectionKey}",
          position: sectionMedias.length
      );

      items.insert(0, new Container(
        padding: const EdgeInsets.only(top: _kPadding),
        child: new SizedBox(
          height: row2Width,
          width: boxWidth,
          child: new Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                item1,
                item2,
              ]
          ),
        ),
      ));
      mediaContainerHeight += (row2Width + _kPadding);
    }

    if (sectionMedias.length == 1) {
      // create 1 row if has 1 item
      MediaInfo firstItem = sectionMedias.removeAt(0);
      double height = boxWidth / 2;
      items.insert(0, new InkWell(
        child: _buildMediaItem(
            firstItem,
            boxWidth,
            height,
            fit: BoxFit.cover,
            name: "${sectionKey}",
            position: sectionMedias.length),
      ));
      mediaContainerHeight += height;
    }
    mediaContainerHeight += _kSectionHeader;
    items.insert(0, header);

    return new SizedBox(
        width: boxWidth,
        height: mediaContainerHeight,
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items
        )
    );
  }

}
