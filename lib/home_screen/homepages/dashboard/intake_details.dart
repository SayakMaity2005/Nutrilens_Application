import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';

import '../../../cores/constants/colors.dart';
import '../../../cores/custom_datatypes/custom_classes.dart';
import '../../../cores/daily_data/daily_data_services.dart';
import '../../home_screen.dart' as nutrilens_test_home;

class IntakeDetails extends StatefulWidget {
  final Intake selectedIntake;
  final bool showRecipeAndIngredients;

  const IntakeDetails({
    super.key, 
    required this.selectedIntake,
    this.showRecipeAndIngredients = false,
  });
  @override
  State<IntakeDetails> createState() => _IntakeDetailsState();
}

class _IntakeDetailsState extends State<IntakeDetails> {
  late Intake _selectIntake;
  
  double _carbsPercentage = 0.0;
  double _proteinPercentage = 0.0;
  double _fatPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _selectIntake = widget.selectedIntake;
    _calculatePercentages();
  }

  void _calculatePercentages() {
    double carbs = _selectIntake.carbs();
    double protein = _selectIntake.protein();
    double fat = _selectIntake.fat();
    double total = carbs + protein + fat;

    if (total > 0) {
      _carbsPercentage = carbs / total;
      _proteinPercentage = protein / total;
      _fatPercentage = fat / total;
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(
          msg,
          style: AppTextStyle.primaryText.copyWith(color: const Color(0xFF000000)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8), // Premium very light grey
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context, _selectIntake),
          child: Container(
            height: 16,
            width: 16,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: const BoxDecoration(
              color: Color(0xFFEBF8FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
              color: Color(0xFF393939),
            ),
          ),
        ),
        title: const Text(
          'Food Details',
          style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Header
            Text(
              _selectIntake.name(),
              style: AppTextStyle.heading2.copyWith(
                color: const Color(0xFF0F172A),
                fontWeight: FontWeight.w900,
                fontSize: 32,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            if (_selectIntake.type() != null && _selectIntake.type()!.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Text(
                  _selectIntake.type()!.toUpperCase(),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            
            const SizedBox(height: 24),

            // Calories & Quantity Card
            Container(
              width: screenWidth,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Calories',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _selectIntake.energy().toStringAsFixed(0),
                            style: const TextStyle(
                              color: Color(0xFF1E293B),
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(
                              'kcal',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(width: 1, height: 60, color: Colors.grey.shade200),
                  Column(
                    children: [
                      Text(
                        'Portion',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _selectIntake.quantity().toStringAsFixed(0),
                            style: const TextStyle(
                              color: Color(0xFF1E293B),
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text(
                              'g',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Macronutrients Bar Charts
            const Text(
              "Macronutrients",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                  _buildMacroBar(
                    label: "Carbs",
                    amount: _selectIntake.carbs(),
                    percentage: _carbsPercentage,
                    color: const Color(0xFF10B981), // Emerald Green
                  ),
                  const SizedBox(height: 24),
                  _buildMacroBar(
                    label: "Protein",
                    amount: _selectIntake.protein(),
                    percentage: _proteinPercentage,
                    color: const Color(0xFFF59E0B), // Amber
                  ),
                  const SizedBox(height: 24),
                  _buildMacroBar(
                    label: "Fat",
                    amount: _selectIntake.fat(),
                    percentage: _fatPercentage,
                    color: const Color(0xFFEF4444), // Red/Orange
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            
            // Optional: Ingredients and Recipe for Custom Recipes
            if (widget.showRecipeAndIngredients && _selectIntake.ingredients().isNotEmpty) ...[
              const Text(
                "Ingredients",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: screenWidth,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_selectIntake.ingredients().length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• ", style: TextStyle(color: Color(0xFF64748B), fontSize: 16, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(
                              _selectIntake.ingredients()[i],
                              style: const TextStyle(
                                color: Color(0xFF334155),
                                fontSize: 16,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (widget.showRecipeAndIngredients && _selectIntake.recipe().isNotEmpty) ...[
              const Text(
                "Recipe",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: screenWidth,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Text(
                  _selectIntake.recipe(),
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            const SizedBox(height: 120), // space for FAB
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: screenWidth - 40,
        height: 56,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ]
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            // Show loading
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );

            // Determine meal type by time
            final hour = DateTime.now().hour;
            String computedMealType = "lunch";
            if (hour < 11) {
              computedMealType = "breakfast";
            } else if (hour < 16) {
              computedMealType = "lunch";
            } else if (hour < 19) {
              computedMealType = "snacks";
            } else {
              computedMealType = "dinner";
            }

            // Prepare payload
            final mealData = {
              "meal_type": computedMealType,
              "consumed_intakes": [
                {
                  "name": _selectIntake.name(),
                  "type": _selectIntake.type(),
                  "energy_per_unit": _selectIntake.energyPerUnit(),
                  "quantity": _selectIntake.quantity(),
                  "carbs_per_unit": _selectIntake.carbsPerUnit(),
                  "protein_per_unit": _selectIntake.proteinPerUnit(),
                  "fat_per_unit": _selectIntake.fatPerUnit(),
                },
              ],
            };

            // Send to backend
            final response = await DailyDataServices().addMeal(mealData);

            // Close loading
            if (mounted) Navigator.pop(context);

            if (response['status_ok']) {
              if (!mounted) return;
              _showSnackBar('Added to your Meal!');

              // Force the app to restart at HomeScreen so Dashboard refreshes its data!
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const nutrilens_test_home.HomeScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            } else {
              if (mounted) _showSnackBar('Error: ${response['message']}');
            }
          },
          label: const Text(
            'Log this Meal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
          icon: const Icon(Icons.check_circle_outline, size: 24),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue.shade600,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _buildMacroBar({
    required String label,
    required double amount,
    required double percentage,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFF334155),
              ),
            ),
            Row(
              children: [
                Text(
                  '${amount.toStringAsFixed(1)}g',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${(percentage * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            // Background track
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            // Filled bar (animated for premium feel)
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: percentage.isNaN ? 0 : percentage),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return FractionallySizedBox(
                  widthFactor: value.clamp(0.0, 1.0),
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
