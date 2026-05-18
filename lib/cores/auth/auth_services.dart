import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class AuthServices {
  final storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/token"),

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

  Future<void> logout() async {
    await storage.delete(key: "access_token");
  }
}
