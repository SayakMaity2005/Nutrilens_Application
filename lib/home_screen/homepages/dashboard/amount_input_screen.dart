import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/home_screen/homepages/dashboard/analyzing_loading_screen.dart';

class AmountInputScreen extends StatefulWidget {
  final XFile imageFile;
  const AmountInputScreen({super.key, required this.imageFile});

  @override
  State<AmountInputScreen> createState() => _AmountInputScreenState();
}

class _AmountInputScreenState extends State<AmountInputScreen> {
  final TextEditingController _amountController = TextEditingController(text: "100");
  String _unit = "grams";

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _analyzeFood() {
    double amount = double.tryParse(_amountController.text) ?? 100.0;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AnalyzingLoadingScreen(
          imageFile: widget.imageFile,
          amount: amount,
          unit: _unit,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>() ?? ThemePalette.lightPalette;

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
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey, size: 28),
                      onPressed: () => Navigator.pop(context),
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

              // Bottom Input Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Set Portion",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Input Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Amount TextField
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Unit Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _unit,
                              dropdownColor: Colors.white,
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                              style: const TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
                              items: const [
                                DropdownMenuItem(value: "grams", child: Text("grams")),
                                DropdownMenuItem(value: "servings", child: Text("servings")),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _unit = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Analyze Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        onPressed: _analyzeFood,
                        child: const Text(
                          "Get Nutritional Info",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

    var path = Path();
    path.moveTo(0, length);
    path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius), clockwise: true);
    path.lineTo(length, 0);
    canvas.drawPath(path, paint);

    path = Path();
    path.moveTo(size.width - length, 0);
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius), clockwise: true);
    path.lineTo(size.width, length);
    canvas.drawPath(path, paint);

    path = Path();
    path.moveTo(size.width, size.height - length);
    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius), clockwise: true);
    path.lineTo(size.width - length, size.height);
    canvas.drawPath(path, paint);

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
