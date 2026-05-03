import 'package:flutter/material.dart';
import 'package:nutrients_tracker/cores/constants/colors.dart';
import 'package:nutrients_tracker/initial_screens/input_screen.dart';
import 'package:nutrients_tracker/initial_screens/overview_screens/first_screen.dart';

import '../cores/constants/text_styles.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  late PageController _pageController;
  late int _index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
    _index = 0;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final palette = Theme.of(context).extension<AppPalette>()!;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _index = index;
              });
            },
            children: [
              const FirstScreen(),
              const FirstScreen(),
              const FirstScreen(),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  for (int i = 0; i < 3; i++)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 150),
                      height: 10,
                      width: i == _index ? 18 : 10,
                      decoration: BoxDecoration(
                        color: i == _index
                            ? palette.selectColor1
                            : Colors.white38,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20, width: 10),
              GestureDetector(
                onTap: () {
                  if (_index < 2) {
                    _pageController.animateToPage(
                      _index + 1,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.bounceOut,
                    );
                  } else if (_index == 2) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return InputScreen();
                        },
                      ),
                    );
                  }
                },
                child: Container(
                  height: 20,
                  width: 60,
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Center(
                    child: Text(
                      _index == 2 ? "Start" : "Next",
                      style: AppTextStyle.heading5.copyWith(
                        color: palette.selectColor1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30, width: 10),
            ],
          ),
        ],
      ),
    );
  }
}
