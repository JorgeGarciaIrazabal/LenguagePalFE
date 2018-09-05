import 'package:language_pal/models/course.dart';

class CoursesPageState {
  List<CourseModel> _courses = [];

  CoursesPageState(this.notifyListeners);

  List<CourseModel> get courses => _courses;

  set courses(List<CourseModel> value) {
    _courses = value;
    notifyListeners();
  }

  setCoursesWithoutNotify(List<CourseModel> value) {
    _courses = value;
  }

  void addCourse(CourseModel course) {
    _courses.add(course);
    notifyListeners();
  }
  final notifyListeners;
}
