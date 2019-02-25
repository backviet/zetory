// Base on bottom_navigation_bar_item.dart in flutter

import 'package:flutter/material.dart';

/// An interactive button within either material's [ZBottomNavigationBar]
/// or the iOS themed [CupertinoTabBar] with an icon and title.
///
/// This class is rarely used in isolation. Commonly embedded in one of the
/// bottom navigation widgets above.
///
/// See also:
///
///  * [ZBottomNavigationBar]
///  * <https://material.google.com/components/bottom-navigation.html>
///  * [CupertinoTabBar]
///  * <https://developer.apple.com/ios/human-interface-guidelines/bars/tab-bars>
class IconBottomNavigationBarItem {
  /// Creates an item that is used with [ZBottomNavigationBar.items].
  ///
  /// The arguments [icon] and [title] should not be null.
  const IconBottomNavigationBarItem({
    this.icon,
    this.backgroundColor,
  }) : assert(icon != null);

  /// The icon of the item.
  ///
  /// Typically the icon is an [Icon] or an [ImageIcon] widget. If another type
  /// of widget is provided then it should configure itself to match the current
  /// [IconTheme] size and color.
  final Widget icon;

  /// The color of the background radial animation for material [ZBottomNavigationBar].
  ///
  /// If the navigation bar's type is [ZBottomNavigationBarType.shifting], then
  /// the entire bar is flooded with the [backgroundColor] when this item is
  /// tapped.
  ///
  /// Not used for [CupertinoTabBar]. Control the invariant bar color directly
  /// via [CupertinoTabBar.backgroundColor].
  ///
  /// See also:
  ///
  ///  * [Icon.color] and [ImageIcon.color] to control the foreground color of
  ///     the icons themselves.
  final Color backgroundColor;
}
