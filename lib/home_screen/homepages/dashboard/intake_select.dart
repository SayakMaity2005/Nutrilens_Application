import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/custom_widget_library/animated_button.dart';
import 'package:nutrilens_test/home_screen/homepages/dashboard/select_intake_popup.dart';

import '../../../cores/custom_datatypes/custom_classes.dart';
import 'intake_details.dart';

class IntakeSelect extends StatefulWidget {
  final int intakeRoundIndex;
  const IntakeSelect({super.key, required this.intakeRoundIndex});
  @override
  State<StatefulWidget> createState() => _IntakeSelectState();
}

class _IntakeSelectState extends State<IntakeSelect>
    with SingleTickerProviderStateMixin {
  final List<_IntakeRound> _intakeRounds = [
    _IntakeRound(name: 'breakfast', icon: '☕'),
    _IntakeRound(name: 'lunch', icon: '🍛'),
    _IntakeRound(name: 'dinner', icon: '🍲'),
    _IntakeRound(name: 'snack', icon: '🍎'),
  ];
  int _currIntakeRoundIndex = 1;

  late final TabController _tabController;

  final List<Intake> _availableLunchIntakes = [
    Intake(
      name: 'Nesfit Diet Cereal',
      type: 'food',
      unit: 'g',
      quantity: 100,
      energyPerUnit: 1.88,
      carbsPerUnit: 0.362,
      proteinPerUnit: 0.069,
      fatPerUnit: 0.00,
      ingredients: [],
      recipe: '',
    ),
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
      recipe: '',
    ),
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
      recipe: '',
    ),
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
      recipe: '',
    ),
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
      recipe: '',
    ),
    Intake(
      name: 'Rice Dal Vegetables',
      type: 'food',
      unit: 'g',
      quantity: 450,
      energyPerUnit: 0.95,
      carbsPerUnit: 0.15,
      proteinPerUnit: 0.035,
      fatPerUnit: 0.02,
      ingredients: [
        'Rice',
        'Dal',
        'Raw vegetables like Potato, tomato,...',
        'Oil, Ginger, Turmeric powder, salt',
        'Cumin',
      ],
      recipe: 'Bla bla bla ......',
    ),
  ];

  final Map<String, List<Intake>> _allIntakes = {
    'breakfast': [],
    'lunch': [],
    'dinner': [],
    'snack': [],
  };

  final List<Intake> _selectedIntakes = [];

  bool _showSelectedIntakes = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currIntakeRoundIndex = widget.intakeRoundIndex;
    _tabController = TabController(length: 4, vsync: this);
    _allIntakes['lunch'] = _availableLunchIntakes;
    _showSelectedIntakes = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  int _totalEnergy() {
    int sum = 0;
    for (int i = 0; i < _selectedIntakes.length; i++) {
      sum += _selectedIntakes[i].energy();
    }
    return sum;
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
                  Navigator.pop(context);
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
            Navigator.pop(context, true);
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        // title: Text('AI recipe', style: TextStyle(fontWeight: FontWeight.w600)),
        title: GestureDetector(
          onTap: () async {
            final response = await showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20), // rounded top
                ),
              ),
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return _intakeRoundSelectionBottomDrawer(screenWidth);
                  },
                );
              },
            );
            if (response != null) {
              setState(() {});
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _intakeRounds[_currIntakeRoundIndex].name
                    .substring(0, 1)
                    .toUpperCase() +
                    _intakeRounds[_currIntakeRoundIndex].name.substring(1),
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Icon(Icons.arrow_drop_down_rounded, size: 40),
            ],
          ),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              SizedBox(height: 110),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  SizedBox(
                    width: screenWidth - 100,
                    child: TextField(
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsetsGeometry.all(10),
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(50),
                        //   borderSide: BorderSide(
                        //     color: Color(0xFFDDDDDD),
                        //     width: 1,
                        //   ),
                        // ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
                            color: Color(0xFFCCCCCC),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
                            color: Color(0xFF2D5ACD),
                            width: 1,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Color(0xFFAAAAAA),
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsGeometry.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1576D6),
                    ),
                    child: Icon(Icons.camera_alt_rounded, color: Colors.white),
                  ),
                ],
              ),

              SizedBox(height: 20),

              TabBar(
                controller: _tabController,
                indicatorColor: Color(0xFF1576D6),
                labelColor: Color(0xFF1576D6),
                labelStyle: TextStyle(fontWeight: FontWeight.w500),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 3.0, color: Color(0xFF1576D6)),
                  borderRadius: BorderRadius.circular(2),
                  // insets: EdgeInsets.symmetric(horizontal: 16),
                ),
                unselectedLabelColor: Color(0xFF777777),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
                dividerColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,

                tabs: const <Widget>[
                  Tab(text: 'All'),
                  Tab(text: 'Recent'),
                  Tab(text: 'Customize'),
                  Tab(text: 'Starred'),
                  // Tab(icon: Icon(Icons.cloud_outlined),text: 'All',),
                  // Tab(icon: Icon(Icons.beach_access_sharp)),
                  // Tab(icon: Icon(Icons.brightness_5_sharp)),
                  // Tab(icon: Icon(Icons.motion_photos_on_outlined)),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    AllTab(
                      intakes:
                      _allIntakes[_intakeRounds[_currIntakeRoundIndex]
                          .name]!,
                      selectedIntakes: _selectedIntakes,
                    ),
                    // Center(child: Text("It's cloudy here")),
                    Center(child: Text("No item yet!")),
                    Center(child: Text("No item yet!")),
                    Center(child: Text("No item yet!")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        height: _showSelectedIntakes ? screenHeight / 2 - 80 : 140,
        width: screenWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: _showSelectedIntakes
                  ? Color(0xFFAAAAAA)
                  : Color(0xFFDDDDDD),
              spreadRadius: _showSelectedIntakes ? 20.0 : 1.0,
              blurRadius: _showSelectedIntakes ? 30 : 10,
            ),
          ],
        ),
        padding: EdgeInsetsGeometry.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(
              '${_intakeRounds[_currIntakeRoundIndex].icon} ${_intakeRounds[_currIntakeRoundIndex].name.substring(0, 1).toUpperCase() + _intakeRounds[_currIntakeRoundIndex].name.substring(1)}',
              style: AppTextStyle.heading4,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              height: _showSelectedIntakes ? screenHeight / 2 - 224 : 0,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  children: [
                    for (int i = 0; i < _selectedIntakes.length; i++)
                      Container(
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
                                Text(
                                  _selectedIntakes[i].name(),
                                  style: AppTextStyle.heading5.copyWith(
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                Text(
                                  '${_selectedIntakes[i].energy()} kcal, ${_selectedIntakes[i].quantity()} g',
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
                                    onTap: () {
                                      setState(() {
                                        _selectedIntakes.removeAt(i);
                                      });
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
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Text.rich(
                  TextSpan(
                    text: _selectedIntakes.length.toString(),
                    style: AppTextStyle.heading4,
                    children: [
                      TextSpan(
                        text: ' Added | ',
                        style: AppTextStyle.primaryText.copyWith(
                          color: Color(0xFF777777),
                        ),
                      ),
                      TextSpan(
                        text: _totalEnergy().toString(),
                        style: AppTextStyle.heading4,
                      ),
                      TextSpan(
                        text: ' kcal',
                        style: AppTextStyle.primaryText.copyWith(
                          color: Color(0xFF777777),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_selectedIntakes.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showSelectedIntakes = _showSelectedIntakes
                            ? false
                            : true;
                      });
                    },
                    child: Icon(
                      _showSelectedIntakes
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                      size: 42,
                      color: Color(0xFF777777),
                    ),
                  ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedButton(
                        width: screenWidth / 4,
                        decoration: BoxDecoration(
                          color: Color(0xFF375EC5),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onTap: () {
                          Navigator.pop(context, {
                            _intakeRounds[_currIntakeRoundIndex].name:
                            _selectedIntakes,
                          });
                        },
                        child: Center(
                          child: Text(
                            'Done',
                            style: AppTextStyle.heading5.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
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

class AllTab extends StatefulWidget {
  final List<Intake> intakes;
  final List<Intake> selectedIntakes;
  const AllTab({
    super.key,
    required this.intakes,
    required this.selectedIntakes,
  });

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late List<Intake> _selectedIntakes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIntakes = widget.selectedIntakes;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: [
          for (int i = 0; i < widget.intakes.length; i++)
            GestureDetector(
              onTap: () async {
                Intake selectedIntake = widget.intakes[i];
                final res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return IntakeDetails(selectedIntake: selectedIntake);
                    },
                  ),
                );
                if (res != null) {
                  setState(() {
                    _selectedIntakes.add(res);
                  });
                }
              },
              child: Container(
                // height: 50,
                width: screenWidth,
                margin: EdgeInsetsGeometry.symmetric(horizontal: 16),
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFE7EBEF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        Text(
                          widget.intakes[i].name(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${widget.intakes[i].energy()} kcal, ${widget.intakes[i].quantity()} ${widget.intakes[i].unit()}',
                          style: AppTextStyle.smallBoldText.copyWith(
                            color: Color(0xFF777777),
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
                              Intake selectedIntake = widget.intakes[i].copyWith();
                              final res = await showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20), // rounded top
                                  ),
                                ),
                                showDragHandle: true,
                                isScrollControlled: true,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return SelectIntakePopup(
                                        selectedIntake: selectedIntake,
                                      );
                                    },
                                  );
                                },
                              );
                              if (res != null) {
                                setState(() {
                                  _selectedIntakes.add(res);
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsetsGeometry.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF102047),
                              ),
                              child: Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          Text('  '),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
