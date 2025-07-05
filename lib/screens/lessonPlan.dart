import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/lessonList.dart';
import '../main.dart';



class LessonPlan extends StatefulWidget {
  const LessonPlan({super.key});

  @override
  State<LessonPlan> createState() => _LessonPlanState();
}


class _LessonPlanState extends State<LessonPlan> {
  _LessonPlanState();
  
  String? occupation;
  late bool a = false;
  late bool b = false;
  late bool c = false;
  late bool d = false;


  @override
  void initState() {
    super.initState();
    _loadOccupation();
    a = false;
    b = false;
    c = false;
    d = false;
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 40.0),
          ),
          SliverToBoxAdapter(
            child: TextButton(
              child: Text("e"),
              onPressed:() => (
                setState(() => a = !a)
                ),
            ),
          ),
          a ? SliverToBoxAdapter(child: LessonList()) : SliverToBoxAdapter(child: SizedBox()),
          SliverToBoxAdapter(
            child: TextButton(
              child: Text("e"),
              onPressed:() => (setState(() => b = !b)),
            ),
          ),
          b ? SliverToBoxAdapter(child: LessonList()) : SliverToBoxAdapter(child: SizedBox()),
          SliverToBoxAdapter(
            child: TextButton(
              child: Text("e"),
              onPressed:() => (setState(() => c = !c)),
            ),
          ),
          c ? SliverToBoxAdapter(child: LessonList()) : SliverToBoxAdapter(child: SizedBox()),
          SliverToBoxAdapter(
            child: TextButton(
              child: Text("e"),
              onPressed:() => (setState(() => d = !d)),
            ),
          ),
          d ? SliverToBoxAdapter(child: LessonList()) : SliverToBoxAdapter(child: SizedBox()),
        ],
      )

    );
  }
}
