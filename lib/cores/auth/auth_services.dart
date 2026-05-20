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
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "full_name": fullName,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final token = data["access_token"];
        await storage.write(key: "access_token", value: token);
        return {'status_ok': true, 'message': 'Welcome to Nutrilens'};
      }
      return {'status_ok': false, 'message': data['detail'] ?? 'Registration failed'};
    } catch (e) {
      return {'status_ok': false, 'message': 'Registration error: $e'};
    }
  }

  Future<void> logout() async {
    await storage.delete(key: "access_token");
  }
}
