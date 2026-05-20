import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;



class UserServices {

  final storage =
  FlutterSecureStorage();


  Future<Map<String, dynamic>> getUser() async {

    String? token = await storage.read(key: "access_token");

    try {

      final response = await http.get(

        Uri.parse(
          "http://192.168.1.4:8000/users/me",
        ),

        headers: {
          "Authorization": "Bearer $token",
        }
      );



      // SUCCESS
      if (response.statusCode == 200) {

        // Convert JSON string → Dart Map
        final data =
        jsonDecode(response.body);


        return {'status_ok': true, 'data': data['user']};
      }

      final data =
      jsonDecode(response.body);

      return {'status_ok': false, 'message': data['detail']};

    } catch (e) {

      // debugPrint(e);
      return {'status_ok': false, 'message': 'User data fetch error: $e'};
    }
  }

  Future<Map<String, dynamic>> getNudges() async {
    String? token = await storage.read(key: "access_token");
    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.4:8000/user/nudges"),
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
}
