import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nutrilens_test/cores/custom_datatypes/custom_classes.dart';
import 'package:nutrilens_test/home_screen/homepages/dashboard/intake_details.dart';

class AnalyzingLoadingScreen extends StatefulWidget {
  final XFile imageFile;
  final double amount;
  final String unit;

  const AnalyzingLoadingScreen({
    super.key,
    required this.imageFile,
    required this.amount,
    required this.unit,
  });

  @override
  State<AnalyzingLoadingScreen> createState() => _AnalyzingLoadingScreenState();
}

class _AnalyzingLoadingScreenState extends State<AnalyzingLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final storage = const FlutterSecureStorage();
  String _statusMessage = "Analyzing image with AI...";

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _uploadAndAnalyze();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _uploadAndAnalyze() async {
    try {
      String? token = await storage.read(key: "access_token");

      setState(() {
        _statusMessage = "Connecting to Neural Engine...";
      });

      // Use deployed backend URL
      final baseUrl = "https://nutrilens-application.onrender.com";

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/daily_data/analyze_food"),
      );

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      
      // We send the amount regardless of 'grams' or 'servings'.
      // If it's servings, maybe grok handles it, but backend defaults to grams prompt right now.
      request.fields['quantity'] = widget.amount.toString();

      final bytes = await widget.imageFile.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: widget.imageFile.name,
      ));

      setState(() {
        _statusMessage = "Processing visual features...";
      });

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        setState(() {
          _statusMessage = "Generating macros...";
        });
        
        // Short delay for visual effect
        await Future.delayed(const Duration(milliseconds: 500));
        
        final data = jsonDecode(response.body);
        
        // Parse JSON data to Intake object
        final intakeObj = Intake(
          name: data['name'] ?? 'Unknown',
          type: data['type'] ?? 'Solid',
          unit: widget.unit,
          quantity: widget.amount, // Intake quantity is usually handled inside the object, but if API returns per unit, we pass 1.0 or the amount. Wait, if Grok calculates TOTAL, then perUnit = total / quantity
          energyPerUnit: (data['energy_per_unit'] ?? 0) / widget.amount,
          carbsPerUnit: (data['carbs_per_unit'] ?? 0) / widget.amount,
          proteinPerUnit: (data['protein_per_unit'] ?? 0) / widget.amount,
          fatPerUnit: (data['fat_per_unit'] ?? 0) / widget.amount,
          ingredients: [],
          recipe: "",
        );
        
        if (!mounted) return;
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IntakeDetails(
              selectedIntake: intakeObj,
            ),
          ),
        );
      } else {
        _showError("Analysis failed: ${response.statusCode}\n${response.body}");
      }
    } catch (e) {
      _showError("Connection error: $e");
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to camera
            },
            child: const Text("Go Back"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: kIsWeb
                ? Image.network(
                    widget.imageFile.path,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(widget.imageFile.path),
                    fit: BoxFit.cover,
                  ),
          ),
          
          // Dark Overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          // Animated Laser Scanner
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                top: _animation.value * size.height,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.8),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Scanning Frame (Corners)
          Center(
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),

          // Status Text
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Colors.blueAccent),
                  const SizedBox(height: 20),
                  Text(
                    _statusMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
