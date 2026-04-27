class IntakeRound {
  late final String _icon;
  late final String _type;
  late final int _requiredEnergy;
  late int _consumedEnergy;
  late double _consumedCarbs;
  late double _consumedProtein;
  late double _consumedFat;
  late int _intakeCount;
  late final List<Intake> _consumedIntakes;
  IntakeRound({
    required String icon,
    required String type,
    required int requiredEnergy,
  }) {
    _icon = icon;
    _type = type;
    _requiredEnergy = requiredEnergy;
    _consumedEnergy = 0;
    _consumedCarbs = 0;
    _consumedProtein = 0;
    _consumedFat = 0;
    _intakeCount = 0;
    _consumedIntakes = [];
  }
  void consumeEnergy(int amount) {
    _consumedEnergy += amount;
  }

  void reduceConsumption(int amount) {
    _consumedEnergy -= amount;
  }

  void consumeIntake(Intake intake) {
    _consumedIntakes.add(intake);
    _consumedEnergy += intake.energy();
    _consumedCarbs += intake.carbs();
    _consumedProtein += intake.protein();
    _consumedFat += intake.fat();
    _intakeCount++;
  }

  void consumeAllIntakes(List<Intake> intakes) {
    for (final intake in intakes) {
      consumeIntake(intake);
    }
  }

  String getIcon() => _icon;
  String getType() => _type;
  List<Intake> consumedIntakes() => _consumedIntakes;
  int getRequiredEnergy() => _requiredEnergy;
  int getConsumedEnergy() => _consumedEnergy;
  double getConsumedCarbs() => _consumedCarbs;
  double getConsumedProtein() => _consumedProtein;
  double getConsumedFat() => _consumedFat;
  int intakeCount() => _intakeCount;
}

class Intake {
  late final String _name;
  late final String _type; // food / drinks
  late final String _unit; // g, L, mL, ...
  late double _quantity;
  late final double _energyPerUnit;
  late final double _carbsPerUnit;
  late final double _proteinPerUnit;
  late final double _fatPerUnit;
  late final List<String> _ingredients;
  late final String _recipe;
  Intake({
    required String name,
    required String type,
    required String unit,
    required double quantity,
    required double energyPerUnit,
    required double carbsPerUnit,
    required double proteinPerUnit,
    required double fatPerUnit,
    required List<String> ingredients,
    required String recipe,
  }) {
    _name = name;
    _type = type;
    _unit = unit;
    _quantity = quantity;
    _energyPerUnit = energyPerUnit;
    _carbsPerUnit = carbsPerUnit;
    _proteinPerUnit = proteinPerUnit;
    _fatPerUnit = fatPerUnit;
    _ingredients = ingredients;
    _recipe = recipe;
  }
  Intake copyWith({
    String? name,
    String? type,
    String? unit,
    double? quantity,
    double? energyPerUnit,
    double? carbsPerUnit,
    double? proteinPerUnit,
    double? fatPerUnit,
    List<String>? ingredients,
    String? recipe,
  }) {
    return Intake(
      name: name ?? _name,
      type: type ?? _type,
      unit: unit ?? _unit,
      quantity: quantity ?? _quantity,
      energyPerUnit: energyPerUnit ?? _energyPerUnit,
      carbsPerUnit: carbsPerUnit ?? _carbsPerUnit,
      proteinPerUnit: proteinPerUnit ?? _proteinPerUnit,
      fatPerUnit: fatPerUnit ?? _fatPerUnit,
      ingredients: ingredients ?? _ingredients,
      recipe: recipe ?? _recipe,
    );
  }

  String name() => _name;
  String type() => _type;
  String unit() => _unit;
  double quantity() => _quantity;
  void setQuantity(double quantity) {
    _quantity = quantity;
  }

  int energy() => (_energyPerUnit * _quantity).toInt();
  double carbs() => _carbsPerUnit * _quantity;
  double protein() => _proteinPerUnit * _quantity;
  double fat() => _fatPerUnit * _quantity;
  List<String> ingredients() => _ingredients;
  String recipe() => _recipe;
}

class WorkoutRound {
  late final int _totalEnergyBurned;
  late final int _workoutCount;
  late final List<Workout> _completedWorkouts;
  WorkoutRound() {
    _totalEnergyBurned = 0;
    _workoutCount = 0;
    _completedWorkouts = [];
  }

  void addWorkout(Workout workout) {
    _completedWorkouts.add(workout);
    _totalEnergyBurned += workout.energyBurned();
    _workoutCount++;
  }

  void removeWorkout(int index) {
    _totalEnergyBurned -= _completedWorkouts[index].energyBurned();
    _completedWorkouts.removeAt(index);
    _workoutCount++;
  }

  int totalEnergyBurned() => _totalEnergyBurned;
  int workoutCount() => _workoutCount;
}

class Workout {
  late final String _name;
  late final String _type;
  late final String _explanation;
  late final double _energyBurnPerMinute;
  late final int _timeInMinute;
  Workout({
    required name,
    required type,
    required explanation,
    required energyBurnPerMinute,
    required timeInMinute,
  }) {
    _name = name;
    _type = type;
    _explanation = explanation;
    _energyBurnPerMinute = energyBurnPerMinute;
    _timeInMinute = timeInMinute;
  }
  String name() => _name;
  String type() => _type;
  String explanation() => _explanation;
  int energyBurned() => (_energyBurnPerMinute * _timeInMinute).round();
  int timeInMinute() => _timeInMinute;
}
