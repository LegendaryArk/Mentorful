import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/user.dart';

class Leaderboard extends StatefulWidget {
  Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  late ScrollController _scrollController;

  late List<User> rankings;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    rankings = [
      User(uid: 0, name: "A", xp: 25),
      User(uid: 1, name: "B", xp: 15),
      User(uid: 2, name: "C", xp: 150),
      User(uid: 3, name: "D", xp: 86),
      User(uid: 4, name: "E", xp: 23),
      User(uid: 5, name: "F", xp: 68),
      User(uid: 6, name: "G", xp: 213),
      User(uid: 7, name: "H", xp: 59),
      User(uid: 8, name: "I", xp: 120),
      User(uid: 9, name: "J", xp: 158),
      User(uid: 10, name: "K", xp: 59),
      User(uid: 11, name: "L", xp: 23),
      User(uid: 12, name: "M", xp: 2),
      User(uid: 13, name: "N", xp: 66),
      User(uid: 14, name: "O", xp: 48),
      User(uid: 15, name: "P", xp: 252),
      User(uid: 16, name: "Q", xp: 348),
      User(uid: 17, name: "R", xp: 27),
      User(uid: 18, name: "S", xp: 31),
      User(uid: 19, name: "T", xp: 83),
    ];

    rankings.sort((a, b) {
      return b.xp - a.xp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leaderboard")),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverToBoxAdapter(child: Text("Leaderboard")),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(23),
              height: 1000,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: List<Widget>.generate(20, (int index) {
                  return Row(
                      children: [
                        CircleAvatar(child: Text("${index + 1}")),
                        SizedBox(width: 10),
                        Text(rankings[index].name),
                        SizedBox(width: 30),
                        Text("${rankings[index].xp} xp")
                      ]
                    );
                }),
              )
            )
          )
        ]
      )
    );
  }
}