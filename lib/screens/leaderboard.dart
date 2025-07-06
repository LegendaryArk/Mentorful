import 'package:carousel_slider/carousel_slider.dart';
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
  String division = "Iron";

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    rankings = [
      User(uid: 0, name: "Liam Carter", xp: 25),
      User(uid: 1, name: "Ava Patel", xp: 15),
      User(uid: 2, name: "Noah Kim", xp: 150),
      User(uid: 3, name: "Sophia Nguyen", xp: 86),
      User(uid: 4, name: "Ethan Li", xp: 23),
      User(uid: 5, name: "Isabella Wright", xp: 68),
      User(uid: 6, name: "Lucas Chen", xp: 213),
      User(uid: 7, name: "Mia Thompson", xp: 59),
      User(uid: 8, name: "Benjamin Singh", xp: 120),
      User(uid: 9, name: "Charlotte Garcia", xp: 158),
      User(uid: 10, name: "James Robinson", xp: 59),
      User(uid: 11, name: "Emily Zhang", xp: 23),
      User(uid: 12, name: "Jack Morales", xp: 2),
      User(uid: 13, name: "Harper Ahmed", xp: 66),
      User(uid: 14, name: "Elijah Green", xp: 48),
      User(uid: 15, name: "Amelia Davis", xp: 252),
      User(uid: 16, name: "Oliver Brown", xp: 348),
      User(uid: 17, name: "Abigail Scott", xp: 27),
      User(uid: 18, name: "Logan Hill", xp: 31),
      User(uid: 19, name: "Grace Lee", xp: 83),
    ];

    rankings.sort((a, b) {
      return b.xp - a.xp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          PinnedHeaderSliver(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), offset: Offset(0, 4), blurRadius: 5, spreadRadius: 0),
                ],
              ),
              child: Column(
                children: [
                  CarouselSlider(
                    items: [
                      Icon(Icons.emoji_events, size: 80, color: Color.fromRGBO(81, 81, 81, 1)),
                      Icon(Icons.emoji_events, size: 80, color: Color.fromRGBO(192, 58, 0, 1)),
                      Icon(Icons.emoji_events, size: 80, color: Color.fromRGBO(189, 189, 189, 1)),
                      Icon(Icons.emoji_events, size: 80, color: Color.fromRGBO(193, 200, 0, 1)),
                      Icon(Icons.emoji_events, size: 80, color: Color.fromRGBO(77, 136, 255, 1)),
                    ],
                    options: CarouselOptions(
                      height: 120,
                      viewportFraction: 0.3,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        switch (index) {
                          case 0:
                            division = "Iron";
                            break;
                          case 1:
                            division = "Bronze";
                            break;
                          case 2:
                            division = "Silver";
                            break;
                          case 3:
                            division = "Gold";
                            break;
                          case 4:
                            division = "Diamond";
                            break;
                        }
                        setState(() {});
                      },
                      enlargeCenterPage: true,
                      enlargeFactor: 0.6,
                      clipBehavior: Clip.none,
                    ),
                  ),
                  Text("$division Division", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    index < 3
                        ? CircleAvatar(
                            child: Icon(
                              Icons.workspace_premium_outlined,
                              size: 40,
                              color: index == 0
                                  ? Color.fromRGBO(193, 200, 0, 1)
                                  : index == 1
                                  ? Color.fromRGBO(189, 189, 189, 1)
                                  : Color.fromRGBO(192, 58, 0, 1),
                            ),
                          )
                        : CircleAvatar(
                            child: Text("${index + 1}.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                          ),
                    SizedBox(width: 15),
                    CircleAvatar(backgroundColor: Theme.of(context).colorScheme.secondary),
                    SizedBox(width: 20),
                    Text(rankings[index].name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                    Spacer(),
                    Text("${rankings[index].xp} XP", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                  ],
                ),
              );
            }, childCount: rankings.length),
          ),
        ],
      ),
    );
  }
}
