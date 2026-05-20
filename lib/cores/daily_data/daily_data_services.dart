import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import '../custom_datatypes/custom_classes.dart';

class DailyDataServices {
  static const String _baseUrl = "https://nutrilens-application.onrender.com";
  final storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> getDailyData(DateTime date) async {
    String? token = await storage.read(key: "access_token");

    String selectedDate =
        "${date.year}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";

    try {
      final response = await http.get(
        Uri.parse(
          "$_baseUrl/daily_data/get_daily_data",
        ).replace(queryParameters: {"date": selectedDate}),

        headers: {"Authorization": "Bearer $token"},
      );

      // SUCCESS
      if (response.statusCode == 200) {
        // Convert JSON string → Dart Map
        final data = jsonDecode(response.body);

        return {
          'status_ok': true,
          'message': 'Daily data fetched successfully',
          'data': data['data'],
        };
      }

      final data = jsonDecode(response.body);

      return {'status_ok': false, 'message': data['detail']};
    } catch (e) {
      // debugPrint(e);
      return {'status_ok': false, 'message': 'Daily data fetch error: $e'};
    }
  }

  Future<Map<String, dynamic>> addMeal(
    dynamic first, [
    List<dynamic>? meals,
  ]) async {
    if (first is Map<String, dynamic>) {
      return _addMealMap(first);
    } else if (first is String && meals != null) {
      return _addMealList(first, meals);
    } else {
      throw ArgumentError("Invalid arguments to addMeal");
    }
  }

  Future<Map<String, dynamic>> _addMealMap(Map<String, dynamic> mealData) async {
    String? token = await storage.read(key: "access_token");
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/daily_data/add_meal"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(mealData),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status_ok': true, 'message': data['message'] ?? 'Meal added successfully'};
      }
      return {'status_ok': false, 'message': data['detail'] ?? 'Failed to add meal'};
    } catch (e) {
      return {'status_ok': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> _addMealList(String mealType, List<dynamic> meals) async {
    String? token = await storage.read(key: "access_token");

    List<Map<String, dynamic>> consumedIntakes = [];
    for (int i = 0; i < meals.length; i++) {
      Map<String, dynamic> intake = {
        'intake_id': meals[i].id(),
        'name': meals[i].name(),
        'type': meals[i].type(),
        'energy_per_unit': meals[i].energyPerUnit(),
        'quantity': meals[i].quantity(),
        'carbs_per_unit': meals[i].carbsPerUnit(),
        'protein_per_unit': meals[i].proteinPerUnit(),
        'fat_per_unit': meals[i].fatPerUnit(),
      };
      consumedIntakes.add(intake);
    }

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/daily_data/add_meal"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "meal_type": mealType,
          "consumed_intakes": consumedIntakes,
        }),
      );

      if (response.statusCode == 200) {
        return {'status_ok': true, 'message': 'Meals added successfully'};
      }
      final data = jsonDecode(response.body);
      return {'status_ok': false, 'message': data['detail']};
    } catch (e) {
      return {'status_ok': false, 'message': 'Meals add error: $e'};
    }
  }

  Future<Map<String, dynamic>> addWater(double quantity) async {
    String? token = await storage.read(key: "access_token");
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/daily_data/add_water").replace(
          queryParameters: {"water_quantity": quantity.toString()}
        ),
        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status_ok': true, 'message': data['message'] ?? 'Water added successfully'};
      }

      String errorMessage = "Unknown error";
      if (data["detail"] is String) {
        errorMessage = data["detail"];
      } else if (data["detail"] is List) {
        errorMessage = data["detail"][0]["msg"];
      }
      return {'status_ok': false, 'message': errorMessage};
    } catch (e) {
      return {'status_ok': false, 'message': 'Water add error: $e'};
    }
  }
}
