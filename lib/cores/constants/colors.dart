import 'package:flutter/material.dart';

class AppPalette extends ThemeExtension<AppPalette> {
  final Color screenColor;
  final Color selectColor1;
  final Color selectColor2;
  final Color selectColor3;
  final Color selectColor4;
  final Color unselectColor1;
  final Color topGradient1;
  final Color topGradient2;
  final Color midGradient2;
  final Color bottomGradient2;
  final Color errorColor;
  // Text Color
  final Color headingBlueText;

  AppPalette({
    required this.screenColor,
    required this.selectColor1,
    required this.selectColor2,
    required this.selectColor3,
    required this.selectColor4,
    required this.unselectColor1,
    required this.topGradient1,
    required this.topGradient2,
    required this.midGradient2,
    required this.bottomGradient2,
    required this.errorColor,
    // Text Color
    required this.headingBlueText,
  });

  @override
  ThemeExtension<AppPalette> copyWith({
    Color? screenColor,
    Color? selectColor1,
    Color? selectColor2,
    Color? selectColor3,
    Color? selectColor4,
    Color? unselectColor1,
    Color? topGradient1,
    Color? topGradient2,
    Color? midGradient2,
    Color? bottomGradient2,
    Color? errorColor,
    // Text Color
    Color? headingBlueText,
  }) {
    // TODO: implement copyWith
    return AppPalette(
      screenColor: screenColor ?? this.screenColor,
      selectColor1: selectColor1 ?? this.selectColor1,
      selectColor2: selectColor2 ?? this.selectColor2,
      selectColor3: selectColor3 ?? this.selectColor3,
      selectColor4: selectColor4 ?? this.selectColor4,
      unselectColor1: unselectColor1 ?? this.unselectColor1,
      topGradient1: topGradient1 ?? this.topGradient1,
      topGradient2: topGradient2 ?? this.topGradient2,
      midGradient2: midGradient2 ?? this.midGradient2,
      bottomGradient2: bottomGradient2 ?? this.bottomGradient2,
      errorColor: errorColor ?? this.errorColor,
      // Text Color
      headingBlueText: headingBlueText ?? this.headingBlueText,
    );
  }

  @override
  ThemeExtension<AppPalette> lerp(
    covariant ThemeExtension<AppPalette>? other,
    double t,
  ) {
    // TODO: implement lerp
    if (other is! AppPalette) return this;
    return AppPalette(
      screenColor: Color.lerp(screenColor, other.screenColor, t)!,
      selectColor1: Color.lerp(selectColor1, other.selectColor1, t)!,
      selectColor2: Color.lerp(selectColor2, other.selectColor2, t)!,
      selectColor3: Color.lerp(selectColor3, other.selectColor3, t)!,
      selectColor4: Color.lerp(selectColor4, other.selectColor4, t)!,
      unselectColor1: Color.lerp(unselectColor1, other.unselectColor1, t)!,
      topGradient1: Color.lerp(topGradient1, other.topGradient1, t)!,
      topGradient2: Color.lerp(topGradient2, other.topGradient2, t)!,
      midGradient2: Color.lerp(midGradient2, other.midGradient2, t)!,
      bottomGradient2: Color.lerp(bottomGradient2, other.bottomGradient2, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      // Text Color
      headingBlueText: Color.lerp(headingBlueText, other.headingBlueText, t)!,
    );
  }
}

class ThemePalette {
  static final AppPalette lightPalette = AppPalette(
    screenColor: Color(0xFFFFFFFF),
    selectColor1: Colors.deepOrange,
    selectColor2: Colors.green,
    selectColor3: Colors.teal,
    selectColor4: Color(0xFFBCC8E6),
    unselectColor1: Color(0xFFD8D8D8),
    topGradient1: Colors.orangeAccent,
    topGradient2: Colors.teal.shade200,
    midGradient2: Color(0xFFF3FCFF),
    bottomGradient2: Color(0xFFE0F8FF),
    errorColor: Color(0xFFC54242),
    // Text Color
    headingBlueText: Color(0xFF052532),
  );
  static final AppPalette darkPalette = AppPalette(
    screenColor: Color(0xFF000000),
    selectColor1: Colors.deepOrangeAccent,
    selectColor2: Color(0xFF006A2C),
    selectColor3: Colors.teal.shade600,
    selectColor4: Color(0xFF9CB0E8),
    unselectColor1: Color(0xFF202020),
    topGradient1: Color(0xFF613700),
    topGradient2: Color(0xFF003933),
    midGradient2: Color(0xFF20333C),
    bottomGradient2: Color(0xFF123545),
    errorColor: Color(0xFFE46E79),
    // Text Color
    headingBlueText: Color(0xFF78B5CD),
  );
}
