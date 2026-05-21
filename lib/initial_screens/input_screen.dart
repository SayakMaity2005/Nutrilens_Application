import 'package:flutter/material.dart';
import 'package:nutrilens_test/initial_screens/input_data_pages/dob_input.dart';
import 'package:nutrilens_test/initial_screens/input_data_pages/gender_selection.dart';
import 'package:nutrilens_test/initial_screens/input_data_pages/height_input.dart';
import 'package:nutrilens_test/initial_screens/input_data_pages/weight_input.dart';
import 'package:nutrilens_test/profile_screen/authentication.dart';
import 'package:nutrilens_test/home_screen/home_screen.dart';

import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';

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
  void onWeightInput(double weight) async {
    _inputData['weight'] = weight;
    
    // Final step: navigate to Authentication screen for account creation
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Authentication(
          initialIsSignIn: false,
          initialInputData: _inputData,
        ),
      ),
    );

    if (result == true) {
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final palette = Theme.of(context).extension<AppPalette>()!;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Authentication(initialIsSignIn: true),
                  ),
                );
                if (result == true) {
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                }
              },
              child: Text(
                "Sign In",
                style: AppTextStyle.heading5.copyWith(color: palette.selectColor1),
              ),
            ),
          ),
        ],
      ),
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
          WeightInput(
            inputData: _inputData,
            onInput: onWeightInput,
          ),
        ],
      ),
    );
  }
}
