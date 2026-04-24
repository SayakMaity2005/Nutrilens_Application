import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/custom_widget_library/animated_button.dart';

import '../../../cores/custom_datatypes/custom_classes.dart';

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

  final List<Intake> _availableBreakfastIntakes = [
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
    ),
  ];

  final Map<String, List<Intake>> _allIntakes = {
    'breakfast': [],
    'lunch': [],
    'dinner': [],
    'snack': [],
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currIntakeRoundIndex = widget.intakeRoundIndex;
    _tabController = TabController(length: 4, vsync: this);
    _allIntakes['lunch'] = _availableBreakfastIntakes;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
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
                  Tab(text: 'All',),
                  Tab(text: 'Recent',),
                  Tab(text: 'Customize',),
                  Tab(text: 'Starred',),
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
                    ),
                    // Center(child: Text("It's cloudy here")),
                    Center(child: Text("No data yet")),
                    Center(child: Text("No data yet")),
                    Center(child: Text("No data yet")),
                  ],
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

class AllTab extends StatefulWidget {
  final List<Intake> intakes;
  const AllTab({super.key, required this.intakes});

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: [
          for (int i = 0; i < widget.intakes.length; i++)
            Container(
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
                        style: TextStyle(fontSize: 18, color: Color(0xFF333333), fontWeight: FontWeight.w500),
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
                        Container(
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
                        Text('  '),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
