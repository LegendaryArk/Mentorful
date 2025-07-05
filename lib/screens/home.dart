import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          SizedBox(height: 300),
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
