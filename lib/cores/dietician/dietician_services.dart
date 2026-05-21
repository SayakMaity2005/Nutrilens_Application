import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nutrilens_test/cores/api_config.dart';

class DieticianServices {
  static String get _baseUrl => ApiConfig.baseUrl;
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> registerDietician({
    required String username,
    required String email,
    required String fullName,
    required String password,
    required String specialization,
    required String qualification,
    required int? experienceYears,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/dietician/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "full_name": fullName,
          "password": password,
          "specialization": specialization,
          "qualification": qualification,
          "experience_years": experienceYears,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = data["access_token"];
        await _storage.write(key: "access_token", value: token);
        return {'status_ok': true, 'message': 'Welcome to Nutrilens'};
      }
      return {'status_ok': false, 'message': data['detail'] ?? 'Registration failed'};
    } catch (e) {
      return {'status_ok': false, 'message': 'Registration error: $e'};
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableDieticians() async {
    String? token = await _storage.read(key: "access_token");
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/dieticians/available"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['dieticians'] ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getClientProgress(String clientId, String dateStr) async {
    String? token = await _storage.read(key: "access_token");
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/dietician/clients/$clientId/progress?date=$dateStr"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> updateClientTargets(String clientId, Map<String, dynamic> targets) async {
    String? token = await _storage.read(key: "access_token");
    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/dietician/clients/$clientId/targets"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(targets),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status_ok': true, 'message': data['message'] ?? 'Targets updated'};
      }
      return {'status_ok': false, 'message': data['detail'] ?? 'Failed to update targets'};
    } catch (e) {
      return {'status_ok': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> sendNudge(String clientId, String message) async {
    String? token = await _storage.read(key: "access_token");
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/dietician/clients/$clientId/nudge"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({"message": message}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status_ok': true, 'message': data['message'] ?? 'Nudge sent successfully'};
      }
      return {'status_ok': false, 'message': data['detail'] ?? 'Failed to send nudge'};
    } catch (e) {
      return {'status_ok': false, 'message': e.toString()};
    }
  }

  Future<List<Map<String, dynamic>>> getClients() async {
    String? token = await _storage.read(key: "access_token");
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/dietician/clients"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['clients'] ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}