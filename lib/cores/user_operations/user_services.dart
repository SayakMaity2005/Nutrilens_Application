import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;
import 'package:nutrilens_test/cores/api_config.dart';

class UserServices {
  final storage = FlutterSecureStorage();
  static String get _baseUrl => ApiConfig.baseUrl;

  Future<Map<String, dynamic>> getUser() async {
    String? token = await storage.read(key: "access_token");

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/users/me"),
        headers: {"Authorization": "Bearer $token"},
      );

      // SUCCESS
      if (response.statusCode == 200) {
        // Convert JSON string → Dart Map
        final data = jsonDecode(response.body);

        return {'status_ok': true, 'data': data['user']};
      }

      final data = jsonDecode(response.body);

      return {'status_ok': false, 'message': data['detail']};
    } catch (e) {
      // debugPrint(e);
      return {'status_ok': false, 'message': 'User data fetch error: $e'};
    }
  }

  Future<Map<String, dynamic>> updateDailyTarget({
    double? energy,
    double? carbs,
    double? protein,
    double? fat,
    double? water,
  }) async {
    String? token = await storage.read(key: "access_token");

    if (token == null) {
      return {
        'status_ok': false,
        'message': 'Authentication token not found. Please log in again.'
      };
    }

    Map<String, dynamic> request = {};
    if (energy != null) request['energy'] = energy;
    if (carbs != null) request['carbs'] = carbs;
    if (protein != null) request['protein'] = protein;
    if (fat != null) request['fat'] = fat;
    if (water != null) request['water'] = water;

    if (request.isEmpty) {
      return {'status_ok': true, 'message': 'No changes detected.'};
    }

    try {
      final response = await http.patch(
        Uri.parse("$_baseUrl/users/update/daily_target"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(request),
      );

      // SUCCESS
      if (response.statusCode == 200) {
        // Convert JSON string → Dart Map
        final data = jsonDecode(response.body);

        return {
          'status_ok': true,
          'message': 'daily target successfully updated',
        };
      }

      final data = jsonDecode(response.body);

      String errorMessage = "Unknown error";

      if (data != null && data["detail"] != null) {
        if (data["detail"] is String) {
          errorMessage = data["detail"];
        } else if (data["detail"] is List && data["detail"].isNotEmpty) {
          // Safe check to make sure the key 'msg' actually exists in the first item
          errorMessage = data["detail"][0]["msg"] ?? "Validation error";
        }
      }

      return {'status_ok': false, 'message': errorMessage};
    } catch (e) {
      // debugPrint(e);
      return {'status_ok': false, 'message': 'User data fetch error: $e'};
    }
  }

  Future<Map<String, dynamic>> getNudges() async {
    String? token = await storage.read(key: "access_token");
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/user/nudges"),
        headers: {"Authorization": "Bearer $token"},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status_ok': true, 'nudges': data['nudges'] ?? []};
      }
      return {'status_ok': false, 'message': data['detail'] ?? 'Failed to get nudges'};
    } catch (e) {
      return {'status_ok': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    double? height,
    double? weight,
    int? age,
    String? gender,
  }) async {
    String? token = await storage.read(key: "access_token");
    if (token == null) {
      return {'status_ok': false, 'message': 'Authentication token not found.'};
    }

    Map<String, dynamic> request = {};
    if (height != null) request['height'] = height;
    if (weight != null) request['weight'] = weight;
    if (age != null) request['age'] = age;
    if (gender != null) request['gender'] = gender;

    if (request.isEmpty) return {'status_ok': true, 'message': 'No changes detected.'};

    try {
      final response = await http.patch(
        Uri.parse("$_baseUrl/users/update/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        return {'status_ok': true, 'message': 'Profile updated successfully'};
      }

      final data = jsonDecode(response.body);
      return {'status_ok': false, 'message': data['detail'] ?? 'Failed to update profile'};
    } catch (e) {
      return {'status_ok': false, 'message': 'Update profile error: $e'};
    }
  }

  Future<Map<String, dynamic>> updateUserDetails({
    String? fullName,
    String? email,
  }) async {
    String? token = await storage.read(key: "access_token");
    if (token == null) {
      return {'status_ok': false, 'message': 'Authentication token not found.'};
    }

    Map<String, dynamic> request = {};
    if (fullName != null) request['full_name'] = fullName;
    if (email != null) request['email'] = email;

    if (request.isEmpty) return {'status_ok': true, 'message': 'No changes detected.'};

    try {
      final response = await http.patch(
        Uri.parse("$_baseUrl/users/update/details"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(request),
      );

      if (response.statusCode == 200) {
        return {'status_ok': true, 'message': 'User details updated successfully'};
      }

      final data = jsonDecode(response.body);
      return {'status_ok': false, 'message': data['detail'] ?? 'Failed to update details'};
    } catch (e) {
      return {'status_ok': false, 'message': 'Update details error: $e'};
    }
  }
}
