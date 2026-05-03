import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';

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
    // TODO: implement initState
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
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          const Text('What is your Gender?', style: AppTextStyle.heading3),
          const SizedBox(height: 20, width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _option = 0;
                widget.onSelection('Male');
              });
            },
            child: Container(
              height: 56,
              width: 220,
              decoration: BoxDecoration(
                color: _option == 0
                    ? palette.selectColor3
                    : palette.unselectColor1,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('Male', style: AppTextStyle.heading5),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _option = 1;
                widget.onSelection('Female');
              });
            },
            child: Container(
              height: 56,
              width: 220,
              decoration: BoxDecoration(
                color: _option == 1
                    ? palette.selectColor3
                    : palette.unselectColor1,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('Female', style: AppTextStyle.heading5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
