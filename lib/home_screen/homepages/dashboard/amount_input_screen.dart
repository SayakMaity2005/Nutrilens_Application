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
    
    // Navigate to the loading/analyzing screen, passing the image and amount
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Set Portion",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
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
          
          // Dark Gradient Overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "How much did you eat?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Input Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Amount TextField
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: TextField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Unit Dropdown / Selector
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _unit,
                              dropdownColor: Colors.grey.shade900,
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                              items: const [
                                DropdownMenuItem(value: "grams", child: Text("grams")),
                                DropdownMenuItem(value: "servings", child: Text("servings")),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _unit = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Analyze Button
                    GestureDetector(
                      onTap: _analyzeFood,
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [palette.selectColor1, palette.selectColor3],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: palette.selectColor1.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "Analyze Food",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
