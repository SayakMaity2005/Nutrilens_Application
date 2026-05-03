import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Size screenSize = MediaQuery.sizeOf(context);
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    final palette = Theme.of(context).extension<AppPalette>()!;

    return Stack(
      children: [
        Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            // color: Color(0xff22a899),
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                Color(0x47000000),
                BlendMode.srcOver,
              ),
              image: AssetImage('assets/first_screen_bg_image.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Column(children: [Text("NutriLens", style: AppTextStyle.heading2)]),

            // For spacing purpose
            SizedBox(height: 120, width: 20),

            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 340,
                  width: 340,
                  // decoration: BoxDecoration(color: Color(0xBE000000)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        // color: Color(0xff3e49af),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff000000),
                            // offset: Offset(-4, -4),
                            blurRadius: 64,
                            blurStyle: BlurStyle.outer,
                            spreadRadius: 0,
                          ),
                        ],
                        // border: BoxBorder.fromLTRB(
                        //   top: BorderSide(color: Colors.white, width: 6),
                        //   left: BorderSide(color: Colors.white, width: 6),
                        // ),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  // color: Color(0xff7520ae),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                  ),
                                  border: BoxBorder.fromLTRB(
                                    left: BorderSide(
                                      color: Colors.white,
                                      width: 6,
                                    ),
                                    top: BorderSide(
                                      color: Colors.white,
                                      width: 6,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 160,
                                width: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white, // Color(0xff661677),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 6,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white, // Color(0xff9c1390),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 6,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white, // Color(0xff6e0e65),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(6),
                                  ),
                                ),
                              ),
                              Container(
                                height: 114,
                                width: 6,
                                decoration: BoxDecoration(
                                  // color: Color(0xffb651ae),
                                ),
                              ),
                              Container(
                                height: 20,
                                width: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white, // Color(0xff9c1390),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 6,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.white, // Color(0xff380845),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      // color: Color(0xff40053b),
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(24),
                                      ),
                                      border: BoxBorder.fromLTRB(
                                        right: BorderSide(
                                          color: Colors.white,
                                          width: 6,
                                        ),
                                        bottom: BorderSide(
                                          color: Colors.white,
                                          width: 6,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 160,
                      width: 80,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              height: 60,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Color(0x44ffffff),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 2,
                                children: [
                                  Text(
                                    "🥚 Protein",
                                    style: AppTextStyle.smallBoldText,
                                  ),
                                  Text(
                                    "24g",
                                    style: AppTextStyle.primaryText.copyWith(
                                      color: Colors.pinkAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 270,
                      width: 80,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              height: 60,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Color(0x44ffffff),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 2,
                                children: [
                                  Text(
                                    "🧈 Fat",
                                    style: AppTextStyle.primaryBoldText,
                                  ),
                                  Text(
                                    "28g",
                                    style: AppTextStyle.primaryText.copyWith(
                                      color: Colors.amberAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      width: 80,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              height: 60,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Color(0x44ffffff),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 2,
                                children: [
                                  Text(
                                    "🍞 Carbs",
                                    style: AppTextStyle.smallBoldText,
                                  ),
                                  Text(
                                    "16g",
                                    style: AppTextStyle.primaryText.copyWith(
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 160,
                      width: 80,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              height: 60,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Color(0x44ffffff),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 2,
                                children: [
                                  Text(
                                    "🥛 Calcium",
                                    style: AppTextStyle.smallBoldText,
                                  ),
                                  Text(
                                    "150mg",
                                    style: AppTextStyle.primaryText.copyWith(
                                      color: Colors.lightBlueAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Container(
              height: 300,
              width: screenWidth,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xcf000000)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 2,
                children: [
                  Text("Capture your food,", style: AppTextStyle.heading3),
                  Text(
                    "we'll categorize the nutrients!",
                    style: AppTextStyle.heading3,
                  ),
                  SizedBox(height: 100, width: 10),
                  // Text("\n\nNext\n", style: AppTextStyle.heading5.copyWith(color: palette.selectColor1),)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
