import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import '../custom_datatypes/custom_classes.dart';

class GroqServices {
  final storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> makeRecipe(String userPrompt) async {
    String? token = await storage.read(key: "access_token");

    try {
      final response = await http.post(
        Uri.parse(
          // "https://nutrilens-application.onrender.com/make_recipe",
          "http://nutrilens-application.onrender.com/make_recipe",
        ).replace(queryParameters: {"user_prompt": userPrompt}),

        headers: {"Authorization": "Bearer $token"},
      );

      final data = jsonDecode(response.body);

      // SUCCESS
      if (response.statusCode == 200) {
        // print('/////////////// DONE ///////////////');
        return {'status_ok': true, 'message': 'Recipe generated successfully', 'data': data};
      }

      String errorMessage = "Unknown error";

      if (data["detail"] is String) {
        errorMessage = data["detail"];
      } else if (data["detail"] is List) {
        errorMessage = data["detail"][0]["msg"];
      }

      // print('//////////////////// Error: $errorMessage ///////////////////');

      return {'status_ok': false, 'message': errorMessage};
    } catch (e) {
      // print('//////////////// Exception: $e /////////////////');
      return {'status_ok': false, 'message': 'Recipe generation error: $e'};
    }
  }
}