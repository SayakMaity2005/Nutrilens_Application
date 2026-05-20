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
  bool _isDietician = false;

  late TextEditingController _usernameTextController;
  late TextEditingController _passwordTextController;
  late TextEditingController _confirmPasswordTextController;
  late TextEditingController _fullNameTextController;
  late TextEditingController _emailTextController;

  // Dietitian specific controllers
  late TextEditingController _specializationController;
  late TextEditingController _qualificationController;
  late TextEditingController _experienceController;

  // Normal User specific controllers
  late TextEditingController _heightTextController;
  late TextEditingController _weightTextController;

  DateTime? _selectedDate;
  String? _selectedGender = 'Male';

  Future<void> pickDOB(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(
          msg,
          style: AppTextStyle.primaryText.copyWith(color: const Color(0xFF000000)),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _usernameTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    _confirmPasswordTextController = TextEditingController();
    _fullNameTextController = TextEditingController();
    _emailTextController = TextEditingController();

    _specializationController = TextEditingController();
    _qualificationController = TextEditingController();
    _experienceController = TextEditingController();

    _heightTextController = TextEditingController();
    _weightTextController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    _fullNameTextController.dispose();
    _emailTextController.dispose();
    _specializationController.dispose();
    _qualificationController.dispose();
    _experienceController.dispose();
    _heightTextController.dispose();
    _weightTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final palette = Theme.of(context).extension<AppPalette>()!;

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
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 16,
            width: 16,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: const BoxDecoration(
              color: Color(0xFFD9EEFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 24,
              color: Color(0xFF393939),
            ),
          ),
        ),
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
        child: Column(
          children: [
            const SizedBox(height: 110),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFAAAAAA),
                            offset: Offset(1, 1),
                            spreadRadius: 0,
                            blurRadius: 1,
                          ),
                        ],
                        gradient: const LinearGradient(
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
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Column(
                              spacing: 16,
                              children: [
                                // Username Field
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 5,
                                  children: [
                                    const Text('  Username'),
                                    TextField(
                                      controller: _usernameTextController,
                                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                                        prefixIcon: const Icon(Icons.person),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF0D35B5))),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF777777))),
                                      ),
                                    ),
                                  ],
                                ),
                                // Full name Field
                                if (!_isSignIn)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 5,
                                    children: [
                                      const Text('  Full name'),
                                      TextField(
                                        controller: _fullNameTextController,
                                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                                          prefixIcon: const Icon(Icons.person_pin_outlined),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF0D35B5))),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF777777))),
                                        ),
                                      ),
                                    ],
                                  ),
                                // Email Field
                                if (!_isSignIn)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 5,
                                    children: [
                                      const Text('  Email'),
                                      TextField(
                                        controller: _emailTextController,
                                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                                          prefixIcon: const Icon(Icons.email_outlined),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF0D35B5))),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF777777))),
                                        ),
                                      ),
                                    ],
                                  ),

                                // User specific registration fields: DOB, Gender, Height, Weight
                                if (!_isSignIn && !_isDietician) ...[
                                  Row(
                                    spacing: 20,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        spacing: 5,
                                        children: [
                                          const Text('  Date of birth'),
                                          GestureDetector(
                                            onTap: () => pickDOB(context),
                                            child: Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: const Color(0xFF777777)),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                _selectedDate == null
                                                    ? "Select DOB"
                                                    : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          spacing: 4,
                                          children: [
                                            const Text('  Gender'),
                                            DropdownButtonFormField<String>(
                                              value: _selectedGender,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              items: ["Male", "Female", "Other"]
                                                  .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                                                  .toList(),
                                              onChanged: (value) {
                                                if (value != null) {
                                                  setState(() {
                                                    _selectedGender = value;
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    spacing: 20,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          spacing: 5,
                                          children: [
                                            const Text('  Height'),
                                            TextField(
                                              controller: _heightTextController,
                                              onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                              maxLength: 3,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                                                prefixIcon: const Icon(Icons.height),
                                                suffixText: 'cm',
                                                counterText: '',
                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF0D35B5))),
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF777777))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          spacing: 5,
                                          children: [
                                            const Text('  Weight'),
                                            TextField(
                                              controller: _weightTextController,
                                              onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                              maxLength: 3,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                                                prefixIcon: const Icon(Icons.monitor_weight_outlined),
                                                suffixText: 'kg',
                                                counterText: '',
                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF0D35B5))),
                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF777777))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],

                                // Dietitian specific registration fields
                                if (!_isSignIn && _isDietician) ...[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 5,
                                    children: [
                                      const Text('  Specialization'),
                                      TextField(
                                        controller: _specializationController,
                                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                                          prefixIcon: const Icon(Icons.work),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF0D35B5))),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF777777))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 5,
                                    children: [
                                      const Text('  Qualification'),
                                      TextField(
                                        controller: _qualificationController,
                                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                                          prefixIcon: const Icon(Icons.school),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF0D35B5))),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF777777))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 5,
                                    children: [
                                      const Text('  Experience (Years)'),
                                      TextField(
                                        controller: _experienceController,
                                        keyboardType: TextInputType.number,
                                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                                          prefixIcon: const Icon(Icons.timeline),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF0D35B5))),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF777777))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],

                                // Password Field
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 5,
                                  children: [
                                    const Text('  Password'),
                                    TextField(
                                      controller: _passwordTextController,
                                      obscureText: true,
                                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                                        prefixIcon: const Icon(Icons.key_rounded),
                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF0D35B5))),
                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF777777))),
                                      ),
                                    ),
                                  ],
                                ),
                                // Confirm Password Field
                                if (!_isSignIn)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 5,
                                    children: [
                                      const Text('  Confirm password'),
                                      TextField(
                                        controller: _confirmPasswordTextController,
                                        obscureText: true,
                                        keyboardType: TextInputType.visiblePassword,
                                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                                          prefixIcon: const Icon(Icons.key_rounded),
                                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF0D35B5))),
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF777777))),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    AnimatedButton(
                      onTap: () async {
                        if (_usernameTextController.text.isEmpty) {
                          _showSnackBar(context, 'Enter username (mandatory field)');
                          return;
                        }
                        if (_passwordTextController.text.isEmpty) {
                          _showSnackBar(context, 'Enter password');
                          return;
                        }
                        if (!_isSignIn) {
                          if (_passwordTextController.text.length < 8) {
                            _showSnackBar(context, 'Password must have at least 8 characters');
                            return;
                          }
                          if (_passwordTextController.text != _confirmPasswordTextController.text) {
                            _showSnackBar(context, 'Password mismatch');
                            return;
                          }
                        }

                        // Show loading
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(child: CircularProgressIndicator()),
                        );

                        Map<String, dynamic> response;

                        if (_isSignIn) {
                          response = await AuthServices().login(
                            username: _usernameTextController.text,
                            password: _passwordTextController.text,
                          );
                        } else {
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
                            final double? height = double.tryParse(_heightTextController.text);
                            final double? weight = double.tryParse(_weightTextController.text);
                            final int? age = _selectedDate == null ? null : DateTime.now().year - _selectedDate!.year;

                            response = await AuthServices().register(
                              username: _usernameTextController.text,
                              email: _emailTextController.text,
                              fullName: _fullNameTextController.text,
                              height: height,
                              weight: weight,
                              age: age,
                              gender: _selectedGender?.toLowerCase(),
                              password: _passwordTextController.text,
                            );
                          }
                        }

                        if (!context.mounted) return;
                        Navigator.pop(context); // Close loading

                        _showSnackBar(context, response['message'] ?? 'Authentication updated');

                        if (response['status_ok'] == true) {
                          Navigator.pop(context, true);
                        }
                      },
                      height: 54,
                      width: screenWidth / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFAAAAAA),
                            offset: Offset(1, 1),
                            spreadRadius: 0,
                            blurRadius: 1,
                          ),
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.0, 0.3, 0.7, 1.0],
                          colors: [
                            Color(0xFF6DBDF6),
                            Colors.white,
                            Colors.white,
                            Color(0xFF987AF3),
                          ],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: SizedBox(
                            height: screenHeight,
                            width: screenWidth,
                            child: Center(
                              child: Text(
                                _isSignIn ? 'Sign In' : 'Sign Up',
                                style: AppTextStyle.heading5.copyWith(
                                  color: const Color(0xFF0D2968),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
