import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DobInput extends StatefulWidget {
  final Map<String, dynamic> inputData;
  final void Function(DateTime) onInput;
  const DobInput({super.key, required this.inputData, required this.onInput});

  @override
  State<DobInput> createState() => _DobInputState();
}

class _DobInputState extends State<DobInput> {
  late TextEditingController _dateTextController;
  late TextEditingController _monthTextController;
  late TextEditingController _yearTextController;
  late FocusNode _dateFocus;
  late FocusNode _monthFocus;
  late FocusNode _yearFocus;

  @override
  void initState() {
    super.initState();
    _dateTextController = TextEditingController();
    _monthTextController = TextEditingController();
    _yearTextController = TextEditingController();
    _dateFocus = FocusNode();
    _monthFocus = FocusNode();
    _yearFocus = FocusNode();
    
    if(widget.inputData['dob'] != null) {
      DateTime dob = widget.inputData['dob'];
      _dateTextController.text = dob.day.toString().padLeft(2, '0');
      _monthTextController.text = dob.month.toString().padLeft(2, '0');
      _yearTextController.text = dob.year.toString();
    }
  }

  @override
  void dispose() {
    _dateTextController.dispose();
    _monthTextController.dispose();
    _yearTextController.dispose();
    _dateFocus.dispose();
    _monthFocus.dispose();
    _yearFocus.dispose();
    super.dispose();
  }

  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  int checkDateValidation(int date, int month, int year) {
    if (year > DateTime.now().year) return 3;
    if(DateTime(year, month, date).isAfter(DateTime.now())) return 3;
    if (month > 12) return 2;
    if (isLeapYear(year)) {
      if (month == 2 && date > 29) return 1;
    } else {
      if (month == 2 && date > 28) return 1;
    }
    if (month >= 7) {
      if (month % 2 != 0 && date > 31) return 1;
      if (month % 2 == 0 && date > 30) return 1;
    } else {
      if (month % 2 == 0 && date > 31) return 1;
      if (month % 2 != 0 && date > 30) return 1;
    }
    return 0;
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
            Colors.purple.shade50,
            Colors.white,
            Colors.blue.shade50,
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
                        color: Colors.purple.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cake_rounded,
                        size: 48,
                        color: Colors.purple.shade400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "When is your birthday?",
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
                      "Your age determines your metabolic rate.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Inputs
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDateInput(
                          controller: _dateTextController,
                          focusNode: _dateFocus,
                          nextNode: _monthFocus,
                          hint: 'DD',
                          maxLength: 2,
                          width: 70,
                        ),
                        const SizedBox(width: 12),
                        Text("/", style: GoogleFonts.nunito(fontSize: 24, color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        _buildDateInput(
                          controller: _monthTextController,
                          focusNode: _monthFocus,
                          prevNode: _dateFocus,
                          nextNode: _yearFocus,
                          hint: 'MM',
                          maxLength: 2,
                          width: 70,
                        ),
                        const SizedBox(width: 12),
                        Text("/", style: GoogleFonts.nunito(fontSize: 24, color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 12),
                        _buildDateInput(
                          controller: _yearTextController,
                          focusNode: _yearFocus,
                          prevNode: _monthFocus,
                          hint: 'YYYY',
                          maxLength: 4,
                          width: 90,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade500,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          shadowColor: Colors.purple.withValues(alpha: 0.5),
                        ),
                        child: Text(
                          "Next",
                          style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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

  Widget _buildDateInput({
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextNode,
    FocusNode? prevNode,
    required String hint,
    required int maxLength,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: maxLength,
        style: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF334155),
        ),
        onChanged: (value) {
          if (value.isEmpty && prevNode != null) {
            FocusScope.of(context).requestFocus(prevNode);
          } else if (value.length == maxLength && nextNode != null) {
            FocusScope.of(context).requestFocus(nextNode);
          }
        },
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.nunito(color: Colors.grey.shade400, fontSize: 18, fontWeight: FontWeight.w600),
          counterText: "",
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.purple.shade300, width: 2),
          ),
        ),
      ),
    );
  }

  void _handleNext() {
    int? date = int.tryParse(_dateTextController.text);
    int? month = int.tryParse(_monthTextController.text);
    int? year = int.tryParse(_yearTextController.text);
    
    if (date == null || month == null || year == null) {
      _showError('Please fill in your complete birth date');
      return;
    }
    
    int dateValidationState = checkDateValidation(date, month, year);
    if (dateValidationState == 0) {
      widget.onInput(DateTime(year, month, date));
      return;
    }
    
    _showError(dateValidationState == 3 ? "Date of birth cannot be in the future" : 'Please enter a valid date');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        backgroundColor: Colors.red.shade400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
