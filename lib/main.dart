import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mentorful/screens/leaderboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';



late Directory appDir;
late SharedPreferences prefs;
final localNotif = FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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


  runApp(const MyApp());
}


Future<void> scheduleOnDate({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledDate,
}) async {
  // Convert to a TZ-aware date in the user's local timezone.
  final tz.TZDateTime scheduledLocal =
      tz.TZDateTime.from(scheduledDate, tz.local);

  // Build platform-specific details:
  const notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'one_time_channel',        // channel ID
      'One-Time Notifications',  // channel name
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


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: Leaderboard(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
