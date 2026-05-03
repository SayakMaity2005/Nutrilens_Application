import 'package:flutter/material.dart';

import '../../cores/constants/colors.dart';
import '../../cores/constants/text_styles.dart';
import '../../custom_widget_library/animated_button.dart';
import '../../custom_widget_library/customized_text_field.dart';

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
  late String? _dateError;
  late String? _monthError;
  late String? _yearError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateTextController = TextEditingController();
    _monthTextController = TextEditingController();
    _yearTextController = TextEditingController();
    _dateFocus = FocusNode();
    _monthFocus = FocusNode();
    _yearFocus = FocusNode();
    _dateError = null;
    _monthError = null;
    _yearError = null;
    if(widget.inputData['dob'] != null) {
      DateTime dob = widget.inputData['dob'];
      _dateTextController.text = dob.day.toString();
      _monthTextController.text = dob.month.toString();
      _yearTextController.text = dob.year.toString();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
    /// return 3 => year error, dob can't be > now().year
    /// return 2 => month error
    /// return 1 => date error according to month, like 30/02 is invalid
    /// return 0 => no error
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
    // TODO: implement build
    final screenSize = MediaQuery.sizeOf(context);
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final palette = Theme.of(context).extension<AppPalette>()!;

    return Container(
      height: screenHeight,
      width: screenWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [palette.topGradient2, Colors.transparent],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'What is your date of birth?',
            style: AppTextStyle.heading3,
          ),
          const SizedBox(height: 30, width: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              SizedBox(
                height: 70,
                width: 80,
                child: CustomizedTextField(
                  controller: _dateTextController,
                  focusNode: _dateFocus,
                  nextNode: _monthFocus,
                  maxLength: 2,
                  maxVal: 31,
                  minVal: 1,
                  textAlign: TextAlign.center,
                  hintText: 'DD',
                ),
              ),

              SizedBox(
                height: 70,
                width: 80,
                child: CustomizedTextField(
                  controller: _monthTextController,
                  focusNode: _monthFocus,
                  nextNode: _yearFocus,
                  prevNode: _dateFocus,
                  maxLength: 2,
                  maxVal: 12,
                  minVal: 1,
                  textAlign: TextAlign.center,
                  hintText: 'MM',
                ),
              ),

              SizedBox(
                height: 70,
                width: 80,
                child: CustomizedTextField(
                  controller: _yearTextController,
                  focusNode: _yearFocus,
                  prevNode: _monthFocus,
                  maxLength: 4,
                  minVal: 1850,
                  textAlign: TextAlign.center,
                  hintText: 'YYYY',
                ),
              ),
            ],
          ),
          SizedBox(height: 200, width: 10),
          AnimatedButton(
            onTap: () {
              int? date = int.tryParse(_dateTextController.text);
              int? month = int.tryParse(_monthTextController.text);
              int? year = int.tryParse(_yearTextController.text);
              if (date == null || month == null || year == null) {
                final errorSnackBar = SnackBar(
                  content: Text(
                    'Please fill complete date',
                    style: AppTextStyle.primaryText.copyWith(
                      color: Color(0xFF53121B),
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsetsGeometry.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  backgroundColor: Color(0xC2D599A2),
                  showCloseIcon: true,
                  closeIconColor: Color(0xFF53121B),
                );
                ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                return;
              }
              int dateValidationState = checkDateValidation(date, month, year);
              if (dateValidationState == 0) {
                widget.onInput(DateTime(year, month, date));
                return;
              }
              final errorSnackBar = SnackBar(
                content: Text(
                  dateValidationState == 3
                      ? "Dob can't be greater than today!"
                      : 'Invalid date provided!',
                  style: AppTextStyle.primaryText.copyWith(
                    color: Color(0xFF53121B),
                  ),
                ),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsetsGeometry.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                backgroundColor: Color(0xC2D599A2),
                showCloseIcon: true,
                closeIconColor: Color(0xFF53121B),
              );
              ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
            },
            height: 50,
            width: 220,
            decoration: BoxDecoration(
              color: palette.selectColor3,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('Next', style: AppTextStyle.heading5),
            ),
          ),
          SizedBox(height: 30, width: 10),
        ],
      ),
    );
  }
}
