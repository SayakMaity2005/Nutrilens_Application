import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import '../custom_datatypes/custom_classes.dart';

class CustomRecipe {
  static const String _baseUrl = "https://nutrilens-application.onrender.com";
  final storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> addRecipe(
    String mealType,
    Intake customRecipe,
  ) async {
    String? token = await storage.read(key: "access_token");

    // List<Map<String, dynamic>> consumedIntakes = [];
    // for (int i = 0; i < meals.length; i++) {
    Map<String, dynamic> intake = {
      'meal_type': "breakfast",

      'name': customRecipe.name(),
      'type': customRecipe.type(),

      'energy_per_unit': customRecipe.energyPerUnit(),
      'quantity': customRecipe.quantity(),
      'carbs_per_unit': customRecipe.carbsPerUnit(),
      'protein_per_unit': customRecipe.proteinPerUnit(),
      'fat_per_unit': customRecipe.fatPerUnit(),

      'ingredients': customRecipe.ingredients(),
      'recipe': customRecipe.recipe(),
    };
    // consumedIntakes.add(intake);
    // }

    try {
      final response = await http.post(
        Uri.parse(
          "$_baseUrl/custom_recipe/add_recipe",
          // "http://10.0.2.2:8000/custom_recipe/add_recipe",
        ),

        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },

        body: jsonEncode(intake),
      );

      // SUCCESS
      if (response.statusCode == 200) {
        // Convert JSON string → Dart Map
        // final data = jsonDecode(response.body);

        return {
          'status_ok': true,
          'message': 'Custom recipe added successfully',
        };
      }

      final data = jsonDecode(response.body);

      return {'status_ok': false, 'message': data['detail']};
    } catch (e) {
      // debugPrint(e);
      return {'status_ok': false, 'message': 'Meals add error: $e'};
    }
  }

  Future<Map<String, dynamic>> getAllRecipe() async {
    String? token = await storage.read(key: "access_token");

    try {
      final response = await http.get(
        Uri.parse(
          // "https://nutrilens-application.onrender.com/custom_recipe/add_recipe",
          "$_baseUrl/custom_recipe/get_all",
        ),

        headers: {"Authorization": "Bearer $token"},
      );

      // SUCCESS
      if (response.statusCode == 200) {
        // Convert JSON string → Dart Map
        final data = jsonDecode(response.body);

        return {
          'status_ok': true,
          'message': 'Custom recipe added successfully',
          'data': data['data'],
        };
      }

      final data = jsonDecode(response.body);

      return {'status_ok': false, 'message': data['detail']};
    } catch (e) {
      // debugPrint(e);
      return {'status_ok': false, 'message': 'Meals add error: $e'};
    }
  }

  Future<Map<String, dynamic>> deleteRecipe(String recipeId) async {
    String? token = await storage.read(key: "access_token");

    try {
      final response = await http.delete(
        Uri.parse(
          "$_baseUrl/custom_recipe/delete_recipe",
        ).replace(queryParameters: {"recipe_id": recipeId}),

        headers: {"Authorization": "Bearer $token"},
      );

      // SUCCESS
      if (response.statusCode == 200) {
        // Convert JSON string → Dart Map
        // final data = jsonDecode(response.body);

        return {
          'status_ok': true,
          'message': 'Custom recipe deleted successfully',
        };
      }

      final data = jsonDecode(response.body);

      return {'status_ok': false, 'message': data['detail']};
    } catch (e) {
      // debugPrint(e);
      return {'status_ok': false, 'message': 'Custom recipe deletion error: $e'};
    }
  }
}
