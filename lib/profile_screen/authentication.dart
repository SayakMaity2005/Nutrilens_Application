import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cores/constants/colors.dart';
import '../cores/constants/text_styles.dart';
import '../cores/auth/auth_services.dart';
import '../cores/dietician/dietician_services.dart';
import '../custom_widget_library/animated_button.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  String _headingText = 'Sign In';
  bool _isSignIn = true;
  bool _isDietician = false; // NEW TOGGLE
  late TextEditingController _usernameTextController;
  late TextEditingController _passwordTextController;
  late TextEditingController _confirmPasswordTextController;
  late TextEditingController _fullNameTextController;
  late TextEditingController _emailTextController;
  
  // Dietician specific controllers
  late TextEditingController _specializationController;
  late TextEditingController _qualificationController;
  late TextEditingController _experienceController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _confirmPasswordTextController = TextEditingController();
    _fullNameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    
    _specializationController = TextEditingController();
    _qualificationController = TextEditingController();
    _experienceController = TextEditingController();
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
            SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 110, width: screenWidth),
                // Dashboard(),
                SizedBox(height: 40),

                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsetsGeometry.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  // padding: EdgeInsetsGeometry.symmetric(
                  //   horizontal: 20,
                  //   vertical: 20,
                  // ),
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
                        Color(0xFFE59FF6),
                      ],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                      child: Container(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          spacing: 16,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Text(
                                  '  '
                                  'Username',
                                ),
                                TextField(
                                  controller: _usernameTextController,
                                  // style: AppTextStyle.primaryText.copyWith(
                                  //   fontWeight: FontWeight.w900,
                                  // ),
                                  // autofocus: true,
                                  onTapOutside: (_) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsetsGeometry.symmetric(
                                          vertical: 16,
                                          horizontal: 30,
                                        ),
                                    prefixIcon: Icon(Icons.person),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0xFF0D35B5),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0xFF777777),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0x98ED0F0F),
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0x98ED0F0F),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (!_isSignIn)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  Text(
                                    '  '
                                    'Full name',
                                  ),
                                  TextField(
                                    controller: _fullNameTextController,
                                    // style: AppTextStyle.primaryText.copyWith(
                                    //   fontWeight: FontWeight.w900,
                                    // ),
                                    // autofocus: true,
                                    onTapOutside: (_) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsetsGeometry.symmetric(
                                            vertical: 16,
                                            horizontal: 30,
                                          ),
                                      prefixIcon: Icon(Icons.badge),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Color(0xFF0D35B5),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Color(0xFF777777),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Color(0x98ED0F0F),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Color(0x98ED0F0F),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (!_isSignIn)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  Text(
                                    '  '
                                    'Email',
                                  ),
                                  TextField(
                                    controller: _emailTextController,
                                    // style: AppTextStyle.primaryText.copyWith(
                                    //   fontWeight: FontWeight.w900,
                                    // ),
                                    // autofocus: true,
                                    onTapOutside: (_) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsetsGeometry.symmetric(
                                            vertical: 16,
                                            horizontal: 30,
                                          ),
                                      prefixIcon: Icon(Icons.email),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Color(0xFF0D35B5),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Color(0xFF777777),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Color(0x98ED0F0F),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Color(0x98ED0F0F),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Text(
                                  '  '
                                  'Password',
                                ),
                                TextField(
                                  controller: _passwordTextController,
                                  // style: AppTextStyle.primaryText.copyWith(
                                  //   fontWeight: FontWeight.w900,
                                  // ),
                                  // autofocus: true,
                                  obscureText: true,
                                  onTapOutside: (_) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsetsGeometry.symmetric(
                                          vertical: 16,
                                          horizontal: 30,
                                        ),
                                    prefixIcon: Icon(Icons.key_rounded),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0xFF0D35B5),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0xFF777777),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0x98ED0F0F),
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0x98ED0F0F),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (!_isSignIn)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  Text(
                                    '  '
                                    'Confirm password',
                                  ),
                                  TextField(
                                    controller: _confirmPasswordTextController,
                                    // style: AppTextStyle.primaryText.copyWith(
                                    //   fontWeight: FontWeight.w900,
                                    // ),
                                    // autofocus: true,
                                    keyboardType: TextInputType.visiblePassword,
                                    onTapOutside: (_) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsetsGeometry.symmetric(
                                            vertical: 16,
                                            horizontal: 30,
                                          ),
                                      prefixIcon: Icon(Icons.key),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Color(0xFF0D35B5),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Color(0xFF777777),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Color(0x98ED0F0F),
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(
                                          color: Color(0x98ED0F0F),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (!_isSignIn && _isDietician) ...[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  Text('  Specialization'),
                                  TextField(
                                    controller: _specializationController,
                                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsetsGeometry.symmetric(vertical: 16, horizontal: 30),
                                      prefixIcon: Icon(Icons.work),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Color(0xFF0D35B5))),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Color(0xFF777777))),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  Text('  Qualification'),
                                  TextField(
                                    controller: _qualificationController,
                                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsetsGeometry.symmetric(vertical: 16, horizontal: 30),
                                      prefixIcon: Icon(Icons.school),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Color(0xFF0D35B5))),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Color(0xFF777777))),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  Text('  Experience (Years)'),
                                  TextField(
                                    controller: _experienceController,
                                    keyboardType: TextInputType.number,
                                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsetsGeometry.symmetric(vertical: 16, horizontal: 30),
                                      prefixIcon: Icon(Icons.timeline),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Color(0xFF0D35B5))),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Color(0xFF777777))),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                AnimatedButton(
                  onTap: () async {
                    // Show loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(child: CircularProgressIndicator()),
                    );

                    Map<String, dynamic> response;
                    
                    if (_isSignIn) {
                      response = await AuthServices().login(
                        username: _usernameTextController.text,
                        password: _passwordTextController.text,
                      );
                    } else {
                      if (_passwordTextController.text != _confirmPasswordTextController.text) {
                        Navigator.pop(context); // Close loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Passwords do not match!')),
                        );
                        return;
                      }
                      if (_isDietician) {
                        response = await DieticianServices().registerDietician(
                          username: _usernameTextController.text,
                          email: _emailTextController.text,
                          fullName: _fullNameTextController.text,
                          password: _passwordTextController.text,
                          specialization: _specializationController.text,
                          qualification: _qualificationController.text,
                          experienceYears: int.tryParse(_experienceController.text),
                        );
                      } else {
                        response = await AuthServices().register(
                          username: _usernameTextController.text,
                          email: _emailTextController.text,
                          fullName: _fullNameTextController.text,
                          password: _passwordTextController.text,
                        );
                      }
                    }

                    if(!context.mounted) return;
                    Navigator.pop(context); // Close loading

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        margin: EdgeInsetsGeometry.symmetric(
                          horizontal: 40,
                          vertical: 40,
                        ),
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        content: Text(
                          response['message'],
                          style: AppTextStyle.primaryText.copyWith(
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                    );

                    if (response['status_ok']) {
                      Navigator.pop(context, true);
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
                            _isSignIn ? 'sign in' : 'sign up',
                            style: AppTextStyle.heading5.copyWith(
                              color: Color(0xFF0D2968),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isSignIn = !_isSignIn;
                      _headingText = _isSignIn ? 'Sign In' : 'Create Account';
                      if (_isSignIn) _isDietician = false; // reset when going to sign in
                    });
                  },
                  child: Text(
                    _isSignIn ? "Don't have an account? Sign Up" : "Already have an account? Sign In",
                    style: TextStyle(
                      color: palette.headingBlueText,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (!_isSignIn)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isDietician = !_isDietician;
                      });
                    },
                    child: Text(
                      _isDietician ? "Register as a normal user instead" : "Are you a Dietician? Sign up here",
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                SizedBox(height: 40),
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}
