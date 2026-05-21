import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeightInput extends StatefulWidget {
  final Map<String, dynamic> inputData;
  final void Function(String) onInput;
  const HeightInput({
    super.key,
    required this.inputData,
    required this.onInput,
  });

  @override
  State<HeightInput> createState() => _HeightInputState();
}

class _HeightInputState extends State<HeightInput> {
  late bool _unitInCm;
  late TextEditingController _cmTextController;
  late TextEditingController _ftTextController;
  late TextEditingController _inTextController;
  late FocusNode _ftNode;
  late FocusNode _inNode;

  @override
  void initState() {
    super.initState();
    _unitInCm = true;
    _cmTextController = TextEditingController();
    _ftTextController = TextEditingController();
    _inTextController = TextEditingController();
    _ftNode = FocusNode();
    _inNode = FocusNode();
    
    String? height = widget.inputData['height'];
    if (height != null) {
      if (height.contains('cm')) {
        _unitInCm = true;
        _cmTextController.text = height.substring(0, height.indexOf('cm'));
      } else {
        _unitInCm = false;
        _ftTextController.text = height.substring(0, height.indexOf('ft'));
        _inTextController.text = height.substring(height.indexOf('ft') + 2, height.indexOf('in'));
      }
    }
  }

  @override
  void dispose() {
    _cmTextController.dispose();
    _ftTextController.dispose();
    _inTextController.dispose();
    _ftNode.dispose();
    _inNode.dispose();
    super.dispose();
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
            Colors.teal.shade50,
            Colors.white,
            Colors.green.shade50,
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
                        color: Colors.teal.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.height_rounded,
                        size: 48,
                        color: Colors.teal.shade400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "What's your height?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Unit Toggle
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _unitInCm = true),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _unitInCm ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: _unitInCm
                                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))]
                                      : [],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Centimeters",
                                  style: GoogleFonts.nunito(
                                    color: _unitInCm ? Colors.teal.shade600 : const Color(0xFF64748B),
                                    fontWeight: _unitInCm ? FontWeight.w800 : FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _unitInCm = false),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !_unitInCm ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: !_unitInCm
                                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))]
                                      : [],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Feet / Inches",
                                  style: GoogleFonts.nunito(
                                    color: !_unitInCm ? Colors.teal.shade600 : const Color(0xFF64748B),
                                    fontWeight: !_unitInCm ? FontWeight.w800 : FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Inputs
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _unitInCm
                          ? _buildDateInput(
                              controller: _cmTextController,
                              focusNode: FocusNode(),
                              hint: 'cm',
                              maxLength: 3,
                              width: 120,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildDateInput(
                                  controller: _ftTextController,
                                  focusNode: _ftNode,
                                  nextNode: _inNode,
                                  hint: 'ft',
                                  maxLength: 1,
                                  width: 80,
                                ),
                                const SizedBox(width: 16),
                                _buildDateInput(
                                  controller: _inTextController,
                                  focusNode: _inNode,
                                  prevNode: _ftNode,
                                  hint: 'in',
                                  maxLength: 2,
                                  width: 80,
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 40),

                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade500,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          shadowColor: Colors.teal.withValues(alpha: 0.5),
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
          fontSize: 24,
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
          hintStyle: GoogleFonts.nunito(color: Colors.grey.shade400, fontSize: 20, fontWeight: FontWeight.w600),
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
            borderSide: BorderSide(color: Colors.teal.shade300, width: 2),
          ),
        ),
      ),
    );
  }

  void _handleNext() {
    if ((_unitInCm && _cmTextController.text.isEmpty) ||
        (!_unitInCm && (_ftTextController.text.isEmpty || _inTextController.text.isEmpty))) {
      _showError('Please enter your complete height');
      return;
    }
    
    String height = _unitInCm
        ? '${_cmTextController.text}cm'
        : '${_ftTextController.text}ft${_inTextController.text}in';
    widget.onInput(height);
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
