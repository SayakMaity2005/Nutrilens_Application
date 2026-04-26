import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/custom_widget_library/animated_button.dart';

class WaterDetails extends StatefulWidget {
  final int requiredWater;
  final int waterCupSize;
  const WaterDetails({
    super.key,
    required this.requiredWater,
    required this.waterCupSize,
  });
  @override
  State<WaterDetails> createState() => _WaterDetailsState();
}

class _WaterDetailsState extends State<WaterDetails> {
  late int _requiredWater;
  late int _waterCupSize;

  late TextEditingController _requiredWaterTextEditingController;
  late TextEditingController _waterCupSizeTextEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requiredWater = widget.requiredWater;
    _waterCupSize = widget.waterCupSize;

    _requiredWaterTextEditingController = TextEditingController(
      text: _requiredWater.toString(),
    );
    _waterCupSizeTextEditingController = TextEditingController(
      text: _waterCupSize.toString(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _requiredWaterTextEditingController.dispose();
    _waterCupSizeTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // final screenHeight = size.height;
    // final screenWidth = size.width;
    // TODO: implement build
    return LayoutBuilder(
      builder: (context, constrains) {
        final sheetWidth = constrains.maxWidth;
        return SizedBox(
          width: sheetWidth,
          child: Wrap(
            alignment: WrapAlignment.center,
            // spacing: 14,
            children: [
              Text('Water details', style: AppTextStyle.heading4),
              Container(
                margin: EdgeInsetsGeometry.all(16),
                padding: EdgeInsetsGeometry.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Text('Goal', style: AppTextStyle.heading4),

                    TextField(
                      controller: _requiredWaterTextEditingController,
                      style: AppTextStyle.heading3.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      autofocus: true,
                      maxLength: 4,
                      decoration: InputDecoration(
                        suffix: Text(
                          'ml',
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
                  ],
                ),
              ),

              Container(
                margin: EdgeInsetsGeometry.all(16),
                padding: EdgeInsetsGeometry.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Text('Cup size', style: AppTextStyle.heading4),

                    TextField(
                      controller: _waterCupSizeTextEditingController,
                      style: AppTextStyle.heading3.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      autofocus: true,
                      maxLength: 4,
                      decoration: InputDecoration(
                        suffix: Text(
                          'ml',
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
                  ],
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
                  Navigator.pop(context, {
                    'goal': _requiredWaterTextEditingController.text,
                    'cup': _waterCupSizeTextEditingController.text,
                  });
                },
                child: Center(
                  child: Text(
                    'Save',
                    style: AppTextStyle.heading5.copyWith(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20, width: sheetWidth),
            ],
          ),
        );
      },
    );
  }
}
