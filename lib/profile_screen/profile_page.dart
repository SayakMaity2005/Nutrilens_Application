import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrients_tracker/cores/constants/text_styles.dart';
import 'package:nutrients_tracker/custom_widget_library/animated_button.dart';
import 'package:nutrients_tracker/profile_screen/authentication.dart';

import '../cores/constants/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _headingText = 'Profile';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final palette = Theme.of(context).extension<AppPalette>()!;

    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(_headingText),
        titleTextStyle: GoogleFonts.nunito(
          textStyle: TextStyle(
            color: palette.headingBlueText,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.transparent,
        toolbarHeight: 50,
        elevation: 0,
        scrolledUnderElevation: 0,

        // automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 16,
            width: 16,
            margin: EdgeInsetsGeometry.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Color(0xFFD9EEFF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 24,
              color: Color(0xFF393939),
            ),
          ),
        ),
        // flexibleSpace: IconButton(onPressed: () {}, icon: Icon(Icons.person))
      ),

      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              palette.topGradient2,
              palette.midGradient2,
              palette.midGradient2,
              palette.bottomGradient2,
            ],
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 110, width: screenWidth),
                // Dashboard(),
                SizedBox(height: 40),
                Container(
                  margin: EdgeInsetsGeometry.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Text(
                    "You haven't signed in yet!\nTo use all the AI and history tracking features of this app you need to create an account first or sign in if you already have an account",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.primaryText.copyWith(
                      color: Color(0xFF555555),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                AnimatedButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Authentication();
                        },
                      ),
                    );
                  },
                  height: 54,
                  width: screenWidth / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFAAAAAA),
                        offset: Offset(1, 1),
                        spreadRadius: 0,
                        blurRadius: 1,
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 0.3, 0.7, 1.0],
                      colors: [
                        Color(0xFF6DBDF6),
                        Colors.white,
                        Colors.white,
                        Color(0xFFDB7AF3),
                      ],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: SizedBox(
                        height: screenHeight,
                        width: screenWidth,
                        child: Center(
                          child: Text(
                            'sign in',
                            style: AppTextStyle.heading5.copyWith(
                              color: Color(0xFF0D2968),
                            ),
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
      ),
    );
  }
}
