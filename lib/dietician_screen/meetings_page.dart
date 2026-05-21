import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/cores/meetings/meeting_services.dart';

class MeetingsPage extends StatefulWidget {
  const MeetingsPage({super.key});

  @override
  State<MeetingsPage> createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {
  List<Map<String, dynamic>> _allMeetings = [];
  List<Map<String, dynamic>> _filteredMeetings = [];
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadMeetings();
  }

  Future<void> _loadMeetings() async {
    setState(() => _isLoading = true);
    final meetings = await MeetingServices().getMyMeetings();
    
    // Sort meetings chronologically
    meetings.sort((a, b) {
      final dateA = DateTime.tryParse(a['scheduled_at'] ?? "") ?? DateTime.now();
      final dateB = DateTime.tryParse(b['scheduled_at'] ?? "") ?? DateTime.now();
      return dateA.compareTo(dateB);
    });

    if (mounted) {
      setState(() {
        _allMeetings = meetings;
        _isLoading = false;
        _filterMeetingsForDate(_selectedDate);
      });
    }
  }

  void _filterMeetingsForDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _filteredMeetings = _allMeetings.where((m) {
        final mDate = DateTime.tryParse(m['scheduled_at'] ?? "");
        if (mDate == null) return false;
        return mDate.year == date.year && mDate.month == date.month && mDate.day == date.day;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = Theme.of(context).extension<AppPalette>() ?? ThemePalette.lightPalette;

    return Column(
      children: [
        // Horizontal Date Selector
        _buildDateSelector(palette),
        
        // Meetings Timeline
        Expanded(
          child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : _filteredMeetings.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadMeetings,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 100), // padding for bottom nav
                    itemCount: _filteredMeetings.length,
                    itemBuilder: (context, index) {
                      return _buildTimelineCard(_filteredMeetings[index], palette, index == _filteredMeetings.length - 1);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
              ],
            ),
            child: Icon(Icons.event_busy_rounded, size: 60, color: Colors.grey.shade300),
          ),
          const SizedBox(height: 24),
          Text(
            "Free Schedule",
            style: AppTextStyle.heading4.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "No appointments scheduled for\n${DateFormat('EEEE, MMM d').format(_selectedDate)}.",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(AppPalette palette) {
    // Generate dates for a 2-week window (1 week past, 1 week future)
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dates = List.generate(15, (index) => today.subtract(Duration(days: 7 - index)));

    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // Start scroll offset around 'today' ideally, but we'll just center it logically by picking the right index
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date.year == _selectedDate.year && 
                             date.month == _selectedDate.month && 
                             date.day == _selectedDate.day;
          
          return GestureDetector(
            onTap: () => _filterMeetingsForDate(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 65,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? palette.selectColor1 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(color: palette.selectColor1.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                  else
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
                ],
                border: isSelected ? null : Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date).toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.white.withOpacity(0.9) : Colors.grey.shade500,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (date.year == today.year && date.month == today.month && date.day == today.day)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : palette.selectColor1,
                        shape: BoxShape.circle,
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _joinCall(String meetingId) async {
    final url = Uri.parse('https://meet.jit.si/Nutrilens_Meeting_$meetingId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch video call')),
        );
      }
    }
  }

  Widget _buildTimelineCard(Map<String, dynamic> meeting, AppPalette palette, bool isLast) {
    final status = meeting["status"] ?? "scheduled";
    final scheduledAt = DateTime.tryParse(meeting["scheduled_at"] ?? "") ?? DateTime.now();
    final userName = meeting["user_name"] ?? "Client";
    final notes = meeting["notes"];

    Color statusColor;
    Color bgColor;
    if (status == "completed") {
      statusColor = Colors.green.shade600;
      bgColor = Colors.green.shade50;
    } else if (status == "cancelled") {
      statusColor = Colors.red.shade600;
      bgColor = Colors.red.shade50;
    } else {
      statusColor = palette.selectColor1;
      bgColor = Colors.white;
    }

    final timeString = DateFormat('hh:mm a').format(scheduledAt);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line & Dot
          SizedBox(
            width: 70,
            child: Column(
              children: [
                Text(
                  timeString,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      if (!isLast)
                        Container(
                          width: 2,
                          color: Colors.grey.shade200,
                        ),
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: statusColor.withOpacity(0.4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Card Content
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: status == 'scheduled' ? Colors.transparent : statusColor.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Consultation",
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  if (notes != null && notes.toString().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notes_rounded, size: 16, color: Colors.grey.shade400),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            notes,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ],
                  
                  if (status == "scheduled") ...[
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () => _joinCall(meeting['_id'] ?? ''),
                          icon: const Icon(Icons.video_call_rounded, size: 20),
                          label: const Text("Join Call"),
                          style: TextButton.styleFrom(
                            foregroundColor: palette.selectColor1,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final meetingId = meeting["_id"];
                            if (meetingId != null) {
                              await MeetingServices().cancelMeeting(meetingId);
                              _loadMeetings();
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red.shade400,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
