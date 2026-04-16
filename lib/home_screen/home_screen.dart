import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/custom_widget_library/animated_button.dart';
import 'package:nutrilens_test/custom_widget_library/rounded_notched_nav_bar.dart';
import 'package:nutrilens_test/home_screen/homepages/dashboard/dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentPageIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentPageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final palette = Theme.of(context).extension<AppPalette>()!;

    // TODO: implement build
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('NutriLens'),
        titleTextStyle: GoogleFonts.nunito(
          textStyle: TextStyle(
            color: palette.headingBlueText,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: Colors.transparent,
        toolbarHeight: 50,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Container(
            height: 44,
            width: 44,
            margin: EdgeInsetsGeometry.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: palette.unselectColor1,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.person, size: 28),
              ),
            ),
          ),
        ],
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
                Dashboard(),
              ],
            ),
            RoundedNotchedNavBar(borderColor: palette.selectColor3),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        margin: EdgeInsetsGeometry.symmetric(horizontal: 22),
        child: NavigationBar(
          height: 54,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, size: 28),
              selectedIcon: Icon(Icons.home_filled, size: 24),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart, size: 24),
              selectedIcon: Icon(Icons.bar_chart_rounded, size: 24),
              label: 'Progress',
            ),
            SizedBox(width: 10),
            NavigationDestination(
              icon: Icon(Icons.eco_outlined, size: 28),
              selectedIcon: Icon(Icons.eco, size: 24),
              label: 'Dietitian',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, size: 24),
              selectedIcon: Icon(Icons.settings, size: 24),
              label: 'Settings',
            ),
          ],
          indicatorColor: palette.selectColor4,
          selectedIndex: _currentPageIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
        ),
      ),
      extendBody: true,

      floatingActionButton: AnimatedButton(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlueAccent.shade100, Colors.blue.shade700],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              Container(
                height: 10,
                width: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                  border: BorderDirectional(
                    start: BorderSide(color: Colors.white, width: 2),
                    top: BorderSide(color: Colors.white, width: 2),
                    end: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 20,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(2)),
              ),
              Container(
                height: 10,
                width: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
                  border: BorderDirectional(
                    start: BorderSide(color: Colors.white, width: 2),
                    bottom: BorderSide(color: Colors.white, width: 2),
                    end: BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
