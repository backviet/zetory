import 'package:flutter/material.dart';
import 'dart:math';

const int _kLineStep = 4;
const num _kOvalStep = 6;
const int _kDefaultDuration = 600;
const double _kDefaultPadding = 2.5;
const double _kDefaultSize = 8.0;
const double _kBaseSize = _kDefaultPadding + _kDefaultPadding + _kDefaultSize;
const double _kDefaultFactor = 0.15;
const double _kRatio = _kDefaultFactor * _kDefaultSize;
const List<MaterialColor> _kDefaultColors = const [Colors.orange, Colors.red, Colors.green, Colors.blue];

typedef bool ShouldComplete();

enum LoadingAnimationType {
  line,
  line_forward,
  oval,
  oval_forward
}

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({
    Key key,
    this.duration: _kDefaultDuration,
    this.colors: _kDefaultColors,
    this.animationType: LoadingAnimationType.oval_forward,
    this.completedCallback,
    this.shouldComplete,
  })
      : assert(duration != null && duration > 0),
        assert(animationType != null),
        assert(colors != null),
        super(key: key);

  final List<MaterialColor> colors;
  final VoidCallback completedCallback;
  final ShouldComplete shouldComplete;
  final LoadingAnimationType animationType;
  final int duration;

  @override
  State<StatefulWidget> createState() => new _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;

  AnimationController _controller;
  int _step = 1;
  int _count = 0;
  bool _isLoading = false;

  AbsLoadingAdapter _adapter;

  @override
  void initState() {
    super.initState();
    _initAdapter();
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.duration),
        vsync: this
    );

    _animation = new Tween(begin: 1.0, end: _maxStep + 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _step = _animation.value.floor();
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _isLoading =
          widget.shouldComplete != null ? !widget.shouldComplete() : false;
          if (_isLoading) {
            _controller.reset();
            _count++;
          } else {
            if (widget.completedCallback != null) {
              widget.completedCallback();
            }
          }
        } else if (status == AnimationStatus.dismissed) {
          if (_isLoading) {
            _controller.forward();
          }
        }
      });

    start();
  }

  @override
  Widget build(BuildContext context) {
    return _adapter._buildAnimation(_count, _step, widget.colors);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _maxStep => widget.animationType == LoadingAnimationType.line ? _kLineStep : _kOvalStep;

  void _initAdapter() {
    if (widget.animationType == LoadingAnimationType.line ||
        widget.animationType == LoadingAnimationType.line_forward) {
      _adapter = new _LineLoadingAdapter();
    } else {
      _adapter = new _OvalLoadingAdapter();
    }
  }

  void start() {
    _isLoading = true;
    _count = 0;
    _controller.forward();
  }
}

abstract class AbsLoadingAdapter {
  Widget _buildCircle(double size, Color color) {
    return new Container(
      margin: const EdgeInsets.all(_kDefaultPadding),
      width: size,
      height: size,
      decoration: new BoxDecoration(
        color: color ?? Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildAnimation(int count, int step, List<MaterialColor> colors);
}

class _LineLoadingAdapter extends AbsLoadingAdapter {
  _LineLoadingAdapter({LoadingAnimationType type = LoadingAnimationType.line_forward}) {
    _type = type ?? LoadingAnimationType.line_forward;
  }

  LoadingAnimationType _type;

  @override
  Widget _buildAnimation(int count, int step, List<MaterialColor> colors) {
    if (colors == null || colors.length == 0) {
      colors = _kDefaultColors;
    }
    final List<Widget> children = new List();
    MainAxisAlignment mainAxisAlignment;
    if (_type == LoadingAnimationType.line) {
      for (int i = 1; i <= step && i <= _kLineStep; i++) {
        final double size = _kDefaultSize + (i - 1) * _kRatio;
        children.add(_buildCircle(
            size, colors[(i - 1)% colors.length]));
      }
      mainAxisAlignment = MainAxisAlignment.start;
    } else {
      if (count % 2 == 0) {
        for (int i = 1; i <= step && i <= _kLineStep; i++) {
          final double size = _kDefaultSize + (i - 1) * _kRatio;
          children.add(_buildCircle(
              size, colors[(i - 1) % colors.length]));
        }
        mainAxisAlignment = MainAxisAlignment.start;
      } else {
        for (int i = step + 1; i <= _kLineStep; i++) {
          final double size = _kDefaultSize + (i - 1) * _kRatio;
          children.add(_buildCircle(
              size, colors[(i - 1) % colors.length]));
        }
        mainAxisAlignment = MainAxisAlignment.end;
      }
    }

    final double width = _kLineStep * (2 * _kBaseSize + (_kLineStep - 1) * _kRatio) / 2;
    final double height = _kBaseSize + (_kLineStep - 1) * _kRatio;
    return new Container(
      width: width,
      height: height,
      child: new Row(
        mainAxisAlignment: mainAxisAlignment,
        children: children,
      ),
    );
  }
}

class _OvalLoadingAdapter extends AbsLoadingAdapter {
  _OvalLoadingAdapter({LoadingAnimationType type = LoadingAnimationType.oval_forward}) {
    _degree = 2 * pi / _kOvalStep;
    _R = sqrt(_kBaseSize * _kBaseSize / (2 * (1 - cos(_degree))));
    _type = type ?? LoadingAnimationType.oval_forward;
  }

  double _R;
  double _degree;
  LoadingAnimationType _type;

  @override
  Widget _buildAnimation(int count, int step, List<MaterialColor> colors) {
    if (colors == null || colors.length == 0) {
      colors = _kDefaultColors;
    }
    final List<Widget> children = new List();
    if (_type == LoadingAnimationType.oval) {
      for (int i = 1; i <= step && i <= _kOvalStep; i++) {
        final double size = _kDefaultSize;
        final Offset off = _getOffset(i - 1);
        children.add(new Positioned(
            top: off.dy,
            left: off.dx,
            child: _buildCircle(size, colors[(i - 1) % colors.length]))
        );
      }
    } else {
      if (count % 2 == 0) {
        for (int i = 1; i <= step && i <= _kOvalStep; i++) {
          final double size = _kDefaultSize;
          final Offset off = _getOffset(i - 1);
          children.add(new Positioned(
              top: off.dy,
              left: off.dx,
              child: _buildCircle(size, colors[(i - 1) % colors.length]))
          );
        }
      } else {
        for (int i = step + 1; i <= _kOvalStep; i++) {
          final double size = _kDefaultSize;
          final Offset off = _getOffset(i - 1);
          children.add(new Positioned(
              top: off.dy,
              left: off.dx,
              child: _buildCircle(size, colors[(i - 1) % colors.length]))
          );
        }
      }
    }
    final double width = (_R + _kDefaultSize - 2 * _kDefaultPadding) * 2;
    final double height = width;
    return new Container(
      child: new Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: children,
      ),
      width: width,
      height: height,
    );
  }

  Offset _getOffset(int pos) {
    final double degree = pi/2 - (_degree * pos);
    double y = _R * sin(degree);
    double x = _R * cos(degree);

    double l = _R + x;
    double t = _R - y;
    return new Offset(l, t);
  }
}
