import 'package:flutter/material.dart';
import 'package:nutrients_tracker/cores/constants/text_styles.dart';

import '../../cores/constants/colors.dart';
import '../../custom_widget_library/animated_button.dart';
import '../../custom_widget_library/customized_text_field.dart';

class WeightInput extends StatefulWidget {
  final Map<String, dynamic> inputData;
  final void Function(double) onInput;
  const WeightInput({
    super.key,
    required this.inputData,
    required this.onInput,
  });

  @override
  State<WeightInput> createState() => _WeightInputState();
}

class _WeightInputState extends State<WeightInput> {
  // late bool _unitInCm;
  late TextEditingController _kgTextController;
  // late TextEditingController _ftTextController;
  // late TextEditingController _inTextController;
  // late FocusNode _ftNode;
  // late FocusNode _inNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _unitInCm = true;
    _kgTextController = TextEditingController();
    // _ftTextController = TextEditingController();
    // _inTextController = TextEditingController();
    // _ftNode = FocusNode();
    // _inNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _kgTextController.dispose();
    // _ftTextController.dispose();
    // _inTextController.dispose();
    // _ftNode.dispose();
    // _inNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final palette = Theme.of(context).extension<AppPalette>()!;

    return Container(
      height: screenHeight,
      width: screenWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [palette.topGradient2, Colors.transparent],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 20,
        children: [
          const Text("What's your weight?", style: AppTextStyle.heading3),
          // if (_unitInCm)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: 80,
                  child: CustomizedTextField(
                    controller: _kgTextController,
                    // focusNode: _dateFocus,
                    // nextNode: _monthFocus,
                    maxLength: 6,
                    maxVal: 250,
                    minVal: 0,
                    textAlign: TextAlign.center,
                    hintText: 'Kg',
                  ),
                ),
              ],
            ),
          // if (!_unitInCm)
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     spacing: 20,
          //     children: [
          //       SizedBox(
          //         height: 70,
          //         width: 100,
          //         child: CustomizedTextField(
          //           controller: _ftTextController,
          //           focusNode: _ftNode,
          //           nextNode: _inNode,
          //           maxLength: 2,
          //           maxVal: 12,
          //           minVal: 0,
          //           textAlign: TextAlign.center,
          //           hintText: 'Feet',
          //         ),
          //       ),
          //       SizedBox(
          //         height: 70,
          //         width: 100,
          //         child: CustomizedTextField(
          //           controller: _inTextController,
          //           focusNode: _inNode,
          //           prevNode: _ftNode,
          //           maxLength: 2,
          //           maxVal: 11,
          //           // minVal: 1,
          //           textAlign: TextAlign.center,
          //           hintText: 'Inches',
          //         ),
          //       ),
          //     ],
          //   ),

          // Container(
          //   height: 50,
          //   width: 200,
          //   decoration: BoxDecoration(
          //     color: palette.unselectColor1,
          //     borderRadius: BorderRadius.circular(30),
          //   ),
          //   child: Stack(
          //     children: [
          //       Center(
          //         child: SizedBox(
          //           height: 38,
          //           width: 188,
          //           child: Align(
          //             alignment: Alignment.centerLeft,
          //             child: AnimatedSlide(
          //               offset: _unitInCm? Offset(0, 0): Offset(1, 0),
          //               duration: Duration(milliseconds: 300),
          //               curve: Curves.easeOutExpo,
          //               child: Container(
          //                 height: 38,
          //                 width: 94,
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(25),
          //                   gradient: LinearGradient(
          //                     colors: [
          //                       palette.selectColor2,
          //                       palette.selectColor3,
          //                     ],
          //                   ),
          //                 ),
          //                 // child: Center(child: Text('ft/in')),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       Align(
          //         alignment: Alignment.center,
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             GestureDetector(
          //               onTap: () {
          //                 setState(() {
          //                   _unitInCm = true;
          //                 });
          //               },
          //               child: Container(
          //                 height: 38,
          //                 width: 94,
          //                 decoration: BoxDecoration(
          //                   // color: palette.selectColor2,
          //                   borderRadius: BorderRadius.circular(25),
          //                   // gradient: _unitInCm
          //                   //     ? LinearGradient(
          //                   //         colors: [
          //                   //           palette.selectColor2,
          //                   //           palette.selectColor3,
          //                   //         ],
          //                   //       )
          //                   //     : null,
          //                 ),
          //                 child: Center(child: Text('cm')),
          //               ),
          //             ),
          //             GestureDetector(
          //               onTap: () {
          //                 setState(() {
          //                   _unitInCm = false;
          //                 });
          //               },
          //               child: Container(
          //                 height: 38,
          //                 width: 94,
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(25),
          //                   // gradient: !_unitInCm
          //                   //     ? LinearGradient(
          //                   //         colors: [
          //                   //           palette.selectColor2,
          //                   //           palette.selectColor3,
          //                   //         ],
          //                   //       )
          //                   //     : null,
          //                 ),
          //                 child: Center(child: Text('ft/in')),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          SizedBox(height: 200, width: 10),
          AnimatedButton(
            onTap: () {
              if (_kgTextController.text.isEmpty) {
                final errorSnackBar = SnackBar(
                  content: Text(
                    'Please fill correctly!',
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
              double weight = double.parse(_kgTextController.text);
              widget.onInput(weight);
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
          SizedBox(height: 10, width: 10),
        ],
      ),
    );
  }
}
