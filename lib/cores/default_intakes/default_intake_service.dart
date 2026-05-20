import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;



class DefaultIntakeService {

  final storage =
  FlutterSecureStorage();


  Future<Map<String, dynamic>> getDefaultIntakes(String mealType) async {

    String? token = await storage.read(key: "access_token");

    try {

      final response = await http.get(

          Uri.parse(
            "https://nutrilens-application.onrender.com/default_intakes",
          ).replace(queryParameters: {"meal_type": mealType}),
      );



      // SUCCESS
      if (response.statusCode == 200) {

        // Convert JSON string → Dart Map
        final data =
        jsonDecode(response.body);


        return {'status_ok': true, 'data': data['data']};
      }

      final data =
      jsonDecode(response.body);

      return {'status_ok': false, 'message': data['detail']};

    } catch (e) {

      // debugPrint(e);
      return {'status_ok': false, 'message': 'User data fetch error: $e'};
    }
  }
}
