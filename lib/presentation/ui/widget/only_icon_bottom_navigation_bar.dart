// Base on bottom_navigation_bar.dart in flutter

import 'dart:collection' show Queue;
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

import 'only_icon_bottom_navigation_bar_item.dart';

const double _kTopMargin = 6.0;
const double _kBottomMargin = 8.0;

/// The height of the bottom navigation bar.
const double _kIconBottomNavigationBarHeight = 48.0;

/// A material widget displayed at the bottom of an app for selecting among a
/// small number of views.
///
/// The bottom navigation bar consists of multiple items in the form of
/// text labels, icons, or both, laid out on top of a piece of material. It
/// provides quick navigation between the top-level views of an app. For larger
/// screens, side navigation may be a better fit.
///
/// A bottom navigation bar is usually used in conjunction with a [Scaffold],
/// where it is provided as the [Scaffold.bottomNavigationBar] argument.
///
/// See also:
///
///  * [IconBottomNavigationBarItem]
///  * [Scaffold]
///  * <https://material.google.com/components/bottom-navigation.html>
class IconBottomNavigationBar extends StatefulWidget {
  /// Creates a bottom navigation bar, typically used in a [Scaffold] where it
  /// is provided as the [Scaffold.bottomNavigationBar] argument.
  ///
  /// The argument [items] should not be null.
  ///
  /// The number of items passed should be equal to, or greater than, two. If
  /// three or fewer items are passed, then the default [type] (if [type] is
  /// null or not given) will be [ZBottomNavigationBarType.fixed], and if more
  /// than three items are passed, will be [ZBottomNavigationBarType.shifting].
  ///
  /// Passing a null [fixedColor] will cause a fallback to the theme's primary
  /// color. The [fixedColor] field will be ignored if the [IconBottomNavigationBar.type] is
  /// not [ZBottomNavigationBarType.fixed].
  IconBottomNavigationBar({
    Key key,
    @required this.items,
    this.onTap,
    this.currentIndex: 0,
    this.fixedColor,
    this.iconSize: 32.0,
  }) : assert(items != null),
        assert(items.length >= 2),
        assert(0 <= currentIndex && currentIndex < items.length),
        assert(iconSize != null),
        super(key: key);

  /// The interactive items laid out within the bottom navigation bar.
  final List<IconBottomNavigationBarItem> items;

  /// The callback that is called when a item is tapped.
  ///
  /// The widget creating the bottom navigation bar needs to keep track of the
  /// current index and call `setState` to rebuild it with the newly provided
  /// index.
  final ValueChanged<int> onTap;

  /// The index into [items] of the current active item.
  final int currentIndex;

  /// The color of the selected item when bottom navigation bar is
  /// [ZBottomNavigationBarType.fixed].
  ///
  /// If [fixedColor] is null, it will use the theme's primary color. The [fixedColor]
  /// field will be ignored if the [type] is not [ZBottomNavigationBarType.fixed].
  final Color fixedColor;

  /// The size of all of the [IconBottomNavigationBarItem] icons.
  ///
  /// See [IconBottomNavigationBarItem.icon] for more information.
  final double iconSize;

  @override
  _IconBottomNavigationBarState createState() => new _IconBottomNavigationBarState();
}

// This represents a single tile in the bottom navigation bar. It is intended
// to go into a flex container.
class _IconBottomNavigationTile extends StatelessWidget {
  const _IconBottomNavigationTile(
      this.item,
      this.animation,
      this.iconSize, {
        this.onTap,
        this.colorTween,
        this.flex
      }
      );

  final IconBottomNavigationBarItem item;
  final Animation<double> animation;
  final double iconSize;
  final VoidCallback onTap;
  final ColorTween colorTween;
  final double flex;

