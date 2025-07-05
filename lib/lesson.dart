import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class Lesson extends StatefulWidget {
  const Lesson({super.key});

  @override
  State<Lesson> createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
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
    List<Widget> featurePages = [
      Column(children: [
        Text(
          'At a glance',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Upcoming matches & info',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 20),
        //Expanded(child: PhotoPreview(imageLocation: 'assets/onboardingHome$imageStringAddition.png'))
      ]),
      Column(children: [
        Text(
          'Find matches',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'See scores and live timing',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 20),
        //Expanded(child: PhotoPreview(imageLocation: "assets/onboardingSchedule$imageStringAddition.png"))
      ]),
      Column(children: [
        Text(
          'Check rankings',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Find teams and stats',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 20),
        //Expanded(child: PhotoPreview(imageLocation: 'assets/onboardingRankings$imageStringAddition.png'))
      ]),
      Column(children: [
        Text(
          'Dive deeper',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Get stats about your team',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 20),
        //Expanded(child: PhotoPreview(imageLocation: 'assets/onboardingMyTeam$imageStringAddition.png'))
      ]),
    ];

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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
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
                            items: featurePages,
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
                                })),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 5,
                      child: DotsIndicator(
                        dotsCount: featurePages.length,
                        position: currIndex.toDouble(),
                        mainAxisSize: MainAxisSize.min,
                        decorator: DotsDecorator(
                          color: Theme.of(context).colorScheme.surfaceDim, // Inactive color
                          size: const Size.fromRadius(3.0),
                          activeSize: const Size.fromRadius(3.0),
                          activeColor: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 23.0),
                        child: TextButton(
                          child: Text(
                            "e"
                          ),
                          onPressed: () {
                            if (currIndex == 3) {
                              Navigator.pop(context);
                            } else {
                              carouselController.nextPage(
                                  duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
                            }
                          },
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

// class PhotoPreview extends StatelessWidget {
//   const PhotoPreview({super.key, required this.imageLocation});
//   final String imageLocation;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(width: 1, color: Theme.of(context).colorScheme.surface)),
//       child: ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.asset(imageLocation, fit: BoxFit.fill)),
//     );
//   }
// }