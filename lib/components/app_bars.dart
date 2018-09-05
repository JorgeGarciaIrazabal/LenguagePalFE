import 'package:flutter/material.dart';
import 'package:language_pal/pages/login.dart';
import 'package:language_pal/store_utils/user_settings_utils.dart';
import 'package:meta/meta.dart';

class AppBarFactory {
  static AppBar authAppBar(
      {@required Widget title, @required BuildContext context}) {
    return new AppBar(
      title: title,
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.exit_to_app),
          tooltip: 'Logout',
          onPressed: () async {
            getSettings().clear();
            Navigator.pushReplacementNamed(context, LoginPage.routeName);
          },
        ),
        new IconButton(
          icon: new Icon(Icons.compare),
          tooltip: 'Select Mode',
          onPressed: () {
            throw new Error();
//            Navigator.pushReplacementNamed(context, ModeSelection.routeName);
          },
        ),
      ],
    );
  }
}
