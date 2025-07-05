import 'package:flutter/material.dart';
import '../lesson.dart';



class LessonList extends StatefulWidget {
  const LessonList({super.key});

  @override
  State<LessonList> createState() => _LessonListState();
}


class _LessonListState extends State<LessonList> {
  _LessonListState();
  
  String? occupation;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // so it sizes itself and doesn't try to scroll
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,      // 2 columns
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3 / 1,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Lesson()),
            );
          },
          child: const Text('e'),
        );
      },
    );
  }
}
