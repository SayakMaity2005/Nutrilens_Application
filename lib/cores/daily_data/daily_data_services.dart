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
          "http://10.0.2.2:8000/daily_data/get_daily_data",
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
}
