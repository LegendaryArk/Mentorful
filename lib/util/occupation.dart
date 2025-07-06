import 'package:flutter/material.dart';

import '../main.dart';
import 'lesson.dart';

class Occupation {
  int id;
  String name;
  List<Lesson> lessons;

  Occupation({required this.id, required this.name, required this.lessons});
}

final hs = Occupation(
  id: 0,
  name: "High Schooler",
  lessons: [
    Lesson(name: "Prioritize", icon: Icons.new_releases, txts: ["kms", "lsd;fkd;s", "dfks"], imgs: [null, null, null]),
    Lesson(
      name: "Meal Prep",
      icon: Icons.set_meal,
      txts: ["Bulk Purchasing", "Variety", "Shelf Life"],
      imgs: [
        Image.asset("lib/assets/chicken-fried-rice-16.jpg"),
        Image.asset("lib/assets/vegetables.webp"),
        Image.asset("lib/assets/frozen-food.webp"),
      ],
    ),
    Lesson(name: "Research", icon: Icons.science, txts: ["help", "asdfjdsklfj", "dks"], imgs: [null, null, null]),
  ],
);
final uni = Occupation(
  id: 1,
  name: "University Student",
  lessons: [
    Lesson(
      name: "Time blocks",
      icon: Icons.dashboard_customize,
      txts: ["help", "asdfjdsklfj", "dks"],
      imgs: [null, null, null],
    ),
    Lesson(
      name: "Meal Prep",
      icon: Icons.set_meal,
      txts: ["Bulk Purchasing", "Variety", "Shelf Life"],
      imgs: [
        Image.asset("lib/assets/chicken-fried-rice-16.jpg"),
        Image.asset("lib/assets/vegetables.webp"),
        Image.asset("lib/assets/frozen-food.webp"),
      ],
    ),
    Lesson(name: "Nighttime", icon: Icons.brightness_2, txts: ["help", "asdfjdsklfj", "dks"], imgs: [null, null, null]),
    Lesson(
      name: "Biz. Casual",
      icon: Icons.business_center,
      txts: ["help", "asdfjdsklfj", "dks"],
      imgs: [null, null, null],
    ),
    Lesson(name: "Nerves", icon: Icons.electric_meter, txts: ["help", "asdfjdsklfj", "dks"], imgs: [null, null, null]),
  ],
);

final workForce = Occupation(
  id: 2,
  name: "Work Force",
  lessons: [
    Lesson(name: "Calendars", icon: Icons.calendar_month, txts: ["hi", "test", "asfddsaf"], imgs: [null, null, null]),
    Lesson(name: "Meal Times", icon: Icons.punch_clock, txts: ["help", "asdfjdsklfj", "dks"], imgs: [null, null, null]),
    Lesson(name: "Customs", icon: Icons.house, txts: ["help", "asdfjdsklfj", "dks"], imgs: [null, null, null]),
    Lesson(name: "Formal", icon: Icons.corporate_fare, txts: ["help", "asdfjdsklfj", "dks"], imgs: [null, null, null]),
    Lesson(
      name: "Questions",
      icon: Icons.question_mark,
      txts: ["help", "asdfjdsklfj", "dks"],
      imgs: [null, null, null],
    ),
  ],
);

final other = Occupation(id: 3, name: "Other", lessons: []);

Occupation getOccupation() {
  switch (prefs.getString("occupation")) {
    case "High Schooler":
      return hs;
    case "University Student":
      return uni;
    case "Work Force":
      return workForce;
    default:
      return other;
  }
}