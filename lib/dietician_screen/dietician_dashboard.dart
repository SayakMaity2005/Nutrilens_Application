import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/dietician/dietician_services.dart';
import 'package:nutrilens_test/cores/meetings/meeting_services.dart';

class DieticianDashboard extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const DieticianDashboard({super.key, this.userData});

  @override
  State<DieticianDashboard> createState() => _DieticianDashboardState();
}

class _DieticianDashboardState extends State<DieticianDashboard> {
  List<Map<String, dynamic>> _clients = [];
  List<Map<String, dynamic>> _meetings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    final clients = await DieticianServices().getClients();
    final meetings = await MeetingServices().getMyMeetings();
    
    if (mounted) {
      setState(() {
        _clients = clients;
        _meetings = meetings;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>() ?? ThemePalette.lightPalette;
    final name = widget.userData?['full_name'] ?? widget.userData?['username'] ?? 'Dietician';

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Hero
            Text(
              "Good Morning,",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: TextStyle(
                color: palette.headingBlueText,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Quick Stats Grid
            if (_isLoading)
              const Center(child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ))
            else ...[
              Row(
                children: [
                  Expanded(child: _buildStatCard("Total Clients", _clients.length.toString(), Icons.people_alt, Colors.blue.shade100, Colors.blue.shade700)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard("Today's Meetings", _getTodayMeetings().length.toString(), Icons.event_available, Colors.purple.shade100, Colors.purple.shade700)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildStatCard("High Risk", _getHighRiskClients().toString(), Icons.warning_amber_rounded, Colors.red.shade100, Colors.red.shade700)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard("Avg Check-in", "82%", Icons.trending_up, Colors.green.shade100, Colors.green.shade700)),
                ],
              ),
            ],

            const SizedBox(height: 30),
            
            // Upcoming Agenda Widget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Upcoming Agenda",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Could dispatch an event to switch tabs, but we'll leave it as mock for now
                  },
                  child: const Text("View All"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_meetings.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text("No upcoming meetings scheduled."),
                ),
              )
            else
              ..._getUpcomingMeetings().take(2).map((m) => _buildMiniMeetingCard(m, palette)),
              
            const SizedBox(height: 100), // padding for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMeetingCard(Map<String, dynamic> meeting, AppPalette palette) {
    final scheduledAt = DateTime.tryParse(meeting["scheduled_at"] ?? "") ?? DateTime.now();
    final clientName = meeting["user_name"] ?? "Client";
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: palette.selectColor1,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Consultation with $clientName",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')} - ${scheduledAt.day}/${scheduledAt.month}/${scheduledAt.year}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(Icons.video_call, color: palette.selectColor3),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getUpcomingMeetings() {
    return _meetings.where((m) => m['status'] == 'scheduled').toList()
      ..sort((a, b) {
        final dateA = DateTime.tryParse(a['scheduled_at'] ?? "") ?? DateTime.now();
        final dateB = DateTime.tryParse(b['scheduled_at'] ?? "") ?? DateTime.now();
        return dateA.compareTo(dateB);
      });
  }

  List<Map<String, dynamic>> _getTodayMeetings() {
    final now = DateTime.now();
    return _meetings.where((m) {
      if (m['status'] != 'scheduled') return false;
      final date = DateTime.tryParse(m['scheduled_at'] ?? "");
      if (date == null) return false;
      return date.year == now.year && date.month == now.month && date.day == now.day;
    }).toList();
  }

  int _getHighRiskClients() {
    return _clients.where((c) => c['risk_level'] == 'high').length;
  }
}
