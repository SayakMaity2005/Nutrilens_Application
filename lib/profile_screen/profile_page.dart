import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrilens_test/cores/auth/auth_services.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/custom_widget_library/animated_button.dart';
import 'package:nutrilens_test/profile_screen/authentication.dart';

import '../cores/constants/colors.dart';
import '../cores/user_operations/user_services.dart';
import '../home_screen/home_screen.dart';
import '../dietician_screen/dietician_home_screen.dart' as nutrilens_test_dietician;

class ProfilePage extends StatefulWidget {
  final Function(Map<String, dynamic>?) updateUserdata;
  final Map<String, dynamic>? userData;
  const ProfilePage({super.key, required this.updateUserdata, this.userData});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _headingText = 'Profile';
  bool _authorized = false;

  late Map<String, dynamic> _userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.userData == null) {
      getCurrentUser();
    } else {
      _authorized = true;
      _userData = widget.userData!;
    }
  }

  Future<void> getCurrentUser() async {
    final response = await UserServices().getUser();
    if (response['status_ok']) {
      setState(() {
        _authorized = true;
        _headingText = response['data']['full_name'];
        _userData = response['data'];
        widget.updateUserdata(_userData);
      });
    } else {
      setState(() {
        _authorized = false;
        _userData = {};
        widget.updateUserdata(null);
      });
    }
  }

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
        actions: [
          if (_authorized)
            GestureDetector(
              onTap: () async {
                await AuthServices().logout();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Container(
                // height: 16,
                // width: 16,
                margin: EdgeInsetsGeometry.symmetric(horizontal: 6),
                padding: EdgeInsetsGeometry.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFD9EEFF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  size: 24,
                  color: Color(0xFF882828),
                ),
              ),
            ),
        ],
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
            if (!_authorized)
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
                    onTap: () async {
                      final res = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Authentication();
                          },
                        ),
                      );

                      if (res != null) {
                        await getCurrentUser();
                      }
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
                          Color(0xFF947AF3),
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

            if (_authorized)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 110, width: screenWidth),
                  // Dashboard(),
                  SizedBox(height: 40),

                  Container(
                    padding: EdgeInsetsGeometry.all(30),
                    decoration: BoxDecoration(
                      color: Color(0xFF47DDB4),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _userData['full_name'][0].toString().toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Container(
                    width: screenWidth,
                    margin: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text('User details', style: AppTextStyle.heading5),
                  ),

                  Container(
                    // height: 70,
                    width: screenWidth,
                    margin: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: BoxBorder.all(color: Color(0xFFE1E9FF), width: 1),
                    ),
                    child: Row(
                      spacing: 28,
                      children: [
                        Icon(Icons.person_pin_outlined),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name', style: AppTextStyle.heading6),
                            Text('${_userData['full_name'] ?? '--'}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // height: 70,
                    width: screenWidth,
                    margin: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: BoxBorder.all(color: Color(0xFFE1E9FF), width: 1),
                    ),
                    child: Row(
                      spacing: 28,
                      children: [
                        Icon(Icons.email_outlined),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email', style: AppTextStyle.heading6),
                            Text('${_userData['email'] ?? '--'}'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  Container(
                    width: screenWidth,
                    margin: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text('Profile', style: AppTextStyle.heading5),
                  ),

                  Container(
                    // height: 70,
                    width: screenWidth,
                    margin: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: BoxBorder.all(color: Color(0xFFE1E9FF), width: 1),
                    ),
                    child: Row(
                      spacing: 28,
                      children: [
                        Icon(Icons.calendar_month_outlined),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Age', style: AppTextStyle.heading6),
                            Text('${_userData['profile']?['age'] ?? '--'}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // height: 70,
                    width: screenWidth,
                    margin: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: BoxBorder.all(color: Color(0xFFE1E9FF), width: 1),
                    ),
                    child: Row(
                      spacing: 28,
                      children: [
                        Icon(Icons.person),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Gender', style: AppTextStyle.heading6),
                            Text('${_userData['profile']?['gender'] ?? '--'}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // height: 70,
                    width: screenWidth,
                    margin: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: BoxBorder.all(color: Color(0xFFE1E9FF), width: 1),
                    ),
                    child: Row(
                      spacing: 28,
                      children: [
                        Icon(Icons.height),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Height', style: AppTextStyle.heading6),
                            Text(
                              '${_userData['profile']?['height'] ?? '--'}'
                              '${_userData['profile']?['height'] != null ? ' cm' : ''}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // height: 70,
                    width: screenWidth,
                    margin: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: BoxBorder.all(color: Color(0xFFE1E9FF), width: 1),
                    ),
                    child: Row(
                      spacing: 28,
                      children: [
                        Icon(Icons.monitor_weight_outlined),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Weight', style: AppTextStyle.heading6),
                            Text(
                              '${_userData['profile']?['weight'] ?? '--'}'
                              '${_userData['profile']?['weight'] != null ? ' kg' : ''}',
                            ),
                          ],
                        ),
                      ],
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
