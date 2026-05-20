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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _authorized ? "Profile" : "Sign In",
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
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
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  size: 22,
                  color: Colors.red.shade700,
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
              Colors.cyan.shade100.withOpacity(0.6),
              Colors.white,
              Colors.white,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: !_authorized
              ? _buildUnauthorizedState(context, screenWidth)
              : _buildAuthorizedState(screenWidth),
        ),
      ),
    );
  }

  Widget _buildUnauthorizedState(BuildContext context, double screenWidth) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Icon(Icons.person_outline_rounded, size: 80, color: Colors.blue.shade200),
          ),
          const SizedBox(height: 30),
          const Text(
            "You haven't signed in yet!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 12),
          const Text(
            "To use all the AI and history tracking features of this app you need to create an account first or sign in.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Color(0xFF64748B), height: 1.5),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => const Authentication()));
                if (res != null) await getCurrentUser();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                shadowColor: Colors.blue.withOpacity(0.5),
              ),
              child: const Text("Sign In / Create Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorizedState(double screenWidth) {
    final String initial = _userData['full_name'] != null ? _userData['full_name'][0].toString().toUpperCase() : '?';
    final String name = _userData['full_name'] ?? 'User';
    final String email = _userData['email'] ?? 'No email';
    final String age = _userData['profile']?['age']?.toString() ?? '--';
    final String gender = _userData['profile']?['gender']?.toString() ?? '--';
    final String height = _userData['profile']?['height']?.toString() ?? '--';
    final String weight = _userData['profile']?['weight']?.toString() ?? '--';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          // Hero Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade300, Colors.blue.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(fontSize: 16, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Stats Grid
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Health Profile",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(child: _buildStatCard("Age", age, Icons.cake_outlined, Colors.orange)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard("Gender", gender, Icons.person_outline, Colors.purple)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatCard("Height", "$height cm", Icons.height, Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard("Weight", "$weight kg", Icons.monitor_weight_outlined, Colors.blue)),
            ],
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color.shade600, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }
}
