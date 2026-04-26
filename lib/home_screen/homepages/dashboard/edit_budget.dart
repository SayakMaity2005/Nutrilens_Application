import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/custom_widget_library/animated_button.dart';

class EditBudget extends StatefulWidget {
  final Map<String, int> requiredIntake;
  const EditBudget({super.key, required this.requiredIntake});
  @override
  State<EditBudget> createState() => _EditBudgetState();
}

class _EditBudgetState extends State<EditBudget> {
  late Map<String, int> _requiredIntake;
  final Map<String, int> _energyPerUnit = {'carbs': 4, 'protein': 4, 'fat': 9};
  late Map<String, double> _energyPercentage;
  late RangeValues _nutrientsRanges;

  late TextEditingController _textEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requiredIntake = widget.requiredIntake;
    _energyPercentage = {
      'carbs':
          (100 * _requiredIntake['carbs']! * _energyPerUnit['carbs']!) /
          _requiredIntake['energy']!,
      'protein':
          (100 * _requiredIntake['protein']! * _energyPerUnit['protein']!) /
          _requiredIntake['energy']!,
      'fat':
          (100 * _requiredIntake['fat']! * _energyPerUnit['fat']!) /
          _requiredIntake['energy']!,
    };

    _nutrientsRanges = RangeValues(
      _energyPercentage['carbs']! / 100,
      (_energyPercentage['protein']! + _energyPercentage['carbs']!) / 100,
    );

