import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Lesson {
  String name;
  IconData icon;
  List<String> txts;
  List<Image?> imgs;

  Lesson({required this.name, required this.icon, required this.txts, required this.imgs});
}