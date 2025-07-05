import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/lessonScreen.dart';
import '../util/lesson.dart';

class LessonList extends StatefulWidget {
  const LessonList({super.key, required this.lessons});

  final List<Lesson> lessons;

  @override
  State<LessonList> createState() => _LessonListState();
}

class _LessonListState extends State<LessonList> {
  _LessonListState();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // so it sizes itself and doesn't try to scroll
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 columns
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: widget.lessons.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LessonScreen(lesson: widget.lessons[index])),
            );
          },
          child: Flex(
            direction: Axis.vertical,
            children: [
              Flexible(
                flex: 7,
                fit: FlexFit.tight,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: FittedBox(
                      child: Icon(widget.lessons[index].icon, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ),
              ),
              Spacer(flex: 1),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: Text(widget.lessons[index].name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
              ),
            ],
          ),
        );

        //   Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     Container(
        //       decoration: BoxDecoration(
        //         color: Theme.of(context).colorScheme.surface,
        //         borderRadius: BorderRadius.circular(25),
        //         boxShadow: [
        //           BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), offset: Offset(0, 4), blurRadius: 4, spreadRadius: 0),
        //         ],
        //       ),
        //       child: Icon(widget.lessons[index].icon, color: Theme.of(context).colorScheme.onSurface),
        //     ),
        //     SizedBox(height: 25),
        //     Text(widget.lessons[index].name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
        //   ],
        // );
      },
    );
  }
}
