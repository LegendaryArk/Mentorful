import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mentorful/aesthetics/colorSchemes.dart';
import 'package:mentorful/screens/home.dart';
import 'package:mentorful/screens/leaderboard.dart';
import 'package:mentorful/screens/lessonPlan.dart';
import 'package:mentorful/widgets/photoSubmission.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<MentorfulState> mentorfulKey = GlobalKey<MentorfulState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late Directory appDir;
late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appDir = await getApplicationDocumentsDirectory();
  prefs = await SharedPreferences.getInstance();

  runApp(
    MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Mentorful',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: darkScheme,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        fontFamily: "Manrope",
      ),
      home: Mentorful(key: mentorfulKey),
    ),
  );
}

class Mentorful extends StatefulWidget {
  const Mentorful({super.key});

  @override
  State<Mentorful> createState() => MentorfulState();
}

class MentorfulState extends State<Mentorful> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext) {
    List<Widget> screens = [
      HomeScreen(key: PageStorageKey<String>("home")),
      LessonPlan(key: PageStorageKey<String>("lessons")),
      Container(),
      Leaderboard(key: PageStorageKey<String>("leaderboard")),
      Container(),
    ];

    List<NavigationDestination> destination = [
      NavigationDestination(
        selectedIcon: Icon(Icons.home_rounded, color: Theme.of(context).colorScheme.onPrimary),
        icon: Icon(Icons.home_outlined, color: Theme.of(context).colorScheme.onSecondary),
        label: "Home",
      ),
      NavigationDestination(
        selectedIcon: Icon(Icons.list_alt_rounded, color: Theme.of(context).colorScheme.onPrimary),
        icon: Icon(Icons.list_alt, color: Theme.of(context).colorScheme.onSecondary),
        label: "Learn",
      ),
      NavigationDestination(
        icon: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(25),
          ),
          child: IconButton(
            onPressed: () async {
              await savePhoto(context);
            },
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            icon: Icon(Icons.camera_alt_rounded, color: Theme.of(context).colorScheme.surface),
          ),
        ),
        label: "Camera",
      ),
      NavigationDestination(
        selectedIcon: Icon(Icons.leaderboard_rounded, color: Theme.of(context).colorScheme.onPrimary),
        icon: Icon(Icons.leaderboard_outlined, color: Theme.of(context).colorScheme.onSecondary),
        label: "Leaderboard",
      ),
      NavigationDestination(
        selectedIcon: Icon(Icons.person_rounded, color: Theme.of(context).colorScheme.onPrimary),
        icon: Icon(Icons.person_outlined, color: Theme.of(context).colorScheme.onSecondary),
        label: "Profile",
      ),
    ];
    final PageStorageBucket _bucket = PageStorageBucket();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          centerTitle: true,
          toolbarHeight: 80,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 4,
          shadowColor: Color.fromRGBO(0, 0, 0, 0.5),
          title: Padding(
            padding: EdgeInsets.only(top: 50, bottom: 15),
            child: Text("Mentorful.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
      body: PageStorage(bucket: _bucket, child: screens[selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        indicatorColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        animationDuration: const Duration(milliseconds: 500),
        labelBehavior: selectedIndex == 2
            ? NavigationDestinationLabelBehavior.alwaysHide
            : NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (v) => setState(() => selectedIndex = v),
        destinations: destination,
      ),
    );
  }
}
