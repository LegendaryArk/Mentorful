import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../util/lesson.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int currIndex = 0;
  late CarouselSliderController carouselController;

  @override
  void initState() {
    super.initState();
    carouselController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false;
    if (Theme.of(context).brightness == Brightness.dark) {
      isDarkMode = true;
    }

    String imageStringAddition = "";
    if (isDarkMode) {
      imageStringAddition = "Dark";
    }
    List<Widget> lessonPages = widget.lesson.txts.map((e) {
      int i = widget.lesson.txts.indexWhere((e2) => e2 == e);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.lesson.name,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 10),
          widget.lesson.imgs.isNotEmpty && widget.lesson.imgs[i] != null
              ? Expanded(child: PhotoPreview(image: widget.lesson.imgs[i]!))
              : SizedBox(),
          const SizedBox(height: 15),
          Text(
            e,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ],
      );
    }).toList();
    // List<Widget> featurePages = [
    //   Column(children: [
    //     Text(
    //       'At a glance',
    //       style: TextStyle(
    //         fontSize: 32,
    //         fontWeight: FontWeight.w300,
    //         color: Theme.of(context).colorScheme.secondary,
    //       ),
    //     ),
    //     const SizedBox(height: 8),
    //     Text(
    //       'Upcoming matches & info',
    //       style: TextStyle(
    //         fontSize: 16,
    //         fontWeight: FontWeight.w400,
    //         color: Theme.of(context).colorScheme.onSurface,
    //       ),
    //     ),
    //     const SizedBox(height: 20),
    //     //Expanded(child: PhotoPreview(imageLocation: 'assets/onboardingHome$imageStringAddition.png'))
    //   ]),
    //   Column(children: [
    //     Text(
    //       'Find matches',
    //       style: TextStyle(
    //         fontSize: 32,
    //         fontWeight: FontWeight.w300,
    //         color: Theme.of(context).colorScheme.secondary,
    //       ),
    //     ),
    //     const SizedBox(height: 8),
    //     Text(
    //       'See scores and live timing',
    //       style: TextStyle(
    //         fontSize: 16,
    //         fontWeight: FontWeight.w400,
    //         color: Theme.of(context).colorScheme.onSurface,
    //       ),
    //     ),
    //     const SizedBox(height: 20),
    //     //Expanded(child: PhotoPreview(imageLocation: "assets/onboardingSchedule$imageStringAddition.png"))
    //   ]),
    //   Column(children: [
    //     Text(
    //       'Check rankings',
    //       style: TextStyle(
    //         fontSize: 32,
    //         fontWeight: FontWeight.w300,
    //         color: Theme.of(context).colorScheme.secondary,
    //       ),
    //     ),
    //     const SizedBox(height: 8),
    //     Text(
    //       'Find teams and stats',
    //       style: TextStyle(
    //         fontSize: 16,
    //         fontWeight: FontWeight.w400,
    //         color: Theme.of(context).colorScheme.onSurface,
    //       ),
    //     ),
    //     const SizedBox(height: 20),
    //     //Expanded(child: PhotoPreview(imageLocation: 'assets/onboardingRankings$imageStringAddition.png'))
    //   ]),
    //   Column(children: [
    //     Text(
    //       'Dive deeper',
    //       style: TextStyle(
    //         fontSize: 32,
    //         fontWeight: FontWeight.w300,
    //         color: Theme.of(context).colorScheme.secondary,
    //       ),
    //     ),
    //     const SizedBox(height: 8),
    //     Text(
    //       'Get stats about your team',
    //       style: TextStyle(
    //         fontSize: 16,
    //         fontWeight: FontWeight.w400,
    //         color: Theme.of(context).colorScheme.onSurface,
    //       ),
    //     ),
    //     const SizedBox(height: 20),
    //     //Expanded(child: PhotoPreview(imageLocation: 'assets/onboardingMyTeam$imageStringAddition.png'))
    //   ]),
    // ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              // height: double.infinity,
              // width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 70,
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.only(top: 18),
                      child: CarouselSlider(
                        items: lessonPages,
                        carouselController: carouselController,
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height * 0.7,
                          enableInfiniteScroll: false,
                          autoPlay: false,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              currIndex = index;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 5,
                    child: DotsIndicator(
                      dotsCount: lessonPages.length,
                      position: currIndex.toDouble(),
                      mainAxisSize: MainAxisSize.min,
                      decorator: DotsDecorator(
                        color: Theme.of(context).colorScheme.onSecondary, // Inactive color
                        size: const Size.fromRadius(4.0),
                        activeSize: const Size.fromRadius(5.0),
                        activeColor: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              carouselController.previousPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn,
                              );
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    offset: Offset(0, 4),
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Icon(Icons.navigate_before),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (currIndex == lessonPages.length - 1) {
                                Navigator.pop(context);
                              } else {
                                carouselController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.fastOutSlowIn,
                                );
                              }
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    offset: Offset(0, 4),
                                    blurRadius: 5,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Icon(currIndex == lessonPages.length - 1 ? Icons.check : Icons.navigate_next),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoPreview extends StatelessWidget {
  const PhotoPreview({super.key, required this.image});
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(width: 1, color: Theme.of(context).colorScheme.surface),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(18), child: image),
    );
  }
}
