import 'package:flutter/cupertino.dart';

import 'lesson.dart';

class LessonCategory {
  int id;
  String name;
  IconData icon;
  List<Lesson> lessons;

  LessonCategory({required this.id, required this.name, required this.icon, required this.lessons});
}
