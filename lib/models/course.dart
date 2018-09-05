import 'package:language_pal/models/model.dart';
import 'package:language_pal/models/user.dart';

class CourseModel extends Model {
  String title;
  String description;
  UserModel teacher;

  CourseModel({this.title, this.teacher})
      : super.fromMap(null);

  CourseModel.fromMap(Map<String, dynamic> map) : super.fromMap(map);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'teacher': teacher?.toMap(),
    }..addAll(super.toMap());
  }

  CourseModel mergeMap(Map<String, dynamic> map) {
    if (map == null) {
      return this;
    }
    super.mergeMap(map);
    title = map['title'] ?? title;
    description = map['description'] ?? description;
    teacher = map.containsKey('teacher') ? UserModel.fromMap( map['teacher']) : teacher;
    return this;
  }
}
