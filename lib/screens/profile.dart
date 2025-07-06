import 'package:flutter/material.dart';

import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  _ProfileScreen();

  bool darkTheme = true;
  String occupation = prefs.getString("occupation") ?? "Other";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 2),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), offset: Offset(0, 4), blurRadius: 5, spreadRadius: 0),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(radius: 30, child: Icon(Icons.person, size: 50)),
                  IconButton(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 15),
                        Icon(Icons.logout, weight: 2),
                        SizedBox(width: 10),
                        Text("Sign Out", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                        SizedBox(width: 15),
                      ],
                    ),
                    onPressed: () {
                      print("logged out");
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Dark Mode", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
              Switch(
                value: darkTheme,
                onChanged: (bool value) {
                  setState(() {
                    darkTheme = !darkTheme;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Occupation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
              DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: occupation,
                    items: [
                      DropdownMenuItem(
                          value: "High Schooler", child: Text("High Schooler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSurface))),
                      DropdownMenuItem(
                          value: "University Student",
                          child: Text("University Student", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSurface))),
                      DropdownMenuItem(
                          value: "Work Force",
                          child: Text("Work Force", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSurface))),
                      DropdownMenuItem(
                          value: "Other", child: Text("Other", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSurface)))
                    ],
                    onChanged: (String? value) {
                      prefs.setString("occupation", value!);

                      setState(() {
                        occupation = value;
                      });
                    },
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                    icon: const SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(10),
                    alignment: Alignment.centerRight,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
