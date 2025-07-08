import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../util/lesson.dart';
import '../util/lessonCategory.dart';
import '../util/occupation.dart';
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
        name: "Recommended",
        icon: Icons.thumb_up,
        lessons: getOccupation().lessons
      ),
      LessonCategory(
        id: 1,
        name: "Time Management",
        icon: Icons.schedule,
        lessons: [
          Lesson(name: "Calendars", icon: Icons.calendar_month, txts: ["hi", "test", "asfddsaf"], imgs: [null, null, null]),
          Lesson(
            name: "Time blocks",
            icon: Icons.dashboard_customize,
            txts: ["help", "asdfjdsklfj", "dks"],
            imgs: [null, null, null],
          ),
          Lesson(name: "Prioritize", icon: Icons.new_releases, txts: ["kms", "lsd;fkd;s", "dfks"], imgs: [null, null, null]),
        ],
      ),
      LessonCategory(
        id: 2,
        name: "Cooking", 
        icon: Icons.bakery_dining, 
        lessons: [
          Lesson(
            name: "Meal Prep",
            icon: Icons.set_meal,
            txts: ["Bulk Purchasing:\nPurchasing ingredients in bulk often allow for fresher, cheaper, and higher-quality products.", "Variety: \nEating a variety of food groups ensures a balanced diet, leading to improved cognitive and physical abilities.", "Shelf Life: \nUnderstanding the shelf life of foods can help you prioritize certain food groups when shopping, and also helps reduce food waste,."],
            imgs: [
              Image.asset("lib/assets/chicken-fried-rice-16.jpg",
              ), 
              Image.asset("lib/assets/vegetables.webp",
              
              ), 
              Image.asset("lib/assets/frozen-food.webp",
              )
            ],
          ),
          Lesson(
            name: "Meal Times",
            icon: Icons.punch_clock,
            txts: ["help", "asdfjdsklfj", "dks"],
            imgs: [null, null, null],
          ),
          Lesson(
            name: "Cleanup",
            icon: Icons.table_restaurant,
            txts: ["help", "asdfjdsklfj", "dks"],
            imgs: [null, null, null],
          ),
        ]
        ),
      LessonCategory(
        id: 3,
        name: "Self-Hygiene", 
        icon: Icons.iron, 
        lessons: [
          Lesson(
            name: "Mornings",
            icon: Icons.sunny,
            txts: ["help", "asdfjdsklfj", "dks"],
            imgs: [null, null, null],
          ),
          Lesson(
            name: "Customs",
            icon: Icons.house,
            txts: ["help", "asdfjdsklfj", "dks"],
            imgs: [null, null, null],
          ),
          Lesson(
            name: "Nighttime",
            icon: Icons.brightness_2,
            txts: ["help", "asdfjdsklfj", "dks"],
            imgs: [null, null, null],
          ),
        ]
      ),
      LessonCategory(
        id: 4,
        name: "Fashion", 
        icon: Icons.watch, 
        lessons: [
          Lesson(
            name: "Casual",
            icon: Icons.checkroom,
            txts: ["help", "asdfjdsklfj", "dks"],
            imgs: [null, null, null],
          ),
          Lesson(
            name: "Biz. Casual",
            icon: Icons.business_center,
            txts: ["help", "asdfjdsklfj", "dks"],
            imgs: [null, null, null],
          ),
          Lesson(
            name: "Formal",
            icon: Icons.corporate_fare,
            txts: ["help", "asdfjdsklfj", "dks"],
            imgs: [null, null, null],
          ),
        ]
      ),
      LessonCategory(
        id: 5,
        name: "Interviews", 
        icon: Icons.person_2_rounded, 
        lessons: [
          Lesson(
            name: "Research",
            icon: Icons.science,
            txts: ["help", "asdfjdsklfj", "dks"],
            imgs: [null, null, null],
          ),
          Lesson(
            name: "Nerves",
            icon: Icons.electric_meter,
            txts: ["help", "asdfjdsklfj", "dks"],
            imgs: [null, null, null],
          ),
          Lesson(
            name: "Questions",
            icon: Icons.question_mark,
            txts: ["help", "asdfjdsklfj", "dks"],
            imgs: [null, null, null],
          ),
        ]
      ),
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
          if (e.lessons.isEmpty) return SizedBox();
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
