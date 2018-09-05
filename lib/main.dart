import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:language_pal/api_clients/cousers_api.dart';
import 'package:language_pal/pages/courses.dart';
import 'package:language_pal/pages/flashcards.dart';
import 'package:language_pal/pages/login.dart';
import 'package:language_pal/states/app_state.dart';
import 'package:language_pal/store_utils/user_settings_utils.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:logging/logging.dart';



class MyApp extends StatelessWidget {
  final routes;
  final AppState state;
  final GlobalKey<AsyncLoaderState> _asyncLoaderState = new GlobalKey<AsyncLoaderState>();
  final Logger log = new Logger('MyApp');

  initAsyncInstances() async {
    Logger.root.level = Level.ALL;
    recordStackTraceAtLevel = Level.WARNING;
    Logger.root.onRecord.listen((LogRecord rec) {
      var message = '${rec.level.name} ${rec.loggerName} : ${rec.message}';
      if (rec.error != null) {
        message += '\n${rec.error.toString()}';
      }
      if (rec.stackTrace != null) {
        message += '\n\n${rec.stackTrace.toString()}';
      }
      print(message);
    });

    await UserSettingUtils.getAsyncInstance();
    print(getSettings().token);
    print(getSettings().self);
    if (getSettings().token != null) {
      var courses = await getCourseApi().getCourses();
      this.state.coursesPage.courses = courses;
    }
  }

  MyApp({this.routes, this.state});

  @override
  Widget build(BuildContext context) {
    final _asyncLoader = new AsyncLoader(
        key: _asyncLoaderState,
        initState: () async => await initAsyncInstances(),
        renderLoad: () => new Container(
              decoration: new BoxDecoration(color: Colors.white70),
              child: new Center(child: new CircularProgressIndicator()),
            ),
        renderError: ([error]) => new Text('Sorry, there was an error loading the application'),
        renderSuccess: ({data}) {
          return getSettings().token == null
              ? LoginPage()
              : ScopedModelDescendant<AppState>(builder: (context, child, model) => CoursesPage(state: this.state));
        });

    return ScopedModel<AppState>(
        model: this.state,
        child: MaterialApp(
          title: 'Scoped Model MultiPage Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: _asyncLoader,
          routes: routes,
        ));
  }
}

final state = AppState();

final routes = <String, WidgetBuilder>{
  LoginPage.routeName: (BuildContext context) => new LoginPage(),
  CoursesPage.routeName: (BuildContext context) =>
      ScopedModelDescendant<AppState>(builder: (context, child, model) => CoursesPage(state: model)),
  FlashcardsPage.routeName: (BuildContext context) =>
      ScopedModelDescendant<AppState>(builder: (context, child, model) => FlashcardsPage(state: model)),
};

void main() => runApp(MyApp(routes: routes, state: state));
