import 'dart:async';

import 'package:flutter/material.dart';
import 'package:language_pal/api_clients/auth_api.dart';
import 'package:language_pal/api_clients/lp_client.dart';
import 'package:language_pal/components/snack_bar_shortcuts.dart';
import 'package:language_pal/models/user.dart';
import 'package:language_pal/sevices/smart_navigator.dart';
import 'package:language_pal/states/app_state.dart';
import 'package:language_pal/store_utils/user_settings_utils.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginPage extends StatelessWidget {
  LoginPage({this.title = 'Welcome to LanguagePal'});

  static const String routeName = "/login";
  final Logger log = new Logger('LoginPage');
  final String title;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  factory LoginPage.forDesignTime() {
    return new LoginPage(title: "test");
  }

  Future _submit(BuildContext context, AppState state) async {
    try {
      final form = formKey.currentState;
      if (form.validate()) {
        form.save();
        state.loginPage.loading = true;
        LPResponse response;
        try {
          response = await getAuthApi().login(email: state.loginPage.email, password: state.loginPage.password);
          getSettings().persistUser(UserModel.fromMap(response.body['user']));
          getSettings().persistToken(response.body['token']);

          getSmartNavigator().goToCourses(context, state);
        } on HttpClientException catch (e) {
          if (e.response.statusCode == 400) {
            response = await getAuthApi().signUp(email: state.loginPage.email, password: state.loginPage.password);
          } else {
            throw e;
          }
        }
      }
    } catch (e) {
      snackBarError(
        context: context,
        widget: new Text("Error login in, please try again later "),
      );
      log.severe("Error logging in", e);
    } finally {
      state.loginPage.loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text(this.title),
        ),
        body: ScopedModelDescendant<AppState>(
          builder: (context, child, model) => new Container(
                padding: const EdgeInsets.all(20.0),
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Form(
                        key: formKey,
                        child: new Column(
                          children: buildInputs(model, context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ));
  }

  List<Widget> buildInputs(AppState model, BuildContext context) {
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (val) => !val.contains('@') ? 'Not a valid email.' : null,
        onSaved: (val) => model.loginPage.email = val,
        keyboardType: TextInputType.emailAddress,
        initialValue: 'jorge.girazagal+student@gmail.com',
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        validator: (val) => val.length < 6 ? 'Password too short.' : null,
        obscureText: true,
        initialValue: 'myPasswordForStudent',
        onSaved: (val) => model.loginPage.password = val,
      ),
      new Container(
          padding: const EdgeInsets.all(15.0),
          alignment: Alignment.centerRight,
          child: new RaisedButton(
            onPressed: model.loginPage.loading ? null : () => this._submit(context, model),
            child: new Text(model.loginPage.loading ? 'Loging in' : 'Login'),
          )),
    ];
  }
}
