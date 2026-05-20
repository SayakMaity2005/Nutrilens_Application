import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/dietician_screen/client_list_page.dart';
import 'package:nutrilens_test/dietician_screen/meetings_page.dart';
import 'package:nutrilens_test/profile_screen/profile_page.dart';

class DieticianHomeScreen extends StatefulWidget {
  const DieticianHomeScreen({super.key});

  @override
  State<DieticianHomeScreen> createState() => _DieticianHomeScreenState();
}

class _DieticianHomeScreenState extends State<DieticianHomeScreen> {
  int _currentIndex = 0;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final palette = Theme.of(context).extension<AppPalette>() ?? ThemePalette.lightPalette;

    final pages = <Widget>[
      const ClientListPage(),
      const MeetingsPage(),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? 'My Clients' : 'Meetings',
        ),
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
        automaticallyImplyLeading: false,
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
                      builder: (context) => ProfilePage(
                        updateUserdata: (userData) {
                          setState(() => _userData = userData);
                        },
                        userData: _userData,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.person, size: 28),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
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
        child: Column(
          children: [
            const SizedBox(height: 110),
            Expanded(child: pages[_currentIndex]),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 80,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: Colors.transparent,
        indicatorColor: palette.selectColor4,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline, size: 28),
            selectedIcon: Icon(Icons.people, size: 24),
            label: 'Clients',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined, size: 24),
            selectedIcon: Icon(Icons.calendar_today, size: 24),
            label: 'Meetings',
          ),
        ],
      ),
    );
  }
}
