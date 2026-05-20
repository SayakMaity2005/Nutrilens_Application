import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/cores/meetings/meeting_services.dart';

class MeetingsPage extends StatefulWidget {
  const MeetingsPage({super.key});

  @override
  State<MeetingsPage> createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {
  List<Map<String, dynamic>> _meetings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeetings();
  }

  Future<void> _loadMeetings() async {
    setState(() => _isLoading = true);
    final meetings = await MeetingServices().getMyMeetings();
    setState(() {
      _meetings = meetings;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>()!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_meetings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              "No Meetings Scheduled",
              style: AppTextStyle.heading4.copyWith(color: Colors.grey.shade500),
            ),
            const SizedBox(height: 8),
            Text(
              "Your upcoming appointments will\nappear here.",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMeetings,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: _meetings.length,
        itemBuilder: (context, index) {
          return _buildMeetingCard(_meetings[index], palette);
        },
      ),
    );
  }

  Widget _buildMeetingCard(Map<String, dynamic> meeting, AppPalette palette) {
    final status = meeting["status"] ?? "scheduled";
    final scheduledAt = DateTime.tryParse(meeting["scheduled_at"] ?? "");
    final userName = meeting["user_name"] ?? "Client";
    final dieticianName = meeting["dietician_name"] ?? "Dietician";
    final notes = meeting["notes"];

    Color statusColor;
    IconData statusIcon;
    switch (status) {
      case "completed":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case "cancelled":
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.blue;
        statusIcon = Icons.schedule;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(statusIcon, color: statusColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Meeting with $userName",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    if (scheduledAt != null)
                      Text(
                        "${scheduledAt.day}/${scheduledAt.month}/${scheduledAt.year} at ${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status[0].toUpperCase() + status.substring(1),
                  style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          // Notes
          if (notes != null && notes.toString().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                notes,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
            ),
          ],
          // Cancel button for scheduled meetings
          if (status == "scheduled") ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  final meetingId = meeting["_id"];
                  if (meetingId != null) {
                    await MeetingServices().cancelMeeting(meetingId);
                    _loadMeetings();
                  }
                },
                child: const Text(
                  "Cancel Meeting",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
