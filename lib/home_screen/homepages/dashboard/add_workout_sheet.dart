import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/cores/workout_data/workout_services.dart';

class AddWorkoutSheet extends StatefulWidget {
  const AddWorkoutSheet({super.key});

  @override
  State<AddWorkoutSheet> createState() => _AddWorkoutSheetState();
}

class _AddWorkoutSheetState extends State<AddWorkoutSheet> {
  final _workoutServices = WorkoutServices();
  int _selectedTabIndex = 0; // 0 for Predefined, 1 for Manual

  // Manual entry controllers
  final _nameCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _caloriesCtrl = TextEditingController();

  // Predefined state
  bool _isLoadingWorkouts = true;
  List<dynamic> _defaultWorkouts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchDefaultWorkouts();
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

  Future<void> _fetchDefaultWorkouts() async {
    final response = await _workoutServices.getDefaultWorkouts();
    if (response['status_ok']) {
      setState(() {
        _defaultWorkouts = response['data'] ?? [];
        _isLoadingWorkouts = false;
      });
    } else {
      setState(() {
        _isLoadingWorkouts = false;
      });
      if (mounted) {
        _showSnackBar( response['message'] ?? "Failed to fetch workouts");
      }
    }
  }

  void _submitWorkout(String name, double duration, double energy) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    final workoutData = {
      "name": name,
      "duration": duration,
      "energy": energy,
      "count": 1,
    };

    final response = await _workoutServices.addWorkout(workoutData);

    if (mounted) Navigator.pop(context); // Close loading

    if (response['status_ok']) {
      if (mounted) {
        _showSnackBar("Workout added successfully!");
        Navigator.pop(context, true); // Return true to trigger refresh
      }
    } else {
      if (mounted) {
        _showSnackBar(response['message'] ?? "Error adding workout");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Add Workout",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Tab Selection
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildTabButton("Predefined", 0),
                _buildTabButton("Manual Entry", 1),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedTabIndex == 0 ? _buildPredefinedTab() : _buildManualTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade600 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPredefinedTab() {
    if (_isLoadingWorkouts) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredWorkouts = _defaultWorkouts.where((w) {
      final name = w['name'].toString().toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        TextField(
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: "Search workouts...",
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: filteredWorkouts.isEmpty
              ? const Center(child: Text("No workouts found.", style: TextStyle(color: Colors.grey)))
              : ListView.separated(
                  itemCount: filteredWorkouts.length,
                  separatorBuilder: (ctx, i) => Divider(color: Colors.grey.shade200),
                  itemBuilder: (ctx, i) {
                    final workout = filteredWorkouts[i];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.fitness_center, color: Colors.blue.shade700),
                      ),
                      title: Text(workout['name'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${workout['duration'] ?? 0} mins • ${workout['energy'] ?? 0} kcal"),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.blue, size: 28),
                        onPressed: () {
                          _submitWorkout(
                            workout['name'] ?? 'Unknown',
                            (workout['duration'] ?? 0).toDouble(),
                            (workout['energy'] ?? 0).toDouble(),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildManualTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField("Workout Name", "e.g., Morning Run", _nameCtrl, TextInputType.text),
          const SizedBox(height: 16),
          _buildTextField("Duration (minutes)", "e.g., 30", _durationCtrl, TextInputType.number),
          const SizedBox(height: 16),
          _buildTextField("Calories Burned (kcal)", "e.g., 300", _caloriesCtrl, TextInputType.number),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_nameCtrl.text.trim().isEmpty) return;
                final duration = double.tryParse(_durationCtrl.text) ?? 0;
                final energy = double.tryParse(_caloriesCtrl.text) ?? 0;
                _submitWorkout(_nameCtrl.text.trim(), duration, energy);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Add Workout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
