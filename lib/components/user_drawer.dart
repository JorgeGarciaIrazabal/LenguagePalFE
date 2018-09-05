import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:language_pal/api_clients/auth_api.dart';
import 'package:language_pal/components/user_circle_avatar.dart';
import 'package:language_pal/pages/login.dart';
import 'package:language_pal/sevices/smart_navigator.dart';
import 'package:language_pal/states/app_state.dart';
import 'package:language_pal/states/stateful_drawer_state.dart';
import 'package:language_pal/store_utils/user_settings_utils.dart';
import 'package:scoped_model/scoped_model.dart';

class UserDrawer extends StatelessWidget {
  final AppState state;

  UserDrawer({this.state});

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ScopedModel<StatefulDrawerState>(
        model: new StatefulDrawerState(getSettings().self),
        child: ScopedModelDescendant<StatefulDrawerState>(builder: (context, widget, drawerState) {
          return new ListView(
            children: <Widget>[
              new DrawerHeader(
                child: Column(
                  children: <Widget>[
                    new UserCircleAvatar(
                      user: drawerState.user,
                      radius: 45.0,
                      onTab: () async {
                        var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                        var user = await getAuthApi().uploadPhoto(image.path);
                        drawerState.user = user;
                        getSettings().persistUser(user);
                      },
                    ),
                    new Text(getSettings().self.fullName),
                    new Text(getSettings().self.email),
                  ],
                ),
                decoration: new BoxDecoration(color: Colors.orange),
              ),
              new ListTile(
                title: new Text("Go To My Courses"),
                onTap: () {
                  getSmartNavigator().goToCourses(context, state);
                },
              ),
              new ListTile(
                title: new Text("Go To My Tests (coming soon)"),
                onTap: null,
              ),
              new ListTile(
                title: new Text("Logout"),
                trailing: new Icon(Icons.exit_to_app),
                onTap: () {
                  getSettings().clear();
                  Navigator.pushReplacementNamed(context, LoginPage.routeName);
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
