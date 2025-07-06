import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/lessonScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Center(child: SizedBox(
            height: 200, width: 200,
            child: Image.asset("lib/assets/sad.png", fit: BoxFit.cover,),
          ),),
          SizedBox(height: 120),
          Center(
          child: Container(
            height: 188,
            width: 225,
            padding: const EdgeInsets.all(15),
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.5), offset: Offset(0, 4), spreadRadius: 0, blurRadius: 5),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.local_fire_department, size: 100, color: Color.fromRGBO(255, 89, 0, 1)),
                Text(
                  "69 days",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onPrimary),
                ),
              ],
            ),
          ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
