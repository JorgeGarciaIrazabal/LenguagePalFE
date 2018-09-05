import 'dart:async';

import 'package:flutter/material.dart';
import 'package:language_pal/api_clients/cousers_api.dart';
import 'package:language_pal/pages/courses.dart';
import 'package:language_pal/states/app_state.dart';

class SmartNavigator {


  Future goToFirstNotConfigView(BuildContext context) {
//    var self = UserSettingUtils.self;
//    if (self.mode == null) {
//      return Navigator.pushReplacementNamed(context, ModeSelection.routeName);
//    } else if (self.mode == UserMode.teacher && self.studentEmail == null) {
//      return Navigator.pushReplacementNamed(context, SelectStudent.routeName);
//    }
//    return Navigator.pushReplacementNamed(context, Flashcards.routeName);
  }

  Future goToCourses(BuildContext context, AppState state) async {
    var courses = await getCourseApi().getCourses();
    state.coursesPage.setCoursesWithoutNotify(courses);
    Navigator.pushReplacementNamed(context, CoursesPage.routeName);
  }
}


SmartNavigator _instance;

SmartNavigator getSmartNavigator() {
  if (_instance == null) {
    _instance = new SmartNavigator();
  }
  return _instance;
}