import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/custom_widget_library/animated_button.dart';
import 'package:nutrilens_test/custom_widget_library/rounded_notched_nav_bar.dart';
import 'package:nutrilens_test/home_screen/homepages/dashboard/dashboard.dart';
import 'package:nutrilens_test/home_screen/homepages/dashboard/scan_food_screen.dart';
import 'package:nutrilens_test/home_screen/homepages/dietitian/dietitian_page.dart';
import 'package:nutrilens_test/home_screen/homepages/progress/progress_page.dart';

import '../profile_screen/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    final palette = Theme.of(context).extension<AppPalette>() ?? ThemePalette.lightPalette;

    final List<Widget> pages = [
      Dashboard(
        updateUserdata: (userData) {
          setState(() {
            _userData = userData;
          });
        },
      ),
      const ProgressPage(),
      const DietitianPage(),
      const Center(child: Text("Settings Page (Coming Soon)")),
    ];

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
            margin: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: palette.unselectColor1,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ProfilePage(
                          updateUserdata: (userData) {
                            setState(() {
                              _userData = userData;
                            });
                          },
                          userData: _userData,
                        );
                      },
                    ),
                  );
                },
                icon: (_userData == null || _userData?['full_name'] == null)
                    ? const Icon(Icons.person, size: 28)
                    : Text(
                        _userData!['full_name'][0].toString().toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 22,
                        ),
                      ),
              ),
            ),
          ),
        ],
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
                const SizedBox(height: 110),
                Expanded(
                  child: _currentPageIndex >= 0 && _currentPageIndex < pages.length
                      ? pages[_currentPageIndex]
                      : const Center(child: Text("Page not found")),
                ),
              ],
            ),
            RoundedNotchedNavBar(borderColor: palette.selectColor3),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 22),
        child: NavigationBar(
          height: 80 - bottomPadding,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined, size: 28),
              selectedIcon: Icon(Icons.home_filled, size: 24),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.bar_chart, size: 24),
              selectedIcon: Icon(Icons.bar_chart_rounded, size: 24),
              label: 'Progress',
            ),
            const NavigationDestination(
              icon: Opacity(opacity: 0, child: Icon(Icons.add)),
              label: '',
              enabled: false,
            ),
            const NavigationDestination(
              icon: Icon(Icons.eco_outlined, size: 28),
              selectedIcon: Icon(Icons.eco, size: 24),
              label: 'Dietitian',
            ),
            const NavigationDestination(
              icon: Icon(Icons.settings_outlined, size: 24),
              selectedIcon: Icon(Icons.settings, size: 24),
              label: 'Settings',
            ),
          ],
          indicatorColor: palette.selectColor4,
          selectedIndex: _currentPageIndex >= 2 ? _currentPageIndex + 1 : _currentPageIndex,
          onDestinationSelected: (index) {
            if (index == 2) return;
            setState(() {
              _currentPageIndex = index > 2 ? index - 1 : index;
            });
          },
          backgroundColor: Colors.transparent,
        ),
      ),
      extendBody: true,
      floatingActionButton: AnimatedButton(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScanFoodScreen()),
          );
        },
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
                decoration: const BoxDecoration(
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 10,
                width: 28,
                decoration: const BoxDecoration(
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
