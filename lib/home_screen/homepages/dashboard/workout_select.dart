import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';

class WorkoutSelect extends StatefulWidget {
  final int intakeRoundIndex;
  const WorkoutSelect({super.key, required this.intakeRoundIndex});
  @override
  State<StatefulWidget> createState() => _WorkoutSelectState();
}

class _WorkoutSelectState extends State<WorkoutSelect>
    with SingleTickerProviderStateMixin {

  final List<Workout> _allWorkouts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDefaultData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  bool _allItemsLoading = true;

  Future<void> getDefaultData() async {
    if (_allWorkouts.isEmpty) {
      _allItemsLoading = true;
      //   backend call
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        // title: Text('AI recipe', style: TextStyle(fontWeight: FontWeight.w600)),
        title:
        Text(
          'Select workout',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: SingleChildScrollView(
        child: Column(
        spacing: 10,
        children: [
          for (int i = 0; i < _allWorkouts.length; i++)

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
                      SizedBox(
                        width: screenWidth - 136,
                        child: Text(
                          _allWorkouts[i].name(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Add other attributes
                    ],
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Workout selectedWorkout = _allWorkouts[i];
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
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery
                                            .of(
                                          context,
                                        )
                                            .viewInsets
                                            .bottom,
                                      ),
                                      // child:
                                    //   Add a popup
                                    );
                                  },
                                );
                              },
                            );
                            if (res != null) {
                              setState(() {
                                // add in backend
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
        ],
      ),
    ),)
    ,
    );
  }
}

class Workout {

  late final String _name;
  late final double? _duration;
  late final int? _count;
  late final double _energy;

  Workout({
    required String name,
    double? duration,
    int? count,
    required double energy,
  }) {
    _name = name;
    _duration = duration;
    _count = count;
    _energy = energy;
  }

  String name() => _name;
  double? duration() => _duration;
  int? count() => _count;
  double energy() => _energy;
}
