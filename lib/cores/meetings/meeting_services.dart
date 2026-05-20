import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MeetingServices {
  static const String _baseUrl = "https://nutrilens-application.onrender.com";
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> bookMeeting({
    required String dieticianId,
    required DateTime scheduledAt,
    required String notes,
  }) async {
    String? token = await _storage.read(key: "access_token");
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/meetings/book"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "dietician_id": dieticianId,
          "scheduled_at": scheduledAt.toIso8601String(),
          "notes": notes,
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'status_ok': data['status'] == 'ok',
          'message': data['message'] ?? 'Meeting booked successfully'
        };
      }
      return {
        'status_ok': false,
        'message': data['detail'] ?? 'Failed to book meeting'
      };
    } catch (e) {
      return {'status_ok': false, 'message': 'Booking error: $e'};
    }
  }

  Future<List<Map<String, dynamic>>> getMyMeetings() async {
    String? token = await _storage.read(key: "access_token");
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/meetings/my"),
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['meetings'] ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> cancelMeeting(String meetingId) async {
    String? token = await _storage.read(key: "access_token");
    try {
      final response = await http.patch(
        Uri.parse("$_baseUrl/meetings/$meetingId/cancel"),
        headers: {"Authorization": "Bearer $token"},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'status_ok': true, 'message': data['message'] ?? 'Meeting cancelled successfully'};
      }
      return {'status_ok': false, 'message': data['detail'] ?? 'Failed to cancel meeting'};
    } catch (e) {
      return {'status_ok': false, 'message': e.toString()};
    }
  }
}