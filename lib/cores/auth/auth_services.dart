import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class AuthServices {
  static const String _baseUrl = "http://192.168.1.4:8000";
  final storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/token"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"username": username, "password": password},
      );

      // SUCCESS
      if (response.statusCode == 200) {
        // Convert JSON string → Dart Map
        final data = jsonDecode(response.body);

        // Extract token
        final token = data["access_token"];

        // Save token securely
        await storage.write(key: "access_token", value: token);

        return {'status_ok': true, 'message': 'Welcome to Nutrilens'};
      }

      final data = jsonDecode(response.body);

      return {'status_ok': false, 'message': data['detail']};
    } catch (e) {
      // debugPrint(e);
      return {'status_ok': false, 'message': 'Login error: $e'};
    }
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String fullName,
    required double? height,
    required double? weight,
    required int? age,
    required String? gender,
    required String password,
  }) async {
    bool canCalculate = height != null && weight != null && gender != null && age != null;

    double? energy, carbs, protein, fat;

    if (canCalculate) {
      double BMR = 0.0;

      if (gender == 'male') {
        BMR = (10 * weight) + (6.25 * height) - (5 * age) + 5;
      } else if (gender == 'female') {
        BMR = 10 * weight + 6.25 * height - 5 * age - 161;
      }

      double activityFactor = 1.55; // moderate
      double TDEE = BMR * activityFactor;

      protein = 2.0 * weight; // 1.6 to 2.2×Weight(kg)
      fat = 0.8 * weight; // 0.8 * Weight(kg)
      carbs = (TDEE - protein * 4 - fat * 9) / 4;
      energy = TDEE;
    }

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "full_name": fullName,
          "disabled": false,
          "profile": {
            "height": height,
            "weight": weight,
            "age": age,
            "gender": gender,
            "daily_target": {
              "energy": energy ?? 2000,
              "carbs": carbs ?? 250,
              "protein": protein ?? 150,
              "fat": fat ?? 44,
              "water": weight != null ? weight * 42 : 2250
            }
          },
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      // SUCCESS
      if (response.statusCode == 200) {
        final token = data["access_token"];
        await storage.write(key: "access_token", value: token);
        return {"status_ok": true, "message": "Welcome to Nutrilens"};
      }

      return {"status_ok": false, "message": data["detail"] ?? "Registration failed"};
    } catch (e) {
      return {"status_ok": false, "message": "Registration error: $e"};
    }
  }

  Future<void> logout() async {
    await storage.delete(key: "access_token");
  }
}