    _textEditingController = TextEditingController(
      text: _requiredIntake['energy']!.toString(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController.dispose();
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
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              // spacing: 14,
              children: [
                Text('Edit budget', style: AppTextStyle.heading4),
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
                      Text('Daily budget', style: AppTextStyle.heading4),
                      Container(
                        width: sheetWidth,
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          spacing: 4,
                          children: [
                            Text(
                              _requiredIntake['energy'].toString(),
                              style: AppTextStyle.heading2.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'kcal',
                              style: AppTextStyle.heading4.copyWith(
                                color: Color(0xFF777777),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final res = await showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(
                                              20,
                                            ), // rounded top
                                          ),
                                        ),
                                        showDragHandle: true,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (context, setState) {
                                              return LayoutBuilder(
                                                builder: (context, constrains) {
                                                  final subSheetWidth =
                                                      constrains.maxWidth;
                                                  return SizedBox(
                                                    width: subSheetWidth,
                                                    child: Wrap(
                                                      alignment:
                                                          WrapAlignment.center,
                                                      spacing: 20,
                                                      runSpacing: 20,
                                                      children: [
                                                        Text(
                                                          'Customize',
                                                          style: AppTextStyle
                                                              .heading4,
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsetsGeometry.symmetric(
                                                                horizontal: 80,
                                                              ),
                                                          child: TextField(
                                                            controller:
                                                                _textEditingController,
                                                            style: AppTextStyle
                                                                .heading2
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                ),
                                                            autofocus: true,
                                                            maxLength: 5,
                                                            decoration: InputDecoration(
                                                              suffix: Text(
                                                                'kcal',
                                                                style: AppTextStyle
                                                                    .heading4
                                                                    .copyWith(
                                                                      color: Color(
                                                                        0xFF555555,
                                                                      ),
                                                                    ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      16,
                                                                    ),
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Color(
                                                                        0xFF0D35B5,
                                                                      ),
                                                                    ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      16,
                                                                    ),
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Color(
                                                                        0xFFBBBBBB,
                                                                      ),
                                                                    ),
                                                              ),
                                                              errorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      16,
                                                                    ),
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Color(
                                                                        0x98ED0F0F,
                                                                      ),
                                                                    ),
                                                              ),
                                                              focusedErrorBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      16,
                                                                    ),
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Color(
                                                                        0x98ED0F0F,
                                                                      ),
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text.rich(
                                                          TextSpan(
                                                            text:
                                                                'The recommended range is from ',
                                                            style: AppTextStyle
                                                                .primaryText
                                                                .copyWith(
                                                                  color: Color(
                                                                    0xFF555555,
                                                                  ),
                                                                ),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    '1000 to 4000 kcal.',
                                                                style: AppTextStyle
                                                                    .primaryText
                                                                    .copyWith(
                                                                      color: Colors
                                                                          .blueAccent
                                                                          .shade700,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        AnimatedButton(
                                                          width:
                                                              sheetWidth - 32,
                                                          decoration: BoxDecoration(
                                                            color: Color(
                                                              0xFF375EC5,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  30,
                                                                ),
                                                          ),
                                                          onTapScaleFactor:
                                                              0.96,
                                                          onTap: () {
                                                            Navigator.pop(
                                                              context,
                                                              true,
                                                            );
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              'Save',
                                                              style: AppTextStyle
                                                                  .heading5
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                          width: subSheetWidth,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                      if (res != null) {
                                        setState(() {
                                          _requiredIntake['energy'] = int.parse(
                                            _textEditingController.text,
                                          );
                                          _requiredIntake['carbs'] =
                                              ((_requiredIntake['energy']! *
                                                          _energyPercentage['carbs']!) /
                                                      (100 *
                                                          _energyPerUnit['carbs']!))
                                                  .round();
                                          _requiredIntake['protein'] =
                                              ((_requiredIntake['energy']! *
                                                          _energyPercentage['protein']!) /
                                                      (100 *
                                                          _energyPerUnit['protein']!))
                                                  .round();
                                          _requiredIntake['fat'] =
                                              ((_requiredIntake['energy']! *
                                                          _energyPercentage['fat']!) /
                                                      (100 *
                                                          _energyPerUnit['fat']!))
                                                  .round();
                                        });
                                      } else {
                                        _textEditingController.value =
                                            TextEditingValue(
                                              text: _requiredIntake['energy']!
                                                  .toString(),
                                            );
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsetsGeometry.all(8),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFEAEAEA),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.edit_outlined,
                                        size: 20,
                                        color: Color(0xFF777777),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'The recommended range is from ',
                          style: AppTextStyle.primaryText.copyWith(
                            color: const Color(0xFF555555),
                          ),
                          children: [
                            TextSpan(
                              text: '1000 to 4000 kcal. ',
                              style: AppTextStyle.primaryText.copyWith(
                                color: Colors.blueAccent.shade700,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Too low a calorie intake may affect health.',
                              style: AppTextStyle.primaryText.copyWith(
                                color: const Color(0xFF555555),
                              ),
                            ),
                          ],
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
                      Text('Nutrition budget', style: AppTextStyle.heading4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          for (int i = 0; i < 3; i++)
                            Container(
                              padding: EdgeInsetsGeometry.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                spacing: 4,
                                children: [
                                  Text(
                                    _requiredIntake.entries
                                            .elementAt(i)
                                            .key
                                            .substring(0, 1)
                                            .toUpperCase() +
                                        _requiredIntake.entries
                                            .elementAt(i)
                                            .key
                                            .substring(1),
                                    style: AppTextStyle.heading6.copyWith(
                                      color: Color(0xFF444444),
                                    ),
                                  ),
                                  Text(
                                    '${_requiredIntake.entries.elementAt(i).value}g',
                                    style: AppTextStyle.heading5.copyWith(
                                      color: Color(0xFF444444),
                                    ),
                                  ),
                                  Container(
                                    width: sheetWidth / 3 - 50,
                                    padding: EdgeInsetsGeometry.symmetric(
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          (_requiredIntake.entries
                                                  .elementAt(i)
                                                  .key ==
                                              'carbs')
                                          ? Color(0xFFD7FDD8)
                                          : (_requiredIntake.entries
                                                    .elementAt(i)
                                                    .key ==
                                                'protein')
                                          ? Color(0xFFFDE2CF)
                                          : Color(0xFFFBEFCF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${_energyPercentage[_energyPercentage.entries.elementAt(i).key]!.toStringAsFixed(0)}%',
                                        style: AppTextStyle.heading4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                        child: RangeSlider(
                          values: _nutrientsRanges,
                          onChanged: (newRange) {
                            setState(() {
                              _nutrientsRanges = newRange;
                              _energyPercentage['carbs'] = newRange.start * 100;
                              _energyPercentage['protein'] =
                                  (newRange.end - newRange.start) * 100;
                              _energyPercentage['fat'] =
                                  (1 - newRange.end) * 100;
                              _requiredIntake['carbs'] =
                                  ((_requiredIntake['energy']! *
                                              _energyPercentage['carbs']!) /
                                          (100 * _energyPerUnit['carbs']!))
                                      .round();
                              _requiredIntake['protein'] =
                                  ((_requiredIntake['energy']! *
                                              _energyPercentage['protein']!) /
                                          (100 * _energyPerUnit['protein']!))
                                      .round();
                              _requiredIntake['fat'] =
                                  ((_requiredIntake['energy']! *
                                              _energyPercentage['fat']!) /
                                          (100 * _energyPerUnit['fat']!))
                                      .round();
                            });
                          },
                          activeColor: Color(0xFFEDA741),
                          inactiveColor: Color(0xFF31B837),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Drag the progress bar to modify ratio',
                            style: TextStyle(color: Color(0xFF777777)),
                          ),
                        ],
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
                    Navigator.pop(context, true);
                  },
                  child: Center(
                    child: Text(
                      'Save',
                      style: AppTextStyle.heading5.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20, width: sheetWidth),
              ],
            ),
          ),
        );
      },
    );
  }
}
