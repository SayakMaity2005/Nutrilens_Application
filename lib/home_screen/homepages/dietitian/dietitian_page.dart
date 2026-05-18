import 'package:flutter/material.dart';
import 'package:nutrilens_test/cores/constants/colors.dart';
import 'package:nutrilens_test/cores/constants/text_styles.dart';
import 'package:nutrilens_test/custom_widget_library/animated_button.dart';

class DietitianPage extends StatelessWidget {
  const DietitianPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final palette = Theme.of(context).extension<AppPalette>()!;

    return SingleChildScrollView(
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
          const SizedBox(height: 25),
          _buildSectionTitle("Upcoming Appointments"),
          const SizedBox(height: 15),
          _buildMyAppointmentsSection(screenWidth, palette),
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
                Text("Search by name or specialty", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: palette.selectColor4.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.tune, color: palette.headingBlueText),
        ),
      ],
    );
  }

  Widget _buildFeaturedDieticianCard(double width, AppPalette palette) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [palette.selectColor3, palette.selectColor3.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: palette.selectColor3.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.grey),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Dr. Sarah Johnson",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Weight Loss Specialist",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    const Text("4.9 (120 reviews)", style: TextStyle(color: Colors.white, fontSize: 12)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Online", style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ],
                ),
              ],
            ),
          )
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
            "Based on your recent 12 food scans, you're 15% above your sugar goal. Connect with a pro to adjust your plan.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 15),
          AnimatedButton(
            height: 45,
            width: width,
            decoration: BoxDecoration(
              color: palette.selectColor4.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                "Share Trends with Dietician",
                style: TextStyle(color: palette.headingBlueText, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyAppointmentsSection(double width, AppPalette palette) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: const Row(
        children: [
          Icon(Icons.calendar_today, color: Colors.blue),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Video Call with Dr. Sarah", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Tomorrow at 2:00 PM", style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
        ],
      ),
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
              Text("Get a Pro-Review", style: AppTextStyle.heading5.copyWith(color: Colors.amber.shade900)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Have a dietician analyze your last meal photo for \$5.",
            style: TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 15),
          AnimatedButton(
            height: 40,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.amber.shade800,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text("Select Photo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDieticianList(double width, AppPalette palette) {
    return Column(
      children: List.generate(3, (index) => _buildDieticianListItem(width, palette)),
    );
  }

  Widget _buildDieticianListItem(double width, AppPalette palette) {
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
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.person, color: Colors.grey),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Dr. Michael Chen", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Text("Sports Nutrition", style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const Text(" 4.8", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const Text(" (85 consultations)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Text("\$40/hr", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: palette.selectColor3,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("Book", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
