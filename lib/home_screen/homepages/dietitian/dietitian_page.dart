import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/custom_widget_library/animated_button.dart';
import 'package:nutrilens_test/cores/dietician/dietician_services.dart';
import 'package:nutrilens_test/cores/meetings/meeting_services.dart';
import 'package:url_launcher/url_launcher.dart';

class DietitianPage extends StatefulWidget {
  const DietitianPage({super.key});

  @override
  State<DietitianPage> createState() => _DietitianPageState();
}

class _DietitianPageState extends State<DietitianPage> {
  List<Map<String, dynamic>> _availableDieticians = [];
  List<Map<String, dynamic>> _myMeetings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Fetch data in parallel to reduce loading time by half
    final results = await Future.wait([
      DieticianServices().getAvailableDieticians(),
      MeetingServices().getMyMeetings(),
    ]);

    final dieticians = results[0] as List<Map<String, dynamic>>;
    final meetings = results[1] as List<Map<String, dynamic>>;

    setState(() {
      _availableDieticians = dieticians;
      _myMeetings = meetings.where((m) => m["status"] == "scheduled").toList();
      _isLoading = false;
    });
  }

  void _showBookingModal(Map<String, dynamic> dietician, AppPalette palette) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
    final notesController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Book a Meeting", style: AppTextStyle.heading4),
                  const SizedBox(height: 10),
                  Text(
                    "with ${dietician['full_name'] ?? dietician['username']}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                  // Date Picker
                  ListTile(
                    title: const Text("Select Date"),
                    subtitle: Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (picked != null) {
                        setModalState(() => selectedDate = picked);
                      }
                    },
                  ),

                  // Time Picker
                  ListTile(
                    title: const Text("Select Time"),
                    subtitle: Text(selectedTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setModalState(() => selectedTime = picked);
                      }
                    },
                  ),

                  const SizedBox(height: 10),
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: "Notes (Optional)",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: palette.selectColor3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        // Show loading on top of the modal
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (c) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        final dateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );

                        final res = await MeetingServices().bookMeeting(
                          dieticianId: dietician['id'],
                          scheduledAt: dateTime,
                          notes: notesController.text,
                        );

                        if (!context.mounted) return;

                        Navigator.pop(context); // Close loading dialog
                        Navigator.pop(context); // Close modal bottom sheet

                        _showSnackBar(res['message']);

                        if (res['status_ok']) {
                          _loadData();
                        }
                      },
                      child: const Text(
                        "Confirm Booking",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final palette = Theme.of(context).extension<AppPalette>()!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildHeader("Connect with Experts"),
            const SizedBox(height: 20),
            _buildSearchAndFilter(screenWidth, palette),
            const SizedBox(height: 25),
            _buildFeaturedDieticianCard(screenWidth, palette),
            const SizedBox(height: 25),
            _buildNutritionSummaryCard(screenWidth, palette),

            if (_myMeetings.isNotEmpty) ...[
              const SizedBox(height: 25),
              _buildSectionTitle("Upcoming Appointments"),
              const SizedBox(height: 15),
              _buildMyAppointmentsSection(screenWidth, palette),
            ],

            const SizedBox(height: 25),
            _buildSectionTitle("Food Scan Review"),
            const SizedBox(height: 10),
            _buildFoodScanReviewCTA(screenWidth, palette),
            const SizedBox(height: 25),
            _buildSectionTitle("Available Dietitians"),
            const SizedBox(height: 15),
            _buildDieticianList(screenWidth, palette),
            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: AppTextStyle.heading3.copyWith(color: const Color(0xFF052532)),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyle.heading4.copyWith(color: const Color(0xFF333333)),
    );
  }

  Widget _buildSearchAndFilter(double width, AppPalette palette) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Text(
                  "Search by name or specialty",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: palette.selectColor4.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.tune, color: palette.headingBlueText),
        ),
      ],
    );
  }

  Widget _buildFeaturedDieticianCard(double width, AppPalette palette) {
    if (_availableDieticians.isEmpty) return const SizedBox.shrink();
    final topDietician = _availableDieticians.first;
    final name =
        topDietician['full_name'] ??
        topDietician['username'] ??
        'Expert Dietician';
    final spec = topDietician['specialization'] ?? 'General Nutrition';

    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            palette.selectColor3,
            palette.selectColor3.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: palette.selectColor3.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(Icons.star, size: 40, color: Colors.amber),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Text("Featured Pro", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  spec,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _showBookingModal(topDietician, palette),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Book Now",
                      style: TextStyle(
                        color: palette.selectColor3,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSummaryCard(double width, AppPalette palette) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Weekly Summary", style: AppTextStyle.heading5),
              Icon(Icons.auto_graph, color: palette.selectColor3),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            "Based on your recent food scans, you're 15% above your sugar goal. Connect with a pro to adjust your plan.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Future<void> _joinCall(String meetingId) async {
    final url = Uri.parse('https://meet.jit.si/Nutrilens_Meeting_$meetingId');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        _showSnackBar('Could not launch video call');
      }
    }
  }

  Widget _buildMyAppointmentsSection(double width, AppPalette palette) {
    if (_myMeetings.isEmpty) {
      return Container(
        width: width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(
          child: Text(
            "No upcoming meetings.",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: _myMeetings.map((meeting) {
        final dieticianName = meeting['dietician_name'] ?? 'Dietician';
        final date = DateTime.tryParse(meeting['scheduled_at'] ?? '');
        final status = meeting['status'] ?? 'scheduled';

        return Container(
          width: width,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.blue),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Meeting with $dieticianName",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (date != null)
                          Text(
                            "${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (status == 'scheduled') ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _joinCall(meeting['_id'] ?? ''),
                    icon: const Icon(Icons.video_call_rounded, size: 20),
                    label: const Text("Join Call"),
                    style: TextButton.styleFrom(
                      foregroundColor: palette.selectColor1,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFoodScanReviewCTA(double width, AppPalette palette) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.camera_alt, color: Colors.amber.shade800),
              const SizedBox(width: 10),
              Text(
                "Get a Review",
                style: AppTextStyle.heading5.copyWith(
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Have a dietitian analyze your last meal photo.",
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildDieticianList(double width, AppPalette palette) {
    if (_availableDieticians.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            "No verified dietitians available at the moment.",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: _availableDieticians
          .map((d) => _buildDieticianListItem(d, width, palette))
          .toList(),
    );
  }

  Widget _buildDieticianListItem(
    Map<String, dynamic> dietician,
    double width,
    AppPalette palette,
  ) {
    final name = dietician['full_name'] ?? dietician['username'] ?? 'Dietician';
    final spec = dietician['specialization'] ?? 'General';
    final initial = name[0].toString().toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: palette.selectColor4.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: palette.headingBlueText,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  spec,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.supervised_user_circle,
                      color: Colors.blue,
                      size: 14,
                    ),
                    Text(
                      " ${dietician['client_count'] ?? 0} clients",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showBookingModal(dietician, palette),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: palette.selectColor3,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Book",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 40),
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 14),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(
          msg,
          style: AppTextStyle.primaryText.copyWith(color: Color(0xFF000000)),
        ),
      ),
    );
  }
}
