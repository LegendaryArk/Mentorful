import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/lesson.dart';
import '../util/lessonCategory.dart';
import '../widgets/lessonList.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  _LessonsScreenState();

  String? occupation;
  late List<LessonCategory> cats;
  late List<bool> tabs;

  @override
  void initState() {
    super.initState();
    _loadOccupation();

    cats = [
      LessonCategory(
        id: 0,
        name: "Time Management",
        icon: Icons.schedule,
        lessons: [
          Lesson(name: "Calendars", icon: Icons.calendar_month, txts: ["hi", "test", "asfddsaf"], imgs: [null, null, null]),
          Lesson(
            name: "Blocking Time",
            icon: Icons.dashboard_customize,
            txts: ["help", "asdfjdsklfj", "dks"],
            imgs: [null, null, null],
          ),
          Lesson(name: "Prioritize", icon: Icons.new_releases, txts: ["kms", "lsd;fkd;s", "dfks"], imgs: [null, null, null]),
        ],
      ),
      LessonCategory(id: 1, name: "Cooking", icon: Icons.bakery_dining, lessons: []),
      LessonCategory(id: 2, name: "Self-Hygiene", icon: Icons.iron, lessons: []),
      LessonCategory(id: 3, name: "Fashion", icon: Icons.watch, lessons: []),
      LessonCategory(id: 4, name: "Testing", icon: Icons.help, lessons: []),
    ];
    tabs = [false, false, false, false, false, false];
  }

  void _loadOccupation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      occupation = prefs.getString("occupation") ?? "other";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        shrinkWrap: true,
        children: cats.map((e) {
          int i = cats.indexWhere((e1) => e1.id == e.id);
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), offset: Offset(0, 4), blurRadius: 4, spreadRadius: 0),
              ],
            ),
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      tabs[i] = !tabs[i];
                    });
                  },
                  child: Row(
                    children: [
                      Icon(e.icon, color: Theme.of(context).colorScheme.onSurface),
                      SizedBox(width: 10),
                      Text(e.name, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
                      Spacer(),
                      Icon(
                        tabs[i] ? Icons.keyboard_arrow_down : Icons.navigate_next,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
                tabs[i] ? SizedBox(height: 6) : SizedBox(),
                tabs[i] ? LessonList(lessons: e.lessons) : SizedBox(),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
