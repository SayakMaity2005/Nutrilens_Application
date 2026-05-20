import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class DailyDataServices {
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
          "http://192.168.1.4:8000/daily_data/get_daily_data",
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

  Future<Map<String, dynamic>> addWater(double amount) async {
    String? token = await storage.read(key: "access_token");
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.4:8000/daily_data/add_water?water_quantity=$amount"),
        headers: {"Authorization": "Bearer $token"},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status_ok': true, 'message': data['message'] ?? 'Water added'};
      }
      return {'status_ok': false, 'message': data['detail'] ?? 'Failed to add water'};
    } catch (e) {
      return {'status_ok': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> addMeal(Map<String, dynamic> mealData) async {
    String? token = await storage.read(key: "access_token");
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.4:8000/daily_data/add_meal"),
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
}
