import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mentorful/aesthetics/colorSchemes.dart';
import 'package:mentorful/screens/home.dart';
import 'package:mentorful/screens/leaderboard.dart';
import 'package:mentorful/screens/lessonPlan.dart';
import 'package:mentorful/widgets/photoSubmission.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';



final GlobalKey<MentorfulState> mentorfulKey = GlobalKey<MentorfulState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late Directory appDir;
late SharedPreferences prefs;
final localNotif = FlutterLocalNotificationsPlugin();

//android
Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    // Check current status
    final status = await Permission.notification.status;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    if (status.isDenied) {
      // Ask the user for permission
      final result = await Permission.notification.request();
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await requestNotificationPermission();
  appDir = await getApplicationDocumentsDirectory();
  prefs = await SharedPreferences.getInstance();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Toronto'));

  // 2️⃣ Plugin initialization
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosInit = DarwinInitializationSettings();
  await localNotif.initialize(
    const InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    ),
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // This runs when the user taps on a notification
      final payload = response.payload;
      // e.g. navigate to a specific screen, log analytics, etc.
      print('Notification tapped! id=${response.id}, payload=$payload');
      // If you're inside a Navigator-able context you could do:
      // Navigator.of(navigatorKey.currentContext!)
      //     .pushNamed('/detail', arguments: payload);
    },
  );

  // 3️⃣ Request permissions on iOS (optional on Android)
  await localNotif
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);

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
