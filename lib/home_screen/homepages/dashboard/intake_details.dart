import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../cores/constants/colors.dart';
import '../../../cores/custom_datatypes/custom_classes.dart';

class IntakeDetails extends StatefulWidget {
  final Intake selectedIntake;
  const IntakeDetails({super.key, required this.selectedIntake});
  @override
  State<IntakeDetails> createState() => _IntakeDetailsState();
}

class _IntakeDetailsState extends State<IntakeDetails> {
  late Intake _selectIntake;
  late Map<String, double> _pieChartDataMap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectIntake = widget.selectedIntake;
    initializePieChart();
  }

  void initializePieChart() {
    double carbs = _selectIntake.carbs();
    double protein = _selectIntake.protein();
    double fat = _selectIntake.fat();
    double total = carbs + protein + fat;
    _pieChartDataMap = {
      'carbs': (carbs * 100) / total,
      'protein': (protein * 100) / total,
      'fat': (fat * 100) / total,
    };
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
            Navigator.pop(context, _selectIntake);
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
          _selectIntake.name(),
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFEEEEEE),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsetsGeometry.all(16),
              padding: EdgeInsetsGeometry.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Column(
                    spacing: 16,
                    children: [
                      PieChart(
                        dataMap: _pieChartDataMap,
                        chartType: ChartType.ring,
                        chartRadius: screenWidth / 2 - 50,
                        colorList: [
                          Color(0xFF31C339),
                          Colors.orange,
                          Colors.amber,
                        ],
                        ringStrokeWidth: 12,
                        initialAngleInDegree: -90,
                        legendOptions: LegendOptions(showLegends: false),
                        chartValuesOptions: ChartValuesOptions(
                          showChartValues: false,
                        ),
                        centerWidget: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectIntake.energy().toStringAsFixed(0),
                              style: AppTextStyle.heading1.copyWith(
                                color: Color(0xFF112249),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'kcal',
                              style: AppTextStyle.heading5.copyWith(
                                color: Color(0xFF112249),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${_selectIntake.quantity().toStringAsFixed(1)}g',
                        style: AppTextStyle.heading6.copyWith(
                          color: Color(0xFF777777),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    spacing: 16,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            margin: EdgeInsetsGeometry.all(5),
                            decoration: BoxDecoration(
                              color: Color(0xFF31C339),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                'Carbs',
                                style: AppTextStyle.primaryBoldText.copyWith(
                                  color: Color(0xFF555555),
                                ),
                              ),
                              Row(
                                spacing: 8,
                                children: [
                                  Text(
                                    '${_selectIntake.carbs().toStringAsFixed(1)}g',
                                    style: AppTextStyle.heading5.copyWith(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsetsGeometry.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEAEAEA),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      '${_pieChartDataMap['carbs']!.toStringAsFixed(1)}%',
                                      style: AppTextStyle.primaryBoldText
                                          .copyWith(color: Color(0xFF555555)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            margin: EdgeInsetsGeometry.all(5),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                'Protein',
                                style: AppTextStyle.primaryBoldText.copyWith(
                                  color: Color(0xFF555555),
                                ),
                              ),
                              Row(
                                spacing: 8,
                                children: [
                                  Text(
                                    '${_selectIntake.protein().toStringAsFixed(1)}g',
                                    style: AppTextStyle.heading5.copyWith(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsetsGeometry.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEAEAEA),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      '${_pieChartDataMap['protein']!.toStringAsFixed(1)}%',
                                      style: AppTextStyle.primaryBoldText
                                          .copyWith(color: Color(0xFF555555)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            margin: EdgeInsetsGeometry.all(5),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              Text(
                                'Fat',
                                style: AppTextStyle.primaryBoldText.copyWith(
                                  color: Color(0xFF555555),
                                ),
                              ),
                              Row(
                                spacing: 8,
                                children: [
                                  Text(
                                    '${_selectIntake.fat().toStringAsFixed(1)}g',
                                    style: AppTextStyle.heading5.copyWith(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsetsGeometry.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEAEAEA),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      '${_pieChartDataMap['fat']!.toStringAsFixed(1)}%',
                                      style: AppTextStyle.primaryBoldText
                                          .copyWith(color: Color(0xFF555555)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Ingredients
            Container(
              width: screenWidth,
              margin: EdgeInsetsGeometry.all(16),
              padding: EdgeInsetsGeometry.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Text('Ingredients', style: AppTextStyle.heading4),
                  SizedBox(height: 10),
                  if (_selectIntake.ingredients().isEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No ingredients mentioned!',
                          style: AppTextStyle.primaryText.copyWith(
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  for (int i = 0; i < _selectIntake.ingredients().length; i++)
                    Text(
                      '${i + 1}. ${_selectIntake.ingredients()[i]}',
                      style: AppTextStyle.primaryText.copyWith(
                        color: Color(0xFF555555),
                      ),
                    ),
                ],
              ),
            ),
            // Recipe
            Container(
              width: screenWidth,
              margin: EdgeInsetsGeometry.all(16),
              padding: EdgeInsetsGeometry.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Text('Recipe', style: AppTextStyle.heading4),
                  SizedBox(height: 10),
                  if (_selectIntake.ingredients().isEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No recipe mentioned!',
                          style: AppTextStyle.primaryText.copyWith(
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  Text(
                    _selectIntake.recipe(),
                    style: AppTextStyle.primaryText.copyWith(
                      color: Color(0xFF555555),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // extendBodyBehindAppBar: true,
  }
}
