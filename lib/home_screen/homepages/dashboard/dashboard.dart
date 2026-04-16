import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
// import 'package:nutrilens_test/home_screen/homepages/dashboard/ai_custom_recipe.dart'
//     hide IntakeRound;
// import 'package:nutrilens_test/home_screen/homepages/dashboard/intake_select.dart' hide IntakeRound;

import '../../../cores/custom_datatypes/custom_classes.dart';
import 'ai_custom_recipe.dart';
import 'intake_select.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late PageController _datePageController;
  final List<String> _dayList = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  final List<String> _monthList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  int _todayPageIndex = 0;
  DateTime _selectedDate = DateTime.now();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  final Map<String, IntakeRound> _intakeRounds = {
    'breakfast': IntakeRound(icon: '☕', type: 'Breakfast', requiredEnergy: 620),
    'lunch': IntakeRound(icon: '🍛', type: 'Lunch', requiredEnergy: 870),
    'dinner': IntakeRound(icon: '🍲', type: 'Dinner', requiredEnergy: 517),
    'snack': IntakeRound(icon: '🍎', type: 'Snack', requiredEnergy: 103),
  };

  final Map<String, int> _requiredIntake = {
    'carbs': 259,
    'protein': 155,
    'fat': 46,
    'energy': 620 + 870 + 517 + 103,
  };
  final Map<String, int> _consumedIntake = {
    'carbs': 0,
    'protein': 0,
    'fat': 0,
    'energy': 0,
  };
  final Map<String, int> _consumedIntermediateIntake = {
    'carbs': 0,
    'protein': 0,
    'fat': 0,
    'energy': 0,
  };

  final WorkoutRound _workoutRound = WorkoutRound();
  int _energyBurned = 0;
  int _energyBurnedIntermediate = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createWeekList();
    _datePageController = PageController(initialPage: _todayPageIndex);
    _intakeRounds['breakfast']?.consumeIntake(
      Intake(
        name: 'Navy Beans, raw',
        type: 'food',
        unit: 'g',
        quantity: 200,
        energyPerUnit: 0.5,
        carbsPerUnit: 0.055,
        proteinPerUnit: 0.013,
        fatPerUnit: 0.027,
        ingredients: [],
      ),
    );
    updateConsumptionRecords();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _datePageController.dispose();
    _dayList.clear();
    _monthList.clear();
    super.dispose();
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void createWeekList() {
    DateTime now = DateTime.now();
    // int currMonth = now.month;
    DateTime currMonthFirstDay = DateTime(now.year, now.month, 1);
    int weekDayOfFirstDay = currMonthFirstDay.weekday % 7;
    DateTime currMonthLastDay = DateTime(
      now.year,
      now.month + 1,
      0,
    ); // this will give current mont last date
    int weekDayOfLastDay = currMonthLastDay.weekday % 7;
    int leftExtendedWeekDay = weekDayOfFirstDay - 0;
    int rightExtendedWeekDay = 6 - weekDayOfLastDay;
    DateTime startDate = currMonthFirstDay.subtract(
      Duration(days: leftExtendedWeekDay),
    );
    _startDate = startDate;
    DateTime endDate = currMonthLastDay.add(
      Duration(days: rightExtendedWeekDay),
    );
    _endDate = endDate;

    DateTime tempDate = startDate;
    int index = 0;
    while (endDate.difference(tempDate).inDays > 0) {
      for (int i = 0; i < 7; i++) {
        if (isSameDate(tempDate.add(Duration(days: i)), now)) {
          _todayPageIndex = index;
          break;
        }
      }
      index++;
      tempDate = tempDate.add(Duration(days: 7));
    }
  }

  void updateConsumptionRecords() {
    double totalConsumedCarbs = 0;
    double totalConsumedProtein = 0;
    double totalConsumedFat = 0;
    double totalConsumedEnergy = 0;
    _intakeRounds.forEach((key, value) {
      totalConsumedCarbs += value.getConsumedCarbs();
      totalConsumedProtein += value.getConsumedProtein();
      totalConsumedFat += value.getConsumedFat();
      totalConsumedEnergy += value.getConsumedEnergy();
    });
    _consumedIntermediateIntake['carbs'] = totalConsumedCarbs.toInt();
    _consumedIntermediateIntake['protein'] = totalConsumedProtein.toInt();
    _consumedIntermediateIntake['fat'] = totalConsumedFat.toInt();
    _consumedIntermediateIntake['energy'] = totalConsumedEnergy.toInt();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final palette = Theme.of(context).extension<AppPalette>()!;

    // TODO: implement build
    return Container(
      height: screenHeight - 110,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              child: Container(
                margin: EdgeInsetsGeometry.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        isSameDate(_selectedDate, DateTime.now())
                            ? 'Today'
                            : '${_dayList[_selectedDate.weekday % 7]}, ${_monthList[_selectedDate.month - 1]} ${_selectedDate.day}',
                        style: AppTextStyle.primaryText.copyWith(
                          color: Color(0xFF888888),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 32,
                        color: Color(0xFF999999),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 8),

            // Date Cards
            SizedBox(
              height: 70,
              width: screenWidth - 10,
              child: PageView(
                controller: _datePageController,
                children: [
                  // Container(
                  //   child:
                  for (
                    DateTime tempDate = _startDate;
                    _endDate.difference(tempDate).inDays > 0;
                    tempDate = tempDate.add(Duration(days: 7))
                  )
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 4,
                      children: [
                        for (int i = 0; i < 7; i++)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = tempDate.add(Duration(days: i));
                              });
                            },
                            child: Container(
                              height: 64,
                              width: 52,
                              decoration: BoxDecoration(
                                color:
                                    isSameDate(
                                      tempDate.add(Duration(days: i)),
                                      _selectedDate,
                                    )
                                    ? Colors.blue.shade700
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    isSameDate(
                                      tempDate.add(Duration(days: i)),
                                      _selectedDate,
                                    )
                                    ? null
                                    : BoxBorder.all(
                                        color:
                                            isSameDate(
                                              tempDate.add(Duration(days: i)),
                                              DateTime.now(),
                                            )
                                            ? Colors.blue.shade700
                                            : Color(0xFFBBBBBB),
                                        width:
                                            isSameDate(
                                              tempDate.add(Duration(days: i)),
                                              DateTime.now(),
                                            )
                                            ? 2
                                            : 1,
                                      ),
                              ),
                              // padding: EdgeInsets.only(top: 4),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 4,
                                  children: [
                                    Text(
                                      _dayList[i][0],
                                      style: AppTextStyle.primaryText.copyWith(
                                        color:
                                            isSameDate(
                                              tempDate.add(Duration(days: i)),
                                              _selectedDate,
                                            )
                                            ? Color(0xFFCCCCCC)
                                            : Color(0xFF999999),
                                      ),
                                    ),
                                    Text(
                                      '${tempDate.add(Duration(days: i)).day}',
                                      style: AppTextStyle.heading5.copyWith(
                                        color:
                                            isSameDate(
                                              tempDate.add(Duration(days: i)),
                                              _selectedDate,
                                            )
                                            ? Colors.white
                                            : Color(0xFF3C3C3C),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                      // ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 28),

            // Daily budget Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: screenWidth - 230,
              children: [
                Text('Daily budget', style: AppTextStyle.heading3),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    spacing: 4,
                    children: [
                      Icon(Icons.edit_note, size: 18, color: Color(0xFF555555)),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsetsGeometry.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  // Energy
                  Container(
                    height: (screenWidth - 40) * 0.6,
                    width: (screenWidth - 40) * 0.5,
                    decoration: BoxDecoration(
                      color: palette.screenColor,
                      borderRadius: BorderRadius.circular(16),
                      border: BoxBorder.all(color: Color(0xFFE1E9FF), width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin:
                                    _consumedIntake['energy']! /
                                    _requiredIntake['energy']!,
                                end:
                                    _consumedIntermediateIntake['energy']! /
                                    _requiredIntake['energy']!,
                              ),
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOutCubic,
                              onEnd: () {
                                setState(() {
                                  _consumedIntake['energy'] =
                                      _consumedIntermediateIntake['energy']!;
                                });
                              },
                              builder: (context, value, child) {
                                return CircularProgressIndicator(
                                  constraints: BoxConstraints(
                                    minHeight: (screenWidth - 40) * 0.37,
                                    minWidth: (screenWidth - 40) * 0.37,
                                  ),
                                  strokeWidth: 8,
                                  strokeCap: StrokeCap.round,
                                  value: value,
                                  backgroundColor: Color(0xFFDDDDDD),
                                  color: Color(0xFF237FCA),
                                );
                              },
                            ),
                            Container(
                              height: (screenWidth - 40) * 0.32,
                              width: (screenWidth - 40) * 0.32,
                              decoration: BoxDecoration(
                                color: Color(0xFF92C5FF),
                                borderRadius: BorderRadius.circular(
                                  (screenWidth - 40) * 0.34,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Remaining',
                                    style: TextStyle(color: Color(0xFF666666)),
                                  ),
                                  TweenAnimationBuilder<double>(
                                    tween: Tween<double>(
                                      begin: _consumedIntake['energy']!
                                          .toDouble(),
                                      end:
                                          _consumedIntermediateIntake['energy']!
                                              .toDouble(),
                                    ),
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return Text(
                                        (_requiredIntake['energy']! - value)
                                            .toStringAsFixed(0),
                                        style: AppTextStyle.heading1.copyWith(
                                          color: Color(0xFF081227),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      );
                                    },
                                  ),
                                  // Text(
                                  //   (_requiredIntake['energy']! -
                                  //           _consumedIntake['energy']!)
                                  //       .toString(),
                                  //   style: AppTextStyle.heading1.copyWith(
                                  //     color: Color(0xFF081227),
                                  //     fontWeight: FontWeight.w800,
                                  //   ),
                                  // ),
                                  Text(
                                    'kcal',
                                    style: TextStyle(
                                      color: Color(0xFF081227),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Goal ${_requiredIntake['energy']} kcal',
                          style: TextStyle(color: Color(0xFF666666)),
                        ),
                      ],
                    ),
                  ),
                  // Nutrients
                  Column(
                    spacing:
                        1.5 *
                        ((screenWidth - 40) * 0.2 - (screenWidth - 40) * 0.185),
                    children: [
                      for (int i = 0; i < 3; i++)
                        Container(
                          height: (screenWidth - 40) * 0.185,
                          width: (screenWidth - 40) * 0.5,
                          decoration: BoxDecoration(
                            color: palette.screenColor,
                            borderRadius: BorderRadius.circular(20),
                            border: BoxBorder.all(
                              color: Color(0xFFE1E9FF),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 28,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        TweenAnimationBuilder<double>(
                                          tween: Tween<double>(
                                            begin: _consumedIntake.entries
                                                .elementAt(i)
                                                .value
                                                .toDouble(),
                                            end: _consumedIntermediateIntake
                                                .entries
                                                .elementAt(i)
                                                .value
                                                .toDouble(),
                                          ),
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeOutCubic,
                                          builder: (context, value, child) {
                                            return Text(
                                              value.toStringAsFixed(0),
                                              style: AppTextStyle.heading5
                                                  .copyWith(
                                                    color: Color(0xFF3C3C3C),
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            );
                                          },
                                        ),
                                        Text(
                                          ' / ${_requiredIntake.entries.elementAt(i).value}g',
                                          style: TextStyle(
                                            color: Color(0xFF888888),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      _requiredIntake.entries
                                              .elementAt(i)
                                              .key[0]
                                              .toUpperCase() +
                                          _requiredIntake.entries
                                              .elementAt(i)
                                              .key
                                              .substring(1),
                                      style: TextStyle(
                                        color: Color(0xFF555555),
                                      ),
                                    ),
                                  ],
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    TweenAnimationBuilder<double>(
                                      tween: Tween<double>(
                                        begin:
                                            _consumedIntake.entries
                                                .elementAt(i)
                                                .value /
                                            _requiredIntake.entries
                                                .elementAt(i)
                                                .value,
                                        end:
                                            _consumedIntermediateIntake.entries
                                                .elementAt(i)
                                                .value /
                                            _requiredIntake.entries
                                                .elementAt(i)
                                                .value,
                                      ),
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeOutCubic,
                                      onEnd: () {
                                        // setState(() {
                                        final key = _consumedIntake.entries
                                            .elementAt(i)
                                            .key;
                                        _consumedIntake[key] =
                                            _consumedIntermediateIntake[key]!;
                                        // });
                                      },
                                      builder: (context, value, child) {
                                        return CircularProgressIndicator(
                                          constraints: BoxConstraints(
                                            minWidth: 40,
                                            minHeight: 40,
                                          ),
                                          backgroundColor: Color(0xFFDDDDDD),
                                          color:
                                              (_requiredIntake.entries
                                                      .elementAt(i)
                                                      .key ==
                                                  'carbs')
                                              ? Color(0xFF4AD851)
                                              : (_requiredIntake.entries
                                                        .elementAt(i)
                                                        .key ==
                                                    'protein')
                                              ? Colors.orangeAccent
                                              : Colors.amberAccent,
                                          value: value,
                                          // _consumedIntake.entries
                                          //     .elementAt(i)
                                          //     .value /
                                          // _requiredIntake.entries
                                          //     .elementAt(i)
                                          //     .value,
                                          strokeCap: StrokeCap.round,
                                        );
                                      },
                                    ),
                                    if (_requiredIntake.entries
                                            .elementAt(i)
                                            .key ==
                                        'carbs')
                                      Text('🍞'),
                                    if (_requiredIntake.entries
                                            .elementAt(i)
                                            .key ==
                                        'protein')
                                      Text('🥚'),
                                    if (_requiredIntake.entries
                                            .elementAt(i)
                                            .key ==
                                        'fat')
                                      Text('🧀'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Customize Recipe
            Stack(
              children: [
                Container(
                  height: 120,
                  width: screenWidth,
                  margin: EdgeInsetsGeometry.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/recipe_bg_image.jpg'),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  height: 120,
                  width: screenWidth,
                  margin: EdgeInsetsGeometry.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      // stops: [0.0, 0.2, 0.6, 1],
                      colors: [
                        Color(0x807FF1C0),
                        Color(0x99DDF7FA),
                        Color(0xFFDAF9FD),
                        // Color(0xCC72F8F8),
                        Color(0xFF9AEFFF),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customize Your Recipe',
                        style: AppTextStyle.heading5,
                      ),
                      Text(
                        'Input ingredients and generate a custom recipe',
                        style: TextStyle(color: Color(0xFF555555)),
                      ),
                      GestureDetector(
                        onTap: () {
                          // setState(() {
                          //   // _consumedIntermediateIntake['energy'] =
                          //   //     _consumedIntermediateIntake['energy']! + 400;
                          //
                          // });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AiCustomRecipe(),
                            ),
                          );
                        },
                        child: Container(
                          // height: 20,
                          width: 164,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFF17233C),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.7, 1.0],
                              colors: [Color(0xFF17233C), Color(0xFF7C899F)],
                            ),
                          ),
                          padding: EdgeInsetsGeometry.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          margin: EdgeInsetsGeometry.only(top: 8),
                          child: Row(
                            spacing: 4,
                            children: [
                              Text(
                                'Check it out',
                                style: AppTextStyle.heading6.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_double_arrow_right_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: screenWidth - 232,
              children: [
                Text('Intake', style: AppTextStyle.heading3),
                SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 8,
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 20,
                        color: Color(0xFF4D8EEA),
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: _consumedIntake['energy']!.toDouble(),
                          end: _consumedIntermediateIntake['energy']!
                              .toDouble(),
                        ),
                        duration: Duration(milliseconds: 500),
                        builder: (context, value, child) {
                          return Text(
                            '${value.toStringAsFixed(0)} kcal',
                            style: AppTextStyle.heading5,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            for (int i = 0; i < 4; i++)
              Container(
                // height: 70,
                width: screenWidth,
                margin: EdgeInsetsGeometry.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                padding: EdgeInsetsGeometry.symmetric(
                  // horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: BoxBorder.all(color: Color(0xFFE1E9FF), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16,
                  children: [
                    Text(
                      _intakeRounds.entries.elementAt(i).value.getIcon(),
                      style: AppTextStyle.heading2,
                    ),
                    SizedBox(
                      width: 110,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _intakeRounds.entries.elementAt(i).value.getType(),
                            style: AppTextStyle.heading4,
                          ),
                          Row(
                            children: [
                              Text(
                                _intakeRounds.entries
                                    .elementAt(i)
                                    .value
                                    .getConsumedEnergy()
                                    .toStringAsFixed(0),
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                ' / ${_intakeRounds.entries.elementAt(i).value.getRequiredEnergy().toStringAsFixed(0)} kcal',
                                style: TextStyle(
                                  color: Color(0xFF888888),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: screenWidth - 310),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IntakeSelect(),
                          ),
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFFDFF1FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Icon(Icons.add, color: Color(0xFF1457A5)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: screenWidth - 244,
              children: [
                Text('Burned', style: AppTextStyle.heading3),
                SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 8,
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 20,
                        color: Color(0xFFFBAC50),
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: _energyBurned.toDouble(),
                          end: _energyBurnedIntermediate.toDouble(),
                        ),
                        duration: Duration(milliseconds: 500),
                        onEnd: () {
                          setState(() {
                            _energyBurned = _workoutRound.totalEnergyBurned();
                          });
                        },
                        builder: (context, value, child) {
                          return Text(
                            '${value.toStringAsFixed(0)} kcal',
                            style: AppTextStyle.heading5,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              // height: 120,
              width: screenWidth,
              margin: EdgeInsetsGeometry.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFD6EBF6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8,
                children: [
                  Text(
                    "You haven't uploaded any workout",
                    style: AppTextStyle.heading5,
                  ),
                  Text(
                    'You can search in our database',
                    style: TextStyle(color: Color(0xFF555555)),
                  ),
                  Container(
                    margin: EdgeInsetsGeometry.symmetric(vertical: 6),
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: screenWidth / 2 - 100,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF17233C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '+  Add workout',
                      style: AppTextStyle.heading6.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}

//
// class IntakeRound {
//   late final String _icon;
//   late final String _type;
//   late final int _requiredEnergy;
//   late int _consumedEnergy;
//   late double _consumedCarbs;
//   late double _consumedProtein;
//   late double _consumedFat;
//   late int _intakeCount;
//   late final List<Intake> _consumedIntakes;
//   IntakeRound({
//     required String icon,
//     required String type,
//     required int requiredEnergy,
//   }) {
//     _icon = icon;
//     _type = type;
//     _requiredEnergy = requiredEnergy;
//     _consumedEnergy = 0;
//     _consumedCarbs = 0;
//     _consumedProtein = 0;
//     _consumedFat = 0;
//     _intakeCount = 0;
//     _consumedIntakes = [];
//   }
//   void consumeEnergy(int amount) {
//     _consumedEnergy += amount;
//   }
//
//   void reduceConsumption(int amount) {
//     _consumedEnergy -= amount;
//   }
//
//   void consumeIntake(Intake intake) {
//     _consumedIntakes.add(intake);
//     _consumedEnergy += intake.energy();
//     _consumedCarbs += intake.carbs();
//     _consumedProtein += intake.protein();
//     _consumedFat += intake.fat();
//     _intakeCount++;
//   }
//
//   String getIcon() => _icon;
//   String getType() => _type;
//   int getRequiredEnergy() => _requiredEnergy;
//   int getConsumedEnergy() => _consumedEnergy;
//   double getConsumedCarbs() => _consumedCarbs;
//   double getConsumedProtein() => _consumedProtein;
//   double getConsumedFat() => _consumedFat;
//   int intakeCount() => _intakeCount;
// }
//
// class Intake {
//   late final String _name;
//   late final String _type; // food / drinks
//   late final String _unit; // g, L, mL, ...
//   late double _quantity;
//   late final double _energyPerUnit;
//   late final double _carbsPerUnit;
//   late final double _proteinPerUnit;
//   late final double _fatPerUnit;
//   late final List<String> _ingredients;
//   Intake({
//     required String name,
//     required String type,
//     required String unit,
//     required double quantity,
//     required double energyPerUnit,
//     required double carbsPerUnit,
//     required double proteinPerUnit,
//     required double fatPerUnit,
//     required List<String> ingredients,
//   }) {
//     _name = name;
//     _type = type;
//     _unit = unit;
//     _quantity = quantity;
//     _energyPerUnit = energyPerUnit;
//     _carbsPerUnit = carbsPerUnit;
//     _proteinPerUnit = proteinPerUnit;
//     _fatPerUnit = fatPerUnit;
//     _ingredients = ingredients;
//   }
//   String name() => _name;
//   String type() => _type;
//   String unit() => _unit;
//   double quantity() => _quantity;
//   int energy() => (_energyPerUnit * _quantity).toInt();
//   double carbs() => _carbsPerUnit * _quantity;
//   double protein() => _proteinPerUnit * _quantity;
//   double fat() => _fatPerUnit * _quantity;
//   List<String> ingredients() => _ingredients;
// }
//
// class WorkoutRound {
//   late final int _totalEnergyBurned;
//   late final int _workoutCount;
//   late final List<Workout> _completedWorkouts;
//   WorkoutRound() {
//     _totalEnergyBurned = 0;
//     _workoutCount = 0;
//     _completedWorkouts = [];
//   }
//
//   void addWorkout(Workout workout) {
//     _completedWorkouts.add(workout);
//     _totalEnergyBurned += workout.energyBurned();
//     _workoutCount++;
//   }
//   void removeWorkout(int index) {
//     _totalEnergyBurned -= _completedWorkouts[index].energyBurned();
//     _completedWorkouts.removeAt(index);
//     _workoutCount++;
//   }
//
//   int totalEnergyBurned() => _totalEnergyBurned;
//   int workoutCount() => _workoutCount;
// }
//
// class Workout {
//   late final String _name;
//   late final String _type;
//   late final String _explanation;
//   late final double _energyBurnPerMinute;
//   late final int _timeInMinute;
//   Workout({
//     required name,
//     required type,
//     required explanation,
//     required energyBurnPerMinute,
//     required timeInMinute,
//   }) {
//     _name = name;
//     _type = type;
//     _explanation = explanation;
//     _energyBurnPerMinute = energyBurnPerMinute;
//     _timeInMinute = timeInMinute;
//   }
//   String name() => _name;
//   String type() => _type;
//   String explanation() => _explanation;
//   int energyBurned() => (_energyBurnPerMinute * _timeInMinute).round();
//   int timeInMinute() => _timeInMinute;
// }
