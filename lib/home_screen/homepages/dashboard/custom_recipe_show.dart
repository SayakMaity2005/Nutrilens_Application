import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/ai_usage/custom_recipe.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/home_screen/homepages/dashboard/intake_details.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../cores/constants/colors.dart';
import '../../../cores/custom_datatypes/custom_classes.dart';

class CustomRecipeShow extends StatefulWidget {
  final List<Intake> customRecipeList;
  const CustomRecipeShow({super.key, required this.customRecipeList});
  @override
  State<CustomRecipeShow> createState() => _CustomRecipeShowState();
}

class _CustomRecipeShowState extends State<CustomRecipeShow> {
  late List<Intake> _customRecipeList;
  late Map<String, double> _pieChartDataMap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _customRecipeList = widget.customRecipeList;
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 40),
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 14),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(
          msg,
          style: AppTextStyle.primaryText.copyWith(color: Color(0xFF000000)),
        ),
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
              color: Color(0xFFEBF8FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 24,
              color: Color(0xFF393939),
            ),
          ),
        ),

        title: Text(
          // _selectIntake.name(),
          'Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFEEEEEE),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: [
            // Container(
            //   margin: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
            //   child: Text(_selectIntake.name(), style: AppTextStyle.heading4,),
            // ),
            SizedBox(height: 20),

            for (int i = 0; i < _customRecipeList.length; i++)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return IntakeDetails(
                          selectedIntake: _customRecipeList[i],
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsetsGeometry.symmetric(horizontal: 20),
                  padding: EdgeInsetsGeometry.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: BoxBorder.all(color: Color(0xFFBBBBBB)),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: screenWidth - 130,
                            child: Text(
                              _customRecipeList[i].name(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.heading5.copyWith(
                                color: Color(0xFF333333),
                              ),
                            ),
                          ),
                          Text(
                            '${_customRecipeList[i].energy()} kcal, ${_customRecipeList[i].quantity()} g',
                            style: AppTextStyle.primaryBoldText.copyWith(
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final response = await CustomRecipe()
                                    .deleteRecipe(_customRecipeList[i].id());

                                _showSnackBar(response['message']);

                                if(response['status_ok']) {
                                  setState(() {
                                    _customRecipeList.removeAt(i);
                                    if (_customRecipeList.isEmpty) {
                                      // _showSelectedIntakes = false;
                                    }
                                  });
                                }
                              },
                              child: Container(
                                padding: EdgeInsetsGeometry.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.cancel_outlined,
                                  color: Color(0xFFFF9898),
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
          ],
        ),
      ),
    );
    // extendBodyBehindAppBar: true,
  }
}
