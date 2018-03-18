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

import '../view_model/view_model.dart';

class PhotoViewer extends StatefulWidget {
  const PhotoViewer({
    Key key,
    this.photo,
    this.tag,
    this.onTap,
  }) : super(key: key);

  final String tag;
  final MediaInfo photo;
  final VoidCallback onTap;

  @override
  State<StatefulWidget> createState() => new PhotoViewerState();

  static void onShowPhoto(BuildContext context, MediaInfo media, {String tag = null}) {
    final Size screenSize = MediaQuery
        .of(context)
        .size;
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return new Scaffold(
            backgroundColor: Colors.transparent,
            body: new Stack(
              children: <Widget>[
                new SizedBox(
                  width: screenSize.width,
                  height: screenSize.height,
                  child:new Material(
                    color: Colors.black,
                    child: new PhotoViewer(
                      photo: media, onTap: () => Navigator.of(context).pop(), tag: tag == null ? media.image : tag,
                    ),
                  ),
                ),
                new SafeArea(
                  child: new IconButton(
                    icon: new Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              ],
            ),
          );
        },
        transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
          return new FadeTransition(
            opacity: animation,
            child: child,
//            child: new ScaleTransition(
//              scale: new Tween<double>(begin: 0.0, end: 1.0).animate(animation),
//              child: child,
//            ),
          );
        }
    ));
  }

}

class PhotoViewerState extends State<PhotoViewer> with TickerProviderStateMixin {
  static const double _kMinFlingVelocity = 800.0;

  AnimationController _controller;
  Animation<Offset> _flingAnimation;
  Animation<double> _scaleAnimation;
  AnimationController _scaleController;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this)
      ..addListener(_handleFlingAnimation);
    _scaleController = new AnimationController(vsync: this)
      ..addListener(_handleScaleAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  // The maximum offset value is 0,0. If the size of this renderer's box is w,h
  // then the minimum offset value is w - _scale * w, h - _scale * h.
  Offset _clampOffset(Offset offset, { bool isMove = false }) {
    final Size size = context.size;
    final Offset minOffset = new Offset(size.width * (1.0 - _scale), size.height * (1.0 - _scale)/2);
    return new Offset(offset.dx.clamp(minOffset.dx, 0.0), minOffset.dy);
  }

  void _handleFlingAnimation() {
    setState(() {
      _offset = _flingAnimation.value;
    });
  }

  void _handleScaleAnimation() {
    setState(() {
      _scale = _scaleAnimation.value;
    });
  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // The fling animation stops if an input gesture starts.
      _controller.stop();
      _scaleController.stop();
    });
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 3.0);
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity)
      return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;
    _flingAnimation = new Tween<Offset>(
        begin: _offset,
        end: _clampOffset(_offset + direction * distance)
    ).animate(_controller);
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  void _onDoubleTab() {
    _scaleAnimation = new Tween<double>(
      begin: _scale,
      end: 1.0,
    ).animate(_scaleController);
    _scaleController
      ..value = 0.0
      ..fling();
    _flingAnimation = new Tween<Offset>(
        begin: _offset,
        end: Offset.zero
    ).animate(_controller);
    _controller
      ..value = 0.0
      ..fling();
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onDoubleTap: _onDoubleTab,
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleOnScaleUpdate,
      onScaleEnd: _handleOnScaleEnd,
      child: new Transform(
        transform: new Matrix4.identity()
          ..translate(_offset.dx, _offset.dy)
          ..scale(_scale),
        child: new Center(
          child: new Hero(
            tag: widget.tag,
            child: new Image.network(
              widget.photo.image,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
