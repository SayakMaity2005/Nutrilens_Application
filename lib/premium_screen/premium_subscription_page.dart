import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/home_screen/homepages/dashboard/amount_input_screen.dart';

class PremiumSubscriptionPage extends StatefulWidget {
  final XFile imageFile;
  const PremiumSubscriptionPage({super.key, required this.imageFile});

  @override
  State<PremiumSubscriptionPage> createState() => _PremiumSubscriptionPageState();
}

class _PremiumSubscriptionPageState extends State<PremiumSubscriptionPage> {
  int _selectedPlanIndex = 1; // 0: 3 Months, 1: 12 Months, 2: 1 Month

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
                    Row(
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
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade400,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "PRO",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey, size: 28),
                      onPressed: () {
                        // User pressed X. Remove price tags / proceed to analysis for free.
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AmountInputScreen(imageFile: widget.imageFile),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Image Viewer with Scanner Brackets
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Food Image
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
                            image: FileImage(File(widget.imageFile.path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Scanning Brackets
                      SizedBox(
                        width: 310,
                        height: 310,
                        child: CustomPaint(
                          painter: ScannerBracketsPainter(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Pricing Section
              Container(
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // TODO: Handle Premium Checkout
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
                          "Cancel in the Our Store Anytime",
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
              )
            ],
          ),
        ),
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

class ScannerBracketsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double length = 40;
    final double radius = 25;

    // Top Left
    var path = Path();
    path.moveTo(0, length);
    path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius), clockwise: true);
    path.lineTo(length, 0);
    canvas.drawPath(path, paint);

    // Top Right
    path = Path();
    path.moveTo(size.width - length, 0);
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius), clockwise: true);
    path.lineTo(size.width, length);
    canvas.drawPath(path, paint);

    // Bottom Right
    path = Path();
    path.moveTo(size.width, size.height - length);
    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius), clockwise: true);
    path.lineTo(size.width - length, size.height);
    canvas.drawPath(path, paint);

    // Bottom Left
    path = Path();
    path.moveTo(length, size.height);
    path.lineTo(radius, size.height);
    path.arcToPoint(Offset(0, size.height - radius), radius: Radius.circular(radius), clockwise: true);
    path.lineTo(0, size.height - length);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
