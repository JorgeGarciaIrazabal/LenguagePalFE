import 'package:flutter/material.dart';
import 'package:language_pal/models/course.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final GestureTapCallback onTab;

  CourseCard({this.course, this.onTab});

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new GestureDetector(
        onTap: this.onTab,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: Text(course.title),
              subtitle: Text(course.teacher.fullName),
            ),
          ],
        ),
      ),
    );
  }
}
