import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mentorful/aesthetics/colorSchemes.dart';
import 'package:mentorful/screens/home.dart';
import 'package:mentorful/screens/leaderboard.dart';
import 'package:mentorful/screens/lessons.dart';
import 'package:mentorful/screens/profile.dart';
import 'package:mentorful/widgets/photoSubmission.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

final GlobalKey<MentorfulState> mentorfulKey = GlobalKey<MentorfulState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late Directory appDir;
late SharedPreferences prefs;
final localNotif = FlutterLocalNotificationsPlugin();

// GoogleSignIn instance
final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: '136345961977-orosn54cojaj3o6fs9kug2t4ihq6rbu9.apps.googleusercontent.com',
  scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'https://www.googleapis.com/auth/calendar.readonly',
  ],
);

//android
Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    // Check current status
    final status = await Permission.notification.status;

    if (status.isDenied) {
      // Ask the user for permission
      final result = await Permission.notification.request();
    }
  }
}

Future<void> scheduleOnDate({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledDate,
}) async {
  // Convert to a TZ-aware date in the user's local timezone.
  tz.initializeTimeZones();
  final tz.TZDateTime scheduledLocal = tz.TZDateTime.from(scheduledDate, tz.getLocation('America/Toronto'));

  // Build platform-specific details:
  const notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'one_time_channel', // channel ID
      'One-Time Notifications', // channel name
      channelDescription: 'Alerts scheduled for a specific date',
      importance: Importance.max,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  // Schedule it:
  await localNotif.zonedSchedule(
    id,
    title,
    body,
    scheduledLocal,
    notificationDetails,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    // no matchDateTimeComponents → fires only once
  );
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
    const InitializationSettings(android: androidInit, iOS: iosInit),
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // This runs when the user taps on a notification
      final payload = response.payload;
      // e.g. navigate to a specific screen, log analytics, etc.
      print('Notification tapped! id=${response.id}, payload=$payload');
      // If you're inside a Navigator-able context you could do:
      // Navigator.of(navigatorKey.currentContext!)
      //     .pushNamed('/detail', arguments: payload);
      savePhoto(navigatorKey.currentContext!);
    },
  );

  // 3️⃣ Request permissions on iOS (optional on Android)
  await localNotif.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );

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

  GoogleSignInAccount? _currentUser;
  String _calendarResponse = '';

  Future<void> _handleSignIn() async {
    try {
      print('Attempting to sign in...');
      final account = await _googleSignIn.signIn();
      if (account == null) {
        setState(() => _calendarResponse = 'Sign-in cancelled.');
        return;
      }

      // **1) Immediately flip the UI over to "signed in"**
      setState(() {
        _currentUser = account;
        _calendarResponse = 'Loading your calendar…';
      });

      // 2) Then fetch your calendar
      final auth = await account.authentication;
      final token = auth.accessToken!;
      final uri = Uri.parse('http://172.20.10.2:8000/get-calendar/?token=$token');
      final resp = await http.get(uri);

      // 3) Finally, show the response
      setState(() => _calendarResponse = resp.body);
    } catch (error) {
      // If anything blows up, at least _currentUser is set:
      setState(() {
        _calendarResponse = 'Error: $error';
      });
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
    setState(() {
      _currentUser = null;
      _calendarResponse = '';
    });
  }

  @override
  Widget build(BuildContext) {
    List<Widget> screens = [HomeScreen(), LessonsScreen(), Container(), Leaderboard(), ProfileScreen()];

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
          leading: Container(
            padding: const EdgeInsets.only(left: 10),
            height: 30,
            width: 30,
            child: Image.asset("lib/assets/mentorfulLogo.png", fit: BoxFit.contain),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 50, bottom: 15),
            child: Text("Mentorful.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ),
          actions: [
            CircleAvatar(radius: 30, child: Icon(Icons.person)),
            SizedBox(width: 10),
          ],
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