  Widget _buildIcon() {
    double tweenStart;
    Color iconColor;

    tweenStart = 8.0;
    iconColor = colorTween.evaluate(animation);

    return new Align(
      alignment: Alignment.topCenter,
      heightFactor: 1.0,
      child: new Container(
        margin: new EdgeInsets.only(
          top: new Tween<double>(
            begin: tweenStart,
            end: _kTopMargin,
          ).evaluate(animation),
        ),
        child: new IconTheme(
          data: new IconThemeData(
            color: iconColor,
            size: iconSize,
          ),
          child: item.icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // In order to use the flex container to grow the tile during animation, we
    // need to divide the changes in flex allotment into smaller pieces to
    // produce smooth animation. We do this by multiplying the flex value
    // (which is an integer) by a large number.
    int size;

    size = 1;

    return new Expanded(
      flex: size,
      child: new InkResponse(
        onTap: onTap,
        child: _buildIcon(),
//        child: new Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            _buildIcon(),
//            label,
//          ],
//        ),
      ),
    );
  }
}

class _IconBottomNavigationBarState extends State<IconBottomNavigationBar> with TickerProviderStateMixin {
  List<AnimationController> _controllers;
  List<CurvedAnimation> _animations;

  // A queue of color splashes currently being animated.
  final Queue<_Circle> _circles = new Queue<_Circle>();

  // Last splash circle's color, and the final color of the control after
  // animation is complete.
  Color _backgroundColor;

  static final Tween<double> _flexTween = new Tween<double>(begin: 1.0, end: 1.5);

  @override
  void initState() {
    super.initState();
    _controllers = new List<AnimationController>.generate(widget.items.length, (int index) {
      return new AnimationController(
        duration: kThemeAnimationDuration,
        vsync: this,
      )..addListener(_rebuild);
    });
    _animations = new List<CurvedAnimation>.generate(widget.items.length, (int index) {
      return new CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn.flipped
      );
    });
    _controllers[widget.currentIndex].value = 1.0;
    _backgroundColor = widget.items[widget.currentIndex].backgroundColor;
  }

  void _rebuild() {
    setState(() {
      // Rebuilding when any of the controllers tick, i.e. when the items are
      // animated.
    });
  }

  @override
  void dispose() {
    for (AnimationController controller in _controllers)
      controller.dispose();
    for (_Circle circle in _circles)
      circle.dispose();
    super.dispose();
  }

  double _evaluateFlex(Animation<double> animation) => _flexTween.evaluate(animation);

  void _pushCircle(int index) {
    if (widget.items[index].backgroundColor != null) {
      _circles.add(
        new _Circle(
          state: this,
          index: index,
          color: widget.items[index].backgroundColor,
          vsync: this,
        )..controller.addStatusListener(
              (AnimationStatus status) {
            switch (status) {
              case AnimationStatus.completed:
                setState(() {
                  final _Circle circle = _circles.removeFirst();
                  _backgroundColor = circle.color;
                  circle.dispose();
                });
                break;
              case AnimationStatus.dismissed:
              case AnimationStatus.forward:
              case AnimationStatus.reverse:
                break;
            }
          },
        ),
      );
    }
  }

  @override
  void didUpdateWidget(IconBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    }
  }

  List<Widget> _createTiles() {
    final List<Widget> children = <Widget>[];
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    Color themeColor;
    switch (themeData.brightness) {
      case Brightness.light:
        themeColor = themeData.primaryColor;
        break;
      case Brightness.dark:
        themeColor = themeData.accentColor;
        break;
    }
    final ColorTween colorTween = new ColorTween(
      begin: textTheme.caption.color,
      end: widget.fixedColor ?? themeColor,
    );
    for (int i = 0; i < widget.items.length; i += 1) {
      children.add(
        new _IconBottomNavigationTile(
          widget.items[i],
          _animations[i],
          widget.iconSize,
          onTap: () {
            if (widget.onTap != null)
              widget.onTap(i);
          },
          colorTween: colorTween,
        ),
      );
    }
    return children;
  }

  Widget _createContainer(List<Widget> tiles) {
    return DefaultTextStyle.merge(
      overflow: TextOverflow.ellipsis,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tiles,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    // Labels apply up to _bottomMargin padding. Remainder is media padding.
    final double additionalBottomPadding = math.max(MediaQuery.of(context).padding.bottom - _kBottomMargin, 0.0);
    Color backgroundColor;
    return new Stack(
      children: <Widget>[
        new Positioned.fill(
          child: new Material( // Casts shadow.
            elevation: 8.0,
            color: backgroundColor,
          ),
        ),
        new ConstrainedBox(
          constraints: new BoxConstraints(minHeight: _kIconBottomNavigationBarHeight + additionalBottomPadding),
          child: new Stack(
            children: <Widget>[
              new Positioned.fill(
                child: new CustomPaint(
                  painter: new _RadialPainter(
                    circles: _circles.toList(),
                    textDirection: Directionality.of(context),
                  ),
                ),
              ),
              new Material( // Splashes.
                type: MaterialType.transparency,
                child: new Padding(
                  padding: new EdgeInsets.only(bottom: additionalBottomPadding),
                  child: new MediaQuery.removePadding(
                    context: context,
                    removeBottom: true,
                    child: _createContainer(_createTiles()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Describes an animating color splash circle.
class _Circle {
  _Circle({
    @required this.state,
    @required this.index,
    @required this.color,
    @required TickerProvider vsync,
  }) : assert(state != null),
        assert(index != null),
        assert(color != null) {
    controller = new AnimationController(
      duration: kThemeAnimationDuration,
      vsync: vsync,
    );
    animation = new CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn
    );
    controller.forward();
  }

  final _IconBottomNavigationBarState state;
  final int index;
  final Color color;
  AnimationController controller;
  CurvedAnimation animation;

  double get horizontalLeadingOffset {
    double weightSum(Iterable<Animation<double>> animations) {
      // We're adding flex values instead of animation values to produce correct
      // ratios.
      return animations.map(state._evaluateFlex).fold(0.0, (double sum, double value) => sum + value);
    }

    final double allWeights = weightSum(state._animations);
    // These weights sum to the start edge of the indexed item.
    final double leadingWeights = weightSum(state._animations.sublist(0, index));

    // Add half of its flex value in order to get to the center.
    return (leadingWeights + state._evaluateFlex(state._animations[index]) / 2.0) / allWeights;
  }

  void dispose() {
    controller.dispose();
  }
}

// Paints the animating color splash circles.
class _RadialPainter extends CustomPainter {
  _RadialPainter({
    @required this.circles,
    @required this.textDirection,
  }) : assert(circles != null),
        assert(textDirection != null);

  final List<_Circle> circles;
  final TextDirection textDirection;

  // Computes the maximum radius attainable such that at least one of the
  // bounding rectangle's corners touches the edge of the circle. Drawing a
  // circle larger than this radius is not needed, since there is no perceivable
  // difference within the cropped rectangle.
  static double _maxRadius(Offset center, Size size) {
    final double maxX = math.max(center.dx, size.width - center.dx);
    final double maxY = math.max(center.dy, size.height - center.dy);
    return math.sqrt(maxX * maxX + maxY * maxY);
  }

  @override
  bool shouldRepaint(_RadialPainter oldPainter) {
    if (textDirection != oldPainter.textDirection)
      return true;
    if (circles == oldPainter.circles)
      return false;
    if (circles.length != oldPainter.circles.length)
      return true;
    for (int i = 0; i < circles.length; i += 1)
      if (circles[i] != oldPainter.circles[i])
        return true;
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (_Circle circle in circles) {
      final Paint paint = new Paint()..color = circle.color;
      final Rect rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.height);
      canvas.clipRect(rect);
      double leftFraction;
      switch (textDirection) {
        case TextDirection.rtl:
          leftFraction = 1.0 - circle.horizontalLeadingOffset;
          break;
        case TextDirection.ltr:
          leftFraction = circle.horizontalLeadingOffset;
          break;
      }
      final Offset center = new Offset(leftFraction * size.width, size.height / 2.0);
      final Tween<double> radiusTween = new Tween<double>(
        begin: 0.0,
        end: _maxRadius(center, size),
      );
      canvas.drawCircle(
        center,
        radiusTween.lerp(circle.animation.value),
        paint,
      );
    }
  }
}
