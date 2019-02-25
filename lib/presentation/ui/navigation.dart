import 'package:flutter/material.dart';

import './widget/only_icon_bottom_navigation_bar.dart';
import './widget/only_icon_bottom_navigation_bar_item.dart';

import 'home.dart';
import 'user.dart';
import 'package:image_picker/image_picker.dart';

import 'package:zetory/app.dart';

class AppNavigation extends StatefulWidget {
  @override
  ZAppNavigationState createState() => new ZAppNavigationState();
}

class ZAppNavigationState extends State<AppNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  /// Called when the user presses on of the
  /// [IconBottomNavigationBarItem] with corresponding
  /// page index
  void navigationTapped(int page) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    if (this._currentIndex - page == 1 || page - this._currentIndex == 1) {
      _pageController.animateToPage(page,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      _pageController.jumpToPage(page);
    }
  }

  void onPageChanged(int page) {
    setState(() {
      this._currentIndex = page;
    });
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }

  void _addAPhoto() {
    setState(() {
      final _imageFile = ImagePicker.pickImage(
        source: ImageSource.gallery
      );
      print("_imageFile: ${_imageFile.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);
    assert(container != null);

    final IconBottomNavigationBar botNavBar = new IconBottomNavigationBar(
      items: [
        new IconBottomNavigationBarItem(icon: const Icon(Icons.home)),
        new IconBottomNavigationBarItem(icon: const Icon(Icons.account_circle)),
      ],
      currentIndex: _currentIndex,
      onTap: navigationTapped,
    );

    final AppBar appBar = new AppBar(
      backgroundColor: Colors.blue,
      centerTitle: true,
      title: new Text(
        "Zetory",
        style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold
        ),
      ),
    );

    return new Scaffold(
      appBar: appBar,
      body: new PageView(
          physics: new NeverScrollableScrollPhysics(),
          children: [
            new HomePage(),
            new UserPage()
          ],
          controller: _pageController,
          onPageChanged: onPageChanged),
      bottomNavigationBar: botNavBar,
    );
  }
}
