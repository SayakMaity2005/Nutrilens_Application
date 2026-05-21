import 'package:flutter/material.dart';
import 'dart:async';
import 'package:nutrilens_test/home_screen/home_screen.dart';
import 'package:nutrilens_test/initial_screens/input_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // "Come down to up in a swing" -> start below screen, end at center with a bouncy curve
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5), // Start lower down
      end: const Offset(0, 0),    // End exactly in the center
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut, // Elastic effect creates the "swing" / bounce
      ),
    );

    // "Zoom to front" -> scale from tiny to full size
    _scaleAnimation = Tween<double>(
      begin: 0.1, // Start very small
      end: 1.0,   // Full size
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic), // Scale completes faster than the swing
      ),
    );

    // Start the animation
    _controller.forward();

    // Navigate to HomeScreen after animation and a tiny delay
    Timer(const Duration(milliseconds: 3200), () async {
      String? token = await FlutterSecureStorage().read(key: "access_token");
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
                token != null ? const HomeScreen() : const InputScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match your app's theme
      body: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              'assets/image.png',
              width: 250, // Adjust size as needed based on your image
              height: 250,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
