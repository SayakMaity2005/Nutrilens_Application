import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nutrilens_test/cores/custom_datatypes/custom_classes.dart';
import 'package:nutrilens_test/home_screen/homepages/dashboard/intake_details.dart';
import 'package:nutrilens_test/home_screen/homepages/dashboard/amount_input_screen.dart'; import 'package:nutrilens_test/cores/api_config.dart';
// For ScannerBracketsPainter

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
  
  bool _showProAds = true;
  int _selectedPlanIndex = 1;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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

      final baseUrl = ApiConfig.baseUrl;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/daily_data/analyze_food"),
      );

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      
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
        
        await Future.delayed(const Duration(milliseconds: 500));
        
        final data = jsonDecode(response.body);
        
        final intakeObj = Intake(
          name: data['name'] ?? 'Unknown',
          type: data['type'] ?? 'Solid',
          unit: widget.unit,
          quantity: widget.amount,
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.cyan.shade100.withOpacity(0.4),
              Colors.white,
              Colors.white,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Nutrilens",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F2D3F),
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (_showProAds)
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey, size: 28),
                        onPressed: () => setState(() => _showProAds = false),
                      )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Image Viewer with Scanner Brackets & Laser
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            )
                          ],
                          image: DecorationImage(
                            image: kIsWeb ? NetworkImage(widget.imageFile.path) as ImageProvider : FileImage(File(widget.imageFile.path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: ClipOval(
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Stack(
                                children: [
                                  Positioned(
                                    top: _animation.value * 250,
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
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 310,
                        height: 310,
                        child: CustomPaint(painter: ScannerBracketsPainter()),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 180,),

              // Bottom Section
              // AnimatedSwitcher(
              //   duration: const Duration(milliseconds: 300),
              //   child: _showProAds
              //       ? _buildPricingSection()
              //       : _buildLoadingState(),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      key: const ValueKey('loading'),
      padding: const EdgeInsets.symmetric(vertical: 50.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Colors.blueAccent),
          const SizedBox(height: 20),
          Text(
            _statusMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Container(
      key: const ValueKey('pricing'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildPricingCard(
                index: 0,
                title: "3\nMONTHS",
                pricePerMonth: "₹ 766.66 /mo",
                totalPrice: "₹2,300.00",
              ),
              const SizedBox(width: 12),
              _buildPricingCard(
                index: 1,
                title: "12\nMONTHS",
                pricePerMonth: "₹ 433.33 /mo",
                totalPrice: "₹5,200.00",
                badgeText: "60% OFF",
                isFeatured: true,
              ),
              const SizedBox(width: 12),
              _buildPricingCard(
                index: 2,
                title: "1\nMONTH",
                pricePerMonth: "₹ 1,050.00 /mo",
                totalPrice: "₹1,050.00",
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _selectedPlanIndex == 1 
              ? "Just ₹5,200.00/year, ₹ 433.33/month" 
              : (_selectedPlanIndex == 0 ? "Just ₹2,300.00/quarter, ₹ 766.66/month" : "Just ₹1,050.00/month"),
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment Gateway Integration Required')),
                );
              },
              child: const Text(
                "Continue",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user, color: Colors.green.shade600, size: 16),
              const SizedBox(width: 5),
              const Text(
                "Cancel in the Google Play Anytime",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Privacy policy", style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("|", style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
              ),
              Text("Terms of use", style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("|", style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
              ),
              Text("Restore", style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "According to GooglePlay policy, your subscription is automatically renewed. If you do not cancel, your Google account will be charged for the next period 24 hours before the end of the current subscription period. If you need to cancel, please manually turn off automatic renewal in the Google Play settings at least 24 hours before the end of the current subscription.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 10,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildPricingCard({
    required int index,
    required String title,
    required String pricePerMonth,
    required String totalPrice,
    String? badgeText,
    bool isFeatured = false,
  }) {
    final isSelected = _selectedPlanIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlanIndex = index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 120,
            width: isFeatured ? 110 : 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (badgeText != null) const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: isFeatured ? 15 : 13,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  pricePerMonth,
                  style: TextStyle(
                    color: isSelected ? Colors.blue.shade700 : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: isFeatured ? 13 : 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  totalPrice,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (badgeText != null)
            Positioned(
              top: -10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
