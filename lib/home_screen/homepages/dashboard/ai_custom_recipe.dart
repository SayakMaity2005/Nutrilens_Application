import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/custom_widget_library/animated_button.dart';

class AiCustomRecipe extends StatefulWidget {
  const AiCustomRecipe({super.key});
  @override
  State<StatefulWidget> createState() => _AiCustomRecipeState();
}

class _AiCustomRecipeState extends State<AiCustomRecipe>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animationBlue;
  late Animation<double> _animationGreen;
  late Animation<double> _animationPurple;

  final List<_IntakeRound> _intakeRounds = [
    _IntakeRound(name: 'breakfast', icon: '☕'),
    _IntakeRound(name: 'lunch', icon: '🍛'),
    _IntakeRound(name: 'dinner', icon: '🍲'),
    _IntakeRound(name: 'snack', icon: '🍎'),
  ];
  int _currIntakeRoundIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 16),
    )..repeat(reverse: true);
    _animationBlue = Tween<double>(begin: -100, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc),
    );
    _animationGreen = Tween<double>(begin: -100, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc),
    );
    _animationPurple = Tween<double>(begin: -350, end: -100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();

    super.dispose();
  }

  Widget _intakeRoundSelectionBottomDrawer(double screenWidth) {
    return Container(
      height: 400,
      width: screenWidth,
      padding: EdgeInsets.all(20),
      child: Column(
        spacing: 8,
        children: [
          Text(
            'Select a meal',
            style: AppTextStyle.heading4.copyWith(color: Color(0xFF333333)),
          ),
          SizedBox(height: 20),
          for (int i = 0; i < 4; i++)
            GestureDetector(
              onTap: () {
                setState(() {
                  _currIntakeRoundIndex = i;
                  Navigator.pop(context, true);
                });
              },
              child: Container(
                width: screenWidth,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: BoxBorder.all(
                    width: 2,
                    color: i == _currIntakeRoundIndex
                        ? Color(0xFF1C3678)
                        : Color(0xFFE1E9FF),
                  ),
                ),
                child: Row(
                  spacing: 16,
                  children: [
                    Text(_intakeRounds[i].icon, style: AppTextStyle.heading5),
                    //TextStyle(fontSize: 20),),
                    Text(
                      _intakeRounds[i].name.substring(0, 1).toUpperCase() +
                          _intakeRounds[i].name.substring(1),
                      style: AppTextStyle.heading4.copyWith(
                        color: Color(0xFF444444),
                      ),
                    ),
                    if (i == _currIntakeRoundIndex)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.radio_button_checked,
                              color: Color(0xFF1E6ABF),
                            ),
                          ],
                        ),
                      ),
                    //TextStyle(fontSize: 20),)
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;
    final palette = Theme.of(context).extension<AppPalette>()!;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 16,
            width: 16,
            margin: EdgeInsetsGeometry.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Color(0xFFD9EEFF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 24,
              color: Color(0xFF393939),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('AI recipe', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              // height: 16,
              // width: 16,
              margin: EdgeInsetsGeometry.symmetric(horizontal: 6),
              padding: EdgeInsetsGeometry.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFD9EEFF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: 24,
                color: Color(0xFF393939),
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,

          child: Stack(
            children: [
              // Base dark
              Container(color: Colors.white),

              // Blue glow
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Positioned(
                    top: -100,
                    left: _animationBlue.value,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          stops: [0.7, 1.0],
                          colors: [Color(0xA200C6FF), Colors.transparent],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // green glow
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Positioned(
                    top: -100,
                    right: _animationGreen.value,
                    child: Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          stops: [0.7, 1.0],
                          colors: [Color(0xA200FFD0), Colors.transparent],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Purple glow
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Positioned(
                    bottom: 50,
                    left: _animationPurple.value,
                    child: Container(
                      width: 900,
                      height: 500,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Color(0xB26A5AE0), Colors.transparent],
                        ),
                      ),
                    ),
                    // ),
                  );
                },
              ),

              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: SizedBox(height: screenHeight, width: screenWidth),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Text('Customize Your Recipe', style: AppTextStyle.heading3),
                  SizedBox(
                    width: screenWidth - 100,
                    child: Text(
                      "What's in your fridge? Input your ingredients and generate a custom recipe",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF777777)),
                    ),
                  ),

                  SizedBox(height: 150, width: screenWidth),
                ],
              ),

              Positioned(
                bottom: 0,
                child: Container(
                  height: 350,
                  width: screenWidth,
                  padding: EdgeInsetsGeometry.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, palette.bottomGradient2],
                    ),
                    // color: palette.bottomGradient2,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    spacing: 16,
                    children: [
                      // Stack(
                      //   children: [
                      Container(
                        height: 140,
                        width: screenWidth,
                        padding: EdgeInsetsGeometry.all(1.2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF2190EA), Color(0xFF14D8BB)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          height: 140,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            cursorColor: Color(0xFF435B9A),
                            onTapOutside: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            maxLines: null,
                            decoration: InputDecoration(
                              // filled: true,
                              // fillColor: Colors.white,
                              prefixIcon: Icon(
                                Icons.auto_awesome,
                                color: Color(0xFF00C6FF),
                              ),
                              hintText: 'e.g., mung beans, rice, tomatoes...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth,
                        child: Text(
                          'Recipe Setting',
                          style: TextStyle(
                            color: Color(0xFF777777),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20), // rounded top
                                    ),
                                  ),
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return _intakeRoundSelectionBottomDrawer(
                                          screenWidth,
                                        );
                                      },
                                    );
                                  },
                                );
                              });

                              // setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsetsGeometry.all(6),
                              decoration: BoxDecoration(
                                color: Color(0xFFD4DFE6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                spacing: 4,
                                children: [
                                  Text(
                                    _intakeRounds[_currIntakeRoundIndex].icon,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    _intakeRounds[_currIntakeRoundIndex].name
                                            .substring(0, 1)
                                            .toUpperCase() +
                                        _intakeRounds[_currIntakeRoundIndex]
                                            .name
                                            .substring(1),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text('    '),
                                  Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Color(0xFFAAAAAA),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      AnimatedButton(
                        width: screenWidth,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF0766AA), Color(0xFF064977)],
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onTapScaleFactor: 0.96,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 8,
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.white),
                            Text(
                              'Generate AI Recipes',
                              style: AppTextStyle.heading5.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntakeRound {
  final String name;
  final String icon;
  _IntakeRound({required this.name, required this.icon});
}
