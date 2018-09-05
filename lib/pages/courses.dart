import 'dart:async';

import 'package:flutter/material.dart';
import 'package:language_pal/api_clients/cousers_api.dart';
import 'package:language_pal/components/app_bars.dart';
import 'package:language_pal/components/controlled_dialog.dart';
import 'package:language_pal/components/course_card.dart';
import 'package:language_pal/components/user_drawer.dart';
import 'package:language_pal/models/course.dart';
import 'package:language_pal/pages/flashcards.dart';
import 'package:language_pal/states/app_state.dart';
import 'package:language_pal/states/stateful_dialog_state.dart';
import 'package:language_pal/store_utils/user_settings_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logging/logging.dart';

class CoursesPage extends StatelessWidget {
  static const String routeName = "/courses";
  final Logger log = new Logger('CoursesPage');
  final String title;
  final AppState state;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  CoursesPage({this.title = 'Your Courses', this.state});

  factory CoursesPage.forDesignTime() {
    return new CoursesPage(title: "test");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBarFactory.authAppBar(title: new Text('Select Course'), context: context),
      body: new Container(
        padding: const EdgeInsets.all(20.0),
        child: new ListView(
          children: buildCourses(context),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          CourseModel course = await _onFloatingActionButtonPressed(context);
          if (course != null) {
            state.coursesPage.courses.add(course);
          }
        },
        tooltip: 'Add Card',
        child: new Icon(Icons.add),
        elevation: 150.0,
      ),
      drawer: new UserDrawer(
        state: state,
      ),
    );
  }

  List<Widget> buildCourses(BuildContext context) {
    return this.state.coursesPage.courses.map<CourseCard>((CourseModel course) {
      return CourseCard(
          course: course,
          onTab: () async {
            var cards = await getCourseApi().getFlashCards(course.id);
            state.flashcardPage.flashcards = cards;
            state.flashcardPage.courseModel = course;
            Navigator.pushNamed(context, FlashcardsPage.routeName);
          });
    }).toList();
  }

  Future<CourseModel> _onFloatingActionButtonPressed(BuildContext context) async {
    final formKey = new GlobalKey<FormState>();
    CourseModel course = new CourseModel();

    return showDialog<CourseModel>(
      context: context,
      builder: (BuildContext context) {
        return new ControlledDialog(
          builder: (context, child, model) {
            return alertDialog(course, context, model, formKey);
          },
        );
      },
    );
  }

  AlertDialog alertDialog(CourseModel course, BuildContext context, StatefulDialogState model, formKey) {
    return new AlertDialog(
      title: new Text('Create Course'),
      content: new Form(
        key: formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new TextFormField(
              decoration: new InputDecoration(labelText: 'Title'),
              validator: (val) => val.isEmpty ? 'Please, add a title.' : null,
              onSaved: (val) => course.title = val,
            ),
            new TextFormField(
              decoration: new InputDecoration(labelText: 'Description'),
              onSaved: (val) => course.description = val.isEmpty ? null : val,
            )
          ],
        ),
      ),
      actions: <Widget>[
        model.loading
            ? SpinKitThreeBounce(
                color: Colors.grey,
                size: 45.0,
              )
            : new FlatButton(
                child: Text(model.loading ? '' : 'save'),
                onPressed: model.loading
                    ? null
                    : () async {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          model.loading = true;
                          try {
                            var newCourse = await getCourseApi().postCourse(course);
                            newCourse.teacher = getSettings().self;
                            Navigator.of(context).pop(newCourse);
                          } finally {
                            model.loading = false;
                          }
                        }
                      },
              ),
      ],
    );
  }
}
