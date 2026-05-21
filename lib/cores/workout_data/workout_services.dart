import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:nutrilens_test/cores/api_config.dart';

class WorkoutServices {
  static String get _baseUrl => ApiConfig.baseUrl;
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> addWorkout(Map<String, dynamic> workoutData) async {
    String? token = await storage.read(key: "access_token");
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/daily_data/add_workout"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(workoutData),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status_ok': true, 'message': data['message'] ?? 'Workout added successfully'};
      }
      return {'status_ok': false, 'message': data['detail'] ?? 'Failed to add workout'};
    } catch (e) {
      return {'status_ok': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getDailyWorkoutData(DateTime date) async {
    String? token = await storage.read(key: "access_token");
    String dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/daily_data/get_daily_workout_data").replace(
          queryParameters: {"date": dateStr}
        ),
        headers: {"Authorization": "Bearer $token"},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status_ok': true, 'data': data['data']};
      }
      return {'status_ok': false, 'message': data['detail'] ?? 'Failed to fetch workout data'};
    } catch (e) {
      return {'status_ok': false, 'message': 'Workout data fetch error: $e'};
    }
  }

  Future<Map<String, dynamic>> getDefaultWorkouts() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/default_workouts"),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status_ok': true, 'data': data['data']};
      }
      return {'status_ok': false, 'message': data['detail'] ?? 'Failed to fetch default workouts'};
    } catch (e) {
      return {'status_ok': false, 'message': 'Default workouts fetch error: $e'};
    }
  }
}
