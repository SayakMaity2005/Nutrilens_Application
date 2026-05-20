import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/cores/dietician/dietician_services.dart';

class ClientProgressPage extends StatefulWidget {
  final String clientId;
  final String clientName;

  const ClientProgressPage({
    super.key,
    required this.clientId,
    required this.clientName,
  });

  @override
  State<ClientProgressPage> createState() => _ClientProgressPageState();
}

class _ClientProgressPageState extends State<ClientProgressPage> {
  Map<String, dynamic>? _progressData;
  bool _isLoading = true;
  late DateTime _selectedDate;
  int _selectedTabIndex = 0; // 0: Overview, 1: Meals, 2: Diversity

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() => _isLoading = true);
    final dateStr =
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
    final data = await DieticianServices().getClientProgress(widget.clientId, dateStr);
    setState(() {
      _progressData = data;
      _isLoading = false;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      _loadProgress();
    }
  }

  List<dynamic> _getMealIntakes(String mealType) {
    if (_progressData == null) return [];
    final meals = _progressData!["meals"];
    if (meals == null) return [];
    final meal = meals[mealType];
    if (meal == null) return [];
    return meal["consumed_intakes"] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      appBar: AppBar(
        title: GestureDetector(
          onTap: _pickDate,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Daily Insight",
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1E293B)),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4F8FB),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      _buildCalorieGoalCard(screenWidth),
                      const SizedBox(height: 20),
                      _buildTabSelector(),
                      const SizedBox(height: 20),
                      if (_selectedTabIndex == 0) _buildHeartHealthCard(),
                      if (_selectedTabIndex == 1) _buildMealsChartCard(),
                      if (_selectedTabIndex == 2) _buildDiversityCard(),
                      if (_selectedTabIndex == 3) _buildMacrosPieChart(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: _buildAnalyzeButton(),
                ),
              ],
            ),
    );
  }

  Widget _buildCalorieGoalCard(double screenWidth) {
    double totalEnergy = 0, totalCarbs = 0, totalProtein = 0, totalFat = 0;
    
    final targets = _progressData?["daily_target"] ?? {};
    double targetEnergy = (targets["energy"] ?? 2000).toDouble();
    double targetCarbs = (targets["carbs"] ?? 250).toDouble();
    double targetProtein = (targets["protein"] ?? 150).toDouble();
    double targetFat = (targets["fat"] ?? 44).toDouble();

    for (final mealType in ["breakfast", "lunch", "dinner", "snacks"]) {
      for (final intake in _getMealIntakes(mealType)) {
        double qty = (intake["quantity"] ?? 0).toDouble();
        totalEnergy += (intake["energy_per_unit"] ?? 0).toDouble() * qty;
        totalCarbs += (intake["carbs_per_unit"] ?? 0).toDouble() * qty;
        totalProtein += (intake["protein_per_unit"] ?? 0).toDouble() * qty;
        totalFat += (intake["fat_per_unit"] ?? 0).toDouble() * qty;
      }
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.blue, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    "Calorie goal",
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
                onPressed: () => _showEditTargetsDialog(targetEnergy, targetCarbs, targetProtein, targetFat),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                totalEnergy.toStringAsFixed(0),
                style: GoogleFonts.nunito(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF0F172A),
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
                child: Text(
                  " / ${targetEnergy.toStringAsFixed(0)}kcal",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: targetEnergy > 0 ? (totalEnergy / targetEnergy).clamp(0.0, 1.0) : 0,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMacroBar("Carbs", totalCarbs, targetCarbs, Colors.green),
              _buildMacroBar("Protein", totalProtein, targetProtein, Colors.orange),
              _buildMacroBar("Fat", totalFat, targetFat, Colors.amber),
            ],
          ),
          const SizedBox(height: 24),
          _buildAdviceCard(),
        ],
      ),
    );
  }

  Widget _buildMacroBar(String title, double value, double target, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width - 90) / 3,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          _CustomDotProgressBar(value: value, target: target, color: color),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${value.toStringAsFixed(0)} ",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13),
                ),
                TextSpan(
                  text: "/ ${target.toStringAsFixed(0)}g",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF7DD3FC).withOpacity(0.5)),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF7DD3FC),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Advice for today",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Great job on hitting your protein target!",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "• Consider keeping your fat intake lower today.\n"
                    "• You've got a little calorie buffer remaining.\n"
                    "• Don't forget to hydrate!",
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Container(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: GestureDetector(
                  onTap: () => _showNudgeDialog(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5EEAD4), Color(0xFF38BDF8)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.send, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text("Send Nudge", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditTargetsDialog(double currentEnergy, double currentCarbs, double currentProtein, double currentFat) async {
    final energyCtrl = TextEditingController(text: currentEnergy.toStringAsFixed(0));
    final carbsCtrl = TextEditingController(text: currentCarbs.toStringAsFixed(0));
    final proteinCtrl = TextEditingController(text: currentProtein.toStringAsFixed(0));
    final fatCtrl = TextEditingController(text: currentFat.toStringAsFixed(0));

    bool isUpdating = false;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text("Edit Daily Targets", style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTargetField("Energy (kcal)", energyCtrl),
                    const SizedBox(height: 10),
                    _buildTargetField("Carbs (g)", carbsCtrl),
                    const SizedBox(height: 10),
                    _buildTargetField("Protein (g)", proteinCtrl),
                    const SizedBox(height: 10),
                    _buildTargetField("Fat (g)", fatCtrl),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: isUpdating ? null : () async {
                    setDialogState(() => isUpdating = true);
                    final newTargets = {
                      "energy": double.tryParse(energyCtrl.text) ?? currentEnergy,
                      "carbs": double.tryParse(carbsCtrl.text) ?? currentCarbs,
                      "protein": double.tryParse(proteinCtrl.text) ?? currentProtein,
                      "fat": double.tryParse(fatCtrl.text) ?? currentFat,
                    };

                    final res = await DieticianServices().updateClientTargets(widget.clientId, newTargets);
                    setDialogState(() => isUpdating = false);
                    if (res['status_ok'] == true) {
                      Navigator.pop(context);
                      _loadProgress(); // Reload data to show updated targets
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Targets updated successfully!")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Failed to update')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isUpdating ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          }
        );
      },
    );
  }

  Future<void> _showNudgeDialog() async {
    final msgCtrl = TextEditingController();
    bool isSending = false;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text("Send a Nudge", style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: TextField(
                  controller: msgCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Type your message here...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: isSending ? null : () async {
                    if (msgCtrl.text.trim().isEmpty) return;
                    setDialogState(() => isSending = true);
                    final res = await DieticianServices().sendNudge(widget.clientId, msgCtrl.text.trim());
                    setDialogState(() => isSending = false);
                    if (res['status_ok'] == true) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nudge sent!")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Failed to send')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isSending ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text("Send", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          }
        );
      },
    );
  }

  Widget _buildTargetField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Row(
      children: [
        _buildTabButton("Heart", 0),
        const SizedBox(width: 6),
        _buildTabButton("Meals", 1),
        const SizedBox(width: 6),
        _buildTabButton("Diversity", 2),
        const SizedBox(width: 6),
        _buildTabButton("Macros", 3),
      ],
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFD0E3F5) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: Colors.blue, width: 1.5) : null,
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.blue.shade700 : Colors.grey.shade500,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeartHealthCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("🫀", style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    "Heart Health",
                    style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: const Color(0xFF1E293B)),
                  ),
                ],
              ),
              const Icon(Icons.help_outline, color: Colors.grey, size: 20),
            ],
          ),
          const SizedBox(height: 24),
          _buildGradientBar("Saturated Fat", 0.0, 20.0, "g", [const Color(0xFF86EFAC), const Color(0xFFFBBF24), const Color(0xFFF87171)]),
          const SizedBox(height: 20),
          _buildGradientBar("Sodium", 0.0, 2300.0, "mg", [const Color(0xFF86EFAC), const Color(0xFFFBBF24), const Color(0xFFF87171)]),
          const SizedBox(height: 20),
          _buildGradientBar("Cholesterol", 0.0, 300.0, "mg", [const Color(0xFF86EFAC), const Color(0xFFFBBF24), const Color(0xFFF87171)]),
        ],
      ),
    );
  }

  Widget _buildGradientBar(String label, double value, double target, String unit, List<Color> colors) {
    final progress = (value / target).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569), fontSize: 16)),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${value.toStringAsFixed(1)}",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                  ),
                  TextSpan(
                    text: "/${target.toStringAsFixed(1)}$unit",
                    style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Positioned(
              left: (MediaQuery.of(context).size.width - 72) * progress - 8,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMealsChartCard() {
    double breakfastEnergy = 0, lunchEnergy = 0, dinnerEnergy = 0, snackEnergy = 0;
    for (final intake in _getMealIntakes("breakfast")) breakfastEnergy += (intake["energy_per_unit"] ?? 0) * (intake["quantity"] ?? 0);
    for (final intake in _getMealIntakes("lunch")) lunchEnergy += (intake["energy_per_unit"] ?? 0) * (intake["quantity"] ?? 0);
    for (final intake in _getMealIntakes("dinner")) dinnerEnergy += (intake["energy_per_unit"] ?? 0) * (intake["quantity"] ?? 0);
    for (final intake in _getMealIntakes("snacks")) snackEnergy += (intake["energy_per_unit"] ?? 0) * (intake["quantity"] ?? 0);

    final targetTotal = (_progressData?["daily_target"]?["energy"] ?? 2000).toDouble();
    final targets = [targetTotal * 0.3, targetTotal * 0.4, targetTotal * 0.25, targetTotal * 0.05];
    final values = [breakfastEnergy, lunchEnergy, dinnerEnergy, snackEnergy];
    
    double maxVal = 700;
    for (var v in [...targets, ...values]) {
      if (v > maxVal) maxVal = v;
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("🍽️", style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text("Meals", style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: const Color(0xFF1E293B))),
                ],
              ),
              Row(
                children: [
                  _buildLegendItem("Intake", Colors.blue.shade700),
                  const SizedBox(width: 12),
                  _buildLegendItem("Goal", const Color(0xFFBAE6FD)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMealBarPair("Breakfast", values[0], targets[0], maxVal, "🌅"),
                _buildMealBarPair("Lunch", values[1], targets[1], maxVal, "☀️"),
                _buildMealBarPair("Dinner", values[2], targets[2], maxVal, "🌙"),
                _buildMealBarPair("Snack", values[3], targets[3], maxVal, "🍎"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMealBarPair(String label, double intake, double goal, double maxVal, String icon) {
    final intakeHeight = (intake / maxVal) * 120;
    final goalHeight = (goal / maxVal) * 120;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                Text(intake.toStringAsFixed(0), style: TextStyle(fontSize: 10, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  width: 16,
                  height: intakeHeight,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 2),
            Column(
              children: [
                const SizedBox(height: 14),
                Container(
                  width: 16,
                  height: goalHeight,
                  decoration: const BoxDecoration(
                    color: Color(0xFFBAE6FD),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(height: 1, width: 60, color: Colors.grey.shade300),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(icon, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildDiversityCard() {
    double totalCarbs = 0, totalProtein = 0, totalFat = 0;
    
    for (final mealType in ["breakfast", "lunch", "dinner", "snacks"]) {
      for (final intake in _getMealIntakes(mealType)) {
        double qty = (intake["quantity"] ?? 0).toDouble();
        totalCarbs += (intake["carbs_per_unit"] ?? 0).toDouble() * qty;
        totalProtein += (intake["protein_per_unit"] ?? 0).toDouble() * qty;
        totalFat += (intake["fat_per_unit"] ?? 0).toDouble() * qty;
      }
    }

    double totalMacros = totalCarbs + totalProtein + totalFat;
    if (totalMacros == 0) totalMacros = 1; // avoid division by zero

    // Proxies for diversity based on macros to make it dynamic with real data
    double grainsFrac = (totalCarbs * 0.6) / totalMacros;
    double vegFrac = (totalCarbs * 0.2) / totalMacros;
    double fruitsFrac = (totalCarbs * 0.2) / totalMacros;
    double proteinFrac = (totalProtein * 0.8) / totalMacros;
    double dairyFrac = ((totalProtein * 0.2) + (totalFat * 0.2)) / totalMacros;
    double fatsFrac = (totalFat * 0.8) / totalMacros;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("🥗", style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text("Diversity", style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: const Color(0xFF1E293B))),
            ],
          ),
          const SizedBox(height: 24),
          _buildDiversityRow("Grains", grainsFrac),
          _buildDiversityRow("Vegetables", vegFrac),
          _buildDiversityRow("Fruits", fruitsFrac),
          _buildDiversityRow("Protein", proteinFrac),
          _buildDiversityRow("Dairy", dairyFrac),
          _buildDiversityRow("Healthy Fats", fatsFrac),
        ],
      ),
    );
  }

  Widget _buildDiversityRow(String label, double fraction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Container(
                  height: 12,
                  width: (MediaQuery.of(context).size.width - 150) * fraction,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF38BDF8), Color(0xFF7DD3FC)]),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF38BDF8).withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 2)),
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

  Widget _buildAnalyzeButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF3B82F6)]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: const Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              "Analyze your diet",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacrosPieChart() {
    double totalCarbs = 0, totalProtein = 0, totalFat = 0;
    
    for (final mealType in ["breakfast", "lunch", "dinner", "snacks"]) {
      for (final intake in _getMealIntakes(mealType)) {
        double qty = (intake["quantity"] ?? 0).toDouble();
        totalCarbs += (intake["carbs_per_unit"] ?? 0).toDouble() * qty;
        totalProtein += (intake["protein_per_unit"] ?? 0).toDouble() * qty;
        totalFat += (intake["fat_per_unit"] ?? 0).toDouble() * qty;
      }
    }

    // Ensure we have some data to show, otherwise pie chart throws error
    if (totalCarbs == 0 && totalProtein == 0 && totalFat == 0) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(40),
        child: const Center(
          child: Text("No macro data logged yet", style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    Map<String, double> dataMap = {
      "Carbs": totalCarbs,
      "Protein": totalProtein,
      "Fat": totalFat,
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("📊", style: TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text("Macros Breakdown", style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w800, color: const Color(0xFF1E293B))),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: PieChart(
              dataMap: dataMap,
              animationDuration: const Duration(milliseconds: 800),
              chartLegendSpacing: 40,
              chartRadius: MediaQuery.of(context).size.width / 2.8,
              colorList: const [Colors.green, Colors.orange, Colors.amber],
              initialAngleInDegree: 0,
              chartType: ChartType.disc, // Solid filled circle
              legendOptions: const LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: false,
                showChartValues: true,
                showChartValuesInPercentage: true,
                showChartValuesOutside: false,
                decimalPlaces: 1,
                chartValueStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomDotProgressBar extends StatelessWidget {
  final double value;
  final double target;
  final Color color;

  const _CustomDotProgressBar({required this.value, required this.target, required this.color});

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (value / target).clamp(0.0, 1.0) : 0.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 4,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              height: 4,
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Positioned(
              left: (constraints.maxWidth * progress) - 3,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
