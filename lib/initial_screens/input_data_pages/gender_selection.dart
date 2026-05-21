import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GenderSelection extends StatefulWidget {
  final Map<String, dynamic> inputData;
  final void Function(String) onSelection;
  const GenderSelection({
    super.key,
    required this.inputData,
    required this.onSelection,
  });

  @override
  State<GenderSelection> createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  late int _option;

  @override
  void initState() {
    super.initState();
    if(widget.inputData['gender']==null) {
      _option = -1;
    } else if(widget.inputData['gender']=='Male') {
      _option = 0;
    } else {
      _option = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Container(
      height: screenSize.height,
      width: screenSize.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.white,
            Colors.pink.shade50,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main Card
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_outline_rounded,
                        size: 48,
                        color: Colors.blue.shade400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "What's your gender?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "This helps us calculate your specific nutritional needs.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Options
                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderOption(
                            index: 0,
                            icon: Icons.male_rounded,
                            label: "Male",
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildGenderOption(
                            index: 1,
                            icon: Icons.female_rounded,
                            label: "Female",
                            color: Colors.pink,
                          ),
                        ),
                      ],
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

  Widget _buildGenderOption({
    required int index,
    required IconData icon,
    required String label,
    required MaterialColor color,
  }) {
    final bool isSelected = _option == index;
    
    return GestureDetector(
      onTap: () {
        setState(() => _option = index);
        // Small delay to show the animation before moving to next page
        Future.delayed(const Duration(milliseconds: 300), () {
          widget.onSelection(label);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? color.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color.shade300 : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? color.shade600 : Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? color.shade700 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
