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
    final screenWidth = screenSize.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Color(0xFF334155),
            ),
          ),
        ),
      ),
      body: Container(
        height: screenSize.height,
        width: screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.cyan.shade100.withOpacity(0.6),
              Colors.white,
              Colors.white,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Texts
                Text(
                  _isSignIn ? "Welcome Back!" : "Create Account",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isSignIn ? "Sign in to access your AI assistant and history." : "Join NutriLens to track your nutrition seamlessly.",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 32),

                // Form Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Toggle Switch
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() {
                                  _isSignIn = true;
                                  _isDietician = false;
                                }),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _isSignIn ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: _isSignIn
                                        ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]
                                        : [],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: _isSignIn ? Colors.blue.shade700 : const Color(0xFF64748B),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isSignIn = false),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: !_isSignIn ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: !_isSignIn
                                        ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))]
                                        : [],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: !_isSignIn ? Colors.blue.shade700 : const Color(0xFF64748B),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Form Fields
                      _buildTextField("Username", Icons.person, _usernameTextController),
                      if (!_isSignIn) const SizedBox(height: 16),
                      if (!_isSignIn) _buildTextField("Full Name", Icons.badge_outlined, _fullNameTextController),
                      if (!_isSignIn) const SizedBox(height: 16),
                      if (!_isSignIn) _buildTextField("Email", Icons.email_outlined, _emailTextController),
                      
                      if (!_isSignIn && !_isDietician) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => pickDOB(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_month, color: Colors.grey.shade500, size: 22),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _selectedDate == null ? "DOB" : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                                          style: TextStyle(color: _selectedDate == null ? Colors.grey.shade500 : const Color(0xFF334155), fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedGender,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                ),
                                icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade500),
                                items: ["Male", "Female", "Other"]
                                    .map((g) => DropdownMenuItem(value: g, child: Text(g, style: const TextStyle(fontSize: 15, color: Color(0xFF334155)))))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedGender = val);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildTextField("Height (cm)", Icons.height, _heightTextController, isNumber: true)),
                            const SizedBox(width: 12),
                            Expanded(child: _buildTextField("Weight (kg)", Icons.monitor_weight_outlined, _weightTextController, isNumber: true)),
                          ],
                        ),
                      ],

                      if (!_isSignIn && _isDietician) ...[
                        const SizedBox(height: 16),
                        _buildTextField("Specialization", Icons.work_outline, _specializationController),
                        const SizedBox(height: 16),
                        _buildTextField("Qualification", Icons.school_outlined, _qualificationController),
                        const SizedBox(height: 16),
                        _buildTextField("Experience (Years)", Icons.timeline, _experienceController, isNumber: true),
                      ],

                      const SizedBox(height: 16),
                      _buildTextField("Password", Icons.lock_outline, _passwordTextController, isObscure: true),
                      if (!_isSignIn) const SizedBox(height: 16),
                      if (!_isSignIn) _buildTextField("Confirm Password", Icons.lock_outline, _confirmPasswordTextController, isObscure: true),

                      const SizedBox(height: 30),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            shadowColor: Colors.blue.withOpacity(0.5),
                          ),
                          child: Text(
                            _isSignIn ? "Sign In" : "Create Account",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      
                      if (!_isSignIn) const SizedBox(height: 20),
                      if (!_isSignIn)
                        GestureDetector(
                          onTap: () => setState(() => _isDietician = !_isDietician),
                          child: Text(
                            _isDietician ? "Register as a normal user instead" : "Are you a Dietitian? Sign up here",
                            style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller, {bool isObscure = false, bool isNumber = false}) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      style: const TextStyle(color: Color(0xFF334155), fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
        prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 22),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.blue.shade400, width: 1.5)),
      ),
    );
  }

  Future<void> _handleSubmit() async {
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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white)),
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
  }
}
