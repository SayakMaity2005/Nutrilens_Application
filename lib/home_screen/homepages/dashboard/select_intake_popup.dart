import 'package:flutter/material.dart';

import '../../../cores/constants/text_styles.dart';
import '../../../cores/custom_datatypes/custom_classes.dart';
import '../../../custom_widget_library/animated_button.dart';

class SelectIntakePopup extends StatefulWidget {
  final Intake selectedIntake;
  const SelectIntakePopup({super.key, required this.selectedIntake});

  @override
  State<SelectIntakePopup> createState() => _SelectIntakePopupState();
}

class _SelectIntakePopupState extends State<SelectIntakePopup> {
  late Intake _selectedIntake;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIntake = widget.selectedIntake;
    _textEditingController = TextEditingController(
      text: _selectedIntake.quantity().toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        final sheetWidth = constrains.maxWidth;
        return SizedBox(
          width: sheetWidth,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              Text(_selectedIntake.name(), style: AppTextStyle.heading4),
              Container(
                padding: EdgeInsetsGeometry.all(16),
                child: Column(
                  spacing: 16,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Container(
                          width: sheetWidth/4-20,
                          padding: EdgeInsetsGeometry.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFFD2E8F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            spacing: 4,
                            children: [
                              Text('Calorie'),
                              Text(
                                '${_selectedIntake.energy().toStringAsFixed(0)}kcal',
                                style: AppTextStyle.heading6.copyWith(
                                  color: Color(0xFF444444),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: sheetWidth/4-20,
                          padding: EdgeInsetsGeometry.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFFD7FDD8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            spacing: 4,
                            children: [
                              Text('Carbs'),
                              Text(
                                '${_selectedIntake.carbs().toStringAsFixed(1)}g',
                                style: AppTextStyle.heading6.copyWith(
                                  color: Color(0xFF444444),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: sheetWidth/4-20,
                          padding: EdgeInsetsGeometry.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFFFDE2CF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            spacing: 4,
                            children: [
                              Text('Protein'),
                              Text(
                                '${_selectedIntake.protein().toStringAsFixed(0)}g',
                                style: AppTextStyle.heading6.copyWith(
                                  color: Color(0xFF444444),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: sheetWidth/4-20,
                          padding: EdgeInsetsGeometry.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFFFBEFCF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            spacing: 4,
                            children: [
                              Text('Fat'),
                              Text(
                                '${_selectedIntake.fat().toStringAsFixed(0)}g',
                                style: AppTextStyle.heading6.copyWith(
                                  color: Color(0xFF444444),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 80),
                      child: TextField(
                        controller: _textEditingController,
                        style: AppTextStyle.heading2.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                        autofocus: true,
                        keyboardType: TextInputType.numberWithOptions(
                          signed: false,
                          decimal: true
                        ),
                        maxLength: 5,
                        decoration: InputDecoration(
                          suffix: Text(
                            'g',
                            style: AppTextStyle.heading4.copyWith(
                              color: Color(0xFF555555),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Color(0xFF0D35B5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Color(0xFFBBBBBB)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Color(0x98ED0F0F)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Color(0x98ED0F0F)),
                          ),
                        ),
                      ),
                    ),
                    AnimatedButton(
                      width: sheetWidth - 32,
                      decoration: BoxDecoration(
                        color: Color(0xFF375EC5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onTapScaleFactor: 0.96,
                      onTap: () {
                        double quantity = double.parse(_textEditingController.text);
                        _selectedIntake.setQuantity(quantity);
                        Navigator.pop(context, _selectedIntake);
                      },
                      child: Center(
                        child: Text(
                          'Save to meal',
                          style: AppTextStyle.heading5.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20, width: sheetWidth)
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
