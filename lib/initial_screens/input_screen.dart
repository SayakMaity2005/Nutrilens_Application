import 'package:flutter/material.dart';
import 'package:nutrients_tracker/initial_screens/input_data_pages/dob_input.dart';
import 'package:nutrients_tracker/initial_screens/input_data_pages/gender_selection.dart';
import 'package:nutrients_tracker/initial_screens/input_data_pages/height_input.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  late PageController _pageController;
  late int _index;
  final Map<String, dynamic> _inputData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
    _index = 0;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  // Take Action when child GenderSelection page trigger
  void onGenderSelection(String gender) {
    _inputData['gender'] = gender;
    _pageController.animateToPage(
      _index + 1,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  // Take action when child DobInput page trigger
  void onDobInput(DateTime dob) {
    _inputData['dob'] = dob;
    _pageController.animateToPage(
      _index + 1,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  // Take action when child HeightInput page trigger
  void onHeightInput(String height) {
    _inputData['height'] = height; // height along with it's unit concatenated
    _pageController.animateToPage(
      _index + 1,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  // Take action when child WeightInput page trigger
  void onWeightInput(double weight) {
    _inputData['weight'] = weight; // height along with it's unit concatenated
    _pageController.animateToPage(
      _index + 1,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          if (_inputData.length <= _index && index > _index) {
            _pageController.animateToPage(
              _index,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
            return;
          }
          setState(() {
            _index = index;
          });
        },
        controller: _pageController,
        children: [
          GenderSelection(
            inputData: _inputData,
            onSelection: onGenderSelection,
          ),
          DobInput(inputData: _inputData, onInput: onDobInput),
          HeightInput(inputData: _inputData, onInput: onHeightInput),
          GenderSelection(
            inputData: _inputData,
            onSelection: onGenderSelection,
          ),
        ],
      ),
    );
  }
}
