import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:math' as math;
import 'dart:core';

import 'package:zetory/presentation/view_model/view_model.dart';
import 'package:zetory/presentation/presenter/presenter.dart';

import 'package:zetory/presentation/ui/loading_widget.dart';
import 'package:zetory/presentation/ui/images.dart' as images;

class UserPage extends StatefulWidget {
  @override
  UserPageState createState() => new UserPageState();
}

class UserPageState extends State<UserPage> with AbsLoader<GithubUserViewModel, Null> {
  GetUserInfoPresenter _getUserInfoPresenter = PresenterFactory().getUserInfoPresenter();

  @override
  void initState() {
    super.initState();

    _getUserInfoPresenter.setUiView(this);
    if (!_getUserInfoPresenter.isLoading && _getUserInfoPresenter.presentableResult == null) {
      _reloadData();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  _buildUserInfo(),
                ],
              ),
            ),
          ],
        ));
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
      _getUserInfoPresenter.onLoadStarted(null);
    });
  }

  @override
  void onLoadStop() {
    setState(() {

    });
  }

  @override
  void onLoadSuccess(GithubUserViewModel result) {
    setState(() {
      
    });
  }

  Future<Null> _reloadData() {
    // delay for show loading for long time
    // using this for test only
    return Future.delayed(Duration(seconds: 3), () {
      _getUserInfoPresenter.onLoadStarted(null);
    });
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

  Widget _buildLogo(double width, double height) {
    return Container(
      child: Image(
        image: AssetImage(images.kLogo),
        width: width,
        height: height,
      ),
    );
  }

  Widget _buildUserInfo() {
    if (_getUserInfoPresenter.isLoading || _getUserInfoPresenter.presentableResult == null) {
      return LoadingWidget(
        shouldComplete: () => false,
        animationType: LoadingAnimationType.oval_forward,
      );
    }
    final userViewModel = _getUserInfoPresenter.presentableResult;
    final fixFontSize = 16.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage(userViewModel.avatarUrl), fit: BoxFit.cover),
            ),
          ),
        ),
        Flexible(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                "type: ${userViewModel.type}",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: fixFontSize, color: Colors.black54),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                "login: ${userViewModel.login}",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: fixFontSize, color: Colors.black54),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                "name: ${userViewModel.name}",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: fixFontSize, color: Colors.black54),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                "url: ${userViewModel.url}",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: fixFontSize, color: Colors.black54),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                "blog: ${userViewModel.blog}",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: fixFontSize, color: Colors.black54),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(3.0),
              child: Text(
                "location: ${userViewModel.location}",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: fixFontSize, color: Colors.black54),
              ),
            ),
          ],
        )),
      ],
    );
  }
}
